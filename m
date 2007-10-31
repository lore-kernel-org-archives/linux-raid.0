From: =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
Subject: Strange CPU occupation...
Date: Wed, 31 Oct 2007 13:38:20 +0100
Message-ID: <4728773C.7010802@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: sparclinux@vger.kernel.org, linux-raid@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net
List-Id: linux-raid.ids

	Hello,

	I'm looking for a bug in iSCSI target code, but I have found this 
morning a new bug that is certainly related to mine...

Please consider these raid volumes:
Root gershwin:[/etc] > cat /proc/mdstat
Personalities : [raid1] [raid6] [raid5] [raid4]
md7 : active raid1 sdi1[2](F) md_d0p1[0]
       1464725632 blocks [2/1] [U_]

md_d0 : active raid5 sdc1[0] sdh1[5] sdg1[4] sdf1[3] sde1[2] sdd1[1]
       1464725760 blocks level 5, 64k chunk, algorithm 2 [6/6] [UUUUUU]

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
Root gershwin:[/etc] >

md7 only has one disk because I cannot synchronize it over iSCSI. But 
without any message, load average of this server (24 threads T1000) 
increases until more than 9. top returns :
top - 13:36:08 up 4 days,  1:00,  3 users,  load average: 9.23, 8.46, 6.26
Tasks: 252 total,   5 running, 246 sleeping,   0 stopped,   1 zombie
Cpu(s):  0.0%us,  4.2%sy,  0.0%ni, 87.4%id,  8.4%wa,  0.0%hi,  0.0%si, 
0.0%st
Mem:   4139024k total,  4115920k used,    23104k free,   743976k buffers
Swap:  7815536k total,      304k used,  7815232k free,  2188048k cached

   PID USER      PR  NI  VIRT  RES  SHR S %CPU %MEM    TIME+  COMMAND 

  5426 root      15  -5     0    0    0 R  100  0.0  46:32.54 
md_d0_raid5
17215 root      20   0  3120 1552 1112 R    1  0.0   0:01.38 top 

     1 root      20   0  2576  960  816 S    0  0.0   0:09.74 init 

     2 root      15  -5     0    0    0 S    0  0.0   0:00.00 kthreadd 

     3 root      RT  -5     0    0    0 S    0  0.0   0:00.18 
migration/0
     4 root      15  -5     0    0    0 S    0  0.0   0:00.18 
ksoftirqd/0

and some process are in D state :
Root gershwin:[/etc] > ps auwx | grep D
USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME COMMAND
root       270  0.0  0.0      0     0 ?        D    Oct27   1:17 [pdflush]
root      3676  0.9  0.0      0     0 ?        D    Oct27  56:03 [nfsd]
root      5435  0.0  0.0      0     0 ?        D<   Oct27   3:16 [md7_raid1]
root      5438  0.0  0.0      0     0 ?        D<   Oct27   1:01 [kjournald]
root      5440  0.0  0.0      0     0 ?        D<   Oct27   0:33 [loop0]
root      5441  0.0  0.0      0     0 ?        D<   Oct27   0:05 [kjournald]
root     16442  0.0  0.0  20032  1208 pts/2    D+   13:23   0:00 iftop 
-i eth2

	Why md7_raid is in D state ? Same question about iftop ?

	Regards,

	JKB
