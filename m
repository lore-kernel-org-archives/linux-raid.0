From: noriok <noriok@kitakami.hss.iwate-u.ac.jp>
Subject: Software RAID 1 Prpblem: "raid_autorun failed" booting from /dev/md0
Date: Thu, 26 Jun 2003 17:01:50 +0900
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200306260801.AA01558@ran.kitakami.hss.iwate-u.ac.jp>
References: <200306260750.AA01552@ran.kitakami.hss.iwate-u.ac.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200306260750.AA01552@ran.kitakami.hss.iwate-u.ac.jp>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi, everyone,

I have a problem with the following System-2 on booting from /dev/md0.
Whould anyone kindly give me an advise?

Thank you from Japan.

--
1) System 1; Red Hat Linux 7.1  : succeeded
   Kernel 2.4.20-18.7 on an i686
2) System 2; Vine Linux 2.6 : failed  
   with the booting message  "raid_autorun failed" 
   Kernel 2.4.20-0vl29.1 on an i686
   (Japanese local destribution based upon Red Hat 6.2)

There were no problems with the System-1. 
The system could be booted by /dev/md0 [/deb/hdb1] by bootable FD.

I have not completed the setting yet, so I booted the machine from 
the bootable floppy disk.

--
$ pwd
/mnt/etc
$ cat lilo.conf
disk=/dev/md0
boot=/dev/fd0
map=/boot/map-fd
install=/boot/boot.b
lba32
image=/boot/vmlinuz
        label=linuxRaid
        root=/dev/md0
        read-only
        initrd=/boot/initrd_raid

$ cat raidtab
# md0 is the root array
raiddev                 /dev/md0
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
chunk-size              4
persistent-superblock   1
device                  /dev/hdb1
raid-disk               0
device                  /dev/hda1
failed-disk             1

# md1 is the swap array
raiddev                 /dev/md1
raid-level              1
nr-raid-disks           2
nr-spare-disks          0
chunk-size              4
persistent-superblock   1
device                  /dev/hdb2
raid-disk               0
device                  /dev/hda2
failed-disk             1

$ cat fstab
/dev/md0               /                       ext2    defaults        1 1
/dev/md1               swap                    swap    defaults        0 0
