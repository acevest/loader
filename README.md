# Loader

基于x86，在硬盘上通过ext4文件系统加载ELF格式的内核。

用NASM汇编实现


## 安装软件

设定安装路径

```
sudo mkdir /usr/local/`whoami`
```

### 安装nasm

```
wget -c https://www.nasm.us/pub/nasm/releasebuilds/2.15.05/nasm-2.15.05.tar.gz
tar xvf nasm-2.15.05.tar.gz
cd nasm-2.15.05
./configure --prefix=/usr/local/`whoami`/nasm-2.15.05
make -j4
sudo make install
```

添加环境变量
```
export PATH=$PATH:/usr/local/`whoami`/nasm-2.15.05/bin/
```


### 安装bochs

MacOS 安装方法
```
brew install sdl2
```

下载`bochs-2.7.tar.gz`
```
tar xvf bochs-2.7.tar.gz
cd bochs-2.7
./configure --prefix=/usr/local/`whoami`/bochs-2.7 --enable-a20-pin --enable-x86-64  --enable-fast-function-calls --enable-show-ips --enable-debugger --enable-readline --with-sdl2
make -j4
sudo make install
```

添加到环境变量

```
export PATH=$PATH:/usr/local/`whoami`/bochs-2.7/bin/
```
