Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DD78C4707F
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 06:34:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 741BE613C5
	for <linux-raid@archiver.kernel.org>; Thu, 27 May 2021 06:34:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230107AbhE0Gfd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 27 May 2021 02:35:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbhE0Gfc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 27 May 2021 02:35:32 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87780C061574
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 23:33:59 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id e15so1847804plh.1
        for <linux-raid@vger.kernel.org>; Wed, 26 May 2021 23:33:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=e8/vFfLfH4Qgh2lZVcsx+obx3d0UepHz34RmQg3nNJY=;
        b=JrHQmNPZKofZQgRFmOAE11zy3KP2VgoAgY2hT9oJfKyp185AWhsAD0JR7Fmg6GhrHs
         0TUnWlUEjrnfx1c8H8gAGxbOsApW3rPL0S6zSDCGTmoR9aOBNBTLvm/tt6ETWvbcSCzK
         xtki45ZUDLEewel+fmPodkvPbjflzkOujYkup90rsLrqcWoQjIJ8DjYwIOANMQSB8ESl
         SgBTEXuWHsFUPvdad+rMD10pW1Wc8C4T1P4shYxM+K8+61vPCWP4XM3ZCj+WsiqCkCmM
         yoF1WpuEr8d1c1jUBMnnNCRtGj7GaE4nBjqhGo7HYt4tXq5g29Eti1l1ctK1m+J099+c
         F0fA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=e8/vFfLfH4Qgh2lZVcsx+obx3d0UepHz34RmQg3nNJY=;
        b=YieM2d+dZ9V7OUQKHGpOnszj5xR1vk9zRV6dQxSpAKEBEW3v4cRUimHnEGYCbxFG90
         HPbCjYc+gLyFHHsjDogkXRwEnsux3NZSsHwRYScYafHgCQ2Npl3ueMCM+25MYC3yHcBC
         Fj8mlJdDW8nMer94KqzPEwnqFsSXL3sTGhdi+123kH+nF0X254DzDsPATlrOYp/xVUfT
         DwCRbLmlGbveOkg7cd/Y7/mHujbwNe8HpJn90l4al+OpcG0QIWouSOlAE4U2HQG6lpCY
         9ewn0JPjXeWJI4OKTPB+DvOjxReYcajhTX5/TyxjFd1hnao8RgC1UHNbP5KWZHk406V1
         /jdQ==
X-Gm-Message-State: AOAM530/7k+UXHXvk9Pt4FeGljN7YN22I60KNZb3nrLgJFnxDL8h0Yw8
        SBdkuuvLdPq95E7pdsVCIoE/x71wSDZUG/n/
X-Google-Smtp-Source: ABdhPJxL5DVYSp+rrk9bY16QzPMUj+zXMbF5eYRanxe9GtWDQay8TLLB0/QWe8H6vIuaW08nqWwiOQ==
X-Received: by 2002:a17:902:9685:b029:ef:70fd:a5a2 with SMTP id n5-20020a1709029685b02900ef70fda5a2mr1828898plp.20.1622097239086;
        Wed, 26 May 2021 23:33:59 -0700 (PDT)
Received: from [10.6.1.131] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id 136sm953901pfu.195.2021.05.26.23.33.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 26 May 2021 23:33:58 -0700 (PDT)
Subject: Re: [PATCH V3 2/8] md: add io accounting for raid0 and raid5
To:     Song Liu <song@kernel.org>, Guoqing Jiang <jgq516@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>
References: <20210525094623.763195-1-jiangguoqing@kylinos.cn>
 <20210525094623.763195-3-jiangguoqing@kylinos.cn>
 <CAPhsuW6WyvFtvJVw1q5tpx9C9wWMh8YDEd8v+xdY=P4yLiKELA@mail.gmail.com>
 <a2342aab-28da-64a2-9591-bc7b482e1751@gmail.com>
 <CAPhsuW7Xz6nOPFsn64qLhvDtNGDGX6Pf_U3Tb=d0KiL4+9_h=Q@mail.gmail.com>
 <20118145-e993-b11f-8907-5e2f1cc44ddb@gmail.com>
 <CAPhsuW7hj1pRN8tPLPMr0YGaMG0z5-EKztqoph7sALrW4c+4bA@mail.gmail.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <4fb81639-2f1b-9acd-4d81-37d9817fd89b@gmail.com>
Date:   Thu, 27 May 2021 14:33:44 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7hj1pRN8tPLPMr0YGaMG0z5-EKztqoph7sALrW4c+4bA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Song,

On 5/27/21 2:14 PM, Song Liu wrote:
>> Could you point the place where md enables iostats before the set?
>> I can't find relevant code for it.
> Before this set, we did not set QUEUE_FLAG_IO_STAT, and we didn't
> check blk_queue_io_stat() either. So even with /sys/block/mdX/queue/iostats
> of 0, we still get iostats for the md device. By setting QUEUE_FLAG_IO_STAT
> with the patch, the users still get iostats working by default.

I am okay with enable it by default,  though users need to know the
parameter given it affects the performance.

Thanks,
Guoqing
