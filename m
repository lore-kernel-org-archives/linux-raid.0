Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 34BA2EB64D9
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jul 2023 00:40:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229538AbjGKAkW (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 Jul 2023 20:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjGKAkU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 Jul 2023 20:40:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E511AC
        for <linux-raid@vger.kernel.org>; Mon, 10 Jul 2023 17:39:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689035974;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=o6HpwZnfr49cquFGvcuFiLt6/jJy1ahhoV//DTpoAHs=;
        b=UDZRsjDTroJV4Pt9lC+IHnGlZVdbAgefbu7R9AppILfiIRmdVjhBNDE6iVL8iRF4FDw1N+
        +TQ4X6Z27p0l5xnXuDIYXu8XyN730CFaWLlJsRiniYvrMN/hl1AqwouVA9r2MCAx5kj8ch
        0+NdJGPrMnFKr9lx3v4S+1H3yv4RbG8=
Received: from mail-pf1-f197.google.com (mail-pf1-f197.google.com
 [209.85.210.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-515-48iJi2zaMZS5rOwKAvUx0w-1; Mon, 10 Jul 2023 20:39:33 -0400
X-MC-Unique: 48iJi2zaMZS5rOwKAvUx0w-1
Received: by mail-pf1-f197.google.com with SMTP id d2e1a72fcca58-682a4f1253aso8532262b3a.0
        for <linux-raid@vger.kernel.org>; Mon, 10 Jul 2023 17:39:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689035972; x=1691627972;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from:subject
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=o6HpwZnfr49cquFGvcuFiLt6/jJy1ahhoV//DTpoAHs=;
        b=MsEWj9di06BgOEf03YfPPM31KCTzCZmxqSlZ26Mz16mIVxCqj+68YvltuFmPUHAv7m
         StlQFkP2pUF0q+4NoEpzUFaVnP5uszW51KbU198n//wbIG9YRoubVoQhb589jahobBA1
         8aPPUCrj99MZHQmVHbPcmnmV/C/eU6g/zD98tZ7Yx7jJl9pkD/CcVh375cz6PPDI+p1M
         3zApACndZjELIv3IuJOJENoN5ZOC3kJVVG6ubAVd6ycOLQuTvcgtmmMyJlwnr8pEpOr7
         ctmMx5mxiOw2C7eRr8Jqp/5486USxRwAnMxTjqx/3nxd5oczVV1O2Hjp9HpX6VP87MYA
         u0fA==
X-Gm-Message-State: ABy/qLaeS6CPVEnISxSWzYFYKPMhmXODOEkuSbQedNZvQL53a3GTPc07
        +N1mxJ2IyC8pVJZMOEIxdazK49SI+ca7kMosAju7Mosp2CKW++Vppzv2nE2ryiIT0Lp+ClVU5RR
        7zNZb1BLF/Syg8is8LtXjIQ==
X-Received: by 2002:a05:6a20:7294:b0:12c:1183:edb9 with SMTP id o20-20020a056a20729400b0012c1183edb9mr20522816pzk.3.1689035972443;
        Mon, 10 Jul 2023 17:39:32 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHr3KlTX9TeFnhToT2iCdd6B04WLLt+2XWLU6h2d230zcbyvTJpL8qbB/mGYSI2SCjaWmonzg==
X-Received: by 2002:a05:6a20:7294:b0:12c:1183:edb9 with SMTP id o20-20020a056a20729400b0012c1183edb9mr20522802pzk.3.1689035972106;
        Mon, 10 Jul 2023 17:39:32 -0700 (PDT)
Received: from [10.72.12.51] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id x22-20020aa793b6000000b006826c9e4397sm390986pff.48.2023.07.10.17.39.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Jul 2023 17:39:31 -0700 (PDT)
Message-ID: <1ad13b8c-7601-bbee-3197-cdfcd87173d6@redhat.com>
Date:   Tue, 11 Jul 2023 08:39:27 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: The read data is wrong from raid5 when recovery happens
From:   Xiao Ni <xni@redhat.com>
To:     Song Liu <song@kernel.org>
Cc:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        "Tkaczyk, Mariusz" <mariusz.tkaczyk@intel.com>,
        linux-raid <linux-raid@vger.kernel.org>,
        Heinz Mauelshagen <heinzm@redhat.com>,
        Nigel Croxon <ncroxon@redhat.com>
References: <CALTww28aV5CGXQAu46Rkc=fG1jK=ARzCT8VGoVyje8kQdqEXMg@mail.gmail.com>
 <ebe7fa31-2e9a-74da-bbbd-3d5238590a7c@linux.dev>
 <CALTww2_ks+Ac0hHkVS0mBaKi_E2r=Jq-7g2iubtCcKoVsZEbXQ@mail.gmail.com>
 <7e9fd8ba-aacd-3697-15fe-dc0b292bd177@linux.dev>
 <CALTww297Q+FAFMVBQd-1dT7neYrMjC-UZnAw8Q3UeuEoOCy6Yg@mail.gmail.com>
 <20230526111312.000065f2@linux.intel.com>
 <CAPhsuW4XKYDsEJsbJJX7mDdq_hhF1D8YLN5oyBi746EUtYVv8A@mail.gmail.com>
 <CALTww29YU+ZtbJanzB0buFfofDMv2C68EL2C_Ocr375amCAh+w@mail.gmail.com>
In-Reply-To: <CALTww29YU+ZtbJanzB0buFfofDMv2C68EL2C_Ocr375amCAh+w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


在 2023/5/27 上午8:56, Xiao Ni 写道:
> Hi all
>
> The attachment is the scripts.
>
> 1. It needs to modify the member disks and raid name in prepare_rebuild_env.sh
> 2. It needs to modify the member disks and raid name in 01-test.sh
> 3. Then run 01-test.sh directly
>

Hi all

I have tried with a work around patch and can confirm this problem can't 
be reproduced again with this patch.

diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
index 4cdb35e54251..96d7f8048876 100644
--- a/drivers/md/raid5.c
+++ b/drivers/md/raid5.c
@@ -6190,7 +6190,8 @@ static bool raid5_make_request(struct mddev 
*mddev, struct bio * bi)
                         md_write_end(mddev);
                 return true;
         }
-       md_account_bio(mddev, &bi);
+       if (rw == WRITE)
+               md_account_bio(mddev, &bi);

         /*
          * Lets start with the stripe with the lowest chunk offset in 
the first


This patch only disables the accounting for non-align read requests. I 
know it's not a good one. But the data corruption is more

serious than io accouting.

Regards

Xiao

