#!/usr/bin/python3
import os
import platform
import wget
import tarfile
import subprocess
import sys

def get_operating_system():
    system = platform.system()

    if system == "Windows":
        return "Windows"
    elif system == "Darwin":
        return "MacOS"
    elif system == "Linux":
        return "Linux"
    else:
        return "Інша операційна система"

# Отримання ім'я поточної операційної системи
operating_system = get_operating_system()
print("Поточна операційна система:", operating_system)

# Створюємо робочий каталог gitleaks

isDirExist = os.path.exists('./gitleaks')
if not isDirExist:
        os.mkdir('./gitleaks')

# Закачуємо реліз gitleaks

isGitleacksExist = os.path.isfile(./gitleaks/gitleaks)
if not isGitleacksExist:
        URL = "https://github.com/gitleaks/gitleaks/releases/download/v8.16.4/gitleaks_8.16.4_linux_x64.tar.gz"
        response = wget.download(URL, "gitleaks_8.16.4_linux_x64.tar.gz")
        
        # Розархівовуємо бінарник gitleaks

        archive_file = "gitleaks_8.16.4_linux_x64.tar.gz"
        output_dir = "./gitleaks"
        with tarfile.open(archive_file) as tar:
        tar.extractall(output_dir)

        # Видаляємо архів

        os.remove("gitleaks_8.16.4_linux_x64.tar.gz")


def gitleaksEnabled():
    """Determine if the pre-commit hook for gitleaks is enabled."""
    out = subprocess.getoutput("git config --bool hooks.gitleaks")
    if out == "false":
        return False
    return True


if gitleaksEnabled():
    exitCode = os.WEXITSTATUS(os.system('./gitleaks/gitleaks protect -v --staged'))
    if exitCode == 1:
        print('''Warning: gitleaks has detected sensitive information in your changes.
To disable the gitleaks precommit hook run the following command:

    git config hooks.gitleaks false
''')
        sys.exit(1)
else:
    print('gitleaks precommit disabled\
     (enable with `git config hooks.gitleaks true`)')
