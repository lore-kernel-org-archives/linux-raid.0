From: Paul Clements <paul.clements@steeleye.com>
Subject: Re: [BUG / PATCH] raid1: set BIO_UPTODATE after read error
Date: Wed, 15 Sep 2004 13:34:16 -0400
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41487D18.1050000@steeleye.com>
References: <41420D07.4060001@steeleye.com> <16709.12517.514905.627708@cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010502070606020301040800"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <16709.12517.514905.627708@cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is a multi-part message in MIME format.
--------------010502070606020301040800
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Neil Brown wrote:
> On Friday September 10, paul.clements@steeleye.com wrote:
> 
>>Neil,
>>
>>unless you've already done so, I believe there is a little fix needed in 
>>the raid1 read reschedule code. As the code currently works, a read that 
>>is retried will continue to fail and cause raid1 to go into an infinite 
>>retry loop:
> 
> 
> Thanks.  I must have noticed this when writing the raid10 module
> because it gets it right.  Obviously I didn't "back-port" it to raid1.
> 
> A few other fields need to be reset for safety.

Well, it turns out that even that is not enough. Even with your patch, 
we're still seeing ext3-fs errors, which means we're getting bogus data 
on the read retry (the filesystem is re-created every test run, so 
there's no chance of lingering filesystem corruption causing the errors).

Rather than getting down in the guts of the bio and trying to reset all 
the fields that potentially could have been touched, I think it's 
probably safer to simply discard the bio that had the failed I/O 
attempted against it and clone a new bio, setting it up just as we did 
for the original read attempt. This seems to work better and will also 
protect us against any future changes in the bio code (or bio handling 
in any driver sitting below raid1), which could break read retry again. 
Patch attached.

--
Paul

--------------010502070606020301040800
Content-Type: text/plain;
 name="md_raid1_bio_clone_on_read_error.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="md_raid1_bio_clone_on_read_error.diff"

--- linux-2.6.5-7.97/drivers/md/raid1.c.orig	2004-09-15 12:12:16.658276872 -0400
+++ linux-2.6.5-7.97/drivers/md/raid1.c		2004-09-15 12:11:38.644055912 -0400
@@ -962,14 +962,19 @@ static void raid1d(mddev_t *mddev)
 			} else {
 				r1_bio->bios[r1_bio->read_disk] = NULL;
 				r1_bio->read_disk = disk;
+				/* discard the failed bio and clone a new one */
+				bio_put(bio);
+				bio = bio_clone(r1_bio->master_bio, GFP_NOIO);
 				r1_bio->bios[r1_bio->read_disk] = bio;
 				printk(KERN_ERR "raid1: %s: redirecting sector %llu to"
 				       " another mirror\n",
 				       bdevname(rdev->bdev,b),
 				       (unsigned long long)r1_bio->sector);
-				bio->bi_bdev = rdev->bdev;
 				bio->bi_sector = r1_bio->sector + rdev->data_offset;
+				bio->bi_bdev = rdev->bdev;
+				bio->bi_end_io = raid1_end_read_request;
 				bio->bi_rw = READ;
+				bio->bi_private = r1_bio;
 				unplug = 1;
 				generic_make_request(bio);
 			}

--------------010502070606020301040800--
