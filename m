From: Chris Murphy <lists@colorremedies.com>
Subject: Re: Inactive arrays
Date: Wed, 14 Sep 2016 12:37:16 -0600
Message-ID: <CAJCQCtS_bzN5v_+s3SSD5tagq+zq7DzHgH3fXufvMden6K78_g@mail.gmail.com>
References: <CAHscji0ddZT-aq5fEp8aG030+F7UqGzMgRnm4QP1Lr1AsGy61Q@mail.gmail.com>
 <57A07345.4040708@youngman.org.uk> <CAHscji0BQuyKQbLYZ9Ah16hHday_seTaajm8LOn6+HRFqinTyQ@mail.gmail.com>
 <CAHscji3C4Cygs=xh4d4PtREp9mGSBjNS0o7SatW_QotzYShA_Q@mail.gmail.com>
 <CAHscji3HdHaJAvwtYNU=Ykc_qohBkfFfrbP0M=FNhuFMK+d-Jg@mail.gmail.com>
 <CAHscji35kySP4Q8cUpYCXR2P9DBwPcYeWjr_HX==TNX9CPW9NA@mail.gmail.com>
 <CAHscji2k9FyrOs+96XQWEUWU3W0EWxkanaHakjsGhij0hXiVGw@mail.gmail.com>
 <57D72092.20704@youngman.org.uk> <CAHscji3KfFfO8CxZTbLX6u-bfA57pOR5i6qvc0NhNODH5tGeEg@mail.gmail.com>
 <CAJCQCtTzPpt0krPxCZY_TB-Xa6PcG0YsdDPnneq5dEB30wy8hw@mail.gmail.com>
 <CAHscji0H7kEDzhg3KpUYrdk5MA06k-F5Xe95=EL7mo-_mS3y5A@mail.gmail.com>
 <CAJCQCtS-aYNgy7MM990CTKFqcNk8bf+ggzX3QRrD+yQZfdVxnA@mail.gmail.com>
 <CAHscji1vy55L_BgH=y4X=FMeEgHyxzckhAgLu=BojtTn_2mPug@mail.gmail.com>
 <CAJCQCtRdbWg7HgX=wghd8OBUcauiVfES6NSOKOZj38HMWVg65A@mail.gmail.com>
 <CAHscji1fgVrKwOwf+sCfOrg-MNz0MwRzXAJswKcP=vP2x0PVug@mail.gmail.com>
 <CAJCQCtSTaByUR_2dnGrA0y0dtTaS_sweLKn19QD1=wv+2mnvHg@mail.gmail.com>
 <CAHscji2dhdE7mL-4i8mE6sShQtGCB6v1K02TBQQD4-6R-ZtoZw@mail.gmail.com>
 <CAJCQCtQXd6GgXhu-7h9nNjA1zfdoH_TAEkeQajYv5vsmuG2Vpw@mail.gmail.com>
 <CAHscji1wVYzpzu8X+GYuuxZPdLzY-f+8oogyH7ttqVwMJe2=iQ@mail.gmail.com>
 <CAJCQCtQ3kAKd4U=MgVawU9D6QKuxC+XjLYR6EyL87wuyBvvmtg@mail.gmail.com>
 <CAJCQCtSsC3=hh60PudHqziubnv_KVFevbCgV3MNZKnL44Fow=Q@mail.gmail.com> <CAHscji2BKxNDLzZUonGHVB8PzeFbtuwn32NBaX315QPvvhOxyg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAHscji2BKxNDLzZUonGHVB8PzeFbtuwn32NBaX315QPvvhOxyg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Daniel Sanabria <sanabria.d@gmail.com>
Cc: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, Sep 14, 2016 at 12:16 PM, Daniel Sanabria <sanabria.d@gmail.com> wrote:
> BRAVO!!!!!!
>
> Thanks a million Chris! After following your advice on recovering the
> MBR and the GPT the arrays re-assembled automatically and all data is
> there.
>
> I already changed the type to make it consistent (FD00 on both
> partitions) and working on setting up the timeouts to 180 at boot
> time. Other than replacing the green drives with something more
> suitable (any suggestions are welcome), what else would you suggest to
> change to make the setup a bit more consistent and upgrade proof (i.e.
> having different metadata versions doesn't look right to me)?

Like I mentioned there's something about Greens spinning down that you
might look at. I'm not sure if delays in spinning back up is a
contributing factor to anything? I'd kinda expect that if the
kernel/libata send a command to the drive, and one spins up slow, the
kernel is just going to wait up to whatever the command timer is set
to. So if you set that to 180 seconds, it should be fine because no
drive takes 3 minute to spin up. But... I dunno if there's some other
vector for these drives to cause confusion.

Umm, yeah I don't think you need to worry too much about the metadata.
0.9 is deprecated, uses kernel autodetect rather than initrd based
detection like metadata 1.x, and can be more complex to troubleshoot.
But so long as it's working I honestly wouldn't mess with it. If you
do want to simplify it just make sure you have current backups because
changes are a RIPE time for mistakes that end up in user data loss. I
would pretty much just assume the user will break something, you have
a not too complex layout compared to others I've seen, but there are
some opportunities to make simple mistakes that will just blow shit up
and then you're screwed.

So I'd say it's easier to just plot a future when you're going to buy
a bunch of new drives and do a complete migration, rather than change
the existing setup metadata just for the sake of changing it.

And one thing to incorporate in the planning stage is LVM RAID.  You
could take all of your drives into one big pool, and create LV's like
you are individual RAIDs, and each LV can have its own RAID level. In
many ways it's easier because you're already using LVM on top of RAID
on top of partitioning. Instead you can create basically one
partition, add them all to LVM, and then manage the LV and raid level
at the same time. The main issue here is, familiarity with all the
tools. If you're more comfortable with mdadm, then use that. If you
can get over the hurdle that is lvm tools (it's like emacs for
storage, its metric piles of flags, documentation, features, and as
yet doesn't have all the same features as mdadm still for the raid
stuff). But it'll do scrubs, and device replacements, all the basic
stuff is there. Monitoring for drive failures is a little different, I
don't think it has a way to email you like mdadm does in case of drive
failures/ejections. So you'll have to look at that also. Note that on
the backend LVM raid uses the md kernel driver just like mdadm does,
it's just the user space tools and on disk metadata that differ.



-- 
Chris Murphy
