From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: messages after server crash
Date: Wed, 13 Nov 2002 09:30:53 +1100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <15825.33053.710086.105245@notabene.cse.unsw.edu.au>
References: <200211111526.37325.bernd-schubert@web.de>
	<15824.3059.420677.958049@notabene.cse.unsw.edu.au>
	<200211121702.27034.bernd-schubert@web.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bernd Schubert on Tuesday November 12
To: Bernd Schubert <bernd-schubert@web.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tuesday November 12, bernd-schubert@web.de wrote:
> Hello Neil,
> 
> thanks for your answer.
> 
> > > Well, the 'delaying resync ...' messages are easy to understand, but are
> > > they related to the 'resync aborted' messages ? At least the /proc/mdstat
> > > looks fine.
> >
> > It looks fine ... but the arrays probably aren't in sync.
> 
> How can we force the syncing ?

You could try
		mdadm --readwrite /dev/md?

that should probably do it.

> 
> > The 'resync aborted' is caused either by IO errors, which should show
> > up in dmesg, or the resync threads being signaled, or by the array
> > being switched into readonly mode.
> 
> Hmm, I think the dmesg-output doesn't show IO-errors and since we write to the 
> disks (our home-partition is on it), it shouldn't be readonly, either.
> 

Which only leaves some process sending a SIGKILL to the raid5syncd
thread... is that at all possible?

> >
> > I'm curious about this raidautorun which said:
> > md: raidautorun(pid 89) used obsolete MD ioctl, upgrade your software to
> > use new ictls
> >
> > That appears to be part of mkinitrd.  What distribution are you
> > running? What version?  What version of mkinitrd?
> >
> 
> This is a Suse-7.3 system, but with vanilla kernel and without initrd-support. 
> I guess it comes from the Suse-start-up-scripts, that try to enable the raid, 
> though it was already enabled by the kernel.
> The raidautorun-binary comes from the Suse-raidtools package (version 0.9), is 
> there an upgraded version available (I found only patched debian packages, 
> but no general tgz-files) ?

Ok, I managed to find it. It just does ioctl(, RAID_AUTORUN) on
/dev/md0 which just prints out a bad-ioctl error message.  It isn't
implicated at all.

NeilBrown
