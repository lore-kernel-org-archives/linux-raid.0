From: Gordon Henderson <gordon@drogon.net>
Subject: Re: swap on raid 1
Date: Tue, 14 Oct 2003 15:03:45 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310141456150.29390@unicorn.drogon.net>
References: <2507.146.201.32.254.1066131297.squirrel@english3.fsu.edu>
 <200310141536.30248.dusty@strike.wu-wien.ac.at>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200310141536.30248.dusty@strike.wu-wien.ac.at>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 14 Oct 2003, Hermann Himmelbauer wrote:

> On Tuesday 14 October 2003 13:34, skopel@english.fsu.edu wrote:
> > I have been following the discussion of swap on raid 1 and I just want to
> > clarify something... I have my swap on /dev/md1, which is a raid1 device
> > consisting of /dev/hda2 and /dev/hdc2.
> > If one of the drives fails (either hda or hdc), I think the swap will be
> > duplicated on the other and the box will continue merrily on, right?
> > thanks
>
> Basically, that's what I hope.
>
> Anyway - what exactly happens when a PATA harddisk dies? Will this only lead
> to logentries in the syslog, or will this crash the machine due to hardware
> reasons?

Who knows. I do know that if you plug the cable into an IDE drive the
wrong way up, the processor won't start, so I guess it's possible that a
failing IDE drive can take out the entire PC if you are unlucky.

> Probably there would also be a difference if you would do RAID on
> the same channel (e.g. hda, hdb) as a mulfunction of one device could jam the
> whole IDE channel.

This is generally bad. Don't do it. See archives and HowTos for more
reasons not to. I've had it personally happen to me (ie. a failing drive,
not part of a RAID set that time, caused the other drive on the cable to
be unreachable)

> The same thing can apply to SCSI, too - I once experienced this myself
> when a fautly SCSI-CDROM jammed the whole SCSI-bus and crashed my
> machine.
>
> I hope that SATA will be a lot less critical, it should support
> hotplugging (at least with SATA 1.1, it's a pity that it's not supported
> with 1.0 right away) and there is only one device per channel.

In theory you can hot-plug (and unplug) an IDE drive, with various
hardware caddys and incantations of hdparm, etc.  to spin it down and
remove it from the kernel, but I don't recomend it. The last time I had a
real drive failure which Software RAID coped very well with, I scheduled a
maintenance reboot and changed the drive then.

Gordon
