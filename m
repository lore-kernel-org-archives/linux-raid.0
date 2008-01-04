From: Neil Brown <neilb@suse.de>
Subject: Re: [PATCH] md: Fix data corruption when a degraded raid5 array is
	reshaped.
Date: Fri, 4 Jan 2008 11:41:55 +1100
Message-ID: <18301.32979.409077.527576@notabene.brown>
References: <20080104094516.19216.patches@notabene>
	<1080103224636.19290@suse.de>
	<1199401234.9102.3.camel@dwillia2-linux.ch.intel.com>
	<1199403652.9102.30.camel@dwillia2-linux.ch.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Dan Williams on Thursday January 3
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: NeilBrown <neilb@suse.de>, Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Thursday January 3, dan.j.williams@intel.com wrote:
> 
> On closer look the safer test is:
> 
> 	!test_bit(STRIPE_OP_COMPUTE_BLK, &sh->ops.pending).
> 
> The 'req_compute' field only indicates that a 'compute_block' operation
> was requested during this pass through handle_stripe so that we can
> issue a linked chain of asynchronous operations.
> 
> ---
> 
> From: Neil Brown <neilb@suse.de>

Technically that should probably be
  From: Dan Williams <dan.j.williams@intel.com>

now, and then I add
  Acked-by: NeilBrown <neilb@suse.de>

because I completely agree with your improvement.

We should keep an eye out for then Andrew commits this and make sure
the right patch goes in...

Thanks,
NeilBrown

