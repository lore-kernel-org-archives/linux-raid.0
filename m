From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: fsck problems.  Can't restore raid
Date: Sun, 27 Dec 2009 16:47:06 -0600
Message-ID: <28.16.07989.EE3E73B4@cdptpa-omtalb.mail.rr.com>
References: <1261939285.10448.3328.camel@vibe>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1261939285.10448.3328.camel@vibe>
Sender: linux-raid-owner@vger.kernel.org
To: 'Rick Bragg' <lists@gmnet.net>
Cc: 'Linux RAID' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> On Sun, 2009-12-27 at 00:13 -0600, Leslie Rhorer wrote:
> > > # mdadm --examine /dev/sdb1
> > > mdadm: No md superblock detected on /dev/sdb1.
> > >
> > > (Does this mean that sdb1 is bad? or is that OK?)
> >
> > 	It doesn't necessarily mean the drive is bad, but the superblock is
> > gone.  Are you having mdadm monitor your array(s) and send informational
> > messages to you upon RAID events?  If not, then what may have happened
> is
> > you lost the superblock on sdb1 and at some other time - before or after
> -
> > lost the sda drive.  Once both events had taken place, your array is
> toast.
> Right, I need to set up monitoring...

	Um, yeah.  A RAID array won't prevent drives from going up in smoke,
and if you don't know a drive has failed, you won't know you need to fix
something - until a second drive fails.

> > 	All may not be lost, however.  First of all, take care when
> > re-arranging not to lose track of which drive was which at the outset.
> In
> > fact, other than the sda drive, you might be best served not to move
> > anything.  Take special care if the system re-assigns drive letters, as
> it
> > can easily do.
> So should I just "move" the A drive? and try to fire it back up?

	At this point, yeah.  Don't lose track of from where and to where it
has been moved, though.

> > 	What are the contents of /etc/mdadm.conf?
> >
> 
> mdadm.conf contains this:
> ARRAY /dev/md0 level=raid10 num-devices=4
> UUID=3d93e545:c8d5baec:24e6b15c:676eb40f

	Yeah, that doesn't help much.

> So, by re-creating, do you mean I should try to run the "mdadm --create"
> command again the same way I did back when I created the array
> originally? Will that wipe out my data?

	Not in and of itself, no.  If you get the drive order wrong
(different than when it was first created) and resync or write to the array,
then it will munge the data, but all creating the array does is create the
superblocks.


> # smartctl -l selftest /dev/sda
> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> Standard Inquiry (36 bytes) failed [No such device]
> Retrying with a 64 byte Standard Inquiry
> Standard Inquiry (64 bytes) failed [No such device]
> A mandatory SMART command failed: exiting. To continue, add one or more '-
> T permissive' options.

	Well, we kind of knew that.  Either the drive is dead, or there is a
hardware problem in the controller path.  Hope for the latter, although a
drive with a frozen platter can sometimes be resurrected, and if the drive
electronics are bad but the servo assemblies are OK, replacing the
electronics is not difficult.  Otherwise, it's a goner.

> # smartctl -l selftest /dev/sdb
> smartctl version 5.38 [i686-pc-linux-gnu] Copyright (C) 2002-8 Bruce Allen
> Home page is http://smartmontools.sourceforge.net/
> 
> === START OF READ SMART DATA SECTION ===
> SMART Self-test log structure revision number 1
> Num  Test_Description    Status                  Remaining
> LifeTime(hours)  LBA_of_first_error
> # 1  Extended offline    Completed: read failure       90%      7963
> 543357

	Oooh!  That's bad.  Really bad.  Your earlier post showed the
superblock is a 0.90 version.  The 0.90 superblock is stored near the end of
the partition.  Your drive is suffering a heart attack when it gets near the
end of the drive.  If you can't get your sda drive working again, then I'm
afraid you've lost some data, maybe all of it.  Trying to rebuild a
partition from scratch when part of it is corrupted is not for the feint of
heart.  If you are lucky, you might be able to dd part of the sdb drive onto
a healthy one and manually restore the superblock.  That, or since the sda
drive does appear in /dev, you might have some luck copying some of it to a
new drive.

	Beyond that, you are either going to need the advice of someone who
knows much more about md and Linux than I do, or else the services of a
professional drive recovery expert.  They don't come cheap.

> This is strange, now I am getting info from mdadm --examine that is
> different than before...

	It looks like sda may be responding for the time being.  I suggest
you try to assemble the array, and if successful, copy whatever data you can
to a backup device.  Do not mount the array as read-write until you have
recovered everything you can.  If some data is orphaned, it might be in the
lost+found directory.  If that's successful, I suggest you find out why you
had two failures and start over.  I wouldn't use a 0.90 superblock, though,
and you definitely want to have monitoring enabled.

