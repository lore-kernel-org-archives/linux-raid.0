From: "Chris Birkinshaw" <chris@postbox.org.uk>
Subject: Raid 5 problems
Date: Tue, 25 May 2004 21:29:26 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <43723.132.185.240.121.1085516966.squirrel@postbox.org.uk>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Whenever I reboot my server (kernel 2.6.6) the raid (level 5) comes back in degraded mode. The
missing disk is hdd3 and is correctly set out in the raidtab. The output of lsraid shows the
superblock of hdd3 differs to those of the rest of the disks in the array, as shown below. Does
anyone have any ideas? After a raidhotadd /proc/mdstat corresponds to the raidtab, as does the
ouput of lsraid -d for any device in the raid. At the moment this means that if I lose a disk my
raid will be trashed since I will have two disks missing, so this relaly needs fixing.

Hope someone has an idea, thanks in advance!

Chris


# cat /proc/mdstat
md0 : active raid5 hdh1[1] hdg1[0] hdf1[3] hde1[2] hdc1[4] hdb1[6]
351677952 blocks level 5, 128k chunk, algorithm 0 [7/6] [UUUUU_U]

# /sbin/lsraid -d /dev/hdh1
[dev 9, 0] /dev/md0 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E online
[dev 34, 1] /dev/hdg1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev 34, 65] /dev/hdh1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev 33, 1] /dev/hde1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev 33, 65] /dev/hdf1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev 22, 1] /dev/hdc1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev ?, ?] (unknown) 00000000.00000000.00000000.00000000 missing
[dev 3, 65] /dev/hdb1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good

# /sbin/lsraid -d /dev/hdd3
[dev 9, 0] /dev/md0 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E online
[dev 34, 1] /dev/hdg1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev 34, 65] /dev/hdh1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev 33, 1] /dev/hde1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev 33, 65] /dev/hdf1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev 22, 1] /dev/hdc1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good
[dev ?, ?] (unknown) 00000000.00000000.00000000.00000000 missing
[dev 3, 65] /dev/hdb1 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E good

[dev 22, 67] /dev/hdd3 AEE7CFE5.90AFB264.D1F855A1.F7A6B30E unbound


