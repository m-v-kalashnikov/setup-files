# setup-files
FIles and configs for fast Ubuntu/Termux setup

---

# Prerequirements

To run Makefile first of all you need to install required libs.

`Ubuntu`

```shell
sudo apt install -y gcc git make build-essential
git clone https://github.com/m-v-kalashnikov/setup-files.git
cd setup-files && make ubuntu_all
```

`Termux`

```shell
pkg install -y libllvm git make build-essential
git clone https://github.com/m-v-kalashnikov/setup-files.git
cd setup-files && make termux_all
```

---
