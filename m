From: bruno waes <waesb@oxygenetic.com>
Subject: raid boot problems
Date: Fri, 27 Dec 2002 21:36:09 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20021227203609.GD26188@oxygenetic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: attachment; filename=scsiprobs
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I have debian installation on a asus nforce2 motherboard with two scsi disks (on a adaptec 29160N) and one
IDE hd.

rainman:/proc# more /proc/scsi/scsi
Attached devices:
Host: scsi0 Channel: 00 Id: 00 Lun: 00
  Vendor: IBM      Model: DNES-318350W     Rev: SA30
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 01 Lun: 00
  Vendor: IBM      Model: DNES-318350W     Rev: SA30
  Type:   Direct-Access                    ANSI SCSI revision: 03
Host: scsi0 Channel: 00 Id: 03 Lun: 00
  Vendor: PLEXTOR  Model: CD-ROM PX-40TS   Rev: 1.00
  Type:   CD-ROM                           ANSI SCSI revision: 02


i installed a small system on the ide hd, and afterwards partitioned both scsi disks like this:

                                  cfdisk 2.11n

                              Disk Drive: /dev/sda
                            Size: 18351959040 bytes
              Heads: 64   Sectors per Track: 32   Cylinders: 17501

    Name        Flags      Part Type  FS Type          [Label]        Size (MB)
 ------------------------------------------------------------------------------
    sda1        Boot        Primary   Linux raid autodetect               50.34
    sda2                    Primary   Linux swap                         511.71
    sda4                    Primary   Linux raid autodetect            10788.80
    sda3                    Primary   Linux raid autodetect             7000.30



rainman:/mnt/root/etc# more raidtab
# md0 is the boot array
raiddev                 /dev/md0
raid-level              1
nr-raid-disks           2
chunk-size              32
nr-spare-disks          0
persistent-superblock   1
device                  /dev/sda1
raid-disk               0
device                  /dev/sdb1
raid-disk               1

# md1 is the root array
raiddev                 /dev/md1
raid-level              1
nr-raid-disks           2
chunk-size              32
nr-spare-disks          0
persistent-superblock   1
device                  /dev/sda3
raid-disk               0
device                  /dev/sdb3
raid-disk               1

# md2 is the web array
raiddev                 /dev/md2
raid-level              1
nr-raid-disks           2
chunk-size              32
nr-spare-disks          0
persistent-superblock   1
device                  /dev/sda4
raid-disk               0
device                  /dev/sdb4
raid-disk               1



it looks ok

rainman:~# more /proc/mdstat
Personalities : [linear] [raid1] [multipath]
read_ahead 1024 sectors
md0 : active raid1 sdb1[1] sda1[0]
      49024 blocks [2/2] [UU]

md1 : active raid1 sdb3[1] sda3[0]
      6836160 blocks [2/2] [UU]

md2 : active raid1 sdb4[1] sda4[0]
      10535872 blocks [2/2] [UU]

unused devices: <none>




rainman:~# more /mnt/root/etc/fstab
# /etc/fstab: static file system information.
#
# <file system> <mount point>   <type>  <options>               <dump>  <pass>
/dev/md1        /               ext3    errors=remount-ro       0       1
/dev/sda2       none            swap    sw                      0       0
/dev/sdb2       none            swap    sw                      0       0
proc            /proc           proc    defaults                0       0
/dev/fd0        /floppy         auto    user,noauto             0       0
/dev/cdrom      /cdrom          iso9660 ro,user,noauto          0       0
/dev/md0        /boot           ext3    defaults                0       2
/dev/md2        /web            ext3    defaults                0       2






i installed the LILO in the mbr of /dev/sda

rainman:~# more /mnt/root/etc/lilo.conf
lba32
disk=/dev/md1
bios=0x80
partition=/dev/md0
boot=/dev/sda
root=/dev/md1
...



mobo BIOS boot order is SCSI, scsi-bios boot device is 0 (/dev/sda) but it still hangs on 'LI'
i had that problem too with a non raid install on the scsi disk, but adding a 'bios=0x80' helped that work
out, but now it still does not boot from the scsi, and i dont feel like putting the MBR on the ide disk,
would be nicer to have it on the scsi disks. anyone has an ide or need information ?

thanks in advance


bruno
