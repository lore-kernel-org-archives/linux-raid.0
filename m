From: "George Spelvin" <linux@horizon.com>
Subject: Re: 3-way mirrors
Date: 7 Sep 2010 14:49:17 -0400
Message-ID: <20100907184917.8181.qmail@science.horizon.com>
References: <4C866354.3050904@cdf.toronto.edu>
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4C866354.3050904@cdf.toronto.edu>
Sender: linux-raid-owner@vger.kernel.org
To: iordan@cdf.toronto.edu, linux@horizon.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

George Spelvin wrote:
>> Anyway, one nice property of a 2-drive redundancy (3+-way mirror or
>> RAID-6) is error detection: in case of a mismatch, it's possible to
>> finger the offending drive.

> When we see a mismatch_cnt > 0, we would run a dd/cmp script which would 
> detect the drive and sector which is mismatched (i.e. we would craft a 
> script which runs three dd processes in parallel, reading from each 
> drive, and compares the data).

> When an inconsistency is discovered, we would have the sector which 
> doesn't match, and which drive it's on. However, even at 60MB/s, this 
> would take 5 hours to perform with our 1TB drives. So, it would be much 
> better if we could do this while we are up, somehow.

That was my hope, for the md software to do it automatically.

>> My understanding of the current code is that it just copies one mirror
>> (the first readable?) to the others.  Does someone have a patch to vote
>> on the data?  If not, can someone point me at the relevant bit of code
>> and orient me enough that I can create it?

> Resyncing an entire drive is probably not necessary with a mismatch, 
> because you already know the rest of the drive is synced and can simply 
> manually force a particular sector to match.

Ideally, I'd like ZFS-like checksums on the data, with a mismatch triggering
a read of all mirrors and a reconstruction attempt.  With that, a silently
corrupted sector on RAID-5 can be pinpointed and fixed.

But in the meantime, I'd like check/repair passes to tell me if 2 of the 3
mirrors agree, so I can blame the third.

>> (The other thing I'd love is a more advanced that can accept a
>> block number found by "check" as a parameter to "repair" so I don't have
>> to wait while the array is re-scanned.  Um... I suppose this depends on
>> a local patch I have that logs the sector numbers of mismatches.)

> Yes, but don't you run the risk of syncing the "bad" data from the 
> mismatch drive to the other two drives if you do this automatically? 
> Don't you also need a parameter to specify which drive to sync from?

That's why I wanted the voting, so the RAID software could decide
automatically.  I don't see a practical way to identify the correct
block contents in isolation, although mapping up to a logical file
may find a file which can be checked for consistency.

(But debugfs takes forever to run icheck + ncheck on a large filesystem.)

> At any rate, if the mismatch sector(s) are also logged during the array 
> check, then resyncing this sector by hand would be easy and fast with 
> minimal downtime. It would be great to have this functionality to start 
> with.

I use the following patch.  Note that it reports the offset in 512-byte
sectors within a single component; multiply by the number of data drives
and divide by sectors per block to get a block offset within the RAID
array.

diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
index d1d6891..2dcffcd 100644
--- a/drivers/md/raid10.c
+++ b/drivers/md/raid10.c
@@ -1363,6 +1363,8 @@ static void sync_request_write(mddev_t *mddev, r10bio_t *r10_bio)
 					break;
 			if (j == vcnt)
 				continue;
+			printk(KERN_INFO "%s: Mismatch at sector %llu\n",
+			    mdname(mddev), (unsigned long long)r10_bio->sector);
 			mddev->resync_mismatches += r10_bio->sectors;
 		}
 		if (test_bit(MD_RECOVERY_CHECK, &mddev->recovery))
diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 96c6902..a0a0b08 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -2732,6 +2732,8 @@ static void handle_parity_checks5(raid5_conf_t *conf, struct stripe_head *sh,
 			 */
 			set_bit(STRIPE_INSYNC, &sh->state);
 		else {
+printk(KERN_INFO "%s: Mismatch at sector %llu\n", mdname(conf->mddev),
+	(unsigned long long)sh->sector);
 			conf->mddev->resync_mismatches += STRIPE_SECTORS;
 			if (test_bit(MD_RECOVERY_CHECK, &conf->mddev->recovery))
 				/* don't try to repair!! */
