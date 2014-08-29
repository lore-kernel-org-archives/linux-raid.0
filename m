From: Fabio Bacigalupo <info1@open-haus.de>
Subject: Re: Seeking help to get a failed RAID5 system back to life
Date: Fri, 29 Aug 2014 10:55:53 +0200
Message-ID: <CAGgRf0TZG28nGAHsvZzLkPhYv422GC=r5-km=6OL5-5EXJZQjQ@mail.gmail.com>
References: <CAGgRf0Qe1EU6wZm4BbWqs0diwwnBCeStiVAXaOdHV88Ttn=vfw@mail.gmail.com>
	<20140829074627.GA8321@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140829074627.GA8321@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello Robin,

thank you for your feedback!

2014-08-29 9:46 GMT+02:00 Robin Hill <robin@robinhill.me.uk>:
> That's a disaster waiting to happen. You should never leave a RAID array
> in a degraded state for any longer than is absolutely necessary,
> otherwise you might as well not bother running RAID at all.

>> I could gather the following information:

> Are the above --examine results from before or after the replacement?

I took them before the replacement.

> Was the old /dev/sdc data replicated onto the replacement disk?

No, that is, not, yet. Luckily the guys in the data center kept the disk.

> If the initial --examine results were done on the same disks as the
> --assemble then I'm rather confused as to why mdadm would find a
> superblock for one and not for the other. Could you post the mdadm and
> kernel versions - possibly there's a bug that's been fixed in newer
> releases.

There will be no bug. I just was under a false assumption.

> If the --examine was on the old disk and this wasn't replicated onto the
> new one then I'm not sure what you're expecting to happen here - you've
> lost 2 disks in a 3-disk RAID-5 so your data is now toast.

Ok, now that is clear. I will use ddrescue to replicate the old disk
to the new one and try again.

Thank you,
Fabio
