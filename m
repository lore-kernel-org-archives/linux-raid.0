From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] md: Fix data corruption when a degraded raid5 array is
	reshaped.
Date: Thu, 03 Jan 2008 16:00:34 -0700
Message-ID: <1199401234.9102.3.camel@dwillia2-linux.ch.intel.com>
References: <20080104094516.19216.patches@notabene>
	 A<1080103224636.19290@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: A<1080103224636.19290@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, stable@kernel.org
List-Id: linux-raid.ids

On Thu, 2008-01-03 at 15:46 -0700, NeilBrown wrote:
> This patch fixes a fairly serious bug in md/raid5 in 2.6.23 and 24-rc.
> It would be great if it cold get into 23.13 and 24.final.
> Thanks.
> NeilBrown
> 
> ### Comments for Changeset
> 
> We currently do not wait for the block from the missing device
> to be computed from parity before copying data to the new stripe
> layout.
> 
> The change in the raid6 code is not techincally needed as we
> don't delay data block recovery in the same way for raid6 yet.
> But making the change now is safer long-term.
> 
> This bug exists in 2.6.23 and 2.6.24-rc
> 
> Cc: stable@kernel.org
> Cc: Dan Williams <dan.j.williams@intel.com>
> Signed-off-by: Neil Brown <neilb@suse.de>
> 
Acked-by: Dan Williams <dan.j.williams@intel.com>



