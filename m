From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: ICH7 sata-ahci + software raid warning
Date: Tue, 11 Jul 2006 08:23:28 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0607110823160.858@p34.internal.lan>
References: <bb145bd20607100948y2f41e034re3c0fb30c8bd1ad5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <bb145bd20607100948y2f41e034re3c0fb30c8bd1ad5@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Christian Pernegger <pernegger@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Why not just --set-faulty or --fail with mdadm?

On Mon, 10 Jul 2006, Christian Pernegger wrote:

> I'm (still) trying to setup a md array on the ICH7 SATA controller of
> an Intel SE7230NH1-E with 4 WD5000YS disks.
>
> On this controller (in ahci mode) I have not yet managed to get a disk
> mark as failed.
>
> - a bad cable just led to hangs and timeouts
> - pulling the power on one of the SATA drives (while the system is running)
> had the exact same result.
>
> Apparently the error handling up to 2.6.17 is so buggy that it never
> returns an error that might cause md to fail the disk. (Bad blocks
> maybe, can't test that.)
>
> Regards,
>
> C.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
