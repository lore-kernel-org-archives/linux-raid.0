From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/5] md: Turn rdev->sb_offset into a sector-based quantity.
Date: Mon, 21 Jul 2008 20:38:40 +1000
Message-ID: <18564.26416.6888.381849@notabene.brown>
References: <1215681338-32365-1-git-send-email-maan@systemlinux.org>
	<1215681338-32365-5-git-send-email-maan@systemlinux.org>
	<18551.16581.929399.413701@notabene.brown>
	<20080717094008.GW23944@skl-net.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Andre Noll on Thursday July 17
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday July 17, maan@systemlinux.org wrote:
> 
> It might be worth to get fixes for these two bugs into -stable.
> 
> Here's a patch against mainline. Please forward to stable@... if
> you agree.

A question definitely worth considering.

I think in this case they don't qualify.  The bug are in sanity
checks, and they make the checks too weak.  They don't actually cause
incorrect behaviour in any credible scenario.

As the bugs don't open a security hole, don't cause data corruption,
and don't trigger an 'oops', they don't really qualify for -stable.

Thanks,
NeilBrown
