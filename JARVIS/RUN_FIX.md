# How to Run the Fix

Since the automated scripts are having issues, here's how to fix it manually:

## Option 1: Run PowerShell Script (Easiest)

1. Open PowerShell
2. Navigate to the JARVIS folder:
   ```powershell
   cd "C:\Users\rohan\Desktop\Rohan's J.A.R.V.I.S\JARVIS"
   ```
3. Run the PowerShell script:
   ```powershell
   .\fix_secrets.ps1
   ```
4. After it completes, force push:
   ```powershell
   cd ..
   git push origin master --force
   ```

## Option 2: Run Batch File Directly

1. Open File Explorer
2. Navigate to: `C:\Users\rohan\Desktop\Rohan's J.A.R.V.I.S\JARVIS`
3. Double-click `fix_secrets_simple.bat`
4. Follow the prompts
5. After it completes, open PowerShell and run:
   ```powershell
   cd "C:\Users\rohan\Desktop\Rohan's J.A.R.V.I.S"
   git push origin master --force
   ```

## Option 3: Manual Commands (Copy & Paste)

Open PowerShell and run these commands one by one:

```powershell
# Navigate to repository root
cd "C:\Users\rohan\Desktop\Rohan's J.A.R.V.I.S"

# Remove .env from git
git rm --cached JARVIS/.env

# Create new clean branch
git checkout --orphan temp-clean
git add -A
git commit -m "Clean history without secrets"
git branch -D master
git branch -m master

# Push to remote
git push origin master --force
```

## Option 4: Use GitHub's Unblock URLs (Quick but Less Secure)

If you just want to push quickly:

1. Visit each URL from the error message and click "Allow secret"
2. Then push normally:
   ```powershell
   git push origin master
   ```

**Note:** This leaves secrets in history, so consider rotating your API keys if the repo is public.
