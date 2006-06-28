From: Mike Dresser <mdresser_l@windsormachine.com>
Subject: Re: Ok to go ahead with this setup?
Date: Wed, 28 Jun 2006 11:23:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0606281122410.2889@router.windsormachine.com>
References: <bb145bd20606221008p131d4daem289a6b9300757c66@mail.gmail.com>  
 <62b0912f0606221104q2f47f574i86441efed5831957@mail.gmail.com>  
 <bb145bd20606221250y147d0a0bk1e371a3078adc09e@mail.gmail.com>
 <62b0912f0606221511p74a78ca5id4b5d3f870258815@mail.gmail.com>
 <Pine.LNX.4.64.0606272241040.26384@router.windsormachine.com>
 <44A2204D.D21130B7@ardistech.com> <Pine.LNX.4.64.0606280618050.18112@p34.internal.lan>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0606280618050.18112@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 28 Jun 2006, Justin Piszcz wrote:

> How do you have the 15 drives attached? Did you buy a SATA raid card?  Do you 
> have multiple (cheap JBOD SATA cards)?  If so, which did you use? I cannot 
> seem to find any PCI-e cards with >= 4-8 slots that support JBOD under 
> $700-$900.

We're using a 3ware 9550SX-16ML, which is a 133mhz pci-x card.  They also 
have a 9590SE that does the same with PCI-E, though I don't know if the 
stock 2.6.x kernel supports these yet.

Mike

