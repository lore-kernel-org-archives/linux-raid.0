From: Adam Kropelin <akropel1@rochester.rr.com>
Subject: Re: Linux: Why software RAID?
Date: Thu, 24 Aug 2006 09:36:16 -0400
Message-ID: <20060824093616.K30362@mail.kroptech.com>
References: <20060824090741.J30362@mail.kroptech.com> <1156425650.3007.140.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1156425650.3007.140.camel@localhost.localdomain>; from alan@lxorguk.ukuu.org.uk on Thu, Aug 24, 2006 at 02:20:50PM +0100
Sender: linux-raid-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jeff Garzik <jeff@garzik.org>, Linux Kernel <linux-kernel@vger.kernel.org>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, marc@perkel.com
List-Id: linux-raid.ids

On Thu, Aug 24, 2006 at 02:20:50PM +0100, Alan Cox wrote:
> Ar Iau, 2006-08-24 am 09:07 -0400, ysgrifennodd Adam Kropelin:
> > Jeff Garzik <jeff@garzik.org> wrote:
> > with sw RAID of course if the builder is careful to use multiple PCI 
> > cards, etc. Sw RAID over your motherboard's onboard controllers leaves
> > you vulnerable.
> 
> Generally speaking the channels on onboard ATA are independant with any
> vaguely modern card. 

Ahh, I did not know that. Does this apply to master/slave connections on
the same PATA cable as well? I know zero about PATA, but I assumed from
the terminology that master and slave needed to cooperate rather closely.

> And for newer systems well the motherboard tends to
> be festooned with random SATA controllers, all separate!

And how. You can't swing a dead cat without hitting a half-dozen ATA
ports these days. And most of them are those infuriatingly insecure SATA
connectors that pop off when you look at them cross-eyed...

--Adam

