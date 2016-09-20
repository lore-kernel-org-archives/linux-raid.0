From: "WNSDEV" <pete@wnsdev.com>
Subject: RAID1 Questions.  Please help
Date: Tue, 20 Sep 2016 10:40:44 -0700
Message-ID: <001801d21366$1defc350$59cf49f0$@wnsdev.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: en-us
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,  I would greatly appreciate some insight here.

 
Ubuntu 16.04 LTS

$ uname -a 
Linux hostname 4.4.0-21-generic #37-Ubuntu SMP Mon Apr 18 18:33:37 UTC 2016
x86_64 x86_64 x86_64 GNU/Linux

$ mdadm -V
mdadm - v3.3 - 3rd September 2013

RAID1 configuration of 2 SSDs.

Fresh install of Ubuntu 16.04LTS using the installer to create the RAID1
with 3 partitions (/boot,swap,/)

Output of cat /proc/mdstat after installation:


Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4]
[raid10] 
md2 : active raid1 sda3[0] sdb3[1]
      634795008 blocks super 1.2 [2/2] [UU]
      bitmap: 0/5 pages [0KB], 65536KB chunk

md1 : active raid1 sda2[0] sdb2[1]
      126887936 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md0 : active raid1 sda1[0] sdb1[1]
      19514368 blocks super 1.2 [2/2] [UU]
      
unused devices: <none>

Question 1: why is there no bitmap for md0 which is /boot?


Next :  To simulate a failure, I removed sdb from the array, then physically
removed it and installed a new disk in the same physical slot. 
           I partitioned the new disk, synced it to the remaining disk (sda)
then grubed it.  

the output of cat /proc/mdstat after is:

Personalities : [raid1] [linear] [multipath] [raid0] [raid6] [raid5] [raid4]
[raid10] 
md2 : active raid1 sdb3[1] sda3[0]
      634795008 blocks super 1.2 [2/2] [UU]
      bitmap: 0/5 pages [0KB], 65536KB chunk

md1 : active raid1 sdb2[1] sda2[0]
      126887936 blocks super 1.2 [2/2] [UU]
      bitmap: 0/1 pages [0KB], 65536KB chunk

md0 : active raid1 sdb1[2] sda1[0]        
      19514368 blocks super 1.2 [2/2] [UU]
      
unused devices: <none>

Question 2:  why is number in [] for md0, sdb1 now=2 when before it was 1?

Question 3:  Why didn't the numbers for sdb2 and sdb3 change ?
Question 4:  Does it matter what the number are?  Is this an indication of a
problem?
Question 5:  Does this posting pertain here?
http://www.spinics.net/lists/raid/msg49766.html

Thank you for any information or direction,
Pete Sangas





