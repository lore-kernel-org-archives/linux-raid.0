From: Shaohua Li <shli@kernel.org>
Subject: Re: [PATCH v2 0/3] md: three misc changes
Date: Mon, 17 Jul 2017 09:41:47 -0700
Message-ID: <20170717164147.unwgwb4ekmwexc3m@kernel.org>
References: <20170714081444.32645-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-block-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20170714081444.32645-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>
Cc: linux-raid@vger.kernel.org, NeilBrown <neilb@suse.com>, linux-block@vger.kernel.org, Jens Axboe <axboe@fb.com>, Christoph Hellwig <hch@infradead.org>
List-Id: linux-raid.ids

On Fri, Jul 14, 2017 at 04:14:41PM +0800, Ming Lei wrote:
> This 1st patch fixes one issue introduced in the following two
> commits:
> 	Fixes: f0250618361d(md: raid10: don't use bio's vec table to manage resync pages)
> 	Fixes: 98d30c5812c3(md: raid1: don't use bio's vec table to manage resync pages)
> 
> The 2nd one initializes bvec table of bio via bio_add_page() after bio_reset().
> 
> The 3rd one moves the common definitation and helpers into raid1-10.c. 

applied, thanks!
 
> V2:
> 	- fix 'page_idx' increasement in patch 1
> 	- move raid1/raid10 common code to raid1-raid10.c, as suggested by Neil
> 
> Ming Lei (3):
>   md: remove 'idx' from 'struct resync_pages'
>   md: raid1/raid10: initialize bvec table via bio_add_page()
>   md: raid1-10: move raid1/raid10 common code into raid1-10.c
> 
>  drivers/md/md.h       | 54 ----------------------------------
>  drivers/md/raid1-10.c | 81 +++++++++++++++++++++++++++++++++++++++++++++++++++
>  drivers/md/raid1.c    | 31 ++++----------------
>  drivers/md/raid10.c   | 19 ++++--------
>  4 files changed, 93 insertions(+), 92 deletions(-)
>  create mode 100644 drivers/md/raid1-10.c
> 
> -- 
> 2.9.4
> 
