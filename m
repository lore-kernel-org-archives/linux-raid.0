From: Alasdair G Kergon <agk@redhat.com>
Subject: Re: [PATCH]  DM RAID:  Ensure the bitmap region_size is a power of 2
Date: Tue, 11 Dec 2012 21:49:43 +0000
Message-ID: <20121211214943.GC12788@agk.fab.redhat.com>
References: <1355261825.26828.6.camel@f16>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1355261825.26828.6.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, agk@redhat.com
List-Id: linux-raid.ids

On Tue, Dec 11, 2012 at 03:37:05PM -0600, Jon Brassow wrote:
>  		if (min_region_size > (1 << 13)) {
> +			/* region_size must be a power of 2 */
> +			for (i = 13; min_region_size > (1 << i); i++);
> +
> +			region_size = (1 << i);

Can the loop be replaced with a direct bit calculation, perhaps?

Alasdair

