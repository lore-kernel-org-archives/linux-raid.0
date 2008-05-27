From: Lars =?UTF-8?B?VMOkdWJlcg==?= <taeuber@bbaw.de>
Subject: Re: aoe disk not recognized as part of raid
Date: Tue, 27 May 2008 09:52:40 +0200
Message-ID: <20080527095240.f517e4ff.taeuber@bbaw.de>
References: <20080523142525.31d6e06b.taeuber@bbaw.de>
	<20080523170056.d6e39787.taeuber@bbaw.de>
	<46144.192.168.1.70.1211610465.squirrel@neil.brown.name>
	<20080526122057.1ed4454e.taeuber@bbaw.de>
	<18491.45392.503390.245024@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18491.45392.503390.245024@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

Neil Brown <neilb@suse.de> schrieb:
> > Any idea on the actual subject?
> 
> I need you to try the --assemble with --verbose to find out what is
> happening.
> Use an earlier version of mdadm.  (e.g. 2.6.4).

this is the output:

monosan:/usr/local/src/mdadm-2.6.4 # ./mdadm -Av /dev/md9
mdadm: looking for devices for /dev/md9
mdadm: cannot open device /dev/sdb2: Device or resource busy
mdadm: /dev/sdb2 has wrong uuid.
mdadm: cannot open device /dev/sdb1: Device or resource busy
mdadm: /dev/sdb1 has wrong uuid.
mdadm: cannot open device /dev/sda3: Device or resource busy
mdadm: /dev/sda3 has wrong uuid.
mdadm: cannot open device /dev/sda2: Device or resource busy
mdadm: /dev/sda2 has wrong uuid.
mdadm: cannot open device /dev/sda1: Device or resource busy
mdadm: /dev/sda1 has wrong uuid.
mdadm: cannot open device /dev/dm-9: Device or resource busy
mdadm: /dev/dm-9 has wrong uuid.
mdadm: cannot open device /dev/dm-8: Device or resource busy
mdadm: /dev/dm-8 has wrong uuid.
mdadm: cannot open device /dev/dm-7: Device or resource busy
mdadm: /dev/dm-7 has wrong uuid.
mdadm: cannot open device /dev/dm-6: Device or resource busy
mdadm: /dev/dm-6 has wrong uuid.
mdadm: cannot open device /dev/dm-5: Device or resource busy
mdadm: /dev/dm-5 has wrong uuid.
mdadm: cannot open device /dev/dm-4: Device or resource busy
mdadm: /dev/dm-4 has wrong uuid.
mdadm: cannot open device /dev/dm-3: Device or resource busy
mdadm: /dev/dm-3 has wrong uuid.
mdadm: cannot open device /dev/dm-2: Device or resource busy
mdadm: /dev/dm-2 has wrong uuid.
mdadm: /dev/dm-17 has wrong uuid.
mdadm: cannot open device /dev/dm-15: Device or resource busy
mdadm: /dev/dm-15 has wrong uuid.
mdadm: cannot open device /dev/dm-14: Device or resource busy
mdadm: /dev/dm-14 has wrong uuid.
mdadm: cannot open device /dev/dm-13: Device or resource busy
mdadm: /dev/dm-13 has wrong uuid.
mdadm: cannot open device /dev/dm-12: Device or resource busy
mdadm: /dev/dm-12 has wrong uuid.
mdadm: cannot open device /dev/dm-11: Device or resource busy
mdadm: /dev/dm-11 has wrong uuid.
mdadm: cannot open device /dev/dm-10: Device or resource busy
mdadm: /dev/dm-10 has wrong uuid.
mdadm: cannot open device /dev/dm-1: Device or resource busy
mdadm: /dev/dm-1 has wrong uuid.
mdadm: /dev/dm-0 has wrong uuid.
mdadm: /dev/dm-16 is identified as a member of /dev/md9, slot 0.
mdadm: no uptodate device for slot 1 of /dev/md9
mdadm: added /dev/dm-16 to /dev/md9 as 0
mdadm: /dev/md9 has been started with 1 drive (out of 2).

# cat /proc/partitions 
major minor  #blocks  name

   8     0  160836480 sda
   8     1   14354046 sda1
   8     2   48829567 sda2
   8     3   48829567 sda3
   8    16  160836480 sdb
   8    17   14354046 sdb1
   8    18   48829567 sdb2
   8    32  976762584 sdc
...
  65   144  976762584 sdz
  65   160  976762584 sdaa
...
  66    16  976762584 sdah
   9     2   14353920 md2
 253     0  976762584 dm-0
...
 253    15  976762584 dm-15
   9     3   48829440 md3
   9     4 12697912448 md4
   9     9 1074790336 md9
 152  2832 1074790400 etherd/e11.1
 253    16 1074790400 dm-16
 253    17 8589934592 dm-17


dm-16 and etherd/e11.1 are the two parts of md9.

monosan:/usr/local/src/mdadm-2.6.4 # cat /proc/mdstat 
Personalities : [raid1] [raid0] [raid6] [raid5] [raid4] 
md9 : active (auto-read-only) raid1 dm-16[0]
      1074790336 blocks [2/1] [U_]

Sorry for the voluminous outputs. :)
Good luck.
Lars
