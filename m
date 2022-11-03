Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F803C4332F
	for <linux-raid@archiver.kernel.org>; Thu,  3 Nov 2022 03:48:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230030AbiKCDsD (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Nov 2022 23:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229591AbiKCDsB (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 2 Nov 2022 23:48:01 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1A1214D1C
        for <linux-raid@vger.kernel.org>; Wed,  2 Nov 2022 20:47:59 -0700 (PDT)
Subject: Re: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667447277;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=12Uj50v1VBOOvweUjOuQMb2OyBKbRPzEgXDLoxpLcQw=;
        b=amjJtxyBOstRilsdbTV+bjCu59/T+Ki5GSs4Mm/Zp3CRx9LuvUYDUdiwLf17z7rbd0mHmX
        UHvbIBOMvBu+mLHP+y+TsxLZPZwqNohtbBpnnLIIgnbfzKhbW1Y9bZEfF2MFIXjj3kJdTX
        eBYu0bYPkkHZLjDYCUQ5XAEml3VEQ10=
To:     Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>
Cc:     Zdenek Kabelac <zkabelac@redhat.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
Message-ID: <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
Date:   Thu, 3 Nov 2022 11:47:53 +0800
MIME-Version: 1.0
In-Reply-To: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi,

On 11/3/22 12:27 AM, Mikulas Patocka wrote:
> Hi
>
> There's a crash in the test shell/lvchange-rebuild-raid.sh when running
> the lvm testsuite. It can be reproduced by running "make check_local
> T=shell/lvchange-rebuild-raid.sh" in a loop.

I have problem to run the cmd (not sure what I missed), it would be 
better if
the relevant cmds are extracted from the script then I can reproduce it with
those cmds directly.

[root@localhost lvm2]# git log | head -1
commit 36a923926c2c27c1a8a5ac262387d2a4d3e620f8
[root@localhost lvm2]# make check_local T=shell/lvchange-rebuild-raid.sh
make -C libdm device-mapper
[...]
make -C daemons
make[1]: Nothing to be done for 'all'.
make -C test check_local
VERBOSE=0 ./lib/runner \
         --testdir . --outdir results \
         --flavours ndev-vanilla --only shell/lvchange-rebuild-raid.sh 
--skip @
running 1 tests
###      running: [ndev-vanilla] shell/lvchange-rebuild-raid.sh 0
| [ 0:00] lib/inittest: line 133: 
/tmp/LVMTEST317948.iCoLwmDhZW/dev/testnull: Permission denied
| [ 0:00] Filesystem does support devices in 
/tmp/LVMTEST317948.iCoLwmDhZW/dev (mounted with nodev?)
| [ 0:00] ## - /root/lvm2/test/shell/lvchange-rebuild-raid.sh:16
| [ 0:00] ## 1 STACKTRACE() called from lib/inittest:134
| [ 0:00] ## 2 source() called from 
/root/lvm2/test/shell/lvchange-rebuild-raid.sh:16
| [ 0:00] ## teardown....ok
###       failed: [ndev-vanilla] shell/lvchange-rebuild-raid.sh

### 1 tests: 0 passed, 0 skipped, 0 timed out, 0 warned, 1 failed
make[1]: *** [Makefile:137: check_local] Error 1
make: *** [Makefile:89: check_local] Error 2

And line 16 is this,

[root@localhost lvm2]# head -16 
/root/lvm2/test/shell/lvchange-rebuild-raid.sh | tail -1
. lib/inittest

For "lvchange --rebuild" action, I guess it relates to CTR_FLAG_REBUILD flag
which is check from two paths.

1. raid_ctr -> parse_raid_params
                    -> analyse_superblocks -> super_validate -> 
super_init_validation

2. raid_status which might invoked by ioctls (DM_DEV_WAIT_CMD and
     DM_TABLE_STATUS_CMD) from lvm

Since the commit you mentioned the behavior of raid_dtr, then I think 
the crash
is caused by path 2, please correct me if my understanding is wrong.

> The crash happens in the kernel 6.0 and 6.1-rc3, but not in 5.19.
>
> I bisected the crash and it is caused by the commit
> 0dd84b319352bb8ba64752d4e45396d8b13e6018.
>
> I uploaded my .config here (it's 12-core virtual machine):
> https://people.redhat.com/~mpatocka/testcases/md-crash-config/config.txt
>
> Mikulas
>
> [   78.478417] BUG: kernel NULL pointer dereference, address: 0000000000000000
> [   78.479166] #PF: supervisor write access in kernel mode
> [   78.479671] #PF: error_code(0x0002) - not-present page
> [   78.480171] PGD 11557f0067 P4D 11557f0067 PUD 0
> [   78.480626] Oops: 0002 [#1] PREEMPT SMP
> [   78.481001] CPU: 0 PID: 73 Comm: kworker/0:1 Not tainted 6.1.0-rc3 #5
> [   78.481661] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.14.0-2 04/01/2014
> [   78.482471] Workqueue: kdelayd flush_expired_bios [dm_delay]
> [   78.483021] RIP: 0010:mempool_free+0x47/0x80
> [   78.483455] Code: 48 89 ef 5b 5d ff e0 f3 c3 48 89 f7 e8 32 45 3f 00 48 63 53 08 48 89 c6 3b 53 04 7d 2d 48 8b 43 10 8d 4a 01 48 89 df 89 4b 08 <48> 89 2c d0 e8 b0 45 3f 00 48 8d 7b 30 5b 5d 31 c9 ba 01 00 00 00
> [   78.485220] RSP: 0018:ffff88910036bda8 EFLAGS: 00010093
> [   78.485719] RAX: 0000000000000000 RBX: ffff8891037b65d8 RCX: 0000000000000001
> [   78.486404] RDX: 0000000000000000 RSI: 0000000000000202 RDI: ffff8891037b65d8
> [   78.487080] RBP: ffff8891447ba240 R08: 0000000000012908 R09: 00000000003d0900
> [   78.487764] R10: 0000000000000000 R11: 0000000000173544 R12: ffff889101a14000
> [   78.488451] R13: ffff8891562ac300 R14: ffff889102b41440 R15: ffffe8ffffa00d05
> [   78.489146] FS:  0000000000000000(0000) GS:ffff88942fa00000(0000) knlGS:0000000000000000
> [   78.489913] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [   78.490474] CR2: 0000000000000000 CR3: 0000001102e99000 CR4: 00000000000006b0
> [   78.491165] Call Trace:
> [   78.491429]  <TASK>
> [   78.491640]  clone_endio+0xf4/0x1c0 [dm_mod]
> [   78.492072]  clone_endio+0xf4/0x1c0 [dm_mod]

The clone_endio belongs to "clone" target_type.

> [   78.492505]  __submit_bio+0x76/0x120
> [   78.492859]  submit_bio_noacct_nocheck+0xb6/0x2a0
> [   78.493325]  flush_expired_bios+0x28/0x2f [dm_delay]

This is "delay" target_type. Could you shed light on how the two targets
connect with dm-raid? And I have shallow knowledge about dm ...

> [   78.493808]  process_one_work+0x1b4/0x300
> [   78.494211]  worker_thread+0x45/0x3e0
> [   78.494570]  ? rescuer_thread+0x380/0x380
> [   78.494957]  kthread+0xc2/0x100
> [   78.495279]  ? kthread_complete_and_exit+0x20/0x20
> [   78.495743]  ret_from_fork+0x1f/0x30
> [   78.496096]  </TASK>
> [   78.496326] Modules linked in: brd dm_delay dm_raid dm_mod af_packet uvesafb cfbfillrect cfbimgblt cn cfbcopyarea fb font fbdev tun autofs4 binfmt_misc configfs ipv6 virtio_rng virtio_balloon rng_core virtio_net pcspkr net_failover failover qemu_fw_cfg button mousedev raid10 raid456 libcrc32c async_raid6_recov async_memcpy async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod sd_mod t10_pi crc64_rocksoft crc64 virtio_scsi scsi_mod evdev psmouse bsg scsi_common [last unloaded: brd]
> [   78.500425] CR2: 0000000000000000
> [   78.500752] ---[ end trace 0000000000000000 ]---
> [   78.501214] RIP: 0010:mempool_free+0x47/0x80

BTW, is the mempool_free from endio -> dec_count -> complete_io?
And io which caused the crash is from dm_io -> async_io / sync_io
  -> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
suppose the io is for mirror image.

Thanks,
Guoqing
