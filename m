Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A089AEB64DD
	for <linux-raid@archiver.kernel.org>; Mon,  3 Jul 2023 09:47:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230237AbjGCJrW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jul 2023 05:47:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbjGCJrV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 3 Jul 2023 05:47:21 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EAF7BE
        for <linux-raid@vger.kernel.org>; Mon,  3 Jul 2023 02:47:18 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-7653bd3ff2fso471616085a.3
        for <linux-raid@vger.kernel.org>; Mon, 03 Jul 2023 02:47:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1688377637; x=1690969637;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=VutbrjKoUGvpxn0WkSMPeVRQ73Eh+OB9BJjP4KUIoeY=;
        b=VpPpldhaf+Zp/QZOrQJslZgV9jvv4SDOzx9cZmnjGxCuM42xomGN14pELIAUPae7GR
         n3tJd1sIc4Tu3oJ1d5LgtYPCw+wYiOm5augWrYBQdBWYmZd0RQPKoTPEAMKS/REBvYJ+
         Whni/yS1YmS9FjqG1ebSt3QmFeWXwr5ZIpIDBJ5cR/ibDEa8G5Yv0JxqDY5WB8i+hp9u
         YGzuY1qU2mz251qt9a0oq4Fkz/rTNDfEfkZfsl6H5sMEObHgeBHC2kTT5a2/AiH8np6w
         ug5ktYTzyAvXaBad8wjOperg9j/o1WOqxIqRckLqKt1fdVAHcgySvRNnBWzpNKQiLaa8
         arPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688377637; x=1690969637;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VutbrjKoUGvpxn0WkSMPeVRQ73Eh+OB9BJjP4KUIoeY=;
        b=NbBTROkuxoqDx1a8OL241zT5HvgVHJkpg7L6cxH4l9Oq/R+5A/lI6lBv06YtcvkDP7
         jEH6jzVAKR8Q0mSyLNEB3sd2vps0kE+l04fqbt78i/pgT8nagvtvvA091QjssPOukJOs
         zZ5DlvSuVvlvsbXR0McNnyH94tnEi60SNeTeWnh++XLCTJWFd9h+YHnuznhf2Ms/xXcf
         +sskJpFij991L0ntBfzWcFXQ4DykAqdJzp8mjOvoUm65YBpr8EvgUQlBGXXwauIq9Cnc
         9QNcmqZffemLKmC8604qxga3hdfPWP22lu+P9xCf6Tg0BKFGnnPhMKn8iR4KBj6InxCA
         qxOA==
X-Gm-Message-State: ABy/qLZQGaUn6cu8uhClssdBAIBAgTSQZ2Y78FtmIWtFUYhSmLauwBAT
        8l66n5JE1OHioIBdbzgnJbH5ug==
X-Google-Smtp-Source: APBJJlEGTArZT6qemz8vpMQ+6iuy/GpdBO5MskxTTN9fVMp02Co88RBcKZUxHIFkW45SMItqxVbOfQ==
X-Received: by 2002:a05:620a:8c0c:b0:765:8b83:1a02 with SMTP id qz12-20020a05620a8c0c00b007658b831a02mr11089156qkn.51.1688377637538;
        Mon, 03 Jul 2023 02:47:17 -0700 (PDT)
Received: from nixos (61-221-155-12.hinet-ip.hinet.net. [61.221.155.12])
        by smtp.gmail.com with ESMTPSA id f4-20020a655504000000b0055af87fbb2fsm9567754pgr.27.2023.07.03.02.47.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Jul 2023 02:47:17 -0700 (PDT)
Date:   Mon, 3 Jul 2023 17:47:13 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] md/raid1: freeze block layer queue during reshape
Message-ID: <bawtcsifeew7jtinckwxfrg7bach366uoccecfc5v56xmdhqsn@kj72oenu5j2w>
References: <vsag6vp4jokp2k5fkoqb5flklghpakxmglr75vpzgkmzejc47u@ih2255x374rp>
 <658e3fbc-d7bd-3fc9-b82e-0ecb86fd8c49@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <658e3fbc-d7bd-3fc9-b82e-0ecb86fd8c49@huawei.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jul 03, 2023 at 09:44:03AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/02 18:04, Xueshi Hu 写道:
