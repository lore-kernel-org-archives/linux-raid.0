From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Confused about reshape?
Date: Mon, 31 May 2010 04:12:46 -0500
Message-ID: <5C.14.01646.D8D730C4@cdptpa-omtalb.mail.rr.com>
References: <79.18.03062.D5D530C4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <79.18.03062.D5D530C4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Leslie Rhorer' <lrhorer@satx.rr.com>, 'Neil Brown' <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> > You'll probably need to remove the bitmap for --grow to work... I really
> > should fix that.
> 
> 	OK.  That's pretty minor.  I'll do that.
> 
> > >     Update Time : Mon May 31 00:44:25 2010
> > >           State : active
> > >  Active Devices : 8
> > > Working Devices : 9
> > >  Failed Devices : 0
> > >   Spare Devices : 1
> > >
> > >          Layout : left-symmetric
> > >      Chunk Size : 256K
> > >
> > >            Name : Backup:0  (local to host Backup)
> > >            UUID : 940ae4e4:04057ffc:5e92d2fb:63e3efb7
> > >          Events : 987130
> > >
> > >     Number   Major   Minor   RaidDevice State
> > >        0       8        0        0      active sync   /dev/sda
> > >        1       8       16        1      active sync   /dev/sdb
> > >        2       8       32        2      active sync   /dev/sdc
> > >        8       8       48        3      active sync   /dev/sdd
> > >        4       8       64        4      active sync   /dev/sde
> > >        5       8       80        5      active sync   /dev/sdf
> > >        6       8       96        6      active sync   /dev/sdg
> > >        7       8      112        7      active sync   /dev/sdh
> > >
> > >        9       8      128        -      spare   /dev/sdi
> > >
> > > Backup:/tmp# mdadm -V >> temp
> > > mdadm - v3.0.3 - 22nd October 2009
> >
> > I should have checked when you mention the mdadm version in the first
> > email.
> > You need at least 3.1.1 to convert RAID5 to RAID6.
> 
> 	OK.  3.1.2-2 is in "Sid".  I don't think it will give the system a
> heart attack if I scarf it from there.

	Or maybe it will...  The reshape had been going for about 2 hours
when suddenly md tossed out a bunch of garbage and halted the system
entirely.  I had to hit the Big Red Switch to bring it back up.  Of course
the system complained about an unclean shutdown, yada, yada, yada, but now
the main thing is the array won't assemble.  I'm afraid I did something in
retrospect rather foolish.  I put the backup file in /tmp, and upon reboot,
Linux wiped the /tmp directory, and mdadm refuses to restart the re-shape
without the file.  What can I do to get the array re-shape to continue?

