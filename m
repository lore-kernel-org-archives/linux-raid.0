From: Mario 'BitKoenig' Holbe <Mario.Holbe@TU-Ilmenau.DE>
Subject: How to reclaim device slots on v1 superblock?
Date: Tue, 29 Jun 2010 15:02:09 +0200
Message-ID: <slrni2jrmi.n7r.Mario.Holbe@darkside.dyn.samba-tng.org>
References: <4AB37978.5030403@Calva.COM>
 <slrnhb7mt1.dbe.Mario.Holbe@darkside.dyn.samba-tng.org>
 <slrnhbcnjv.eul.Mario.Holbe@darkside.dyn.samba-tng.org>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

md with v1 superblocks seem to somehow associate device slots with
specific devices and doesn't re-use them with others (this was already
reported by John Hughes a while ago, btw.).

So, my question is: how can I force md to finally give up a specific
slot or re-use it with another device?

For example, creating a degraded array reserves slot 1 for the "missing"
device and never re-uses it, but uses slot 2 instead:
	# mdadm -C -n 2 -l raid1 -a md /dev/md9 /dev/loop0 missing
	# mdadm -a /dev/md9 /dev/loop1
	md9 : active raid1 loop1[2] loop0[0]

Creating the array fully developed uses slot 0 and 1 as expected:
	# mdadm -C -n 2 -l raid1 -a md /dev/md9 /dev/loop0 /dev/loop1  
	md9 : active raid1 loop1[1] loop0[0]

The only way I found to enforce using slot 0 and 1 while creating a
degraded array is to grow the number of active devices later:
	# mdadm -C -n 1 --force -l raid1 -a md /dev/md9 /dev/loop0  
	# mdadm -a /dev/md9 /dev/loop1
	# mdadm -G -n 2 /dev/md9
	md9 : active raid1 loop1[1] loop0[0]

Unfortunately, the reverse assumption: reduce the number of active
devices to re-claim unused slots doesn't appear to work:
	# mdadm -C -n 2 -l raid1 -a md /dev/md9 /dev/loop0 missing
	# mdadm -a /dev/md9 /dev/loop1
	md9 : active raid1 loop1[2] loop0[0]
	# mdadm --fail /dev/md9 /dev/loop1
	# mdadm --remove /dev/md9 /dev/loop1
	# mdadm -G -n 1 --force /dev/md9 
	# mdadm -a /dev/md9 /dev/loop1
	# mdadm -G -n 2 /dev/md9
	md9 : active raid1 loop1[2] loop0[0]

I'm using Debians mdadm 3.1.2-2 which defaults to v1.2 superblocks.



regards
   Mario
-- 
Tower: "Say fuelstate." Pilot: "Fuelstate."
Tower: "Say again." Pilot: "Again."
Tower: "Arghl, give me your fuel!" Pilot: "Sorry, need it by myself..."

