From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: raid6 array ,  part id 'fd' not assembling at boot .
Date: Fri, 16 Mar 2007 18:48:06 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0703161838110.11877@filesrv1.baby-dragons.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid maillist <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello All ,  I am having a dickens of a time with preparing this system 
to replace my present one .
 	I created a raid6 array over 6 147GB scsi drives .
 	steps I followed were .

 	fdisk /dev/sd[c-h] ( one at a time of course )
 	  created a partition starting at cyl 2 & -10 Cyls from the end of the drive .
 	  typed the partion FD
 	  w
 	repeat until all six drives partitioned .

 	mdadm --create /dev/md3 --chunk=64 --metadata=1.2 --verbose --bitmap=internal --level=6 --raid-devices=6 --spare-devices=0 /dev/sd[cdefgh]1
 	Built just fine .

 	mkfs.ext3 -c -b 4096 -j -L HOME -R stride=96 /dev/md3
 	Again no problems noted .

 	reboot .

 	Array does not get reassembled ,  Here is the snippit out of a reboot .

md: Autodetecting RAID arrays.
md: invalid raid superblock magic on sdc1
md: sdc1 has invalid sb, not importing!
md: invalid raid superblock magic on sdd1
md: sdd1 has invalid sb, not importing!
md: invalid raid superblock magic on sde1
md: sde1 has invalid sb, not importing!
md: invalid raid superblock magic on sdf1
md: sdf1 has invalid sb, not importing!
md: invalid raid superblock magic on sdg1
md: sdg1 has invalid sb, not importing!
md: invalid raid superblock magic on sdh1
md: sdh1 has invalid sb, not importing!

 	Here is the WHOLE enchalada .  Too big to put on the list so I posted 
them to my webpage . 
http://www.baby-dragons.com/linux-2.6.20.2a.config
http://www.baby-dragons.com/filesrv1b-raid6-reassemble-problem.log

 		Tia ,  JimL

-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
