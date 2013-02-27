From: "Dragon" <Sunghost@gmx.de>
Subject: Possible to rescue SW Raid5 with 2 missing Disks
Date: Wed, 27 Feb 2013 08:14:26 +0100
Message-ID: <20130227071426.42800@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,
Mikael points me to the Permute array.pl Perlscript, but i dont get it run. i tried
permute_array --md /dev/md2 --mount /mnt/md2 /dev/sd[a-f]4 

Iam not sure how to and i wont to make a mistake, can you help for the right syntax? Anywhere i suggest we have to work out that:

- missing disk are sdd and sdf, while sdd looks like to fails at first
- superblock and chunksize are 512 and on all correct

here are the tests with the 6 combinations i tried in the past

Test1:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 \
                /dev/sd{a,b,c,d,e,f}4
-> filesize 708MB with 20603326 lines and canceling at the end by e2fsck
- bad superblock or partitiontable is damage
- bad checksum of group or descriptor
- lots of invalid inodes
- canceld with lots of illegal blocks in inodes

Test2:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c,d,e}4 \
                missing
-> filesize 1,3GB  with 37614367 lines and canceling by e2fsck at the end
- back to original superblock
- bad superblock or damaged partitiontable at the beginning
- lots of invalid inodes
- canceld with iteration of inade

Test3:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c}4 \
                missing /dev/sd{e,f}4
-> filesize 1,4GB with 40745425 lines and canceling by e2fsck at the end
- errors see test2
- read error while reading next inode

Test4:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 \
                /dev/sd{a,b,c,f,e,d}4
->filesize 874MB with 25412000 lines and break by e2fsck at the end
- try original superblock
- bad superblock or damaged partitiontable
- than lots of checksumm  invalid deskriptor of group
- at the end illegal block in inode to much invalid blocks in inode

Test5:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c}4 \
                missing /dev/sd{e,d}4
-> filesize 1,6GB with 45673505 lines and canceling at the end by e2fsck

Test6:
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{a,b,c,f,e}4 \
                missing
- try original superblock
- bad superblock or damage partitiontable
- lots of checksumm error in group deskriptor
- ends with conflict in inode table with another filesystem block
-> filesize 542MB with 15727702 lines and cancelingat the end by e2fsck

what would be the next step?
- backup the disks
- create best combination or all with 
mdadm --create --level 5 -n 6 --chunk=512 --assume-clean /dev/md2 /dev/sd{x,x,x,x,x}4 missing
- ??
