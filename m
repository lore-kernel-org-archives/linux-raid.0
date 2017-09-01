From: alexwu <alexwu@synology.com>
Subject: Enable skip_copy can cause data integrity issue in some storage stack
Date: Fri, 01 Sep 2017 15:26:41 +0800
Message-ID: <73ed28991837a9884824309137f1621c@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: linux-block@vger.kernel.org
List-Id: linux-raid.ids

Hi,

Recently a data integrity issue about skip_copy was found. We are able
to reproduce it and found the root cause. This data integrity issue
might happen if there are other layers between file system and raid5.

[How to Reproduce]

1. Create a raid5 named md0 first (with skip_copy enable), and wait md0
    resync done which ensures that all data and parity are synchronized
2. Use lvm tools to create a logical volume named lv-md0 over md0
3. Format an ext4 file system on lv-md0 and mount on /mnt
4. Do some db operations (e.g. sqlite insert) to write data through /mnt
5. When those db operations finished, we do the following command
    "echo check > /sys/block/md0/md/sync_action" to check mismatch_cnt,
    it is very likely that we got mismatch_cnt != 0 when check finished

[Root Cause]

After tracing code and more experiments, it is more proper to say that
it's a problem about backing_dev_info (bdi) instead of a bug about 
skip_copy.

We notice that:
    1. skip_copy counts on BDI_CAP_STABLE_WRITES to ensure that bio's 
page
       will not be modified before raid5 completes I/O. Thus we can skip 
copy
       page from bio to stripe cache
    2. The ext4 file system will call wait_for_stable_page() to ask 
whether
       the mapped bdi requires stable writes

Data integrity happens because:
    1. When raid5 enable skip_copy, it will only set it's own bdi 
required
       BDI_CAP_STABLE_WRITES, but this information will not propagate to
       other bdi between file system and md
    2. When ext4 file system check stable writes requirement by calling
       wait_for_stable_page(), it can only see the underlying bdi's 
capability
       and cannot see all related bdi

Thus, skip_copy works fine if we format file system directly on md.
But data integrity issue happens if there are some other block layers 
(e.g. dm)
between file system and md.

[Result]

We do more tests on different storage stacks, here are the results.

The following settings can pass the test thousand times:
    1. raid5 with skip_copy enable + ext4
    2. raid5 with skip_copy disable + ext4
    3. raid5 with skip_copy disable + lvm + ext4

The following setting will fail the test in 10 rounds:
    1. raid5 with skip_copy enable + lvm + ext4

I think the solution might be let all bdi can communicate through 
different block layers,
then we can pass BDI_CAP_STABLE_WRITES information if we enable 
skip_copy.
But the current bdi structure is not allowed us to do that.

What would you suggest to do if we want to make skip_copy more reliable 
?

Best Regards,
Alex

