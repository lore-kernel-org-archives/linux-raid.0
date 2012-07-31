From: Jens Axboe <axboe@kernel.dk>
Subject: Re: [PATCH 0/4] Plugging changes for blk/md/umem
Date: Tue, 31 Jul 2012 09:08:55 +0200
Message-ID: <50178487.4090302@kernel.dk>
References: <20120726025650.32180.65163.stgit@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120726025650.32180.65163.stgit@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org, Shaohua Li <shli@kernel.org>
List-Id: linux-raid.ids

On 07/26/2012 04:58 AM, NeilBrown wrote:
> Hi Jens,
>  the following series makes a number of changes to plugging, moving
>  common code from md and umem into block, and modifying it to allow
>  md to get more value out of it.
>  They've been sitting in -next for a while.
>  Are you OK with me forwarding them to Linus, or would you rather they
>  went though your tree?

Thanks Neil, looks good. I will apply them to my tree and do some basic
testing, too, then push it off for this round (where I haven't pushed
out yet).

-- 
Jens Axboe

