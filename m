From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: nonzero mismatch_cnt with no earlier error
Date: Sun, 25 Feb 2007 16:07:41 -0500 (EST)
Message-ID: <Pine.LNX.4.64.0702251606160.31647@p34.internal.lan>
References: <45DF859B.2050108@eyal.emu.id.au> <20070225183332.GA10098@janus>
 <bb145bd20702251158o339093ecu223220d69d2031b3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20702251158o339093ecu223220d69d2031b3@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Sun, 25 Feb 2007, Christian Pernegger wrote:

> Sorry to hijack the thread a little but I just noticed that the
> mismatch_cnt for my mirror is at 256.
>
> I'd always thought the monthly check done by the mdadm Debian package
> does repair as well - apparently it doesn't.
>
> So I guess I should run repair but I'm wondering ...
> - is it safe / bugfree considering my oldish software? (mdadm 2.5.2 +
> linux 2.6.17.4)
> - is there any way to check which files (if any) have been corrupted?
> - I have grub installed by hand on both mirror components, but that
> shouldn't show up as mismatch, should it?
>
> The box in question is in production so I'd rather not update mdadm
> and/or kernel if possible.
>
> Chris
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

That is a very good question.. Also I hope you are not running XFS with 
2.6.17.4.  (corruption bug)

Besides that, I wonder if it would be possible (with bitmaps perhaps(?)) 
to have the kernel increment that and then post via ring buffer/dmesg, 
something like:

kernel: md1: mismatch_cnt: 512, file corrupted: /etc/resolv.conf

I would take a performance hit for something like that :)

Justin.

