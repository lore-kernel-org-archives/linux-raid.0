Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E1D4C433EF
	for <linux-raid@archiver.kernel.org>; Fri, 10 Jun 2022 16:16:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346347AbiFJQQU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 10 Jun 2022 12:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346333AbiFJQQP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 10 Jun 2022 12:16:15 -0400
Received: from mx1.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FC3A196
        for <linux-raid@vger.kernel.org>; Fri, 10 Jun 2022 09:16:12 -0700 (PDT)
Received: from [192.168.0.175] (ip5f5aece4.dynamic.kabel-deutschland.de [95.90.236.228])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: buczek)
        by mx.molgen.mpg.de (Postfix) with ESMTPSA id 24D4161EA1923;
        Fri, 10 Jun 2022 18:16:09 +0200 (CEST)
Message-ID: <936cb7db-0499-2a0c-3b61-f450c7a2b161@molgen.mpg.de>
Date:   Fri, 10 Jun 2022 18:16:08 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH mdadm v1 14/14] tests: Add broken files for all broken
 tests
Content-Language: en-US
To:     Logan Gunthorpe <logang@deltatee.com>, linux-raid@vger.kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Cc:     Song Liu <song@kernel.org>, Christoph Hellwig <hch@infradead.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Coly Li <colyli@suse.de>, Bruce Dubbs <bruce.dubbs@gmail.com>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>
References: <20220609211130.5108-1-logang@deltatee.com>
 <20220609211130.5108-15-logang@deltatee.com>
