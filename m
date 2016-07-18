From: Bryan Hepworth <bryan.hepworth@newcastle.ac.uk>
Subject: superblock help
Date: Mon, 18 Jul 2016 13:33:24 +0000
Message-ID: <DB5PR07MB1287750A7AA38F7154BCCC56D5360@DB5PR07MB1287.eurprd07.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi

I'm trying to salvage some data from disk from a raid I didn't assemble. This is the only disk that has information on. It gets picked up ok as a linux ext4 raid partition in gparted. I was expecting to see raid 5 over four disks, sadly not - the other disks have gpt partitions but report as being unallocated in gparted and gdisk.

Any suggestions as to what to try next in finding a superblock?

Thanks

Bryan

<i>Filesystem volume name:   inscribe_data1
Last mounted on:          <not available>
Filesystem UUID:          95c359b0-66bf-4394-89da-4d7866a92475
Filesystem magic number:  0xEF53
Filesystem revision #:    1 (dynamic)
Filesystem features:      has_journal ext_attr resize_inode dir_index filetype extent flex_bg sparse_super large_file huge_file uninit_bg dir_nlink extra_isize
Filesystem flags:         signed_directory_hash 
Default mount options:    (none)
Filesystem state:         clean
Errors behavior:          Continue
Filesystem OS type:       Linux
Inode count:              122101760
Block count:              488378368
Reserved block count:     24418918
Free blocks:              480664949
Free inodes:              122101749
First block:              0
Block size:               4096
Fragment size:            4096
Reserved GDT blocks:      907
Blocks per group:         32768
Fragments per group:      32768
Inodes per group:         8192
Inode blocks per group:   512
Flex block group size:    16
Filesystem created:       Thu Aug 28 13:57:16 2014
Last mount time:          n/a
Last write time:          Thu Aug 28 14:01:42 2014
Mount count:              0
Maximum mount count:      33
Last checked:             Thu Aug 28 13:57:16 2014
Check interval:           15552000 (6 months)
Next check after:         Tue Feb 24 12:57:16 2015
Lifetime writes:          29 GB
Reserved blocks uid:      0 (user root)
Reserved blocks gid:      0 (group root)
First inode:              11
Inode size:	          256
Required extra isize:     28
Desired extra isize:      28
Journal inode:            8
Default directory hash:   half_md4
Directory Hash Seed:      8c787fea-f93e-453d-ac45-d49a339628ab
Journal backup:           inode blocks</i>

<i>dumpe2fs 1.41.12 (17-May-2010)
Journal superblock magic number invalid!</i>

<i>Unable to read the contents of this file system!
Because of this some operations may be unavailable.
The cause might be a missing software package.
The following list of software packages is required for ext4 file system support:  e2fsprogs v1.41+.</i>

[root@igmimager sbin]# ./gdisk /dev/sdn
GPT fdisk (gdisk) version 0.8.10

Partition table scan:
  MBR: protective
  BSD: not present
  APM: not present
  GPT: present

Found valid GPT with protective MBR; using GPT.

Command (? for help): ?
b	back up GPT data to a file
c	change a partition's name
d	delete a partition
i	show detailed information on a partition
l	list known partition types
n	add a new partition
o	create a new empty GUID partition table (GPT)
p	print the partition table
q	quit without saving changes
r	recovery and transformation options (experts only)
s	sort partitions
t	change a partition's type code
v	verify disk
w	write table to disk and exit
x	extra functionality (experts only)
?	print this menu

Command (? for help): p
Disk /dev/sdn: 3907029168 sectors, 1.8 TiB
Logical sector size: 512 bytes
Disk identifier (GUID): E6755AAC-5295-4417-BA21-E1016486CBDB
Partition table holds up to 128 entries
First usable sector is 34, last usable sector is 3907029134
Partitions will be aligned on 2048-sector boundaries
Total free space is 2157 sectors (1.1 MiB)

Number  Start (sector)    End (sector)  Size       Code  Name
   1            2048      3907028991   1.8 TiB     FD00  

Command (? for help): i
Using 1
Partition GUID code: A19D880F-05FC-4D3B-A006-743F0F84911E (Linux RAID)
Partition unique GUID: 911F59F3-AB98-4A40-9F0B-B191B5C5010E
First sector: 2048 (at 1024.0 KiB)
Last sector: 3907028991 (at 1.8 TiB)
Partition size: 3907026944 sectors (1.8 TiB)
Attribute flags: 0000000000000000
Partition name: ''

Command (? for help): 

