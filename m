From: Nix <nix@esperi.org.uk>
Subject: Re: md device naming question
Date: Mon, 24 Sep 2007 08:12:07 +0100
Message-ID: <87lkawzge0.fsf@hades.wkstn.nix>
References: <20070919081022.GA26155@stro.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070919081022.GA26155@stro.at> (maximilian attems's message of "19 Sep 2007 14:14:54 +0100")
Sender: linux-raid-owner@vger.kernel.org
To: maximilian attems <max@stro.at>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 19 Sep 2007, maximilian attems said:

> hello,
>
> working on initramfs i'd be curious to know what the /sys/block
> entry of a /dev/md/NN device is. have a user request to support
> it and no handy box using it.
>
> i presume it may also be /sys/block/mdNN ?

That's it, e.g. /sys/block/md0. Notable subdirectories include holders/
(block devices within the array, more than one if e.g. LVM is in use),
slaves/ (block devices making up the array) and md/ (RAID-specific
state).

-- 
`Some people don't think performance issues are "real bugs", and I think 
such people shouldn't be allowed to program.' --- Linus Torvalds
