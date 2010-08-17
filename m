From: Joris <joris@v5.be>
Subject: Re: reboot during reshape: superblock incorrect, cannot assemble
Date: Tue, 17 Aug 2010 23:10:30 +0200
Message-ID: <AANLkTim-K8bZSxx==cSy9rsCRxpc50HGvaRT6nFzf+UN@mail.gmail.com>
References: <AANLkTikX5+MCicoYShS_=MqpuCr0CMgS1S2n97-k_Aoy@mail.gmail.com>
	<alpine.DEB.1.10.1008172222500.8562@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.1.10.1008172222500.8562@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

2010/8/17 Mikael Abrahamsson <swmike@swm.pp.se>:
> On Tue, 17 Aug 2010, Joris wrote:
>
>> Various people suggest wiping the superblocks and re-creating the
>> array. Is this the best option?
> Do not do this, since you were reshaping it'll break "everything".
Phew. Dodged a bullet there - thanks!

> You didn't provide what version of kernel and mdadm you were using, I
> suggest trying with 3.1.2 or newer at least, 3.1.3 preferrably.

I'm running mdadm 2.6.7.1 on 2.6.32 (Ubuntu lucid during recovery) -
and the array was used before with 2.6.7.2-3 on 2.6.26 (Debian
Stable); all 64 bit.

I'll start by getting the recommended version, then try to re-assemble?


Regards,
Joris
