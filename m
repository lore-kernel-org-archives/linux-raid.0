From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Fri, 08 Feb 2013 10:17:00 +0100
Message-ID: <20130208091700.256910@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

my situation is this: i have 3 server with each of 6x3tb in an sw raid5 on a debian squeeze system. on top of this i use moosefs as a filecluster. the problem now is that for a very short time 2 of the disks failed. at this time there was no file activity only the filesync between the nodes of the cluster.

after that i cant rebuild the raid: "mdadm: /dev/md2 assembled from 4 drives and 1 spare - not enough to start the array."

the superblock seems to be ok. and at least, by an advice from phil turmel, i tried a diffent kind of recreation with these results:

Test1:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c,d,e,f}4
-> filesize 708MB with 20603326 lines and canceling at the end by e2fsck
- bad superblock or partitiontable is damage
- bad checksum of group or descriptor
- lots of invalid inodes
- canceld with lots of illegal blocks in inodes

Test2:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c,d,e}4 missing
-> filesize 1,3GB  with 37614367 lines and canceling by e2fsck at the end
- back to original superblock
- bad superblock or damaged partitiontable at the beginning
- lots of invalid inodes
- canceld with iteration of inade

Test3:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c}4 missing /dev/sd{e,f}4
-> filesize 1,4GB with 40745425 lines and canceling by e2fsck at the end
- errors see test2
- read error while reading next inode

Test4:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c,f,e,d}4
->filesize 874MB with 25412000 lines and break by e2fsck at the end
- try original superblock
- bad superblock or damaged partitiontable
- than lots of checksumm  invalid deskriptor of group
- at the end illegal block in inode to much invalid blocks in inode

Test5:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c}4 missing /dev/sd{e,d}4
-> filesize 1,6GB with 45673505 lines and canceling at the end by e2fsck

Test6:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c,f,e}4 missing
- try original superblock
- bad superblock or damage partitiontable
- lots of checksumm error in group deskriptor
- ends with conflict in inode table with another filesystem block
-> filesize 542MB with 15727702 lines and cancelingat the end by e2fsck

Teset6 looks like the best one, but what do you think and perhaps what could i do else? Any further help?

Many thanks
Sunny

