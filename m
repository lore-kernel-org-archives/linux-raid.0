From: Michael Munger <michael@highpoweredhelp.com>
Subject: [UU_] Won't go away
Date: Tue, 27 Oct 2015 08:17:26 -0400
Message-ID: <562F6B56.9040901@highpoweredhelp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

It's my understanding, that an array running with [UU_] is degraded and
there is a disk problem.

I have been trying to create a RAID array using this command:

mdadm --create --verbose /dev/md0 --level=5 --raid-devices=3 /dev/sdb1
/dev/sdc1 /dev/sdd1

However, once it create it, it get this in /proc/mdstat:

Personalities : [raid6] [raid5] [raid4]
md0 : active raid5 sdd1[3] sdc1[1] sdb1[0]
      3906764800 blocks super 1.2 level 5, 512k chunk, algorithm 2 [3/2]
[UU_]
      [>....................]  recovery =  0.1% (2611780/1953382400)
finish=1737.7min speed=18709K/sec
      bitmap: 0/15 pages [0KB], 65536KB chunk

I have done the following to "fix" the drive:

1. Smartmontools smartctl long and short tests. All passed.
2. Zeroed the first 1GB of the drive (overkill, I know I could just do
the first 512) with dd if=/dev/zero of=/dev/sdb count=250000 bs=4k
3. Re-partitioned the drive.
4. Re-create.

No joy.

Then, I swapped this hard drive out for another drive.

I am still getting [UU_].

Thoughts?
-- 
Michael Munger, dCAP, MCPS, MCNPS, MBSS
High Powered Help, Inc.
Microsoft Certified Professional
Microsoft Certified Small Business Specialist
Digium Certified Asterisk Professional
michael@highpoweredhelp.com

-- 
Michael Munger, dCAP, MCPS, MCNPS, MBSS
High Powered Help, Inc.
Microsoft Certified Professional
Microsoft Certified Small Business Specialist
Digium Certified Asterisk Professional
michael@highpoweredhelp.com
