Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 83EB3C433EF
	for <linux-raid@archiver.kernel.org>; Wed,  2 Feb 2022 12:50:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344217AbiBBMuv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 2 Feb 2022 07:50:51 -0500
Received: from srv.fail ([135.181.244.181]:45854 "EHLO srv.fail"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230258AbiBBMut (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 2 Feb 2022 07:50:49 -0500
Received: from localhost (localhost [127.0.0.1])
        by srv.fail (Postfix) with ESMTP id 46B20152FB25;
        Wed,  2 Feb 2022 13:50:47 +0100 (CET)
X-Virus-Scanned: Debian amavisd-new at srv.fail
Received: from srv.fail ([127.0.0.1])
        by localhost (srv.fail [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id gqXOeAAdx2BJ; Wed,  2 Feb 2022 13:50:46 +0100 (CET)
Received: from [IPV6:2a02:908:1086:27c0::84a] (unknown [IPv6:2a02:908:1086:27c0::84a])
        by srv.fail (Postfix) with ESMTPSA id EA842152FB11;
        Wed,  2 Feb 2022 13:50:45 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=totally.rip;
        s=default; t=1643806246;
        bh=G0Gm9WTD7qZFEMgWdz0VvWzBwyynwfp3DOHjywlFPvA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=Ri60UpRbef51INlYb2ZkqIqlZzRbRc/eqCQZ7xNWlTuhAcxoboDcE9LTQdnyM2um6
         os+Y/oCVjXBY1Qa3voKPaMmPOMcOVVe0CqYWkEhjALL7IjbNvtWC9ajEC1UBbyO3CK
         NCGKE4YsI9vuvEZyPwoB103ENICVIF1ytMzrql/4Q7waLUIpp9z1KtcNJtoZ81BsN0
         aFuwJLOn91bw4MMF4yiLhpST+AcmFVWn47KxCn/a/gZKBvr7OSeoeG561G1pOrS3Cx
         H212UpD1snUFVaAo2nbqYrQ5fQRRqzVlBcn93K8gNYKdveMx9v0Mv/3U2NrJ5gzC/4
         NWZ+2qSJmpMrw==
Message-ID: <858fc88b-40fe-5bb4-e9be-e8b5f66ff562@totally.rip>
Date:   Wed, 2 Feb 2022 13:50:44 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: NULL pointer dereference in blk_queue_flag_set
Content-Language: en-US
To:     Song Liu <song@kernel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <a673c90f-d9eb-c6d5-b675-e6c2e1c04e5f@totally.rip>
 <CAPhsuW5H1uROu868FhS5MNXuP=nS_=6b8zUrFv4jBjPEA=joPQ@mail.gmail.com>
From:   jkhsjdhjs <jkhsjdhjs@totally.rip>
In-Reply-To: <CAPhsuW5H1uROu868FhS5MNXuP=nS_=6b8zUrFv4jBjPEA=joPQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hey Song,

thanks for the quick reply! I applied your patch on top of 5.17-rc2 and 
it fixes the issue:

[   15.394670] device-mapper: raid: Loading target version 1.15.1
[   15.395216] device-mapper: raid: Ignoring chunk size parameter for RAID 1
[   15.395224] device-mapper: raid: Choosing default region size of 4MiB
[   15.399865] md/raid1:mdX: active with 2 out of 2 mirrors

Best Regards,

Leon

On 02.02.22 07:57, Song Liu wrote:
> Hi Leon,
>
> On Tue, Feb 1, 2022 at 2:15 PM jkhsjdhjs <jkhsjdhjs@totally.rip> wrote:
>> Dear Song Liu,
>>
>> my kernel (5.17-rc2) experiences a NULL pointer dereference when
>> activating an LDM (Windows Logical Disk Manager) on Arch Linux using
>> ldmtool [1]. I have attached the relevant excerpt of dmesg. This bug
>> causes my LDM RAID to fail activating (see ldmtool-status.txt and
>> lsblk.txt). Since this worked fine with 5.16 I bisected the kernel and
>> found, that commit f51d46d0e7cb5b8494aa534d276a9d8915a2443d [2]
>> introduced the issue.
>>
>> I'm not sure what else to add, if there's more information I can
>> provide, please tell me. Otherwise I'll happily assist in fixing this
>> issue - if there's something I can do.
> Thanks for the report! And sorry for the bug.
>
> For the next step, could you please test whether the following change
> fixes the issue?
>
> Best,
> Song
>
> diff --git i/drivers/md/md.c w/drivers/md/md.c
> index 854cbf4234aa..18e987c644c6 100644
> --- i/drivers/md/md.c
> +++ w/drivers/md/md.c
> @@ -5868,10 +5868,6 @@ int md_run(struct mddev *mddev)
>                  nowait = nowait && blk_queue_nowait(bdev_get_queue(rdev->bdev));
>          }
>
> -       /* Set the NOWAIT flags if all underlying devices support it */
> -       if (nowait)
> -               blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
> -
>          if (!bioset_initialized(&mddev->bio_set)) {
>                  err = bioset_init(&mddev->bio_set, BIO_POOL_SIZE, 0,
> BIOSET_NEED_BVECS);
>                  if (err)
> @@ -6009,6 +6005,10 @@ int md_run(struct mddev *mddev)
>                  else
>                          blk_queue_flag_clear(QUEUE_FLAG_NONROT, mddev->queue);
>                  blk_queue_flag_set(QUEUE_FLAG_IO_STAT, mddev->queue);
> +
> +               /* Set the NOWAIT flags if all underlying devices support it */
> +               if (nowait)
> +                       blk_queue_flag_set(QUEUE_FLAG_NOWAIT, mddev->queue);
>          }
>          if (pers->sync_request) {
>                  if (mddev->kobj.sd &&
