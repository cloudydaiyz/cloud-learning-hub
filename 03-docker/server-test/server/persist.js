import fs from "fs";

const DEFAULT_FOLDER = "../persist";
const DEFAULT_FILE_NAME = "persisted_array.data";
const CWD = new URL('.', import.meta.url).pathname;

class PersistedArray {
    constructor(folder = DEFAULT_FOLDER, filename = `${Object.hashCode(this)}_${DEFAULT_FILE_NAME}`) {
        this.con = [];
        this.folder = folder;
        this.filename = filename;
        this.autosave = false;
    }

    enableAutosave() {
        this.autosave = true;
    }

    disableAutosave() {
        this.autosave = false;
    }

    append(data) {
        this.con.push(data);

        // Save if autosave is active
        if(this.autosave) {
            this.save();
        }
    }

    size() {
        return this.con.length;
    }

    get(index) {
        return this.con[index];
    }

    clear(startpos, amount) {
        let removedcnt = 0;

        if(startpos === undefined && amount === undefined) {
            startpos = 0;
            amount = this.con.length;
        } else if(startpos === undefined || amount === undefined) {
            throw new Exception("u suck");
        }
        
        removedcnt = Math.min(amount, this.size() - startpos);
        this.con.splice(startpos, removedcnt);

        // Save if autosave is active
        if(this.autosave) {
            this.save();
        }

        return removedcnt;
    }

    save() {
        const path = `${CWD}/${this.folder}/${this.filename}`

        fs.writeFile(path, this.con.toString(), (err) => {
            if (err) {
                console.error('Error creating the file:', err);
            } else {
                console.log('File created successfully:', path);
            }
        });
    }
}

export default PersistedArray;