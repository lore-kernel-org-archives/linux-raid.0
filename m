From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/3] raid5-cache: IO error handling
Date: Sun, 4 Oct 2015 07:44:40 -0700
Message-ID: <20151004144440.GA19124@infradead.org>
References: <cover.1443653794.git.shli@fb.com>
 <e9c915cf18d81f76e122a2533baeb68c56186d8f.1443653794.git.shli@fb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <e9c915cf18d81f76e122a2533baeb68c56186d8f.1443653794.git.shli@fb.com>
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@fb.com>
Cc: linux-raid@vger.kernel.org, Kernel-team@fb.com, songliubraving@fb.com, dan.j.williams@intel.com, neilb@suse.de
List-Id: linux-raid.ids

On Wed, Sep 30, 2015 at 04:15:40PM -0700, Shaohua Li wrote:
> There are 3 places the raid5-cache dispatches IO. The discard IO error
> doesn't matter, so we ignore it. The superblock write IO error can be
> handled in MD core. The remaining are log write and flush. When the IO
> error happens, we simply fail all raid disks and continue the stripe
> state machine. The MD/raid5 core can handle it (for example, mark all
> disks faulty, report bio error and so on).

This introduces a use after free, which will always report an I/O error
when SLAB poisoning is enabled.  The following patch needs to be folded
into it to fix that:

diff --git a/drivers/md/raid5-cache.c b/drivers/md/raid5-cache.c
index 430ce5c..8d93af1 100644
--- a/drivers/md/raid5-cache.c
+++ b/drivers/md/raid5-cache.c
@@ -239,11 +239,11 @@ static void r5l_log_endio(struct bio *bio)
 	struct r5l_log *log = io->log;
 	unsigned long flags;
 
-	bio_put(bio);
-
 	if (bio->bi_error)
 		r5l_log_io_error(log);
 
+	bio_put(bio);
+
 	if (!atomic_dec_and_test(&io->pending_io))
 		return;
 
