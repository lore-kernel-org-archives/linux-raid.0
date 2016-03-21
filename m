From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH] md:raid1: fix a dead loop when read from a WriteMostly
 disk
Date: Mon, 21 Mar 2016 10:29:33 -0700
Message-ID: <20160321172933.GA66333@kernel.org>
References: <1458559112-27683-1-git-send-email-fangwei1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1458559112-27683-1-git-send-email-fangwei1@huawei.com>
Sender: linux-raid-owner@vger.kernel.org
To: Wei Fang <fangwei1@huawei.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Mar 21, 2016 at 07:18:32PM +0800, Wei Fang wrote:
> If first_bad == this_sector when we get the WriteMostly disk
> in read_balance(), valid disk will be returned with zero
> max_sectors. It'll lead to a dead loop in make_request(), and
> OOM will happen because of endless allocation of struct bio.
> 
> Since we can't get data from this disk in this case, so
> continue for another disk.

Good catch, applied.

Thanks,
Shaohua
