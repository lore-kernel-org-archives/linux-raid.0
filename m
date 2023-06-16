Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18DB3EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 09:13:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245164AbjFPJNs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 05:13:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245666AbjFPJNb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 05:13:31 -0400
Received: from mail-ej1-x62f.google.com (mail-ej1-x62f.google.com [IPv6:2a00:1450:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C12430E2
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 02:13:21 -0700 (PDT)
Received: by mail-ej1-x62f.google.com with SMTP id a640c23a62f3a-985fd30ef48so69415566b.2
        for <linux-raid@vger.kernel.org>; Fri, 16 Jun 2023 02:13:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686906800; x=1689498800;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4lI9Q0p9lb9kIVP732kfndCKbRKSGggwajJ8v/Gf9WA=;
        b=GpsJCPocE2DMml9izND4u/JU9uSXbQy5dHkyUUWi8ZKnFUYi54BL3qmJzbI8SK1g4I
         /lSNlDz6MqxzQVjPq7/WzC5APvQoOq7sGdANTOnORb7ybUL0dBuzwMgvnk2QEtKGooH+
         ziNaO6rmwDwtNwDRnemSo1Me7vkUIH+mO/AhYFHFZJqX1q3m4mWQ3/dedw6gyMO5uqVN
         L0oW+6TLVm59XiYP0TxpTdreYh9zS4oAmiqxGcPNlXz4BVOM4E++zpl06xolrSreAle3
         74hVcXlmYvewiDyvP7v5+MM4ocmB1d2zTfsgSPpxu4AVPBnp93Rm+6/qeuZu4r/E3tmp
         Ur1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686906800; x=1689498800;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4lI9Q0p9lb9kIVP732kfndCKbRKSGggwajJ8v/Gf9WA=;
        b=Cru8L5dBet55G7mFNa/Pq00bQKvkIds675alSXTM2c4A0DyLU0sYi40+Nb/lMwvoTb
         OQsHCLWL0o68Uf2Xz/XRy2fjHX7zOLMP+Rgc54njUmW7okK1effceSlc0QQydLIA0g9G
         2lDLkwxB/bNYB3YLoyNXVt9GYPctgdX55paxjNi7m4KLRsKtzAmkVeXO9G8q0M0HxdKK
         Dnyc5EjpHBCFVqBvz0DLmdFi65nGXi/rD67lFdowfi8HmTpilR4oa7o9pgcQ6NaUrhJK
         7lUFMzSTos4iofd3G6GWY5zkUIMttJpejDkLB4YB5etzGVj9DJ55BVaPwBTygG3oWaKZ
         F/iA==
X-Gm-Message-State: AC+VfDwGGmCuut7bStt46Ov8rTg/XvQw1SyLfvnAvZcwUOZmkywlnYUO
        FZJuI9hKytXgYTJue7EZMyE=
X-Google-Smtp-Source: ACHHUZ4h4Ri0BF7W/aE24rC9hUyGQPVQQYPvk3uNqL+l2LZ5ZZ1k8f3WX0qC2XVmnoSn71VFgXQO2w==
X-Received: by 2002:a17:906:354e:b0:94a:5819:5a2b with SMTP id s14-20020a170906354e00b0094a58195a2bmr1203908eja.33.1686906799739;
        Fri, 16 Jun 2023 02:13:19 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id k9-20020a170906128900b00965ffb8407asm10425873ejb.87.2023.06.16.02.13.17
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Fri, 16 Jun 2023 02:13:19 -0700 (PDT)
Date:   Fri, 16 Jun 2023 12:22:33 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        song@kernel.org, "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231606122233@laper.mirepesht>
In-Reply-To: <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
References: <20231506112411@laper.mirepesht>
 <82d2e7c4-1029-ec7b-a8c5-5a6deebfae31@huaweicloud.com>
 <CALTww28VaFnsBQhkbWMRvqQv6c9HyP-iSFPwG_tn2SqQVLB+7Q@mail.gmail.com>
 <20231606091224@laper.mirepesht> <20231606110134@laper.mirepesht>
 <8b288984-396a-6093-bd1f-266303a8d2b6@huaweicloud.com>
 <20231606115113@laper.mirepesht>
        <1117f940-6c7f-5505-f962-a06e3227ef24@huaweicloud.com>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


Yu Kuai <yukuai1@huaweicloud.com> wrote:
> > diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> > index 4fcfcb350d2b..52f0c24128ff 100644
> > --- a/drivers/md/raid10.c
> > +++ b/drivers/md/raid10.c
> > @@ -905,7 +905,7 @@ static void flush_pending_writes(struct r10conf *conf)
> >   		/* flush any pending bitmap writes to disk
> >   		 * before proceeding w/ I/O */
> >   		md_bitmap_unplug(conf->mddev->bitmap);
> > -		wake_up(&conf->wait_barrier);
> > +		wake_up_barrier(conf);
> >   
> >   		while (bio) { /* submit pending writes */
> >   			struct bio *next = bio->bi_next;
> 
> Thanks for the testing, sorry that I missed one place... Can you try to
> change wake_up() to wake_up_barrier() from raid10_unplug() and test
> again?

OK.  I replaced only the second occurrence of wake_up() in raid10_unplug().

> > Without the patch:
> > READ:  IOPS=2033k BW=8329MB/s
> > WRITE: IOPS= 871k BW=3569MB/s
> > 
> > With the patch:
> > READ:  IOPS=2027K BW=7920MiB/s
> > WRITE: IOPS= 869K BW=3394MiB/s

With the second patch:
READ:  IOPS=3642K BW=13900MiB/s
WRITE: IOPS=1561K BW= 6097MiB/s

That is impressive.  Great job.

I shall test it more.

Thanks,
Ali

