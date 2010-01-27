From: Tim Bock <jtbock@daylight.com>
Subject: Re: Question about raid robustness when disk fails
Date: Wed, 27 Jan 2010 08:15:03 -0700
Message-ID: <1264605304.3015.60.camel@kije>
References: <1262972385.8962.159.camel@kije>
	 <87hbqeyua9.fsf@frosties.localdomain>
	 <7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7d86ddb91001261619kbb77697t2660e5b8cc44535d@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ryan Wagoner <rswagoner@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 2010-01-26 at 19:19 -0500, Ryan Wagoner wrote:
> On Fri, Jan 22, 2010 at 11:32 AM, Goswin von Brederlow
> <goswin-v-b@web.de> wrote:
> > Tim Bock <jtbock@daylight.com> writes:
> >
> >> Hello,
> >>
> >>       I built a raid-1 + lvm setup on a Dell 2950 in December 2008.  The OS
> >> disk (ubuntu server 8.04) is not part of the raid.  Raid is 4 disks + 1
> >> hot spare (all raid disks are sata, 1TB Seagates).
> >>
> >>       Worked like a charm for ten months, and then had some kind of disk
> >> problem in October which drove the load average to 13.  Initially tried
> >> a reboot, but system would not come all of the way back up.  Had to boot
> >> single-user and comment out the RAID entry.  System came up, I manually
> >> failed/removed the offending disk, added the RAID entry back to fstab,
> >> rebooted, and things proceeded as I would expect.  Replaced offending
> >> drive.
> >
> > If a drive goes crazy without actualy dying then linux can spend a
> > long time trying to get something from the drive. The driver chip can
> > go crazy or the driver itself can have a bug and lockup. All those
> > things are below the raid level and if they halt your system then raid
> > can not do anything about it.
> >
> > Only when a drive goes bad and the lower layers report an error to the
> > raid level can raid cope with the situation, remove the drive and keep
> > running. Unfortunately there seems to be a loose correlation between
> > cost of the controler (chip) and the likelyhood of a failing disk
> > locking up the system. I.e. the cheap onboard SATA chips on desktop
> > systems do that more often than expensive server controler. But that
> > is just a loose relationship.
> >
> > MfG
> >        Goswin
> >
> > PS: I've seen hardware raid boxes lock up too so this isn't a drawback
> > of software raid.
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> 
> You need to be using drives designed for RAID use with TLER (time
> limited error recovery). When the drive encounters an error instead of
> attempting to read the data for an extended period of time it just
> gives up so the RAID can take care of it.
> 
> For example I had a SAS drive start to fail on a hardware RAID server.
> Every time it hit a bad spot on the drive you could tell the system
> would pause for a brief second as only that drive light was on. The
> drive gave up and the RAID determined the correct data. It ran fine
> like this until I was able to replace the drive the next day.
> 

Interesting, but from my reading of the tler data sheet, I don't think
this would have helped me.  The failing drive tied up the system for
hours (happened at 2am during backups, and system still unresponsive
with a 12+ load avg when I arrived at 7am), and in fact did not recover
until I rebooted single user and commented out the RAID entry.  My
understanding is that tler prevents the raid from failing the drive too
soon (because of unresponsiveness).  But in my case, I would have been
*happy* if the drive had been failed automatically, rather than
effectively bringing down the system.  So my understanding is that tler
wouldn't have done anything for me, though it is certainly possible I've
misunderstood something.

Thanks,
Tim


> Ryan
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


