Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F9F9C433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Jul 2022 16:35:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230054AbiGTQf4 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Jul 2022 12:35:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35946 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231152AbiGTQfw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Jul 2022 12:35:52 -0400
Received: from mail.esperi.org.uk (icebox.esperi.org.uk [81.187.191.129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 733D3E01C
        for <linux-raid@vger.kernel.org>; Wed, 20 Jul 2022 09:35:51 -0700 (PDT)
Received: from loom (nix@sidle.srvr.nix [192.168.14.8])
        by mail.esperi.org.uk (8.16.1/8.16.1) with ESMTPS id 26KGZmkU018864
        (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NO);
        Wed, 20 Jul 2022 17:35:48 +0100
From:   Nix <nix@esperi.org.uk>
To:     Guoqing Jiang <guoqing.jiang@linux.dev>
Cc:     linux-raid@vger.kernel.org
Subject: Re: 5.18: likely useless very preliminary bug report: mdadm raid-6
 boot-time assembly failure
References: <87o7xmsjcv.fsf@esperi.org.uk>
        <fed30ed9-68e3-ce8b-ec27-45c48cf6a7a1@linux.dev>
Emacs:  or perhaps you'd prefer Russian Roulette, after all?
Date:   Wed, 20 Jul 2022 17:35:48 +0100
In-Reply-To: <fed30ed9-68e3-ce8b-ec27-45c48cf6a7a1@linux.dev> (Guoqing Jiang's
        message of "Tue, 19 Jul 2022 15:00:42 +0800")
Message-ID: <8735evpwrf.fsf@esperi.org.uk>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-DCC--Metrics: loom 1480; Body=2 Fuz1=2 Fuz2=2
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 19 Jul 2022, Guoqing Jiang spake thusly:

> On 7/18/22 8:20 PM, Nix wrote:
>> So I have a pair of RAID-6 mdraid arrays on this machine (one of which
>> has a bcache layered on top of it, with an LVM VG stretched across
>> both). Kernel 5.16 + mdadm 4.0 (I know, it's old) works fine, but I just
>> rebooted into 5.18.12 and it failed to assemble. mdadm didn't display
>> anything useful: an mdadm --assemble --scan --auto=md --freeze-reshape
>> simply didn't find anything to assemble, and after that nothing else was
>> going to work. But rebooting into 5.16 worked fine, so everything was
>> (thank goodness) actually still there.
>>
>> Alas I can't say what the state of the blockdevs was (other than that
>> they all seemed to be in /dev, and I'm using DEVICE partitions so they
>> should all have been spotte
>
> I suppose the array was built on top of partitions, then my wild guess is
> the problem is caused by the change in block layer (1ebe2e5f9d68?),
> maybe we need something similar in loop driver per b9684a71.
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index c7ecb0bffda0..e5f2e55cb86a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -5700,6 +5700,7 @@ static int md_alloc(dev_t dev, char *name)
>         mddev->queue = disk->queue;
>         blk_set_stacking_limits(&mddev->queue->limits);
>         blk_queue_write_cache(mddev->queue, true, true);
> +       set_bit(GD_SUPPRESS_PART_SCAN, &disk->state);
>         disk->events |= DISK_EVENT_MEDIA_CHANGE;
>         mddev->gendisk = disk;
>         error = add_disk(disk);

I'll give it a try. But... the arrays, fully assembled:

Personalities : [raid0] [raid6] [raid5] [raid4] 
md125 : active raid6 sda3[0] sdf3[5] sdd3[4] sdc3[2] sdb3[1]
      15391689216 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
      
md126 : active raid6 sda4[0] sdf4[5] sdd4[4] sdc4[2] sdb4[1]
      7260020736 blocks super 1.2 level 6, 512k chunk, algorithm 2 [5/5] [UUUUU]
      bitmap: 0/2 pages [0KB], 1048576KB chunk

md127 : active raid0 sda2[0] sdf2[5] sdd2[3] sdc2[2] sdb2[1]
      1310064640 blocks super 1.2 512k chunks
      
unused devices: <none>

so they are on top of partitions. I'm not sure suppressing a partition
scan will help... but maybe I misunderstand.

-- 
NULL && (void)
