From: Shaohua Li <shli@kernel.org>
Subject: Re: [md PATCH 1/3] md/raid1: fix: IO can block resync indefinitely
Date: Wed, 9 Nov 2016 12:50:36 -0800
Message-ID: <20161109205036.6do6roypkhpbyv2n@kernel.org>
References: <147864718560.1076.2148299631932240330.stgit@noble>
 <147864729272.1076.727849896269121517.stgit@noble>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <147864729272.1076.727849896269121517.stgit@noble>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Nov 09, 2016 at 10:21:32AM +1100, Neil Brown wrote:
> While performing a resync/recovery, raid1 divides the
> array space into three regions:
>  - before the resync
>  - at or shortly after the resync point
>  - much further ahead of the resync point.
> 
> Write requests to the first or third do not need to wait.  Write
> requests to the middle region do need to wait if resync requests are
> pending.
> 
> If there are any active write requests in the middle region, resync
> will wait for them.
> 
> Due to an accounting error, there is a small range of addresses,
> between conf->next_resync and conf->start_next_window, where write
> requests will *not* be blocked, but *will* be counted in the middle
> region.  This can effectively block resync indefinitely if filesystem
> writes happen repeatedly to this region.

Good catch, thanks Neil! 
> As ->next_window_requests is incremented when the sector is before

I changed 'before' to 'after' when applying this patch

Thanks,
Shaohua
