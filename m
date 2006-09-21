From: "Rob Bray" <raid@bymeinc.com>
Subject: Re: access array from knoppix
Date: Thu, 21 Sep 2006 14:16:31 -0400 (EDT)
Message-ID: <36330.192.168.0.1.1158862591.squirrel@bymeinc.com>
References: <200609121352.08834.Dexter.Filmore@gmx.de>
    <45098066.6020303@maine.edu>
    <200609161226.11722.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200609161226.11722.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID Mailing List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> Maybe valid but not helping with my problem since the problem is/was,
> that /dev/md0 didn't exist at all. mdadm -C won't create device nodes.
>
> But I figured the workaround meanwhile, so it doesn't matter anymore.
> (In case someone wanna know: mknod in /lib/udev/devices does it on a hard
> disk
> install, I guess could work in /dev on knoppix, too, haven't tried yet.)
>
>
Do you want to be able to boot using knoppix all the time, or are you
looking for a oneshot solution? I feel like 'mknod' with major 9 is a
trivial thing to have to do.

