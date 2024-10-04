### How to Display Banners in Linux Command Linux

### 1. Banner

`yum install banner -y`

```
[root@kms ~]# banner tuxfixer

#######  #     #  #     #  #######  ###  #     #  #######  ######
   #     #     #   #   #   #         #    #   #   #        #     #
   #     #     #    # #    #         #     # #    #        #     #
   #     #     #     #     #####     #      #     #####    ######
   #     #     #    # #    #         #     # #    #        #   #
   #     #     #   #   #   #         #    #   #   #        #    #
   #      #####   #     #  #        ###  #     #  #######  #     #
```

### 2. Figlet

`yum install figlet -y`

```
[root@kms ~]# figlet "Hello World"
 _   _      _ _        __        __         _     _
| | | | ___| | | ___   \ \      / /__  _ __| | __| |
| |_| |/ _ \ | |/ _ \   \ \ /\ / / _ \| '__| |/ _` |
|  _  |  __/ | | (_) |   \ V  V / (_) | |  | | (_| |
|_| |_|\___|_|_|\___/     \_/\_/ \___/|_|  |_|\__,_|

```


- Use other fonts in `/usr/share/figlet/`

```
[root@kms figlet]# figlet -f /usr/share/figlet/slant.flf SDSVN
   _____ ____  ______    ___   __
  / ___// __ \/ ___/ |  / / | / /
  \__ \/ / / /\__ \| | / /  |/ /
 ___/ / /_/ /___/ /| |/ / /|  /
/____/_____//____/ |___/_/ |_/
```

`watch -n1 "date '+%D%n%T'|figlet -k"`

<img src="/img/banner2.PNG">

### Custom Fonts

Extra fonts are available for download from `ftp://ftp.figlet.org/pub/figlet/fonts/`. For more information about figlet, read figlet’s man page and visit `http://www.figlet.org/`. As of the time of this writing, the font database was unaccessible, but fonts can still be downloaded from the ftp site.

```
contributed.tar.gz      - Recommended. About 138 new fonts for figlet.
international.tar.gz    - Fonts for other languages. Read cjkfonts-readme.
ms-dos.tar.gz           - Contains only one font, which would not work.
ours.tar.gz             - The default fonts already included with figlet.
sudo cp -R * /usr/share/figlet 
``` 

### 2. Toilet, cowsay

```
yum install toilet cowsay -y

while true; do echo "$(date '+%D %T' | toilet -f term -F border --gay)"; sleep 1; done
```

<img src="/img/banner.PNG">


`toilet -f term -F border --gay WELCOME TO SAMSUNG SDS VIETNAM`

<img src="/img/banner1.PNG">

```
toilet -f smblock --filter border:metal:flip:flop 'Linux is fun'
toilet -f smblock --filter border:metal: 'Linux is fun'
toilet -f slant --filter border:metal 'SDSVN'
toilet -f slant --filter border:metal 'WELCOME TO SAMSUNG SDS VIETNAM'


https://tuxfixer.com/how-to-display-banners-in-linux-command-line/

https://delightlylinux.wordpress.com/2015/11/13/colored-text-with-toilet/

https://delightlylinux.wordpress.com/2014/05/30/produce-fancy-text-with-figlet/

https://www.linux.com/training-tutorials/linux-tips-fun-figlet-and-toilet-commands/
```
`cowsay -f dragon "Run for cover, I feel a sneeze coming on."`