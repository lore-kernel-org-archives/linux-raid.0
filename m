From: Shaohua Li <shli@kernel.org>
Subject: Re: Enable skip_copy can cause data integrity issue in some storage
 stack
Date: Wed, 6 Sep 2017 08:57:39 -0700
Message-ID: <20170906155739.exyap2fythtukpxy@kernel.org>
References: <73ed28991837a9884824309137f1621c@synology.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <73ed28991837a9884824309137f1621c@synology.com>
Sender: linux-raid-owner@vger.kernel.org
To: alexwu <alexwu@synology.com>
Cc: linux-raid@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, neilb@suse.com
List-Id: linux-raid.ids

On Fri, Sep 01, 2017 at 03:26:41PM +0800, alexwu wrote:
> Hi,
> 
> Recently a data integrity issue about skip_copy was found. We are able
> to reproduce it and found the root cause. This data integrity issue
> might happen if there are other layers between file system and raid5.
> 
> [How to Reproduce]
> 
> 1. Create a raid5 named md0 first (with skip_copy enable), and wait md0
>    resync done which ensures that all data and parity are synchronized
> 2. Use lvm tools to create a logical volume named lv-md0 over md0
> 3. Format an ext4 file system on lv-md0 and mount on /mnt
> 4. Do some db operations (e.g. sqlite insert) to write data through /mnt
> 5. When those db operations finished, we do the following command
>    "echo check > /sys/block/md0/md/sync_action" to check mismatch_cnt,
>    it is very likely that we got mismatch_cnt != 0 when check finished
> 
> [Root Cause]
> 
> After tracing code and more experiments, it is more proper to say that
> it's a problem about backing_dev_info (bdi) instead of a bug about
> skip_copy.
> 
> We notice that:
>    1. skip_copy counts on BDI_CAP_STABLE_WRITES to ensure that bio's page
>       will not be modified before raid5 completes I/O. Thus we can skip copy
>       page from bio to stripe cache
>    2. The ext4 file system will call wait_for_stable_page() to ask whether
>       the mapped bdi requires stable writes
> 
> Data integrity happens because:
>    1. When raid5 enable skip_copy, it will only set it's own bdi required
>       BDI_CAP_STABLE_WRITES, but this information will not propagate to
>       other bdi between file system and md
>    2. When ext4 file system check stable writes requirement by calling
>       wait_for_stable_page(), it can only see the underlying bdi's
> capability
>       and cannot see all related bdi
> 
> Thus, skip_copy works fine if we format file system directly on md.
> But data integrity issue happens if there are some other block layers (e.g.
> dm)
> between file system and md.
> 
> [Result]
> 
> We do more tests on different storage stacks, here are the results.
> 
> The following settings can pass the test thousand times:
>    1. raid5 with skip_copy enable + ext4
>    2. raid5 with skip_copy disable + ext4
>    3. raid5 with skip_copy disable + lvm + ext4
> 
> The following setting will fail the test in 10 rounds:
>    1. raid5 with skip_copy enable + lvm + ext4
> 
> I think the solution might be let all bdi can communicate through different
> block layers,
> then we can pass BDI_CAP_STABLE_WRITES information if we enable skip_copy.
> But the current bdi structure is not allowed us to do that.
> 
> What would you suggest to do if we want to make skip_copy more reliable ?

Very interesting problem. Looks this isn't raid5 specific. stacked device with
block integrity enabled could expose the same issue.

I'm cc Jens and Neil to check if they have good idea. Basically the problem is
for stacked disk, the under layer disk has BDI_CAP_STABLE_WRITES enabled, but
upper layer doesn't enable it. The under layer disk could be a raid5 with
skip_copy enabled or could be any disk with block integrity enabled (which will
enable BDI_CAP_STABLE_WRITES). Currently we don't propagate the flag to upper
layer disk.

A solution is blk_set_stacking_limits propagate the flag at queue setup, we
then don't allow the flag changing in runtime later. The raid5 skip_copy
interface changes the flag in runtime which probably isn't safe.

Thanks,
Shaohua
