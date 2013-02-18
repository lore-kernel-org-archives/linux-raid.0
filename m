From: sk <sdk0084@yahoo.com>
Subject: problems formatting raid5
Date: Sun, 17 Feb 2013 23:58:32 -0800 (PST)
Message-ID: <1361174312.47911.YahooMailNeo@web163006.mail.bf1.yahoo.com>
Reply-To: sk <sdk0084@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hi There,

I am trying to create file system on a software raid5 device but after while it hangs on:

Writing superblocks and filesystem accounting information:


some details:
OS: Scientific Linux release 6.3 (Carbon), 2.6.32-279.el6.x86_64; supermicro 4047R-7JRFT

the command i've used:
mkfs.ext3 -v -m .1 -b 4096 -E stride=128,stripe-width=2304 /dev/md0

mdadm --detail /dev/md0
/dev/md0:
Version : 1.2
Creation Time : Wed Feb 13 15:06:39 2013
Raid Level : raid5
Array Size : 9001838592 (8584.82 GiB 9217.88 GB)
Used Dev Size : 500102144 (476.93 GiB 512.10 GB)
Raid Devices : 19
Total Devices : 20
Persistence : Superblock is persistent

Update Time : Fri Feb 15 15:38:08 2013
State : clean
Active Devices : 19
Working Devices : 20
Failed Devices : 0
Spare Devices : 1

Layout : left-symmetric
Chunk Size : 512K

Name : sandy2:0 (local to host sandy2)
UUID : 9e313caa:c33e5d9c:e56f7848:b0c67189
Events : 52

Number Major Minor RaidDevice State
0 8 33 0 active sync /dev/sdc1
1 8 49 1 active sync /dev/sdd1
2 8 65 2 active sync /dev/sde1
3 8 81 3 active sync /dev/sdf1
4 8 97 4 active sync /dev/sdg1
5 8 113 5 active sync /dev/sdh1
6 8 129 6 active sync /dev/sdi1
7 8 145 7 active sync /dev/sdj1
8 8 161 8 active sync /dev/sdk1
9 8 177 9 active sync /dev/sdl1
10 8 193 10 active sync /dev/sdm1
11 8 209 11 active sync /dev/sdn1
12 8 225 12 active sync /dev/sdo1
13 8 241 13 active sync /dev/sdp1
14 65 1 14 active sync /dev/sdq1
15 65 17 15 active sync /dev/sdr1
16 65 33 16 active sync /dev/sds1
17 65 49 17 active sync /dev/sdt1
20 65 65 18 active sync /dev/sdu1

19 8 17 - spare /dev/sdb1

i have tried with mkfs.ext4, and mke2fs as well but the result was the same.
any ideas what could be wrong ?
Thx!
SK

