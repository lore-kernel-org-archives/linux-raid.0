From: Mike Hardy <mhardy@h3c.com>
Subject: Re: 3Ware on 64bit Linux.
Date: Wed, 08 Jun 2005 11:49:23 -0700
Message-ID: <42A73DB3.9050705@h3c.com>
References: <602f2f2b050608100938ddad81@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <602f2f2b050608100938ddad81@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jason Leach <jason.leach@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids


I can't speak to your specific card, but I'm using another of their
cards (8-port PATA, I think that's the 7xxx?) and the driver and admin
client (3dm2) haven't had stability problems so far on a dual opteron
that previously had problems handling the interrupt traffic with
multiple promise/cmd-type PATA cards.

I won't send the details since its all very specific (hopefully someone
else has done it), but 3ware can work well on dual-opteron stuff, which
is a positive sign for you

-Mike

Jason Leach wrote:
> hi,
> 
> Does anyone have a 3ware 90500S card working on 64bit Linux to a point
> where it is very stable and preforming as advertised?  If so, can you
> send me the HW specs you are using? (mobo, cpu, chipsets).  I'm
> considering putting one together but don't want an unstable system.
> 
> Jason.
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
