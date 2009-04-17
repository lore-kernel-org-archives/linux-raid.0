From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Converting system to raid
Date: Thu, 16 Apr 2009 17:47:10 -0700
Message-ID: <002e01c9bef6$0c84c5b0$0a00a8c0@vorg>
References: <00cc01c9ba1d$3aefecf0$0a00a8c0@vorg> <20090410205942.GC21242@cthulhu.home.robinhill.me.uk> <00f301c9ba23$032025f0$0a00a8c0@vorg> <20090410215129.GD21242@cthulhu.home.robinhill.me.uk> <019701c9ba66$aeed5630$0a00a8c0@vorg> <f19d625d0904110729y30e8bc80m41fcd8f2c3298d49@mail.gmail.com> <007001c9bad6$2525c610$0a00a8c0@vorg> <001201c9bb09$3161e9d0$0a00a8c0@vorg> <20090412111107.GA19413@cthulhu.home.robinhill.me.uk> <000b01c9bba8$a5b08a40$0a00a8c0@vorg> <20090414093015.GA19074@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Welllll, tried to switch the other system over to raid boot and something went wrong ether with the copy or with menu.lst change or
with grub, I think. I changed the boot order moving the ide below the 3 sata drives and before the grub boot menu came up I got an
"error 2"

This system is booting from hda1 and will be booting from md0 like the other system. This system has 3 sata drives, so md0 and md1
where setup has raid1 plus spare.

To set up group I used:
sudo grub --no-floppy

Grub> device (hd0) /dev/sda
Grub> root (hd0,0)
Grub> setup (hd0)

Grub> device (hd0) /dev/sdb
Grub> root (hd0,0)
Grub> setup (hd0)

Grub> device (hd0) /dev/sdc
Grub> root (hd0,0)
Grub> setup (hd0)
Grub> quit

it gave me errors for sdc because it is not formated as formating was done on after the array was made. I assume that madadm will
take care of boot setup if it activates it?

I used grml cd started with "grml swraid" and to copy I used:
rsync -cavHh --progress --delete /mnt/sdd1/ /mnt/md0

While booted from hda1 fdisk -l gives:
sudo fdisk -l

Disk /dev/hda: 40.0 GB, 40020664320 bytes
255 heads, 63 sectors/track, 4865 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x6b381dfe

   Device Boot      Start         End      Blocks   Id  System
/dev/hda1   *           1        4660    37431418+  83  Linux
/dev/hda2            4661        4865     1646662+   5  Extended
/dev/hda5            4661        4865     1646631   82  Linux swap / Solaris

Disk /dev/sda: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x94140963

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *           1        3040    24418768+  fd  Linux raid autodetect
/dev/sda2            3041        3649     4891792+  fd  Linux raid autodetect
/dev/sda3            3650       60801   459073440   fd  Linux raid autodetect

Disk /dev/sdb: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0xf1814421

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1   *           1        3040    24418768+  fd  Linux raid autodetect
/dev/sdb2            3041        3649     4891792+  fd  Linux raid autodetect
/dev/sdb3            3650       60801   459073440   fd  Linux raid autodetect

Disk /dev/sdc: 500.1 GB, 500107862016 bytes
255 heads, 63 sectors/track, 60801 cylinders
Units = cylinders of 16065 * 512 = 8225280 bytes
Disk identifier: 0x371b6063

   Device Boot      Start         End      Blocks   Id  System
/dev/sdc1   *           1        3040    24418768+  fd  Linux raid autodetect
/dev/sdc2            3041        3649     4891792+  fd  Linux raid autodetect
/dev/sdc3            3650       60801   459073440   fd  Linux raid autodetect

Disk /dev/md0: 25.0 GB, 25004736512 bytes
2 heads, 4 sectors/track, 6104672 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md0 doesn't contain a valid partition table

Disk /dev/md2: 940.1 GB, 940182208512 bytes
2 heads, 4 sectors/track, 229536672 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md2 doesn't contain a valid partition table

Disk /dev/md1: 5009 MB, 5009113088 bytes
2 heads, 4 sectors/track, 1222928 cylinders
Units = cylinders of 8 * 512 = 4096 bytes
Disk identifier: 0x00000000

Disk /dev/md1 doesn't contain a valid partition table
--------------------------------------------------------------
df -h
Filesystem            Size  Used Avail Use% Mounted on
/dev/hda1              36G  2.9G   31G   9% /
tmpfs                1006M     0 1006M   0% /lib/init/rw
udev                   10M  120K  9.9M   2% /dev
tmpfs                1006M     0 1006M   0% /dev/shm
/dev/md0               23G  2.9G   19G  13% /mnt/md0
/dev/md2              862G  227G  592G  28% /mnt/md2
--------------------------------------------------------------
menu.lst for raid

# kopt=root=/dev/md0 ro quiet

# groot=(hd0,0)

title  Debian GNU/Linux, kernel 2.6.25.9.20081002.1
root  (hd0,0)
kernel  /boot/vmlinuz-2.6.25.9.20081002.1 root=/dev/md0 ro quiet

title  Debian GNU/Linux, kernel 2.6.25.9.20081002.1 (single-user mode)
root  (hd0,0)
kernel  /boot/vmlinuz-2.6.25.9.20081002.1 root=/dev/md0 ro quiet single

