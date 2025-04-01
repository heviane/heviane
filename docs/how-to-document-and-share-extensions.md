# How to document and share extensions

Automatically create an "extensions.json" file to list all your installed extensions, share and automatically install from the generated file.

---

### 📌 **Step 1: Generate the `extensions.json` file automatically**

Open the terminal in **VS Code** and run the following command: 

```sh
echo '{ "recommendations": [' > .vscode/extensions.json && code --list-extensions | sed 's/^/ "/;s/$/",/' >> .vscode/extensions.json && echo '] }' >> .vscode/extensions.json
```

🔹 **Command Explanation:**
- Creates the `extensions.json` file and adds the beginning of the JSON.
- Gets the list of extensions and formats each line correctly with quotes and commas.
- Ends the JSON by closing the array. 

> **⚠️ IMPORTANT:**
> 
> Always run this command after installing new extensions to keep the `extensions.json` file up to date.

---

### 📌 **Step 2: Review and adjust the file**

After running the command, the generated file (`extensions.json`) will have the following structure: 

```json
{
  "recommendations": [
    "esbenp.prettier-vscode",
    "dbaeumer.vscode-eslint",
    "ms-python.python",
    "ms-vscode.cpptools"
  ]
}
```

If you want to **share this file in a Git repository**, place it inside the `.vscode/` folder: 

```sh
mkdir -p .vscode && mv extensions.json .vscode/
```

---

### 📌 **Step 3: Reinstall all extensions on another VS Code**

If you need to reinstall all extensions at once on another machine, use this command:

```sh
cat .vscode/extensions.json | grep '"' | sed 's/[",]//g' | xargs -n 1 code --install-extension
```

---

### **Conclusion** 🚀

✅ **Automatically create `extensions.json`:** `code --list-extensions` + JSON formatting.

✅ **Keep extensions organized:** Add `.vscode/extensions.json` to Git for teams.

✅ **Easily reinstall extensions:** Use `xargs` to install everything at once.

This keeps your development environment always in sync! 🎯