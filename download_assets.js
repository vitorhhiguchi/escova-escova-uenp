const fs = require('fs');
const http = require('http');
const path = require('path');

const rawData = fs.readFileSync('scratch_silabas_utf8.json', 'utf8');
const data = JSON.parse(rawData.replace(/^\uFEFF/, ''));
const items = data.value; // PowerShell ConvertTo-Json wraps arrays

const baseOutputDir = path.join(__dirname, 'assets', 'backend_assets');

if (!fs.existsSync(baseOutputDir)) {
    fs.mkdirSync(baseOutputDir, { recursive: true });
}

function download(url, dest) {
    return new Promise((resolve, reject) => {
        if (fs.existsSync(dest)) {
            return resolve(); // Skip if exists
        }
        
        const dir = path.dirname(dest);
        if (!fs.existsSync(dir)) {
            fs.mkdirSync(dir, { recursive: true });
        }

        const file = fs.createWriteStream(dest);
        http.get(url, (response) => {
            if (response.statusCode !== 200) {
                fs.unlink(dest, () => {});
                return reject(new Error(`Failed to get '${url}' (${response.statusCode})`));
            }
            response.pipe(file);
            file.on('finish', () => {
                file.close(resolve);
            });
        }).on('error', (err) => {
            fs.unlink(dest, () => {});
            reject(err);
        });
    });
}

async function main() {
    const localItems = [];

    for (const item of items) {
        const localItem = { ...item };
        
        // Download audio
        if (item.som) {
            const urlPath = new URL(item.som).pathname; // e.g. /assets/Vogal_A/Audios/a.ogg
            const localPath = path.join(baseOutputDir, urlPath.replace('/assets/', '')); // remove leading /assets/
            await download(item.som, localPath);
            localItem.som = `res://assets/backend_assets/${urlPath.replace('/assets/', '')}`;
        }
        
        // Download images
        if (item.imagens) {
            localItem.imagens = [];
            for (const img of item.imagens) {
                if (img.imagem) {
                    const urlPath = new URL(img.imagem).pathname;
                    const localPath = path.join(baseOutputDir, urlPath.replace('/assets/', ''));
                    await download(img.imagem, localPath);
                    localItem.imagens.push({
                        imagem: `res://assets/backend_assets/${urlPath.replace('/assets/', '')}`
                    });
                }
            }
        }
        
        localItems.push(localItem);
    }

    fs.writeFileSync('assets/silabas.json', JSON.stringify(localItems, null, 2), 'utf8');
    console.log('Download complete. Localized JSON written to assets/silabas.json');
}

main().catch(console.error);
