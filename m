From: Tim Bock <jtbock@daylight.com>
Subject: Re: Question about raid robustness when disk fails
Date: Mon, 25 Jan 2010 09:22:27 -0700
Message-ID: <1264436547.3015.24.camel@kije>
References: <1262972385.8962.159.camel@kije>
	 <87hbqeyua9.fsf@frosties.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87hbqeyua9.fsf@frosties.localdomain>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <goswin-v-b@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you for the response.  Through the smartctl tests, I noticed that
the "seek error rate" value for the misbehaving disk was at 42, with the
threshold at 30.  For other disks in the same array, the "seek error
rate" values were up around 75 (same threshold of 30).  As it seems the
values decrement to the threshold, I took that as a further sign that
the disk was in trouble and replaced it.  Any likely correlation between
the described problem and the "seek error rate" value?

Is there a way to post-mortem the drive/logs/other traces to gain
insight into what the lower layer problem was?  I would like to be able
to definitively pinpoint (or at least have a reasonable level of
confidence about) the cause of the problem.  The ultimate goal, of
course, is to try and prevent any recurrence.

Thanks again,
Tim

On Fri, 2010-01-22 at 17:32 +0100, Goswin von Brederlow wrote:
> Tim Bock <jtbock@daylight.com> writes:
> 
> > Hello,
> >
> > 	I built a raid-1 + lvm setup on a Dell 2950 in December 2008.  The OS
> > disk (ubuntu server 8.04) is not part of the raid.  Raid is 4 disks + 1
> > hot spare (all raid disks are sata, 1TB Seagates).
> >
> > 	Worked like a charm for ten months, and then had some kind of disk
> > problem in October which drove the load average to 13.  Initially tried
> > a reboot, but system would not come all of the way back up.  Had to boot
> > single-user and comment out the RAID entry.  System came up, I manually
> > failed/removed the offending disk, added the RAID entry back to fstab,
> > rebooted, and things proceeded as I would expect.  Replaced offending
> > drive.
> 
> If a drive goes crazy without actualy dying then linux can spend a
> long time trying to get something from the drive. The driver chip can
> go crazy or the driver itself can have a bug and lockup. All those
> things are below the raid level and if they halt your system then raid
> can not do anything about it.
> 
> Only when a drive goes bad and the lower layers report an error to the
> raid level can raid cope with the situation, remove the drive and keep
> running. Unfortunately there seems to be a loose correlation between
> cost of the controler (chip) and the likelyhood of a failing disk
> locking up the system. I.e. the cheap onboard SATA chips on desktop
> systems do that more often than expensive server controler. But that
> is just a loose relationship.
> 
> MfG
>         Goswin
> 
> PS: I've seen hardware raid boxes lock up too so this isn't a drawback
> of software raid.


