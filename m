From: David Dougall <davidd@et.byu.edu>
Subject: Re: Problems with software RAID + iSCSI or GNBD
Date: Wed, 29 Jun 2005 09:24:52 -0600 (MDT)
Message-ID: <Pine.LNX.4.58.0506290918380.799@lewis.et.byu.edu>
References: <Pine.LNX.4.44.0506291027460.26718-100000@firewall2.tmr.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0506291027460.26718-100000@firewall2.tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This discussion intrigues me.  I think there is a lot of merit to running
a raid in this manner.  However, if I understand correctly, under normal
circumstances reads from a Raid1 md device will always round-robin between
the devices to increase performance.  Is there a way or what would need to
be done to set a single component in the device to be the primary.  ie.
don't read from the other device unless the first one fails.
I think there was some discussion about this a month or so ago concerning
ramdisk(which I don't know would be quite as useful), but the theory can
apply to any block devices with significantly different speed/latencies,
etc.
Please advise.
--David Dougall


On Wed, 29 Jun 2005, Bill Davidsen wrote:

> On Wed, 29 Jun 2005, Christopher Smith wrote:
>
> > > Personally, I wouldn't mess with iSCSI or GNBD. You don't need GNBD in
> > > this scenario anyway; simple nbd (which is in the mainline kernel...get
> > > the userland tools at sourceforge.net/projects/nbd) will do just fine,
> > > and I'd be willing to bet that it is more stable and faster...
> >
> > I'd briefly tried nbd, but decided to look elsewhere since it needed to
> > much manual configuration (no included rc script, /dev nodes appear to
> > have to be manually created - yes, I'm lazy).
>
> Based on one test of nbd, it seems to be stable. I did about what you are
> trying, a RAID1 to create an md device, then did an encrypted filesystem
> on it. My test was minor, throw a lot of data at it, check that it is
> there (md5sum), reboot and verify everything still works, drop the local
> drive and rebuild. I did NOT try a rebuild on the nbd drive.
>
> >
> > I've just finished trying NBD now and it seems to solve both my problems
> > - rebuild speed is a healthy 40MB/sec + and the failures are dealt with
> > "properly" (ie: the md device goes into degraded mode if a component nbd
> > suddenly disappears).  This looks like it might be a goer for the disk
> > node/RAID-over-network back-end.
>
> I failed it manually, can't say what pulling the plug will do. Glad it's
> working, I may be doing this on a WAN in the fall.
>
> --
> bill davidsen <davidsen@tmr.com>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>
