From: Victor Geller <vgeller@spindrift.on.ca>
Subject: ADD_NEW_DISK failed
Date: Sun, 23 Feb 2003 08:59:58 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <5.1.0.14.0.20030223085025.00b08b30@psimail.spindrift.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have the following problem:

[root@wti7 vic]# mdadm -Cv /dev/md0 -l1 -n2 /dev/hda1 /dev/hdc1
mdadm: chunk size defaults to 64K
mdadm: /dev/hda1 appears to contain an ext2fs file system
     size=5630748K  mtime=Sun Feb 23 08:52:48 2003
mdadm: /dev/hdc1 appears to contain an ext2fs file system
     size=5630748K  mtime=Sun Feb 23 08:52:54 2003
mdadm: size set to 5630656K
Continue creating array? y
mdadm: ADD_NEW_DISK for /dev/hda1 failed: Invalid argument

[root@wti7 vic]# cat /proc/mdstat
Personalities :
read_ahead not set
md0 : inactive
unused devices: <none>

Partition and mount info is below:

[root@wti7 vic]# fdisk -ul /dev/hda

Disk /dev/hda: 120.0 GB, 120000000000 bytes
255 heads, 63 sectors/track, 14589 cylinders, total 234375000 sectors
Units = sectors of 1 * 512 = 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/hda1   *        63  11261564   5630751   83  Linux
/dev/hda2      11261565 234372284 111555360    5  Extended
/dev/hda5      11261628  11759579    248976   82  Linux swap
/dev/hda6      11759643 234372284 111306321   83  Linux

[root@wti7 vic]# fdisk -ul /dev/hdc

Disk /dev/hdc: 120.0 GB, 120000000000 bytes
255 heads, 63 sectors/track, 14589 cylinders, total 234375000 sectors
Units = sectors of 1 * 512 = 512 bytes

    Device Boot    Start       End    Blocks   Id  System
/dev/hdc1   *        63  11261564   5630751   83  Linux
/dev/hdc2      11261565 234372284 111555360    5  Extended
/dev/hdc5      11261628  11759579    248976   82  Linux swap
/dev/hdc6      11759643 234372284 111306321   83  Linux

[root@wti7 vic]# mount
/dev/hda1 on / type ext3 (rw)
none on /proc type proc (rw)
none on /proc/bus/usb type usbdevfs (rw)
none on /dev type devfs (rw)
none on /dev/pts type devpts (rw,mode=0620)
/dev/hda6 on /home type ext3 (rw)
none on /mnt/cdrom type supermount 
(ro,dev=/dev/scd0,fs=auto,--,iocharset=iso885
9-1,codepage=850,umask=0)
none on /mnt/floppy type supermount 
(rw,sync,dev=/dev/fd0,fs=auto,--,iocharset=i
so8859-1,codepage=850,umask=0)
/dev/hdc1 on /mnt/raid1_1 type ext3 (rw)
/dev/hdc6 on /mnt/raid_1/home type ext3 (rw)

I would appreciate your help

Victor Geller , vgeller@spindrift.on.ca

