From: Corey McGuire <coreyfro@coreyfro.com>
Subject: RAID 5 lost two disks
Date: Fri, 5 Mar 2004 09:26:42 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200403050926.42047.coreyfro@coreyfro.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

help! I'm too afraid to STFW.

All I have to say is SuSE is a @#$@#$ piece of @#$@#$!

I am not used to not having a !@#!@# RAIDTAB! Thats right, SuSE never 
generated a RAIDTAB!  I have no clue what my RAID5 is built like, and I need 
to mkraid -R it? yeah, right!

SuSE must autodetect the RAID, which would be fine if my RAID WERE STILL 
WORKING!

all I have to go by is what dmesg outputs when trying to build the raid.

before I put the dump, let me give my system run down

Kernel 2.4.23
mkraid version 0.90.0

6 disks, hda3, hdc3, hde3, hdg3, hdi3, hdk3

A and C are on the motherboard
E and G are on a promise card
I and K are on another promise card

This is /home this is my everything... 1 @#$@# TB of everything... backed up 
maybe 3 months ago, maybe 4...

everything was working great for nearly 8 months until the failure

Golden bricks people... There's not enough dietary fiber in the world...

as far as I can tell the order is [dev 00:00] hdg3 [dev 00:00] hdk3 hda3 hdc3

if i write this to the raidtab, and its wrong, can i raidstop and try again?

I'm sorry if I'm missing important info... I'm not thinking very well...

here is the dmesg output... 

 [events: 0000004c]
 [events: 00000049]
 [events: 0000004c]
 [events: 0000004a]
 [events: 0000004c]
 [events: 0000004c]
md: autorun ...
md: considering hdc3 ...
md:  adding hdc3 ...
md:  adding hdk3 ...
md:  adding hdi3 ...
md:  adding hdg3 ...
md:  adding hde3 ...
md:  adding hda3 ...
md: created md2
md: bind<hda3,1>
md: bind<hde3,2>
md: bind<hdg3,3>
md: bind<hdi3,4>
md: bind<hdk3,5>
md: bind<hdc3,6>
md: running: <hdc3><hdk3><hdi3><hdg3><hde3><hda3>
md: hdc3's event counter: 0000004c
md: hdk3's event counter: 0000004c
md: hdi3's event counter: 0000004a
md: hdg3's event counter: 0000004c
md: hde3's event counter: 00000049
md: hda3's event counter: 0000004c
md: superblock update time inconsistency -- using the most recent one
md: freshest: hdc3
md: kicking non-fresh hdi3 from array!
md: unbind<hdi3,5>
md: export_rdev(hdi3)
md: kicking non-fresh hde3 from array!
md: unbind<hde3,4>
md: export_rdev(hde3)
md2: removing former faulty hde3!
md2: removing former faulty hdi3!
md2: max total readahead window set to 1240k
md2: 5 data-disks, max readahead per data-disk: 248k
raid5: device hdc3 operational as raid disk 5
raid5: device hdk3 operational as raid disk 3
raid5: device hdg3 operational as raid disk 1
raid5: device hda3 operational as raid disk 4
raid5: not enough operational devices for md2 (2/6 failed)
RAID5 conf printout:
 --- rd:6 wd:4 fd:2
 disk 0, s:0, o:0, n:0 rd:0 us:1 dev:[dev 00:00]
 disk 1, s:0, o:1, n:1 rd:1 us:1 dev:hdg3
 disk 2, s:0, o:0, n:2 rd:2 us:1 dev:[dev 00:00]
 disk 3, s:0, o:1, n:3 rd:3 us:1 dev:hdk3
 disk 4, s:0, o:1, n:4 rd:4 us:1 dev:hda3
 disk 5, s:0, o:1, n:5 rd:5 us:1 dev:hdc3
raid5: failed to run raid set md2
md: pers->run() failed ...
md :do_md_run() returned -22
md: md2 stopped.
md: unbind<hdc3,3>
md: export_rdev(hdc3)
md: unbind<hdk3,2>
md: export_rdev(hdk3)
md: unbind<hdg3,1>
md: export_rdev(hdg3)
md: unbind<hda3,0>
md: export_rdev(hda3)
md: ... autorun DONE.
