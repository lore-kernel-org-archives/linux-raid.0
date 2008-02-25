From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: board/controller recommendations?
Date: Mon, 25 Feb 2008 09:02:31 -0500 (EST)
Message-ID: <alpine.DEB.1.00.0802250900080.17154@p34.internal.lan>
References: <200802251424.57325.Dexter.Filmore@gmx.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200802251424.57325.Dexter.Filmore@gmx.de>
Sender: linux-raid-owner@vger.kernel.org
To: Dexter Filmore <Dexter.Filmore@gmx.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids



On Mon, 25 Feb 2008, Dexter Filmore wrote:

> Currently my array consists of four Samsung Spinpoint sATA drives, I'm about
> to enlarge to 6 drive.
> As of now they sit on an Sil3114 controller via PCI, hence there's a
> bottleneck, can't squeeze more than 15-30 megs write speed (rather 15 today
> as the xfs partitions on it are brim full and started fragmenting).
>
> Now, I'd like to go for a AMD board with 6 sATA channels connected via PCIe -
> can someone recomend a board here? Preferrably AMD 690 based so I won't need
> a video card or similar.
>
> Dex
>
> --
> -----BEGIN GEEK CODE BLOCK-----
> Version: 3.12
> GCS d--(+)@ s-:+ a- C++++ UL++ P+>++ L+++>++++ E-- W++ N o? K-
> w--(---) !O M+ V- PS+ PE Y++ PGP t++(---)@ 5 X+(++) R+(++) tv--(+)@
> b++(+++) DI+++ D- G++ e* h>++ r* y?
> ------END GEEK CODE BLOCK------
>
> http://www.vorratsdatenspeicherung.de
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

That's always the question, which mobo?  I went Intel as many of their 
chipsets (965, p35, x38) have 6 SATA, I am sure AMD have some as well 
though, what I bought awhile back was a 6 port sata w/ 3 pci-e x1 and 1 
pci-e x16.  Then you buy the 2 port sata cards (x1) and plugin your 
drives.

Promise also came out with a 4 port PCI-e x1 card but I have not tried it, 
seen any reviews for it and do not know if it is even supported in linux.

Also, I'd recommend you run a check/resync on your array before removing 
it from your current box, and then make sure the two new drives do not 
have any problems, and (to be safe?) expand by adding 1 drive at a time?

Justin.
