From: "Zeno R.R. Davatz" <zdavatz@ywesee.com>
Subject: Warning: /dev/md/0 is not on the first disk
Date: Thu, 26 Jun 2003 19:32:30 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20030626193230.4482503e.zdavatz@ywesee.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi List

I am trying to set up my second software raid and encounter following problems:

lilo gives me:
Warning: device outside of RAID set  /dev/hda  0x0300
Warning: using BIOS device code 0x81 for RAID boot blocks
Warning: /dev/md/0 is not on the first disk
Fatal: map file must be on the boot RAID partition

My lilo.conf is:

boot=/dev/md/0
raid-extra-boot="/dev/hdc,/dev/hda"

root=/dev/md/1

append="md=0,/dev/hdc3,/dev/hda3"

cat /proc/mdstat gives me:
md0 : active raid1 ide/host1/bus0/target0/lun0/part1[0]
      97664 blocks [2/1] [U_]
       
md1 : active raid1 ide/host1/bus0/target0/lun0/part3[0]
      76126592 blocks [2/1] [U_]

My /etc/raidtab is:
raiddev /dev/md/0
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size      32
        persistent-superblock 1
        device          /dev/hdc1
        raid-disk       0
        device          /dev/hda1
        failed-disk     1
                                                                                                                                              
raiddev /dev/md/1
        raid-level      1
        nr-raid-disks   2
        nr-spare-disks  0
        chunk-size      32
        persistent-superblock 1
        device          /dev/hdc3
        raid-disk       0
        device          /dev/hda3
        failed-disk     1

My /mnt/root/etc/fstab is:
# <Dateisystem> <Mountpunkt>    <Typ>   <Optionen>                      <dump>  <pass>
/dev/md/1       /               reiserfs        defaults        0       0
/dev/hda2       none            swap    sw                      0       0
/dev/hdc2       none            swap    sw                      0       0
proc            /proc           proc    defaults                0       0
/dev/fd0        /floppy         auto    user,noauto             0       0
/dev/cdrom      /cdrom          iso9660 ro,user,noauto          0       0
/dev/md/0       /boot           reiserfs        defaults        0       2

Thanks in advance for any help and hints.

Zeno