From:   Donald Buczek <buczek@molgen.mpg.de>
In-Reply-To: <20220609211130.5108-15-logang@deltatee.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 09.06.22 23:11, Logan Gunthorpe wrote:
> Each broken file contains the rough frequency of brokeness as well
> as a brief explanation of what happens when it breaks. Estimates
> of failure rates are not statistically significant and can vary
> run to run.
> 
> This is really just a view from my window. Tests were done on a
> small VM with the default loop devices, not real hardware. We've
> seen different kernel configurations can cause bugs to appear as well
> (ie. different block schedulers). It may also be that different race
> conditions will be seen on machines with different performance
> characteristics.
> 
> These annotations were done with the kernel currently in md/md-next:
> 
>   facef3b96c5b ("md: Notify sysfs sync_completed in md_reap_sync_thread()")
> 
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> ---
>   tests/01r5integ.broken                     |  7 ++++
>   tests/01raid6integ.broken                  |  7 ++++
>   tests/04r5swap.broken                      |  7 ++++
>   tests/07autoassemble.broken                |  8 ++++
>   tests/07autodetect.broken                  |  5 +++
>   tests/07changelevelintr.broken             |  9 +++++
>   tests/07changelevels.broken                |  9 +++++
>   tests/07reshape5intr.broken                | 45 ++++++++++++++++++++++
>   tests/07revert-grow.broken                 | 31 +++++++++++++++
>   tests/07revert-shrink.broken               |  9 +++++
>   tests/07testreshape5.broken                | 12 ++++++
>   tests/09imsm-assemble.broken               |  6 +++
>   tests/09imsm-create-fail-rebuild.broken    |  5 +++
>   tests/09imsm-overlap.broken                |  7 ++++
>   tests/10ddf-assemble-missing.broken        |  6 +++
>   tests/10ddf-fail-create-race.broken        |  7 ++++
>   tests/10ddf-fail-two-spares.broken         |  5 +++
>   tests/10ddf-incremental-wrong-order.broken |  9 +++++
>   tests/14imsm-r1_2d-grow-r1_3d.broken       |  5 +++
>   tests/14imsm-r1_2d-takeover-r0_2d.broken   |  6 +++
>   tests/18imsm-r10_4d-takeover-r0_2d.broken  |  5 +++
>   tests/18imsm-r1_2d-takeover-r0_1d.broken   |  6 +++
>   tests/19raid6auto-repair.broken            |  5 +++
>   tests/19raid6repair.broken                 |  5 +++
>   24 files changed, 226 insertions(+)
>   create mode 100644 tests/01r5integ.broken
>   create mode 100644 tests/01raid6integ.broken
>   create mode 100644 tests/04r5swap.broken
>   create mode 100644 tests/07autoassemble.broken
>   create mode 100644 tests/07autodetect.broken
>   create mode 100644 tests/07changelevelintr.broken
>   create mode 100644 tests/07changelevels.broken
>   create mode 100644 tests/07reshape5intr.broken
>   create mode 100644 tests/07revert-grow.broken
>   create mode 100644 tests/07revert-shrink.broken
>   create mode 100644 tests/07testreshape5.broken
>   create mode 100644 tests/09imsm-assemble.broken
>   create mode 100644 tests/09imsm-create-fail-rebuild.broken
>   create mode 100644 tests/09imsm-overlap.broken
>   create mode 100644 tests/10ddf-assemble-missing.broken
>   create mode 100644 tests/10ddf-fail-create-race.broken
>   create mode 100644 tests/10ddf-fail-two-spares.broken
>   create mode 100644 tests/10ddf-incremental-wrong-order.broken
>   create mode 100644 tests/14imsm-r1_2d-grow-r1_3d.broken
>   create mode 100644 tests/14imsm-r1_2d-takeover-r0_2d.broken
>   create mode 100644 tests/18imsm-r10_4d-takeover-r0_2d.broken
>   create mode 100644 tests/18imsm-r1_2d-takeover-r0_1d.broken
>   create mode 100644 tests/19raid6auto-repair.broken
>   create mode 100644 tests/19raid6repair.broken
> 
> diff --git a/tests/01r5integ.broken b/tests/01r5integ.broken
> new file mode 100644
> index 000000000000..207376372243
> --- /dev/null
> +++ b/tests/01r5integ.broken
> @@ -0,0 +1,7 @@
> +fails rarely
> +
> +Fails about 1 in every 30 runs with a sha mismatch error:
> +
> +    c49ab26e1b01def7874af9b8a6d6d0c29fdfafe6 /dev/md0 does not match
> +    15dc2f73262f811ada53c65e505ceec9cf025cb9 /dev/md0 with /dev/loop3
> +    missing
> diff --git a/tests/01raid6integ.broken b/tests/01raid6integ.broken
> new file mode 100644
> index 000000000000..1df735f08c8c
> --- /dev/null
> +++ b/tests/01raid6integ.broken
> @@ -0,0 +1,7 @@
> +fails infrequently
> +
> +Fails about 1 in 5 with a sha mismatch:
> +
> +    8286c2bc045ae2cfe9f8b7ae3a898fa25db6926f /dev/md0 does not match
> +    a083a0738b58caab37fd568b91b177035ded37df /dev/md0 with /dev/loop2 and
> +    /dev/loop3 missing
> diff --git a/tests/04r5swap.broken b/tests/04r5swap.broken
> new file mode 100644
> index 000000000000..e38987dbf01b
> --- /dev/null
> +++ b/tests/04r5swap.broken
> @@ -0,0 +1,7 @@
> +always fails
> +
> +Fails with errors:
> +
> +  mdadm: /dev/loop0 has no superblock - assembly aborted
> +
> +   ERROR: no recovery happening
> diff --git a/tests/07autoassemble.broken b/tests/07autoassemble.broken
> new file mode 100644
> index 000000000000..8be09407f628
> --- /dev/null
> +++ b/tests/07autoassemble.broken
> @@ -0,0 +1,8 @@
> +always fails
> +
> +Prints lots of messages, but the array doesn't assemble. Error
> +possibly related to:
> +
> +  mdadm: /dev/md/1 is busy - skipping
> +  mdadm: no recogniseable superblock on /dev/md/testing:0
> +  mdadm: /dev/md/2 is busy - skipping
> diff --git a/tests/07autodetect.broken b/tests/07autodetect.broken
> new file mode 100644
> index 000000000000..294954a1f50a
> --- /dev/null
> +++ b/tests/07autodetect.broken
> @@ -0,0 +1,5 @@
> +always fails
> +
> +Fails with error:
> +
> +    ERROR: no resync happening
> diff --git a/tests/07changelevelintr.broken b/tests/07changelevelintr.broken
> new file mode 100644
> index 000000000000..284b49068295
> --- /dev/null
> +++ b/tests/07changelevelintr.broken
> @@ -0,0 +1,9 @@
> +always fails
> +
> +Fails with errors:
> +
> +  mdadm: this change will reduce the size of the array.
> +         use --grow --array-size first to truncate array.
> +         e.g. mdadm --grow /dev/md0 --array-size 56832
> +
> +  ERROR: no reshape happening
> diff --git a/tests/07changelevels.broken b/tests/07changelevels.broken
> new file mode 100644
> index 000000000000..9b930d932c48
> --- /dev/null
> +++ b/tests/07changelevels.broken
> @@ -0,0 +1,9 @@
> +always fails
> +
> +Fails with errors:
> +
> +    mdadm: /dev/loop0 is smaller than given size. 18976K < 19968K + metadata
> +    mdadm: /dev/loop1 is smaller than given size. 18976K < 19968K + metadata
> +    mdadm: /dev/loop2 is smaller than given size. 18976K < 19968K + metadata
> +
> +    ERROR: /dev/md0 isn't a block device.
> diff --git a/tests/07reshape5intr.broken b/tests/07reshape5intr.broken
> new file mode 100644
> index 000000000000..efe52a667172
> --- /dev/null
> +++ b/tests/07reshape5intr.broken
> @@ -0,0 +1,45 @@
> +always fails
> +
> +This patch, recently added to md-next causes the test to always fail:
> +
> +7e6ba434cc60 ("md: don't unregister sync_thread with reconfig_mutex
> +held")
> +
> +The new error is simply:
> +
> +   ERROR: no reshape happening
> +
> +Before the patch, the error seen is below.
> +
> +--
> +
> +fails infrequently
> +
> +Fails roughly 1 in 4 runs with errors:
> +
> +    mdadm: Merging with already-assembled /dev/md/0
> +    mdadm: cannot re-read metadata from /dev/loop6 - aborting
> +
> +    ERROR: no reshape happening
> +
> +Also have seen a random deadlock:
> +
> +     INFO: task mdadm:109702 blocked for more than 30 seconds.
> +           Not tainted 5.18.0-rc3-eid-vmlocalyes-dbg-00095-g3c2b5427979d #2040
> +     "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> +     task:mdadm           state:D stack:    0 pid:109702 ppid:     1 flags:0x00004000
> +     Call Trace:
> +      <TASK>
> +      __schedule+0x67e/0x13b0
> +      schedule+0x82/0x110
> +      mddev_suspend+0x2e1/0x330
> +      suspend_lo_store+0xbd/0x140
> +      md_attr_store+0xcb/0x130
> +      sysfs_kf_write+0x89/0xb0
> +      kernfs_fop_write_iter+0x202/0x2c0
> +      new_sync_write+0x222/0x330
> +      vfs_write+0x3bc/0x4d0
> +      ksys_write+0xd9/0x180
> +      __x64_sys_write+0x43/0x50
> +      do_syscall_64+0x3b/0x90
> +      entry_SYSCALL_64_after_hwframe+0x44/0xae
> diff --git a/tests/07revert-grow.broken b/tests/07revert-grow.broken
> new file mode 100644
> index 000000000000..9b6db86f60ab
> --- /dev/null
> +++ b/tests/07revert-grow.broken
> @@ -0,0 +1,31 @@
> +always fails
> +
> +This patch, recently added to md-next causes the test to always fail:
> +
> +7e6ba434cc60 ("md: don't unregister sync_thread with reconfig_mutex held")
> +
> +The errors are:
> +
> +    mdadm: No active reshape to revert on /dev/loop0
> +    ERROR: active raid5 not found
> +
> +Before the patch, the error seen is below.
> +
> +--
> +
> +fails rarely
> +
> +Fails about 1 in every 30 runs with errors:
> +
> +    mdadm: Merging with already-assembled /dev/md/0
> +    mdadm: backup file /tmp/md-backup inaccessible: No such file or directory
> +    mdadm: failed to add /dev/loop1 to /dev/md/0: Invalid argument
> +    mdadm: failed to add /dev/loop2 to /dev/md/0: Invalid argument
> +    mdadm: failed to add /dev/loop3 to /dev/md/0: Invalid argument
> +    mdadm: failed to add /dev/loop0 to /dev/md/0: Invalid argument
> +    mdadm: /dev/md/0 assembled from 1 drive - need all 5 to start it
> +            (use --run to insist).
> +
> +    grep: /sys/block/md*/md/sync_action: No such file or directory
> +
> +    ERROR: active raid5 not found
> diff --git a/tests/07revert-shrink.broken b/tests/07revert-shrink.broken
> new file mode 100644
> index 000000000000..c33c39ec04f8
> --- /dev/null
> +++ b/tests/07revert-shrink.broken
> @@ -0,0 +1,9 @@
> +always fails
> +
> +Fails with errors:
> +
> +    mdadm: this change will reduce the size of the array.
> +           use --grow --array-size first to truncate array.
> +           e.g. mdadm --grow /dev/md0 --array-size 53760
> +
> +    ERROR: active raid5 not found
> diff --git a/tests/07testreshape5.broken b/tests/07testreshape5.broken
> new file mode 100644
> index 000000000000..a8ce03e491b3
> --- /dev/null
> +++ b/tests/07testreshape5.broken
> @@ -0,0 +1,12 @@
> +always fails
> +
> +Test seems to run 'test_stripe' at $dir directory, but $dir is never
> +set. If $dir is adjusted to $PWD, the test still fails with:
> +
> +    mdadm: /dev/loop2 is not suitable for this array.
> +    mdadm: create aborted
> +    ++ return 1
> +    ++ cmp -s -n 8192 /dev/md0 /tmp/RandFile
> +    ++ echo cmp failed
> +    cmp failed
> +    ++ exit 2
> diff --git a/tests/09imsm-assemble.broken b/tests/09imsm-assemble.broken
> new file mode 100644
> index 000000000000..a6d4d5cf911b
> --- /dev/null
> +++ b/tests/09imsm-assemble.broken
> @@ -0,0 +1,6 @@
> +fails infrequently
> +
> +Fails roughly 1 in 10 runs with errors:
> +
> +    mdadm: /dev/loop2 is still in use, cannot remove.
> +    /dev/loop2 removal from /dev/md/container should have succeeded
> diff --git a/tests/09imsm-create-fail-rebuild.broken b/tests/09imsm-create-fail-rebuild.broken
> new file mode 100644
> index 000000000000..40c4b294da38
> --- /dev/null
> +++ b/tests/09imsm-create-fail-rebuild.broken
> @@ -0,0 +1,5 @@
> +always fails
> +
> +Fails with error:
> +
> +    **Error**: Array size mismatch - expected 3072, actual 16384
> diff --git a/tests/09imsm-overlap.broken b/tests/09imsm-overlap.broken
> new file mode 100644
> index 000000000000..e7ccab768bea
> --- /dev/null
> +++ b/tests/09imsm-overlap.broken
> @@ -0,0 +1,7 @@
> +always fails
> +
> +Fails with errors:
> +
> +    **Error**: Offset mismatch - expected 15360, actual 0
> +    **Error**: Offset mismatch - expected 15360, actual 0
> +    /dev/md/vol3 failed check
> diff --git a/tests/10ddf-assemble-missing.broken b/tests/10ddf-assemble-missing.broken
> new file mode 100644
> index 000000000000..bfd8d103a630
> --- /dev/null
> +++ b/tests/10ddf-assemble-missing.broken
> @@ -0,0 +1,6 @@
> +always fails
> +
> +Fails with errors:
> +
> +    ERROR: /dev/md/vol0 has unexpected state on /dev/loop10
> +    ERROR: unexpected number of online disks on /dev/loop10
> diff --git a/tests/10ddf-fail-create-race.broken b/tests/10ddf-fail-create-race.broken
> new file mode 100644
> index 000000000000..6c0df023fb18
> --- /dev/null
> +++ b/tests/10ddf-fail-create-race.broken
> @@ -0,0 +1,7 @@
> +usually fails
> +
> +Fails about 9 out of 10 times with many errors:
> +
> +    mdadm: cannot open MISSING: No such file or directory
> +    ERROR: non-degraded array found
> +    ERROR: disk 0 not marked as failed in meta data
> diff --git a/tests/10ddf-fail-two-spares.broken b/tests/10ddf-fail-two-spares.broken
> new file mode 100644
> index 000000000000..eeea56d989ff
> --- /dev/null
> +++ b/tests/10ddf-fail-two-spares.broken
> @@ -0,0 +1,5 @@
> +fails infrequently
> +
> +Fails roughly 1 in 3 with error:
> +
> +   ERROR: /dev/md/vol1 should be optimal in meta data
> diff --git a/tests/10ddf-incremental-wrong-order.broken b/tests/10ddf-incremental-wrong-order.broken
> new file mode 100644
> index 000000000000..a5af3bab2ec2
> --- /dev/null
> +++ b/tests/10ddf-incremental-wrong-order.broken
> @@ -0,0 +1,9 @@
> +always fails
> +
> +Fails with errors:
> +    ERROR: sha1sum of /dev/md/vol0 has changed
> +    ERROR: /dev/md/vol0 has unexpected state on /dev/loop10
> +    ERROR: unexpected number of online disks on /dev/loop10
> +    ERROR: /dev/md/vol0 has unexpected state on /dev/loop8
> +    ERROR: unexpected number of online disks on /dev/loop8
> +    ERROR: sha1sum of /dev/md/vol0 has changed
> diff --git a/tests/14imsm-r1_2d-grow-r1_3d.broken b/tests/14imsm-r1_2d-grow-r1_3d.broken
> new file mode 100644
> index 000000000000..4ef1d4069b65
> --- /dev/null
> +++ b/tests/14imsm-r1_2d-grow-r1_3d.broken
> @@ -0,0 +1,5 @@
> +always fails
> +
> +Fails with error:
> +
> +    mdadm/tests/func.sh: line 325: dvsize/chunk: division by 0 (error token is "chunk")
> diff --git a/tests/14imsm-r1_2d-takeover-r0_2d.broken b/tests/14imsm-r1_2d-takeover-r0_2d.broken
> new file mode 100644
> index 000000000000..89cd4e575362
> --- /dev/null
> +++ b/tests/14imsm-r1_2d-takeover-r0_2d.broken
> @@ -0,0 +1,6 @@
> +always fails
> +
> +Fails with error:
> +
> +    tests/func.sh: line 325: dvsize/chunk: division by 0 (error token
> +		is "chunk")
> diff --git a/tests/18imsm-r10_4d-takeover-r0_2d.broken b/tests/18imsm-r10_4d-takeover-r0_2d.broken
> new file mode 100644
> index 000000000000..a27399f5ed83
> --- /dev/null
> +++ b/tests/18imsm-r10_4d-takeover-r0_2d.broken
> @@ -0,0 +1,5 @@
> +fails rarely
> +
> +Fails about 1 run in 100 with message:
> +
> +   ERROR:  size is wrong for /dev/md/vol0: 2 * 5120 (chunk=128) = 20480, not 0
> diff --git a/tests/18imsm-r1_2d-takeover-r0_1d.broken b/tests/18imsm-r1_2d-takeover-r0_1d.broken
> new file mode 100644
> index 000000000000..59aadfa1ef0e
> --- /dev/null
> +++ b/tests/18imsm-r1_2d-takeover-r0_1d.broken
> @@ -0,0 +1,6 @@
> +always fails
> +
> +Fails with error:
> +
> +    tests/func.sh: line 325: dvsize/chunk: division by 0 (error token
> +    		is "chunk")

NIT:

Applying: tests: Add broken files for all broken tests

.git/rebase-apply/patch:399: space before tab in indent.

     		is "chunk")

warning: 1 line adds whitespace errors.


<space><space><space><space><space><tab> :-)

   Donald


> diff --git a/tests/19raid6auto-repair.broken b/tests/19raid6auto-repair.broken
> new file mode 100644
> index 000000000000..e91a142575e2
> --- /dev/null
> +++ b/tests/19raid6auto-repair.broken
> @@ -0,0 +1,5 @@
> +always fails
> +
> +Fails with:
> +
> +    "should detect errors"
> diff --git a/tests/19raid6repair.broken b/tests/19raid6repair.broken
> new file mode 100644
> index 000000000000..e91a142575e2
> --- /dev/null
> +++ b/tests/19raid6repair.broken
> @@ -0,0 +1,5 @@
> +always fails
> +
> +Fails with:
> +
> +    "should detect errors"

-- 
Donald Buczek
buczek@molgen.mpg.de
Tel: +49 30 8413 1433
