From: Jeremy Graham <jeremy@doghouse.agency>
Subject: Re: mdadm stuck at 0% reshape after grow
Date: Wed, 6 Dec 2017 15:33:36 +1100
Message-ID: <CAGx2nv6YAc5jBL36K0oNG=tE5J3TNXGMvTvD9ZvcZYthXe9Y5g@mail.gmail.com>
References: <CAGx2nv6cZ85YCrUQsCBWfojFxOyqW4=+5OaCqU1Gf0UX=T3Gbg@mail.gmail.com>
 <1865221512489329@web5g.yandex.ru> <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <d34ebd38-47e5-35bc-5ee6-0da194ce1901@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: 002@tut.by, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks very much for the responses so far all!

@Nix
> That's a kernel bug, probably a deadlock. *Definitely* try a newer
> kernel, 4.14.3 (the latest) if possible. I bet this is fixed by

I tried updating the kernel, bumped to "4.12.5-041205-generic" first
but still no dice.

@002, @Phil
> This feature generally shouldn't be used, because its implementation is
> unfinished. Empty BBL's can be removed from every device by giving
> "--update=no-bbl" option to mdadm on assemble, but before that you
> must manually regenerate content for each block in BBL's and then
> manually zero the lists in superblocks.

I am currently running "badblocks -v /dev/sde1 > sde1.badsectors.txt"
and "badblocks -v /dev/sdf1 > sdf1.badsectors.txt" to see what that
comes back with.

How do I "manually regenerate content for each block in BBL's and then
manually zero the lists in superblocks"? This is uncharted (and
slightly scary) territory for me.
