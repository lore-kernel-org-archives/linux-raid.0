From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Tue, 29 Jan 2008 18:13:41 +0300
Message-ID: <479F42A5.8040007@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com> <18334.46306.611615.493031@notabene.brown> <479F07E1.7060408@pobox.com> <479F0AAB.3090702@rabbit.us> <479F331F.7080902@msgid.tls.msk.ru> <479F3C74.1050605@rabbit.us>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <479F3C74.1050605@rabbit.us>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Rabbitson <rabbit+list@rabbit.us>
Cc: Moshe Yudkowsky <moshe@pobox.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Peter Rabbitson wrote:
> Michael Tokarev wrote:
>  > Raid10 IS RAID1+0 ;)
>> It's just that linux raid10 driver can utilize more.. interesting ways
>> to lay out the data.
> 
> This is misleading, and adds to the confusion existing even before linux
> raid10. When you say raid10 in the hardware raid world, what do you
> mean? Stripes of mirrors? Mirrors of stripes? Some proprietary extension?

Mirrors of stripes makes no sense.

> What Neil did was generalize the concept of N drives - M copies, and
> called it 10 because it could exactly mimic the layout of conventional
> 1+0 [*]. However thinking about md level 10 in the terms of RAID 1+0 is
> wrong. Two examples (there are many more):
> 
>     * mdadm -C -l 10 -n 3 -o f2 /dev/md10 /dev/sda1 /dev/sdb1 /dev/sdc1
                       ^^^^ ^^^^^

Those are "interesting ways"

> Odd number of drives, no parity calculation overhead, yet the setup can
> still suffer a loss of a single drive
> 
>     * mdadm -C -l 10 -n 2 -o f2 /dev/md10 /dev/sda1 /dev/sdb1
                            ^^^^^

And this one too.

There are more-or-less standard raid LEVELS, including
raid10 (which is the same as raid1+0, or a stripe on top
of mirrors - note it does not mean 4 drives, you can
use 6 - stripe over 3 mirrors each of 2 components; or
the reverse - stripe over 2 mirrors of 3 components each
etc).

Vendors often adds their own extensions, sometimes calling
them as the original level, and sometimes giving them new
names, especially in the marketing speak.

Linux raid10 MODULE (which implements that standard raid10
LEVEL in full) adds some quite.. unusual extensions to that
standard raid10 LEVEL.  The resulting layout is also called
raid10 in linux (ie, not giving new names), but it's not that
raid10 (which is again the same as raid1+0) as commonly known
in various literature and on the internet.  Yet raid10 module
fully implements STANDARD raid10 LEVEL.

/mjt

