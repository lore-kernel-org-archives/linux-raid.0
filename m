From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Partitionable raid array... How to create devices ?
Date: Tue, 16 Oct 2007 10:22:46 +0200
Message-ID: <471474D6.5090704@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

	Hello,

	I use software raid for a long time without any trouble. Today, I have 
to install a partitionable raid1 array over iSCSI. I have some questions 
because I don't understand how make this kind of array.

	I have a sparc64 (T1000) with a JBOD (U320 SCSI) that runs a 2.6.23 
linux kernel and debian testing distribution.

/dev/sda : internal SAS drive -> OS
/dev/sdb : internal SAS drive -> OS

I have made on /dev/sda and /dev/sdb seven raid1 volumes (non 
partitionables arrays).

/dev/sd[c-h] : external U320 drives. Each 300 GB drive only contains one 
"type fd" partition.

I have tried to create a partitionable array with :

Root gershwin:[/usr/src/linux-2.6.23] > mdadm -C /dev/mdp0 -l5 
--auto=mdp4 -n6 /dev/sd[c-h]1

Root gershwin:[/dev] > ls -l md*
brw-rw---- 1 root disk  9,   0 Oct 15 10:29 md0
brw-rw---- 1 root disk  9,   1 Oct 15 10:29 md1
brw-rw---- 1 root disk  9, 127 Oct 16 09:59 md127
brw-rw---- 1 root disk  9,   2 Oct 15 10:29 md2
brw-rw---- 1 root disk  9,   3 Oct 15 10:29 md3
brw-rw---- 1 root disk  9,   4 Oct 15 10:29 md4
brw-rw---- 1 root disk  9,   5 Oct 15 10:29 md5
brw-rw---- 1 root disk  9,   6 Oct 15 10:29 md6
brw-rw---- 1 root disk  9,   7 Oct 15 10:29 md7
brw-rw---- 1 root disk  9,   8 Oct 15 10:29 md8
crw-rw---- 1 root root 10,  63 Oct 15 10:29 mdesc
brw-rw---- 1 root disk  9, 127 Oct 16 10:03 mdp0

md:
total 0
brw-rw---- 1 root disk 9, 7 Oct 15 10:29 7
brw-rw---- 1 root disk 9, 8 Oct 15 10:29 8
Root gershwin:[/dev] > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md127 : active raid5 sdh1[6] sdg1[4] sdf1[3] sde1[2] sdd1[1] sdc1[0]
       1464725760 blocks level 5, 64k chunk, algorithm 2 [6/5] [UUUUU_]
       [==>..................]  recovery = 12.6% (37043392/292945152) 
finish=127.5min speed=33440K/sec

md6 : active raid1 sda1[0] sdb1[1]
       7815552 blocks [2/2] [UU]

md5 : active raid1 sda8[0] sdb8[1]
       14538752 blocks [2/2] [UU]

md4 : active raid1 sda7[0] sdb7[1]
       4883648 blocks [2/2] [UU]

md3 : active raid1 sda6[0] sdb6[1]
       9767424 blocks [2/2] [UU]

md2 : active raid1 sda5[0] sdb5[1]
       29294400 blocks [2/2] [UU]

md1 : active raid1 sda2[0] sdb2[1]
       489856 blocks [2/2] [UU]

md0 : active raid1 sdb4[1] sda4[0]
       4883648 blocks [2/2] [UU]

unused devices: <none>
Root gershwin:[/dev] >

	Well, /dev/mdp0 is created. But what's about /dev/mdp0p1 ? I believe 
that mdadm has to create required devices. I don't understand where is 
my mistake. Any idea ?

	Regards,

	JKB
