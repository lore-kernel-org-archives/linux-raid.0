From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 3ware 7500-8 controller, hardware or software raid, kernel crash
Date: Sun, 4 May 2003 15:47:55 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0305041546230.6232-100000@uplift.swm.pp.se>
References: <Pine.LNX.4.44.0305040947540.11386-100000@portal.bppiac.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0305040947540.11386-100000@portal.bppiac.hu>
To: Farkas Levente <lfarkas@bnap.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 4 May 2003, Farkas Levente wrote:

> - do anybody use this card with hardware raid5?

Yes.

> - is it better/faster... to use hardware raid5 or software raid5?

Use software raid5, it's faster because the kernel can cache and do more 
efficient writes. There has been extensive discussions on this list about 
that, use google to search for it.

> - with this card the hardware or the software raid5 is the better choise?

We use hardware raid5 because it feels more stable and because we don't 
care much for write speeds.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

