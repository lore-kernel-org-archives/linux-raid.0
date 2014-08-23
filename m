From: Adam Talbot <ajtalbot1@gmail.com>
Subject: Re: RAID partitions, or RAID disks and partition array?
Date: Sat, 23 Aug 2014 15:20:34 -0700
Message-ID: <CAH_2GhfhEvYVog=YG98uqrORn81dC8P3u7nqMgQf7c1+4Ena5Q@mail.gmail.com>
References: <CAH_2Ghc3tW4rD_iS7LO47ot6xURJq-RTrEyd3Z-swN2vA=4pPA@mail.gmail.com>
	<20140823111847.724eabe2@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140823111847.724eabe2@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Thank you all for the feed back.  I never knew the FD vs DA partition
stuff.  I have been using FD with metadata 1.2.  Time to fix that. :-)

Any chance at a wiki article about this?

On Fri, Aug 22, 2014 at 6:18 PM, NeilBrown <neilb@suse.de> wrote:
> On Fri, 22 Aug 2014 09:52:11 -0700 Adam Talbot <ajtalbot1@gmail.com> wrote:
>
>> I hope this is an easy one.  I have two drives I would like to mirror
>> as my boot drive.
>> 1) Should I mirror the drives, then partition the RAID device (md0)?
>> 2) Should I partition the the drives then RAID the partitions?
>>
>> What is the best practice, and why?
>
> I always do '1'.  I use 1.0 metadata so each drive can be used by itself quite
> apart from RAID, or can be part of the array.
> Boot sectors etc are mirrored so you don't need to be sure that grub writes
> to both devices or whatever.
>
> However this is "my" practice rather than "best" practice.  It is entirely
> possible that grub might try to be too clever, see a RAID1 and want to do
> something to the underlying drives - and then fail when they look wrong.
>
> Ultimately this is a question about how your distro is configured and how
> your boot loader works much more than it is a question about md/raid.
>
> Once you choose a distro, you should see what that distro recommends and do
> that, because that is the only configuration you can hope to get support for.
>
> NeilBrown
