From: "Yu Ting LIU" <yt_ytliu@hotmail.com>
Subject: Cannot boot from raid1 root partition
Date: Wed, 26 Nov 2003 13:50:49 +0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <LAW12-F455JQ35J9eVH000148ca@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I am doing testing to configure raid1 on one hard disk on operating system 
Redhat7.2.

The raid map is
/boot        /dev/md0       /dev/hda1 & /dev/hda8
/usr          /dev/md1       /dev/hda2 & /dev/hda9
/home      /dev/md2       /dev/hda3 & /dev/hda10
/root        /dev/md3       /dev/hda6 & /dev/hda12
/var          /dev/md4       /dev/hda7 & /dev/hda13

All of partitions are mirrorred and I can boot in rescue mode with root 
partition /dev/md3 mounted successfully. But if I boot in multi-user mode I 
always get complain:

creating root device
Mounting root filesystem
EXT3-fs: unable to read superblock
mount: error 22 mounting ext3
pivotroot: pivot_root (/sysroot, /sysroot/initrd) failed: 2
Freeing unused kernel memeory: 220k freed
Kernel panic: No init found. Try passing init=option to kernel

Anybody can tell me what I have lost?

This is my output of "fdisk -ul /dev/hda"

Disk /dev/hda: 240 heads, 63 sectors, 1976 cylinders
Units = sectors of 1 * 512 bytes

   Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *        63    105839     52888+  fd  Linux raid autodetect
/dev/hda2        105840   4203359   2048760   fd  Linux raid autodetect
/dev/hda3       4203360   6244559   1020600   fd  Linux raid autodetect
/dev/hda4       6244560  29877119  11816280    5  Extended
/dev/hda5       6244623   7287839    521608+  82  Linux swap
/dev/hda6       7287903   8074079    393088+  fd  Linux raid autodetect
/dev/hda7       8074143   8603279    264568+  fd  Linux raid autodetect
/dev/hda8       8603343   8709119     52888+  fd  Linux raid autodetect
/dev/hda9       8709183  12821759   2056288+  fd  Linux raid autodetect
/dev/hda10     12821823  14878079   1028128+  fd  Linux raid autodetect
/dev/hda11     14878143  15921359    521608+  83  Linux
/dev/hda12     15921423  16707599    393088+  fd  Linux raid autodetect
/dev/hda13     16707663  17236799    264568+  fd  Linux raid autodetect
/dev/hda14     17236863  18023039    393088+  83  Linux

And this is the output of df -k in rescue mode.

Filesystem           1k-blocks      Used Available Use% Mounted on
/dev/md3               380679     68461    292564  19% /
/dev/md0                 51118      5794     43212  12% /boot
/dev/md2               1004408     16672    946920   2% /home
none                    127764         0    127764   0% /dev/shm
/dev/md1              2016520    768280   1145804  41% /usr
/dev/md4                256074     23146    222351  10% /var

Thanks in advance!

Regards!

Yu Ting

_________________________________________________________________
Set yourself up for fun at home!  Get tips on home entertainment equipment, 
video game reviews, and more here.   
http://special.msn.com/home/homeent.armx

