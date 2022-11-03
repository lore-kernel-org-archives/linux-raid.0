Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 38DEFC433FE
	for <linux-raid@archiver.kernel.org>; Thu,  3 Nov 2022 07:29:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230320AbiKCH3I (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 3 Nov 2022 03:29:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiKCH3F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 3 Nov 2022 03:29:05 -0400
Received: from out2.migadu.com (out2.migadu.com [IPv6:2001:41d0:2:aacc::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28E85F20
        for <linux-raid@vger.kernel.org>; Thu,  3 Nov 2022 00:29:00 -0700 (PDT)
Subject: Re: A crash caused by the commit
 0dd84b319352bb8ba64752d4e45396d8b13e6018
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1667460539;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=tNtYgFp1n3m3WLZXm8byzgyXJ+1sDyl5a2XeleXHEFY=;
        b=VhNouYBSpjkcRuVxWSok69lo/TCr6Gff8+afOC3EetAmGvPdYljd4bYfItYRglp2ouRFfH
        GSGTKQM+JP2DEVHMz4woo0DNFIDke7tL9VWlZZ8I5TdOqSIeAsL0SH5EpyWobAiswFyt3M
        yV2pLAi8oJQwwOi8wme+uHEfybYXIT4=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
To:     Mikulas Patocka <mpatocka@redhat.com>, Song Liu <song@kernel.org>
Cc:     Zdenek Kabelac <zkabelac@redhat.com>, linux-raid@vger.kernel.org,
        dm-devel@redhat.com
References: <alpine.LRH.2.21.2211021214390.25745@file01.intranet.prod.int.rdu2.redhat.com>
 <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
Message-ID: <ba8e67d8-b18b-13ba-2883-6ca6c6520ef2@linux.dev>
Date:   Thu, 3 Nov 2022 15:28:55 +0800
MIME-Version: 1.0
In-Reply-To: <78646e88-2457-81e1-e3e7-cf66b67ba923@linux.dev>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/3/22 11:47 AM, Guoqing Jiang wrote:
>> [   78.491429] <TASK>
>> [   78.491640]  clone_endio+0xf4/0x1c0 [dm_mod]
>> [   78.492072]  clone_endio+0xf4/0x1c0 [dm_mod]
>
> The clone_endio belongs to "clone" target_type.

Hmm, could be the "clone_endio" from dm.c instead of dm-clone-target.c.

>
>> [   78.492505] __submit_bio+0x76/0x120
>> [   78.492859]  submit_bio_noacct_nocheck+0xb6/0x2a0
>> [   78.493325]  flush_expired_bios+0x28/0x2f [dm_delay]
>
> This is "delay" target_type. Could you shed light on how the two targets
> connect with dm-raid? And I have shallow knowledge about dm ...
>
>> [   78.493808] process_one_work+0x1b4/0x300
>> [   78.494211]  worker_thread+0x45/0x3e0
>> [   78.494570]  ? rescuer_thread+0x380/0x380
>> [   78.494957]  kthread+0xc2/0x100
>> [   78.495279]  ? kthread_complete_and_exit+0x20/0x20
>> [   78.495743]  ret_from_fork+0x1f/0x30
>> [   78.496096]  </TASK>
>> [   78.496326] Modules linked in: brd dm_delay dm_raid dm_mod 
>> af_packet uvesafb cfbfillrect cfbimgblt cn cfbcopyarea fb font fbdev 
>> tun autofs4 binfmt_misc configfs ipv6 virtio_rng virtio_balloon 
>> rng_core virtio_net pcspkr net_failover failover qemu_fw_cfg button 
>> mousedev raid10 raid456 libcrc32c async_raid6_recov async_memcpy 
>> async_pq raid6_pq async_xor xor async_tx raid1 raid0 md_mod sd_mod 
>> t10_pi crc64_rocksoft crc64 virtio_scsi scsi_mod evdev psmouse bsg 
>> scsi_common [last unloaded: brd]
>> [   78.500425] CR2: 0000000000000000
>> [   78.500752] ---[ end trace 0000000000000000 ]---
>> [   78.501214] RIP: 0010:mempool_free+0x47/0x80
>
> BTW, is the mempool_free from endio -> dec_count -> complete_io?

I guess it is "mempool_free(io, &io->client->pool)", and the pool is 
freed by
dm_io_client_destroy, and seems dm-raid is not responsible for either create
pool or destroy pool.

> And io which caused the crash is from dm_io -> async_io / sync_io
>  -> dispatch_io, seems dm-raid1 can call it instead of dm-raid, so I
> suppose the io is for mirror image. 

The io should be from another path (dm_submit_bio -> 
dm_split_and_process_bio
-> __split_and_process_bio -> __map_bio which sets "bi_end_io = 
clone_endio").

My guess is, there is racy condition between "lvchange --rebuild" and 
raid_dtr since
it was reproduced by running cmd in loop.

Anyway, we can revert the mentioned commit and go back to Neil's 
solution [1],
but I'd like to reproduce it and learn DM a bit.

[1]. 
https://lore.kernel.org/linux-raid/a6657e08-b6a7-358b-2d2a-0ac37d49d23a@linux.dev/T/#m95ac225cab7409f66c295772483d091084a6d470

Thanks,
Guoqing
