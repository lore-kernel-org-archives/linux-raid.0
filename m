From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 11/27] bcache: io.c: use bio_set_vec_table
Date: Tue, 5 Apr 2016 10:31:34 -0700
Message-ID: <20160405173134.GC31055@infradead.org>
References: <1459857443-20611-1-git-send-email-tom.leiming@gmail.com>
 <1459857443-20611-12-git-send-email-tom.leiming@gmail.com>
 <20160405124902.GA11986@infradead.org>
 <CACVXFVN+SfQ=mkdKeAMmPrkzQtrYcNxDPrT6bxNjC==xnuaxhg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-bcache-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACVXFVN+SfQ=mkdKeAMmPrkzQtrYcNxDPrT6bxNjC==xnuaxhg@mail.gmail.com>
Sender: linux-bcache-owner@vger.kernel.org
To: Ming Lei <tom.leiming@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jens Axboe <axboe@fb.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-block@vger.kernel.org, Boaz Harrosh <boaz@plexistor.com>, Kent Overstreet <kent.overstreet@gmail.com>, Shaohua Li <shli@kernel.org>, "open list:BCACHE (BLOCK LAYER CACHE)" <linux-bcache@vger.kernel.org>, "open list:SOFTWARE RAID (Multiple Disks) SUPPORT" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Tue, Apr 05, 2016 at 11:24:30PM +0800, Ming Lei wrote:
> - bio can be embedded into one biger instance, which is often allocated
> dynamically, so one extra allocation for bio can be avoided.

We can also do this the other way around with the bios front_pad,
which avoid the caller poking into bio details.

> - we should support arbitrary bio size by this way, at least bio_add_page()
> supports this usage.  Also code gets lots of simplication with arbitrary bio
> size support, such as prio_io(): bcache

There is no reason for not supporting huge bios in the core bio code,
in fact using bio_kmalloc you can already allocate huges bios
dynamically right now.  Except that you can't really use it, because the
layers below don't expect that.  Bios based drivers expect to be able to
call bio_clone and friends called on bios passed to them, and might
also make assumptions about the max number of bios segments for now.

> BTW, the root cause for bcache crash still isn't clear now because
> blk_bio_segment_split() should split big bio into proper size with
> all queue's limits. Maybe the max segment limit isn't figured out correctly.

The root cause is pretty simple:  The queue limits matter for request
based drivers, which are the only ones getting bios > BIO_MAX_PAGES
except for the buggy bcache use case.  You'll need to either adjust the
limit for all bio based drivers to or get rid of that one magic caller
not playing by the rules.
