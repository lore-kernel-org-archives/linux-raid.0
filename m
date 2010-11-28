From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID10 striping vs LVM striping over RAID1 (noob)
Date: Sun, 28 Nov 2010 12:58:51 -0600
Message-ID: <8D.B1.13137.766A2FC4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTik=pheuEZZ5+uPcnm3_bM5iBvHb5Em=PtrU=53t@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTik=pheuEZZ5+uPcnm3_bM5iBvHb5Em=PtrU=53t@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hansbkk@gmail.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org [mailto:linux-raid-
> owner@vger.kernel.org] On Behalf Of hansbkk@gmail.com
> Sent: Sunday, November 28, 2010 8:49 AM
> To: Mikael Abrahamsson
> Subject: Re: RAID10 striping vs LVM striping over RAID1 (noob)
> 
> On Sun, Nov 28, 2010 at 9:29 PM, Mikael Abrahamsson <swmike@swm.pp.se>
> wrote:
> 
> >striping in lvm is something I wouldn't do.
> 
> Aren't you "striping in LVM" as soon as you have a VG spanning
> multiple PVs anyway? I guess you mean don't bother with the
>   >> should I "help" it by created multiple PVs by slicing the disks
> up into partitions
> question in my OP?
> 
> I've seen comments in multiple reliable places that the striping
> inherent in LVM will give performance increases comparable to RAID's,
> and no suggestions that it isn't as stable.

	Well, yes, but they are designed to handle different things.

> > Go for the raid10 approach per drive size and then vg them together if
> you really want a bigger fs, otherwise keep them as separate vg:s and you
> won't run into case of losing all data at once if one md fails.
> 
> Actually I want to keep the LVs containing backup data on a completely
> separate set of spindles from the data being backed up, and definitely
> want to just mirror the discs to enable offsite rotation and easy
> disaster recovery. My understanding is that putting RAID10 on a single
> pair of disks is A- in effect the same as RAID1 in the event one of
> the drives fails but B- that there might be a performance boost  in
> normal operations from the striping feature?
> 
> And yes that's another question - feedback from anyone welcome. . .
 
> > I'd say "keep it simple". CPU won't be a problem, even with several
> > generation old CPUs and doing raid6.
> >
> > mdadm does raid6 just fine, so you should consider if it suits you.
> >
> > If you still want to go with raid10, then you can do so, best is to not
> > complicate things too much,
> 
> Thanks Mikael, yes simplicity is critical to "ease of recovery",
> especially given my noobness. Are you saying RAID6 is "simpler" than
> RAID10? Actually your reminder of KISS is nudging me to straight
> RAID1, maybe even drop the LVM.

	RAID6 allows for high reliability, allowing up to 2 random volume
failures without taking the array offline.  RAID10 can suffer more volume
failures, but only specific volumes can fail.  If it is the wrong pair of
volumes, the array is toast.  RAID6 allows for easier expansion with minimal
management from the admin.  For your purposes, you could employ RAID6 for
your data volumes and then create RAID1 arrays of the RAID6 volumes for
backup purposes.  You'll need to buy several more drives though.
> 
> Actually this gives me another idea, but unrelated enough I'll start a
> new thread. . .
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

