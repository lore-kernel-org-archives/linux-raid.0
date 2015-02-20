From: Roger Heflin <rogerheflin@gmail.com>
Subject: Re: What are mdadm maintainers to do? (error recovery redundancy/data loss)
Date: Thu, 19 Feb 2015 23:12:59 -0600
Message-ID: <CAAMCDeeBZ-4xe8VWT6+zBefg_C2bS9nDWAJDaX6_OjaJhwVhjg@mail.gmail.com>
References: <loom.20150214T222329-324@post.gmane.org> <20150216142845.0d50207c@notabene.brown>
 <loom.20150216T124230-883@post.gmane.org> <54E1EDEA.1030503@turmel.org>
 <loom.20150216T165111-551@post.gmane.org> <54E226B5.1080500@turmel.org>
 <loom.20150216T183419-387@post.gmane.org> <20150217104906.62d36c62@notabene.brown>
 <loom.20150217T080345-764@post.gmane.org> <CAJCQCtQvoB0yPPc=RXPPyJhpaFwH0pQTRCRaR_ycTbzHrD6rLw@mail.gmail.com>
 <54E3C51C.2080106@websitemanagers.com.au> <CAJCQCtTv-HMX77GWqA+_1rfkWodsTETp_Y3w5En-N4nGCymWsA@mail.gmail.com>
 <loom.20150218T102011-486@post.gmane.org> <CAJCQCtQWBYRu7DFrdoKzj7G1-UKDJKBqyVn=6p91oagLfqd_Kw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJCQCtQWBYRu7DFrdoKzj7G1-UKDJKBqyVn=6p91oagLfqd_Kw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Thu, Feb 19, 2015 at 12:12 AM, Chris Murphy <lists@colorremedies.com> wrote:
> On Wed, Feb 18, 2015 at 4:04 AM, Chris <email.bug@arcor.de> wrote:
>>>
>>
>> Hello all,
>>
>
> On a single randomly selective drive, I disagree. In aggregate, that's
> true, eventually it will happen, you just won't know which drive or
> when it'll happen. I have a number of 5+ year old drives that have
> never reported a  URE. Meanwhile another drive has so many bad sectors
> I only keep it around for abusive purposes.

And I have seen the same.     Not all will fail even of a given type.

It also appears if one was really worried, running smartctl -t long often
(daily or weekly) can result in the disk finding and re-writing or moving
the bad sector.    I have a disk that started given me trouble and the bad
block count has risen a few times without an os level error during the
-t long test.

>
>
>

>
> To get to one size fits all, where SCT ERC is disabled (consumer
> drive), and the kernel command timer is increased accordingly, we
> still need the delay reportable to user space. You can't have a by
> default 2-3 minute showstopper without an explanation so that the user
> can tune this back to 30 seconds or get rid of the drive or some other
> mitigation. Otherwise this is a 2-3 minute silent failure. I know a
> huge number of users who would assume this is a crash and force power
> off the system.
>
> The option where SCT ERC is configurable, you could also do this one
> size fits all by setting this to say 50-70 deciseconds, and for read
> failures to cause  recovery if raid1+ is used, or cause a read retry
> if it's single, raid0, or linear. In other words, control the retries
> in software for these drives.

This gets more interesting.    From what I can tell with my drivers (reds
and seagate video driver) they some allow erc to be set only 7 or higher,
and some allow things to be set lower.   I have been setting mine lower
when it allows since I have raid 6 and expect to be able to get the data
from the other disks.    This min 7 vs min of lower may be a further
distinction between the green(none), red 7, seagate VX (1.0 allowed).

My has video recordings...when the video pauses I counting how long.
I almost always appear to see the full 7 seconds, so I suspect that if
it does not recover in a short time it appears to be unlikely to recover it
all all.      Given the data corruption issue without raid the vendors may
have the though that they cannot really do anything else but retry in the
no raid case.
>
>
>

> I can't agree at all, lacking facts, that this change is marginal for
> non-redundant configurations. I've seen no data how common long
> recovery incidents are, or how much more common data loss would be if
> long recovery were prevented.
>
> The mere fact they exist suggests they're necessary. It may very well
> be that the ECC code or hardware used is so slow that it really does
> take so unbelievably long (really 30 seconds is an eternity, and a
> minute seems outrageous, and 2-3 minutes seems wholly ridiculous as in
> worthy of brutal unrelenting ridicule); but that doesn't even matter
> even if it is true, that's the behavior of the ECC whether we like it
> or not, we can't just willy nilly turn these things off without
> understanding the consequences. Just saying it's marginal doesn't make
> it true.
>
> So if SCT ERC is short, now you have to have a mitigation for the
> possibly higher number of URE's this will result in, in the form of
> kernel instigated read retries on read fail. And in fact, this may be
> false. The retries the drive does internally might be completely
> different than the kernel doing another read. The way data is encoded
> on the drive these days bears no resemblance to discreet 1's and 0's.

Given the drive likely has some ability to adjust the levels of the 0 and 1,
I can see the disk retries possibly playing some games like that trying to get
a better answer.   It is worth nothing that 7 seconds does mean around 70
retries of the read (data comes under the head 70 times).   I doubt the ECC is
so slow it takes more than 10-20 ms to calculate more extreme failures.  So
I am betting on the retries being what is recovering the data.
