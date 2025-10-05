# Security Notes

## Sensitive Information Removed

### Riot Project
- **Removed:** Hardcoded API key loading from `C:/Users/kinka/Desktop/api_keys/112920_0245.txt`
- **Replaced with:** Config-based system using `config.example.py` template
- **Protection:** Added `config.py` to `.gitignore`

### Twitch_downloader Project
- **Removed from SCP_code.txt:**
  - EC2 instance address: `ec2-3-136-155-94.us-east-2.compute.amazonaws.com`
  - Local paths: `C:/Users/kinka/Desktop/api_keys/`, `E:\Downloads KE`, `/mnt/c/Users/kinka/Linuxsubsysme/`
  - Key filenames: `ec2_key_001.ppk`, `keys001.pem`, `key001`
- **Replaced with:** Generic placeholder examples

### Notebook Checkpoints
- **Removed:** All `.ipynb_checkpoints/` containing old hardcoded paths
- **Protection:** Added `.ipynb_checkpoints` to `.gitignore`

## Git History Sanitization

**Status:** Sensitive information still exists in git history (commits 4ae90a8, e2fca4f, 15739a0, d077fd0)

**Action Required:** Run `./SANITIZE_HISTORY.sh` to purge from history

**Files to be purged:**
- Twitch_downloader/SCP_code.txt (old version with EC2 addresses)
- Twitch_downloader/Lamda_junk1.py (old version)
- Riot/Riot_Demo1.ipynb (old version with hardcoded API key path)

**⚠️ Warning:** This rewrites git history. Only do this if:
1. You haven't shared this repo publicly yet, OR
2. You're comfortable with force-pushing to remote

## .gitignore Protection

The following patterns are now excluded from git:
```
.DS_Store              # macOS metadata
.ipynb_checkpoints     # Jupyter auto-saves
config.py              # API keys and credentials
**/api_keys/           # Any api_keys directory
*.pem, *.ppk           # SSH keys
__pycache__/           # Python cache
```

## No Remaining Issues Found

✅ No hardcoded passwords or tokens
✅ No exposed API keys
✅ No IP addresses (except generic examples)
✅ No usernames (removed "kinka" references)
✅ No absolute local paths (except in documentation)

## Recommendations

1. **Before making repo public:**
   - Run `./SANITIZE_HISTORY.sh`
   - Verify with: `git log --all --full-history -- <sensitive-file>`

2. **For Riot project:**
   - Copy `config.example.py` to `config.py`
   - Add your actual API key to `config.py`
   - Never commit `config.py`

3. **General practice:**
   - Always use environment variables or config files for secrets
   - Add config files to `.gitignore` before adding secrets
   - Review diffs before committing with `git diff`
