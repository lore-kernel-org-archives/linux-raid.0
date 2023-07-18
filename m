Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4256CEB64DC
	for <linux-raid@archiver.kernel.org>; Tue, 18 Jul 2023 13:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231252AbjGRNS6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbjGRNS5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 Jul 2023 09:18:57 -0400
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1F40E0
        for <linux-raid@vger.kernel.org>; Tue, 18 Jul 2023 06:18:53 -0700 (PDT)
Received: by mail-pl1-x643.google.com with SMTP id d9443c01a7336-1b89d47ffb6so32405165ad.2
        for <linux-raid@vger.kernel.org>; Tue, 18 Jul 2023 06:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=smartx-com.20221208.gappssmtp.com; s=20221208; t=1689686333; x=1690291133;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=QQvOlwKL/tiL/xL6JgTTEy1m9iPvauZZTG5CBeKEwKg=;
        b=4a0wGFR1ThtPdIBT679BKUZA/5j45fjndh3t1vBGedO5TaH7ZxViJ6Iu3Zf6zkxmuP
         veeu/8QQJLhSbt09Q5zBiTOI00dFpwtaXOYMF+UiFm05+B9aXJ8r68rR6aqFNEAp3hXC
         s833cB/vD5qT8+pA03uUuoJl0eIQqoozLO17CU4R3PWGlW+mUaWxrnmq2bCKXlOkoGln
         OPTX3WoMNuNB5QYzFtsdM006VS85FpjBlSdk2wp06E97W0efwNhsEJjDFNovdGeig8ez
         WhrAiLPvfT80IdrKDhciEqIkhlIeggDdoY9UnswRaDZnWFTHg+AlCvU25tF6hO7Rw76q
         uHoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689686333; x=1690291133;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QQvOlwKL/tiL/xL6JgTTEy1m9iPvauZZTG5CBeKEwKg=;
        b=GwCppqatWbmQGigU74PE8vPzKE4QqScH6fGSw51uE+Vpc6PFRQhQ48BoJ9qGtHX7Y+
         4mupBtWWy0fNhbXIhF9ywwniYLqv69yqSeiVPiTTvSEOUDcwLGnvPb78gDLtMTa34VZe
         EDiAQwlYBZqnz4G04IBK7sl8TTJ1yeScjh19Z/1vffL9IsZYjaizTjePx2+aMgRzxmfJ
         4mxyO/OWtEDRjgILnHZ1Z8c1corBf6GXcW+mbVoA+qyxIqGpZBX25Mvf0gISCAY8PzaZ
         0zDnzRe7OBsa08LLyO4ODhjdAUfh6fHE2uYCWkTjCfXtz0Sg/yWzjJT6P3i+0dmsRudC
         62GQ==
X-Gm-Message-State: ABy/qLbKWo01gCpYzjzvJdTxcTHiJ6uqh1+tarJNY/Cn9iHstixLTFtj
        gVBUfeMtk11JCFlWyNDQjWpRq5JlQVmqm5DGXaC9ORBKYEHizA==
X-Google-Smtp-Source: APBJJlF5BtB/G43ZxbT36/wHfwzMV1F/tz/VYfBePU3Sqx1WgFbqblc1uQiQ9Y5CEDC7Kd3VyYVxVA==
X-Received: by 2002:a17:902:c40f:b0:1b1:753a:49ce with SMTP id k15-20020a170902c40f00b001b1753a49cemr14958640plk.53.1689686333285;
        Tue, 18 Jul 2023 06:18:53 -0700 (PDT)
Received: from nixos ([47.75.78.161])
        by smtp.gmail.com with ESMTPSA id e10-20020a170902744a00b001b39ffff838sm1858286plt.25.2023.07.18.06.18.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Jul 2023 06:18:52 -0700 (PDT)
