From: Joris <joris@v5.be>
Subject: Re: reboot during reshape: superblock incorrect, cannot assemble
Date: Tue, 17 Aug 2010 23:19:57 +0200
Message-ID: <AANLkTik-7WHQQit-RovNYJWeMAaqoBDJvVfRcHqgZxBG@mail.gmail.com>
References: <AANLkTikX5+MCicoYShS_=MqpuCr0CMgS1S2n97-k_Aoy@mail.gmail.com>
	<alpine.DEB.1.10.1008172222500.8562@uplift.swm.pp.se>
	<AANLkTim-K8bZSxx==cSy9rsCRxpc50HGvaRT6nFzf+UN@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTim-K8bZSxx==cSy9rsCRxpc50HGvaRT6nFzf+UN@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm running mdadm 2.6.7.1 on 2.6.32 (Ubuntu lucid during recovery) -
> and the array was used before with 2.6.7.2-3 on 2.6.26 (Debian
> Stable); all 64 bit.
>
> I'll start by getting the recommended version, then try to re-assemble?

I hit send too soon; 3.0.3 starts the array right away, fantastic!

note: should someone get in a similar situation: get the debian squeeze deb.


Now to teach grub about version 0.91 and I'm back in business.


Thanks Mikael,
Joris
