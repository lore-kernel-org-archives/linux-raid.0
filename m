From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] [VFS] mark bio_split_pool static
Date: Thu, 9 Oct 2008 08:58:32 +0200
Message-ID: <20081009065832.GX19428@kernel.dk>
References: <1223038878-8038-1-git-send-email-crquan@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1223038878-8038-1-git-send-email-crquan@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Denis ChengRq <crquan@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Andrew Morton <akpm@linux-foundation.org>, linux-fsdevel@vger.kernel.org, Peter Osterlund <petero2@telia.com>, NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-raid.ids

On Fri, Oct 03 2008, Denis ChengRq wrote:
> Since all bio_split calls refer the same single bio_split_pool, the bio_split
> function can use bio_split_pool directly instead of the mempool_t parameter;
> 
> then the mempool_t parameter can be removed from bio_split param list, and
> bio_split_pool is only referred in fs/bio.c file, can be marked static.

Thanks, applied.

-- 
Jens Axboe

