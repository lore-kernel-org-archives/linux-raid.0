From: Neil Brown <neilb@cse.unsw.edu.au>
Subject: Re: [BUG / PATCH] raid1: set BIO_UPTODATE after read error
Date: Mon, 13 Sep 2004 15:32:21 +1000
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <16709.12517.514905.627708@cse.unsw.edu.au>
References: <41420D07.4060001@steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Paul Clements on Friday September 10
To: Paul Clements <paul.clements@steeleye.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Friday September 10, paul.clements@steeleye.com wrote:
> Neil,
> 
> unless you've already done so, I believe there is a little fix needed in 
> the raid1 read reschedule code. As the code currently works, a read that 
> is retried will continue to fail and cause raid1 to go into an infinite 
> retry loop:

Thanks.  I must have noticed this when writing the raid10 module
because it gets it right.  Obviously I didn't "back-port" it to raid1.

A few other fields need to be reset for safety.

NeilBrown

======================================================
Make sure bio is re-initialised properly before a raid1 re-read.

Various bio fields might have been changed by a failed read request.
We must reset them.

Signed-off-by: Neil Brown <neilb@cse.unsw.edu.au>

### Diffstat output
 ./drivers/md/raid1.c |    5 +++++
 1 files changed, 5 insertions(+)

diff ./drivers/md/raid1.c~current~ ./drivers/md/raid1.c
--- ./drivers/md/raid1.c~current~	2004-09-13 15:27:05.000000000 +1000
+++ ./drivers/md/raid1.c	2004-09-13 15:27:40.000000000 +1000
@@ -952,6 +952,11 @@ static void raid1d(mddev_t *mddev)
 					       (unsigned long long)r1_bio->sector);
 				bio->bi_bdev = rdev->bdev;
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
+				bio->bi_next = NULL;
+				bio->bi_flags &= (1<<BIO_CLONED);
+				bio->bi_flags |= 1 << BIO_UPTODATE;
+				bio->bi_idx = 0;
+				bio->bi_size = r1_bio->sectors << 9;
 				bio->bi_rw = READ;
 				unplug = 1;
 				generic_make_request(bio);