> > When a raid device is reshaped, in-flight bio may reference outdated
> > r1conf::raid_disks and r1bio::poolinfo. This can trigger a bug in
> > three possible paths:
> > 
> > 1. In function "raid1d". If a bio fails to submit, it will be resent to
> > raid1d for retrying the submission, which increases r1conf::nr_queued.
> > If the reshape happens, the in-flight bio cannot be freed normally as
> > the old mempool has been destroyed.
> > 2. In raid1_write_request. If one raw device is blocked, the kernel will
> > allow the barrier and wait for the raw device became ready, this makes
> > the raid reshape possible. Then, the local variable "disks" before the
> > label "retry_write" is outdated. Additionally, the kernel cannot reuse the
> > old r1bio.
> > 3. In raid_end_bio_io. The kernel must free the r1bio first and then
> > allow the barrier.
> > 
> > By freezing the queue, we can ensure that there are no in-flight bios
> > during reshape. This prevents bio from referencing the outdated
> > r1conf::raid_disks or r1bio::poolinfo.
> 
> I didn't look into the details of the problem you described, but even if
> the problem exist, freeze queue can't help at all, blk_mq_freeze_queue()
> for bio-based device can't guarantee that threre are no in-flight bios.
> 
> Thanks,
> Kuai
> > 
> > Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> > ---
> >   drivers/md/raid1.c | 3 +++
> >   1 file changed, 3 insertions(+)
> > 
> > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > index dd25832eb045..d8d6825d0af6 100644
> > --- a/drivers/md/raid1.c
> > +++ b/drivers/md/raid1.c
> > @@ -3247,6 +3247,7 @@ static int raid1_reshape(struct mddev *mddev)
> >   	unsigned long flags;
> >   	int d, d2;
> >   	int ret;
> > +	struct request_queue *q = mddev->queue;
> >   	memset(&newpool, 0, sizeof(newpool));
> >   	memset(&oldpool, 0, sizeof(oldpool));
> > @@ -3296,6 +3297,7 @@ static int raid1_reshape(struct mddev *mddev)
> >   		return -ENOMEM;
> >   	}
> > +	blk_mq_freeze_queue(q);
> >   	freeze_array(conf, 0);
> >   	/* ok, everything is stopped */
> > @@ -3333,6 +3335,7 @@ static int raid1_reshape(struct mddev *mddev)
> >   	md_wakeup_thread(mddev->thread);
> >   	mempool_exit(&oldpool);
> > +	blk_mq_unfreeze_queue(q);
> >   	return 0;
> >   }
> > 

Use this bash script, it's easy to trigger the bug
1. Firstly, start fio to make requests on raid device
2. Set one of the raw devices' state into "blocked"
3. Reshape the raid device and "-blocked" the raw device

```
parted -s /dev/sda -- mklabel gpt
parted /dev/sda -- mkpart primary 0G 1G
parted -s /dev/sdc -- mklabel gpt
parted /dev/sdc -- mkpart primary 0G 1G

yes | mdadm --create /dev/md10 --level=mirror \
	--force --raid-devices=2 /dev/sda1 /dev/sdc1
mdadm --wait /dev/md10

nohup fio fio.job &

device_num=2
for ((i = 0; i <= 100000; i = i + 1)); do
	sleep 1
	echo "blocked" >/sys/devices/virtual/block/md10/md/dev-sda1/state
	if [[ $((i % 2)) -eq 0 ]]; then
		device_num=2
	else
		device_num=1800
	fi
	mdadm --grow --force --raid-devices=$device_num /dev/md10
	sleep 1
	echo "-blocked" >/sys/devices/virtual/block/md10/md/dev-sda1/state
done
```

The configuration of fio, file fio.job
```
[global]
ioengine=libaio
bs=4k
numjobs=1
iodepth=128
direct=1
rate=1M,1M

[md10]
time_based
runtime=-1
rw=randwrite
filename=/dev/md10
```

kernel crashed when trying to free r1bio:

[  116.977805]  ? __die+0x23/0x70
[  116.977962]  ? page_fault_oops+0x181/0x470
[  116.978148]  ? exc_page_fault+0x71/0x180
[  116.978331]  ? asm_exc_page_fault+0x26/0x30
[  116.978523]  ? bio_put+0xe/0x130
[  116.978672]  raid_end_bio_io+0xa1/0xd0
[  116.978854]  raid1_end_write_request+0x111/0x350
[  116.979063]  blk_update_request+0x114/0x480
[  116.979253]  ? __ata_sff_port_intr+0x9c/0x160
[  116.979452]  scsi_end_request+0x27/0x1c0
[  116.979633]  scsi_io_completion+0x5a/0x6a0
[  116.979822]  blk_complete_reqs+0x3d/0x50
[  116.980000]  __do_softirq+0x113/0x3aa
[  116.980169]  irq_exit_rcu+0x8e/0xb0
[  116.980334]  common_interrupt+0x86/0xa0
[  116.980508]  </IRQ>
[  116.980606]  <TASK>
[  116.980704]  asm_common_interrupt+0x26/0x40
[  116.980897] RIP: 0010:default_idle+0xf/0x20

As far I know, when a request is allocated, 
request_queue::q_usage_counter is increased. When the io finished, the 
request_queue::q_usage_counter is decreased, use nvme driver as an
example:

nvme_complete_batch()
	blk_mq_end_request_batch()
		blk_mq_flush_tag_batch()
			percpu_ref_put_many(&q->q_usage_counter, nr_tags);
			

So, when blk_mq_freeze_queue() is returned successfully, every in-flight
io has returned from hardware, also new requests are blocked.

Thanks,
Hu
