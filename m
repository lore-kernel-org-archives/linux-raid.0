From: Vidar <vl-list@ez.no>
Subject: Problems moving a raid5 to other devices
Date: Tue, 16 Apr 2002 14:25:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200204161425.44277.vl-list@ez.no>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hi 

system : RH7.2, all erratas installed (like raidtools-0.90-24 and 
kernel-2.4.9-31)

I got a RAID5, initially on hde1, hdg1, hdh1. Now I want to move the raid to 
another computer and use hdb1, hdc1 and hdd1 instead.
I have browsed the mailinglist archive 
(http://marc.theaimsgroup.com/?l=linux-raid) and seen others with simular 
problems but I have still not solved the problem.

I have altered /etc/raidtab to reflect the device changes and run the command
# raidstart -c /etc/raidtab /dev/md0

My log then gives me messages like :
 kernel: (read) hdb1's sb offset: 22073152 [events: 00000023]
 modprobe: modprobe: Can't locate module block-major-33
 kernel: md: could not lock [dev 21:01], zero-size? Marking faulty.

It's obvious that linux still tries to access hde (block-major-33), hdg and 
hdh.

Do I have to install mdadm and perform some magic stunts ?
If so, does mdadm require any particular version of kernel/raidtools ?


-- 
vidar


