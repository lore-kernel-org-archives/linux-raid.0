From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: 1x 3ware controllers vs. 2x 3ware controllers
Date: Mon, 2 Aug 2004 00:32:17 +0200 (CEST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0408020025460.7382-100000@uplift.swm.pp.se>
References: <410D4444.8000302@dgreaves.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <410D4444.8000302@dgreaves.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, 1 Aug 2004, David Greaves wrote:

> I'm thinking about building a 2Tb SW RAID but will wait a few months
> because I want PCI-X or similar to get the bandwidth to the gigabit card.

According to Adaptec, their 16 port card with 64bit 66MHz PCI will 
transfer up to 1.5gigabit/s. That's a tad low I must say, that's only 190 
megabytes/s. I've gotten better read performance off of a 3ware card. Good 
enough for feed a gig card though, especially if you have multiple PCI 
buses.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se

