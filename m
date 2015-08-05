From: NeilBrown <neilb@suse.com>
Subject: Re: [PATCH 4/9] raid5: log reclaim support
Date: Wed, 5 Aug 2015 13:52:43 +1000
Message-ID: <20150805135243.430fead5@noble>
References: <cover.1438215986.git.shli@fb.com>
	<41a6d2e74494506fcd6ffd68a5884d38dc0bfa8e.1438215986.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <41a6d2e74494506fcd6ffd68a5884d38dc0bfa8e.1438215986.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, hch@infradead.org, dan.j.williams@intel.com
List-Id: linux-raid.ids

On Wed, 29 Jul 2015 17:38:44 -0700 Shaohua Li <shli@fb.com> wrote:

> +		while (!list_empty(&log->stripe_end_ios)) {
> +			io = list_first_entry(&log->stripe_end_ios,
> +				struct r5l_io_unit, log_sibling);
> +			list_move_tail(&io->log_sibling, &list);
> +			free += (io->log_end - io->log_start +
> +				log->total_blocks) % log->total_blocks;
> +		}

sorry, forgot to mention this bit.

That '%' is acting on 64 but numbers, so it won't build in a 32bit
machine.
Maybe use SECTOR_DIV, maybe do an 
   if (x > y) free = x-y else free = x+total-y;

or something.

NeilBrown

