From: jef <jefv@factorylabs.com>
Subject: adding a device to existing RAID 0
Date: Thu, 05 Aug 2004 15:38:06 -0600
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1091741886.5260.12.camel@HT.petrafex>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

after reading & googling all over the place I'm still uncertain that
what I want to do will work. basically I have a 2 device RAID-0 with
existing data on it.

trogdor:# cat /proc/mdstat
Personalities : [raid0]
md0 : active raid0 sdc1[1] sdb1[0]
      1809352448 blocks 8k chunks
       
unused devices: <none>

What I'd like to do is add a third device to increase the capacity.
According to the man page and numerous examples I've found, you can do
this with:

mdadm --add /dev/md0 /dev/sdd

the catch is that all the examples I've seen were for recovering a
RAID-5 (removing a failed device then adding one). Does anyone know if
this will work without destroying the existing data on a RAID-0? 

Thanks in advance!

