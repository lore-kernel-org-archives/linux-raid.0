From: "John Doe" <public_address_911@hotmail.com>
Subject: Re: Problem converting raid-5 array from 2.2.17 into 2.4.22
Date: Wed, 03 Sep 2003 02:28:28 +0300
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Law12-F20LpCdNGFEN5000148c3@hotmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Ahem :-) Still replying to myself, I also found a very nice utility called 
lsraid, which tells us things like:

# lsraid -D -l -d /dev/hda3 -d /dev/hdb1 -d /dev/hdc1 -d /dev/hdd1

[dev 3, 3] /dev/hda3:
        md version              = 0.90.0
        superblock uuid         = CF9E6AB4.00000000.00000000.00000000
        md minor number         = 0
        created                 = 974113695 (Mon Nov 13 13:08:15 2000)
        last updated            = 1062524544 (Tue Sep  2 20:42:24 2003)
        raid level              = 5
        chunk size              = 128 KB
        apparent disk size      = 78935296 KB
        disks in array          = 4
        required disks          = 4
        active disks            = 4
        working disks           = 4
        failed disks            = 0
        spare disks             = 0
        position in disk list   = 0
        position in md device   = 0
        state                   = good

Others are identical except for the following lines:

[dev 3, 65] /dev/hdb1:
        position in disk list   = 1
        position in md device   = 1

[dev 22, 1] /dev/hdc1:
        position in disk list   = 2
        position in md device   = 2

[dev 22, 65] /dev/hdd1:
        position in disk list   = 3
        position in md device   = 3

Yet trying to access them via md0 causes failure:
# lsraid -D -l -a /dev/md0
lsraid: md device [dev 9, 0] /dev/md0 is offline: Please specify a disk to 
query

All partition types for the respective partitions are of type fd (Linux raid 
autodetect)
Kernel config with respect to raid stuff is as follows:

CONFIG_MD=y
CONFIG_BLK_DEV_MD=y
CONFIG_MD_LINEAR=m
CONFIG_MD_RAID0=m
CONFIG_MD_RAID1=m
CONFIG_MD_RAID5=y
# CONFIG_MD_MULTIPATH is not set
# CONFIG_BLK_DEV_LVM is not set

All seems terribly normal - it just doesn't work :(

_________________________________________________________________
STOP MORE SPAM with the new MSN 8 and get 2 months FREE* 
http://join.msn.com/?page=features/junkmail

