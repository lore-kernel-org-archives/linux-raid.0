From: Nicolas Pitre <nico@marvell.com>
Subject: Re: [PATCH] mv_xor: add support for clkdev framework
Date: Tue, 23 Jun 2009 13:22:33 -0400 (EDT)
Message-ID: <alpine.LFD.2.00.0906231317370.16467@xanadu.home>
References: <1245751004-3056-1-git-send-email-saeed@marvell.com> <4A4100B0.3070704@intel.com> <alpine.LFD.2.00.0906231241150.16467@xanadu.home> <alpine.DEB.2.00.0906231957570.31324@ubuntu-saeed.il.marvell.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.00.0906231957570.31324@ubuntu-saeed.il.marvell.com>
Sender: linux-raid-owner@vger.kernel.org
To: Saeed Bishara <saeed@marvell.com>
Cc: Dan Williams <dan.j.williams@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Lennert Buijtenhek <buytenh@marvell.com>, "saeed.bishara@gmail.com" <saeed.bishara@gmail.com>
List-Id: linux-raid.ids

On Tue, 23 Jun 2009, Saeed Bishara wrote:

> 
> > >
> > > Can you expand the changelog to explain why this patch is needed and
> > > summarize what it does?  Also, releasing patches this late in the merge
> Here is the patch with more explanation:
> ----------------------------------------<
> >From c999ed53a913979f1739854cb7c881a9dde980c6 Mon Sep 17 00:00:00 2001
> From: Saeed Bishara <saeed@marvell.com>
> Date: Tue, 12 May 2009 13:29:34 +0300
> Subject: [PATCH 1/2 v2] mv_xor: add support for clkdev framework
> 
> When the clkdev framework is enabled, the device's clock is gated
> by default, this patch uses the framework to enable the clock
> when using the driver loaded and disables it when unloading the
> driver.

Can't you be more agressive with clock gating?

Like using clk_get() when loading the driver and clk_put() when 
unloading, but using clk_enable()/clk_disable() only when a DMA channel 
is actually requested or active.


Nicolas
