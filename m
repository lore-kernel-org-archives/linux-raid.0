From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 3ware 7500-12, bad write speed
Date: Fri, 11 Oct 2002 00:27:47 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0210110026031.7818-100000@uplift.swm.pp.se>
References: <Pine.LNX.4.44.0210102315200.21922-100000@ddx.a2000.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0210102315200.21922-100000@ddx.a2000.nu>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 10 Oct 2002 raid@ddx.a2000.nu wrote:

> Ok did a benchmark between software raid en hw raid
> controller 3ware 7850 (7500-8 now?) with 5 * WDC 120GB 7200RPM (2mb cache)
> On xeon dual 2GHZ (controller in 64bits pci)

Guess that is pretty much the same results I get, but it also shows that 
software raid5 also isn't very fast when it comes to writing, and cpu 
usage actually does rise a lot (your tests seem to indicate that there is 
a lot of cpu activity going on?).

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se


