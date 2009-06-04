From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH 4/8] md/raid6: asynchronous handle_stripe_fill6
Date: Thu, 4 Jun 2009 16:37:58 +1000
Message-ID: <18983.27590.350671.321453@notabene.brown>
References: <20090604012709.11507.15528.stgit@dwillia2-linux.ch.intel.com>
	<20090604012918.11507.99345.stgit@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Wednesday June 3
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: linux-raid@vger.kernel.org, Ilya Yanok <yanok@emcraft.com>, Yuri Tikhonov <yur@emcraft.com>
List-Id: linux-raid.ids

On Wednesday June 3, dan.j.williams@intel.com wrote:
> From: Yuri Tikhonov <yur@emcraft.com>
> 
> Modify handle_stripe_fill6 to work asynchronously by introducing
> fetch_block6 as the raid6 analog of fetch_block5 (schedule compute
> operations for missing/out-of-sync disks).

Following the theme from the previous patch, fetch_block5 is now just
a special case of fetch_block6, so I think it would be best to use the
same code.
Once you do that, handle_stripe_fill6 and handle_stripe_fill5 become
identical, so you only need handle_stripe_fill.

NeilBrown
