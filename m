From: "Shaw, Marco" <Marco.Shaw@aliant.ca>
Subject: Heavy paging, but no swap being used.
Date: Thu, 29 May 2003 11:30:34 -0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <C65F89D1AC0BB54B865127151A24DA7810F74CA9@nbexchm2.aliant.icn>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

RedHat 7.2 with 2.4.18-18.7.xbigmem using RedHat's software RAID package.

I've been seeing quite a bit of page in/page out going on, and have been looking around.

With the 2.4 kernel, when would one expect to see swap usage?  I'm assuming the 2.4 memory works a bit like Solaris where one should expect to see physical memory usage relatively high, and that's a good/normal thing, but I don't see any swap utilization at all, which concerns me.  I may have misconfigured something...

How can I pin-point, if possible, whether the paging is related to the use of software RAID?

Marco

# more raidtab
raiddev /dev/md0
        raid-level              0
        nr-raid-disks           2
        persistent-superblock   1
        chunk-size              32
        device                  /dev/sdc1
        raid-disk               0
        device                  /dev/sdd1
        raid-disk               1

# free
            total       used       free     shared    buffers     cached
Mem:       3874464    3843256      31208          0     381844    3084184
-/+ buffers/cache:     377228    3497236
Swap:      2048248          0    2048248

# sar -r
Linux 2.4.18-18.7.xbigmem 05/29/2003

12:00:00 AM kbmemfree kbmemused  %memused kbmemshrd kbbuffers  kbcached kbswpfree kbswpused  %swpused
12:10:00 AM     33956   3840508     99.12         0    381020   3085476   2048248         0      0.00

# swapon -s
Filename                        Type            Size    Used    Priority
/dev/sda6                       partition       2048248 0       -1

# more /etc/fstab
LABEL=/                 /                       ext3    defaults        1 1
LABEL=/boot             /boot                   ext3    defaults        1 2
none                    /dev/pts                devpts  gid=5,mode=620  0 0
LABEL=/home             /home                   ext3    defaults        1 2
none                    /proc                   proc    defaults        0 0
none                    /dev/shm                tmpfs   defaults        0 0
LABEL=/tmp              /tmp                    ext3    defaults        1 2
LABEL=/usr              /usr                    ext3    defaults        1 2
LABEL=/var              /var                    ext3    defaults        1 2
/dev/md0 /hosting ext3 defaults,usrquota 0 0
/dev/sda6               swap                    swap    defaults        0 0
/dev/cdrom              /mnt/cdrom              iso9660 noauto,owner,kudzu,ro 0
0
/dev/fd0                /mnt/floppy             auto    noauto,owner,kudzu 0 0


# sar -B
Linux 2.4.18-18.7.xbigmem 05/29/2003

12:00:00 AM  pgpgin/s pgpgout/s  activepg  inadtypg  inaclnpg  inatarpg ...
Average:         0.02     55.34    561672    225090    115799    180512