Date:   Tue, 18 Jul 2023 21:18:47 +0800
From:   Xueshi Hu <xueshi.hu@smartx.com>
To:     Yu Kuai <yukuai3@huawei.com>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
Subject: Re: [PATCH] md/raid1: freeze block layer queue during reshape
Message-ID: <3jk6stclszpvesgrznega34kax2gtt4ilqnyswm5qhew2i2mq7@gf5jz5tmyljs>
References: <vsag6vp4jokp2k5fkoqb5flklghpakxmglr75vpzgkmzejc47u@ih2255x374rp>
 <658e3fbc-d7bd-3fc9-b82e-0ecb86fd8c49@huawei.com>
 <bawtcsifeew7jtinckwxfrg7bach366uoccecfc5v56xmdhqsn@kj72oenu5j2w>
 <a366b0fc-3ddb-1a8f-9935-4f3ca8cf1013@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a366b0fc-3ddb-1a8f-9935-4f3ca8cf1013@huawei.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Jul 03, 2023 at 07:19:35PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2023/07/03 17:47, Xueshi Hu 写道:
> > On Mon, Jul 03, 2023 at 09:44:03AM +0800, Yu Kuai wrote:
> > > Hi,
> > > 
> > > 在 2023/07/02 18:04, Xueshi Hu 写道:
> > > > When a raid device is reshaped, in-flight bio may reference outdated
> > > > r1conf::raid_disks and r1bio::poolinfo. This can trigger a bug in
> > > > three possible paths:
> > > > 
> > > > 1. In function "raid1d". If a bio fails to submit, it will be resent to
> > > > raid1d for retrying the submission, which increases r1conf::nr_queued.
> > > > If the reshape happens, the in-flight bio cannot be freed normally as
> > > > the old mempool has been destroyed.
> > > > 2. In raid1_write_request. If one raw device is blocked, the kernel will
> > > > allow the barrier and wait for the raw device became ready, this makes
> > > > the raid reshape possible. Then, the local variable "disks" before the
> > > > label "retry_write" is outdated. Additionally, the kernel cannot reuse the
> > > > old r1bio.
> > > > 3. In raid_end_bio_io. The kernel must free the r1bio first and then
> > > > allow the barrier.
> > > > 
> > > > By freezing the queue, we can ensure that there are no in-flight bios
> > > > during reshape. This prevents bio from referencing the outdated
> > > > r1conf::raid_disks or r1bio::poolinfo.
> > > 
> > > I didn't look into the details of the problem you described, but even if
> > > the problem exist, freeze queue can't help at all, blk_mq_freeze_queue()
> > > for bio-based device can't guarantee that threre are no in-flight bios.
> > > 
> > > Thanks,
> > > Kuai
> > > > 
> > > > Signed-off-by: Xueshi Hu <xueshi.hu@smartx.com>
> > > > ---
> > > >    drivers/md/raid1.c | 3 +++
> > > >    1 file changed, 3 insertions(+)
> > > > 
> > > > diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> > > > index dd25832eb045..d8d6825d0af6 100644
> > > > --- a/drivers/md/raid1.c
> > > > +++ b/drivers/md/raid1.c
> > > > @@ -3247,6 +3247,7 @@ static int raid1_reshape(struct mddev *mddev)
> > > >    	unsigned long flags;
> > > >    	int d, d2;
> > > >    	int ret;
> > > > +	struct request_queue *q = mddev->queue;
> > > >    	memset(&newpool, 0, sizeof(newpool));
> > > >    	memset(&oldpool, 0, sizeof(oldpool));
> > > > @@ -3296,6 +3297,7 @@ static int raid1_reshape(struct mddev *mddev)
> > > >    		return -ENOMEM;
> > > >    	}
> > > > +	blk_mq_freeze_queue(q);
> > > >    	freeze_array(conf, 0);
> > > >    	/* ok, everything is stopped */
> > > > @@ -3333,6 +3335,7 @@ static int raid1_reshape(struct mddev *mddev)
> > > >    	md_wakeup_thread(mddev->thread);
> > > >    	mempool_exit(&oldpool);
> > > > +	blk_mq_unfreeze_queue(q);
> > > >    	return 0;
> > > >    }
> > > > 
> > 
> > Use this bash script, it's easy to trigger the bug
> > 1. Firstly, start fio to make requests on raid device
> > 2. Set one of the raw devices' state into "blocked"
> > 3. Reshape the raid device and "-blocked" the raw device
> > 
> > ```
> > parted -s /dev/sda -- mklabel gpt
> > parted /dev/sda -- mkpart primary 0G 1G
> > parted -s /dev/sdc -- mklabel gpt
> > parted /dev/sdc -- mkpart primary 0G 1G
> > 
> > yes | mdadm --create /dev/md10 --level=mirror \
> > 	--force --raid-devices=2 /dev/sda1 /dev/sdc1
> > mdadm --wait /dev/md10
> > 
> > nohup fio fio.job &
> > 
> > device_num=2
> > for ((i = 0; i <= 100000; i = i + 1)); do
> > 	sleep 1
> > 	echo "blocked" >/sys/devices/virtual/block/md10/md/dev-sda1/state
> > 	if [[ $((i % 2)) -eq 0 ]]; then
> > 		device_num=2
> > 	else
> > 		device_num=1800
> > 	fi
> > 	mdadm --grow --force --raid-devices=$device_num /dev/md10
> > 	sleep 1
> > 	echo "-blocked" >/sys/devices/virtual/block/md10/md/dev-sda1/state
> > done
> > ```
> > 
> > The configuration of fio, file fio.job
> > ```
> > [global]
> > ioengine=libaio
> > bs=4k
> > numjobs=1
> > iodepth=128
> > direct=1
> > rate=1M,1M
> > 
> > [md10]
> > time_based
> > runtime=-1
> > rw=randwrite
> > filename=/dev/md10
> > ```
> > 
> > kernel crashed when trying to free r1bio:
> > 
> > [  116.977805]  ? __die+0x23/0x70
> > [  116.977962]  ? page_fault_oops+0x181/0x470
> > [  116.978148]  ? exc_page_fault+0x71/0x180
> > [  116.978331]  ? asm_exc_page_fault+0x26/0x30
> > [  116.978523]  ? bio_put+0xe/0x130
> > [  116.978672]  raid_end_bio_io+0xa1/0xd0
> > [  116.978854]  raid1_end_write_request+0x111/0x350
> > [  116.979063]  blk_update_request+0x114/0x480
> > [  116.979253]  ? __ata_sff_port_intr+0x9c/0x160
> > [  116.979452]  scsi_end_request+0x27/0x1c0
> > [  116.979633]  scsi_io_completion+0x5a/0x6a0
> > [  116.979822]  blk_complete_reqs+0x3d/0x50
> > [  116.980000]  __do_softirq+0x113/0x3aa
> > [  116.980169]  irq_exit_rcu+0x8e/0xb0
> > [  116.980334]  common_interrupt+0x86/0xa0
> > [  116.980508]  </IRQ>
> > [  116.980606]  <TASK>
> > [  116.980704]  asm_common_interrupt+0x26/0x40
> > [  116.980897] RIP: 0010:default_idle+0xf/0x20
> 
> This looks like freeze_array() doen't work as expected.
> 
> > 
> > As far I know, when a request is allocated,
> > request_queue::q_usage_counter is increased. When the io finished, the
> > request_queue::q_usage_counter is decreased, use nvme driver as an
> > example:
> > 
> > nvme_complete_batch()
> > 	blk_mq_end_request_batch()
> > 		blk_mq_flush_tag_batch()
> > 			percpu_ref_put_many(&q->q_usage_counter, nr_tags);
> > 			
> > 
> > So, when blk_mq_freeze_queue() is returned successfully, every in-flight
> > io has returned from hardware, also new requests are blocked.
> 
> This only works for rq-based device, not bio-based device.
I get you point eventually, raid is bio-based device[^1], and it's io
path diverges from rq-based device at __submit_bio(), bio-based device
call the submit_bio() and put the refcount immediately, without waiting
for the in-flight io to come back.

Thank you for catching my mistake.

[^1]: https://lwn.net/Articles/736534/
> 
> Thanks,
> Kuai
> > 
> > Thanks,
> > Hu
> > 
> > .
> > 
Thanks,
Hu
