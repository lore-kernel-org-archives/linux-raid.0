From: Dan Williams <djbw@fb.com>
Subject: Re: [PATCH] raid5: panic() on dma_wait_for_async_tx() error
Date: Mon, 19 Nov 2012 05:22:25 +0000
Message-ID: <84A937D219C2B44EB8EA44831ACA1E49166C741F@SC-MBX02-3.TheFacebook.com>
References: <20121119120632.1c97e306@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20121119120632.1c97e306@notabene.brown>
Content-Language: en-US
Content-ID: <1E3BA5E6BE7269468734F0EB6B583FCE@fb.com>
Sender: linux-kernel-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Vinod Koul <vinod.koul@intel.com>, Tomasz Figa <t.figa@samsung.com>, Kyungmin Park <kyungmin.park@samsung.com>
List-Id: linux-raid.ids



On 11/18/12 5:06 PM, "NeilBrown" <neilb@suse.de> wrote:

>
>Hi Dan,
> could you comment on this please?  Would it make sense to arrange for
>errors
> to propagate up?  Or should we arrange to do a software-fallback in the
>dma
> engine is a problem?  What sort of things can cause error here anyway?

Propagating up is missing reliable "dma abort" operation.

In these cases the engine failed to complete due to hardware hang / driver
bug, or has hit a memory error (uncorrectable even with software
fallback).  This originally should have been using async_tx_quiesce()
which also does the panic.

The engines that I have worked with have either lacked support for
aborting, or were otherwise unable to recover from a hardware hang.
However, for engines that do support error recovery they should be able to
hide the failure from the upper layers.

--
Dan
