From: "Guy" <bugzilla@watkins-home.com>
Subject: RE: RAID5 - 2nd drive died whilst waiting for RMA
Date: Sat, 13 Nov 2004 15:39:07 -0500
Message-ID: <200411132039.iADKdDN07474@www.watkins-home.com>
References: <41966514.8000301@dgreaves.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41966514.8000301@dgreaves.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Sorry, the command should be:
mdadm --assemble --force /dev/md0 /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/hdb1

Hope that helps.

Guy

-----Original Message-----
From: David Greaves [mailto:david@dgreaves.com] 
Sent: Saturday, November 13, 2004 2:49 PM
To: Guy
Cc: linux-raid@vger.kernel.org
Subject: Re: RAID5 - 2nd drive died whilst waiting for RMA

OK, not great, but nothing has broken either.

So the reboot happened, the disks went in and got moved around:
new drive->/dev/sdd1
the machine hung complaining 'ata4 timed out' during dd if=sda of=sdd :(
reboot, did it again and it worked fine ( - no errors? maybe it was 
transient? anway...)

powerdown
move sickly drive (sda) to new controller (new:sde)
move new copy (sdd) to position 1 (new:sda)
insert new spare disk (new:sdd)

of course, the partitions are 'fd' so boot produces:
md: Autodetecting RAID arrays.
md: invalid raid superblock magic on sdd1
md: sdd1 has invalid sb, not importing!
# that's fair, I just made a partition, never used, no sb
md: autorun ...
md: considering sde1 ...
# hmm, ok, it's fd and has a superblock but should be marked faulty
md: adding sde1 ...
md: adding sdc1 ...
md: adding sdb1 ...
md: adding sda1 ...
md: adding hdb1 ...
md: created md0
md: bind<hdb1>
md: bind<sda1>
md: bind<sdb1>
md: bind<sdc1>
md: export_rdev(sde1)
# what does this mean? does it mean 'sb is marked faulty'?
md: running: <sdc1><sdb1><sda1><hdb1>
md: kicking non-fresh sda1 from array!
# OK, so you recognise it as an md device but think it's dirty - good
md: unbind<sda1>
md: export_rdev(sda1)
raid5: device sdc1 operational as raid disk 1
raid5: device sdb1 operational as raid disk 2
raid5: device hdb1 operational as raid disk 4
raid5: not enough operational devices for md0 (2/5 failed)
# as expected


Now, Guy, your next step:
# mdadm --assemble --force /dev/sda1 /dev/sdb1 /dev/sdc1 /dev/hdb1
mdadm: /dev/sda1 does not appear to be an md device

Oh.

So the first thing I'm doing is to cleanly redo the dd_rescue from (now) 
sde to sda

Comments?

David

PS Guy, my ISP has blocked comcast.net due to excessive spam - he's 
reconsidered and will unblock them 'soon' but for now I can only 
apologise :(

