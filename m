Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BB89C00140
	for <linux-raid@archiver.kernel.org>; Wed, 10 Aug 2022 18:16:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231665AbiHJSQ4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 10 Aug 2022 14:16:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiHJSQx (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 10 Aug 2022 14:16:53 -0400
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A3647823A
        for <linux-raid@vger.kernel.org>; Wed, 10 Aug 2022 11:16:52 -0700 (PDT)
Received: by mail-pf1-f176.google.com with SMTP id f28so14433919pfk.1
        for <linux-raid@vger.kernel.org>; Wed, 10 Aug 2022 11:16:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc;
        bh=5FjMNstts3WSqj0/yQIReMHMJ8Z+MoVNbN67hTtQVY4=;
        b=PQxFpgb4vIS2xd1oUAmq+cw9kkC219GH34T1MyjHTUqtBeMDnED2DJS9nNolxMmDJb
         UgqAXw6XYiFLNbNd3gyvT+paEYT7p1YDSZNawZUxgynoOc2SxuDLpwqx01oeId24lu3f
         v6SY43xQgUKpkUBdTyJYQi0zQT7Q5ZYfgwc5Il9Z1s/Wtj9LyWHH77fRrW+XdywCwjPU
         PUpMEOEq+/be7ldYqADQNkC4cmMo1gO3g9bO0vlWYrjZw2dMRJbrxmVLTKEoZgGk4LHY
         XQYZ7Ly6f5A5WYhA6OtlKk1q6iUZjNbi+U61390ACtO91/EFkWXbM5dg/P1/AVJ1JcA1
         Wm6w==
X-Gm-Message-State: ACgBeo3IKvlyGC7OWU8WoYNRWeKsWkp7pNPRNZdnvjDK/A+JScr2xKCn
        zxS6fADoe1CzmMujxDbJOiHaSjr8et4=
X-Google-Smtp-Source: AA6agR6AqizS62/7CrQJnGm2b7wUutWwUERuujKuAugevgcEmBolnZeHjZBXG6wuEl74LxbtY7zSzw==
X-Received: by 2002:a63:8648:0:b0:41d:259:754 with SMTP id x69-20020a638648000000b0041d02590754mr20847405pgd.422.1660155411898;
        Wed, 10 Aug 2022 11:16:51 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:85c9:163f:8564:e41f? ([2620:15c:211:201:85c9:163f:8564:e41f])
        by smtp.gmail.com with ESMTPSA id i25-20020a635419000000b0041c89bba5a8sm9968843pgb.25.2022.08.10.11.16.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 10 Aug 2022 11:16:51 -0700 (PDT)
Message-ID: <8d1bb00a-32e6-9a8e-49b5-71fecd066e90@acm.org>
Date:   Wed, 10 Aug 2022 11:16:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH] md/raid10: Fix a recently introduced sparse warning
Content-Language: en-US
To:     Paul Menzel <pmenzel@molgen.mpg.de>
Cc:     Song Liu <song@kernel.org>, linux-raid@vger.kernel.org,
        Rong A Chen <rong.a.chen@intel.com>,
        Jens Axboe <axboe@kernel.dk>, kernel test robot <lkp@intel.com>
References: <20220809181358.3111654-1-bvanassche@acm.org>
 <82583f41-31a2-0aa5-76e6-530218e3f593@molgen.mpg.de>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <82583f41-31a2-0aa5-76e6-530218e3f593@molgen.mpg.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 8/9/22 23:04, Paul Menzel wrote:
> Thank you for the patch. I’d prefer the commit message summary to be 
> specific about the change, as there are several sparse warnings. Maybe:
> 
>> Update r10_sync_page_io() to take req_op over int
> 
> Otherwise, this looks good to me.

Hi Paul,

Thanks for having taken a look. I will make the patch subject more 
specific and repost this patch.

Bart.
