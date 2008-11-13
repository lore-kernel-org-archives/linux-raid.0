From: Josh Boyer <jwboyer@linux.vnet.ibm.com>
Subject: Re: [PATCH 11/11] ppc440spe-adma: ADMA driver for PPC440SP(e)
	systems
Date: Thu, 13 Nov 2008 11:03:07 -0500
Message-ID: <20081113160307.GB2299@yoda.jdub.homelinux.org>
References: <1226589364-5619-1-git-send-email-yanok@emcraft.com> <1226589364-5619-12-git-send-email-yanok@emcraft.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1226589364-5619-12-git-send-email-yanok@emcraft.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ilya Yanok <yanok@emcraft.com>
Cc: linux-raid@vger.kernel.org, linuxppc-dev@ozlabs.org, dzu@denx.de, wd@denx.de
List-Id: linux-raid.ids

On Thu, Nov 13, 2008 at 06:16:04PM +0300, Ilya Yanok wrote:
> Adds the platform device definitions and the architecture specific support
>routines for the ppc440spe adma driver.
>
> Any board equipped with PPC440SP(e) controller may utilize this driver.
>
>Signed-off-by: Yuri Tikhonov <yur@emcraft.com>
>Signed-off-by: Ilya Yanok <yanok@emcraft.com>

Before I really dig into reviewing this driver, I'm going to ask you as simple
question.  This looks like a 1/2 completed port of an arch/ppc driver that uses
the device tree (incorrectly) to get the interrupt resources and that's about it.
Otherwise, it's just a straight up platform device driver.  Is that correct?

If that is the case, I think the driver needs more work before it can be merged.
It should get the DCR and MMIO resources from the device tree as well.  It should
be binding on compatible properties and not based on device tree paths.  And it
should probably be an of_platform device driver.

(There's also weird stuff like #if 0 code left in, etc).

josh
