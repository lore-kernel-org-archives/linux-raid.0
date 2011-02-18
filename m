From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Raid selection questions (10 vs 6, n2 vs f2) on an 8 drive array
Date: Fri, 18 Feb 2011 17:44:24 -0600
Message-ID: <4D5F0458.3060403@hardwarefreak.com>
References: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=2xjjuvT3tTs1Y9Qfrn6HxWS3hwzF-Q0ZhPFVM@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Larry Schwerzler <larry@schwerzler.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Larry Schwerzler put forth on 2/18/2011 2:55 PM:

> 1. In my research of raid10 I very seldom hear of drive configurations
> with more drives then 4, are there special considerations with having
> an 8 drive raid10 array? I understand that I'll be loosing 2TB of
> space from my current setup, but i'm not too worried about that.

This is because Linux mdraid is most popular with the hobby crowd, not
business, and most folks in this segment aren't running more than 4
drives in a RAID 10.  For business solutions using embedded Linux and
mdraid, mdraid is typically hidden from the user who isn't going to be
writing posts on the net about mdraid.  He calls his vendor for support.
 In a nutshell, that's why you see little or no posts about mdraid 10
arrays larger than 4 drives.

> 2. One problem I'm having with my current setup is the esata cables
> have been knocked loose which effectively drops 4 of my drives. I'd
> really like to be able to survive this type of sudden drive loss. if

Solve the problem then--quit kicking the cables, or secure them in a
manner that they can't be kicked loose.  Or buy a new chassis that can
hold all drives internally.  Software cannot solve or work around this
problem.  This is actually quite silly to ask.  Similarly, would you ask
your car manufacturer to build a car that floats and has a propeller,
because you keep driving off the road into ponds?

> my drives are /dev/sd[abcdefgh] and abcd are on one esata channel
> while efgh are on the other is there what drive order should I create
> the array with? I'd guess /dev/sd[aebfcgdh] would that give me
> survivability if one of my esata channels went dark?

On a cheap SATA PCIe card, if one channel goes, they both typically go,
as it's a single chip solution and the PHYs are built into the chip.
However, given your penchant for kicking cables out of their ports, you
might physically damage the connector.  So you might want to create the
layout so your mirror pairs are on opposite ports.

> 3. One of the concerns I have with raid10 is expandability, and I'm
> glad to see reshaping raid10 as an item on the 2011 roadmap :) However
> it will likely be a while before I'll see that ability in my distro
> for a while. I did find a guide on expanding raid size when using lvm
> by increasing the size of each drive and creating two partitions 1 the
> size of the original drive, and one with the remainder of the new
> space. Once you have done this for all drives you create a new raid10
> array with the 2nd partitions on all the drives and add it to the lvm
> storage group, effectively you have two raid10 arrays 1 on the first
> half of the drives 1 on the 2nd half of the drives and the space
> pooled together. I'm sure many of you are familiar with this scenario,
> but I'm wondering if this scenario could be problematic, is having two
> raid10 arrays on one drive an issue?

Reshaping requires you have a full good backup for when it all goes
wrong.  Most home users don't keep backups.  If you kick the cable
during a reshape you may hose everything and have to start over from
scratch.  If you don't/won't/or can't keep a regular full backup, then
don't do a reshape.  Simply add new drives, create a new mdraid if you
like, make a filesystem, and mount it somewhere.  Others will likely
give different advice.  If you need to share it via samba or nfs, create
another share.  For those who like everything in one "tree" you can
simply create a new directory "inside" your current array filesystem and
mount the new one there.  Unix is great like this.  Many Linux nubies
forget this capability, or never learned it.

> 4. Part of the reason I'm wanting to switch is because of information
> I read on the "BAARF" site pointing out some of the issues in the
> parity raid's that can cause issues that people sometimes don't think
> about. (site: http://www.miracleas.com/BAARF/BAARF2.html) A lot of the
> information on the site is a few years old now and given how fast
> things can change and the fact that I have not found many people
> complaining about the parity raids I'm wondering if some/all of the
> gotchas that they list are less of an issue now? Maybe my reasons for
> moving to raid10 are no longer relevant?

You need to worry far more about your cabling situation.  Kicking a
cable out is what can/will cause data loss.  At this point that is far
more detrimental to you than the RAID 5/6 invisible data loss issue.

Always fix the big problems first.  The RAID level you use is the least
of yours right now.

-- 
Stan
