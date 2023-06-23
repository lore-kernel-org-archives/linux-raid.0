Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E3CF5C001B0
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 13:13:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbjFWNM7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 09:12:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231629AbjFWNMy (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 09:12:54 -0400
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 551AB2694
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 06:12:52 -0700 (PDT)
Received: by mail-pl1-x62a.google.com with SMTP id d9443c01a7336-1b5079b8cb3so1370375ad.1
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 06:12:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1687525972; x=1690117972;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ztC9JD/gutKJP42tTw7xRzDnyP1Mlz22AqRtCxWHul4=;
        b=iReOyCzgXqjGHDqep4+7Y02y+2KsxvqbysTBx4QdxMakwFT9O9Z6y8UTRhYCpdiwGk
         ivfBmaLpXRLdsg2xXtWNoGf0LJW9OuaoWVHjbG5+PmrhjKOTehTkz5xr7u03dJPl3Vvf
         epR4VYk9iCpPZkMT+p54jmiUndhguXzeWsKZiPn3OwVHy+V1VU+7xSZ1lgncoZQcneJS
         pVLxKUfpwqKrHzPfUfH95joX35kksCvYI/qVSfPkEqAU61Mo8RwQARiYkcVaAbzt+5qk
         cYcyAi42FXf01kq9CxVaIQAWB9c34fULDSPKve/N0V/DkCTafLxv3dWbsj8Ke3WxSlSL
         ozRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687525972; x=1690117972;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ztC9JD/gutKJP42tTw7xRzDnyP1Mlz22AqRtCxWHul4=;
        b=jZplnJwYVPF54iiEx7pbQDJaOoNuF1HKN3n91USHGSU8dHVq2lkxaWEeGXf4pbjUIg
         kxRMk2SlsZnh7z5ii8ANMzDCpPtxdWyYW1b3D2kOO60tq6KstY+49Cqvlwuh/FyF2K+G
         GdntiL0WxlspOKjS6KIsDSnMUdfYMLTwgaj9Q3BOjE8A3t8JKtwF+bKuGga+3Xg6TrYM
         IjOfIk8Q9BV/sEKQNCpRG1VYksNAdFXv0VqGcT00W98Vk/KwhEwsRHqcjV5CBOj2iM2H
         xYgM+cFivzs1xXUw1bnqY2OFEichp5fqii2yoSoTbxQ3g0G9oiOwNXOmI18TDBEnSw9G
         krww==
X-Gm-Message-State: AC+VfDwl6zwsPLtflIP4GRecehzC3V9dBI4Z1ZOMsVdyKT3yDfuVbwYj
        qWQCcAn9QIH5d5df4a2bIQ2jWLDTHdInzu+FvhE=
X-Google-Smtp-Source: ACHHUZ78dOQlFEQQrAnXInKb8JKnRB3NkeUnqCzTvDvkAqdG76W+IPYWNvfD8Ue2cdvcaNnPedDi+w==
X-Received: by 2002:a17:902:dac6:b0:1ac:656f:a68d with SMTP id q6-20020a170902dac600b001ac656fa68dmr25602985plx.4.1687525971804;
        Fri, 23 Jun 2023 06:12:51 -0700 (PDT)
Received: from [10.4.168.167] ([139.177.225.254])
        by smtp.gmail.com with ESMTPSA id c15-20020a170903234f00b001b694130c05sm5473889plh.1.2023.06.23.06.12.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 06:12:51 -0700 (PDT)
Message-ID: <792beadd-7597-ec8c-e3b1-d8274d68d8c1@bytedance.com>
Date:   Fri, 23 Jun 2023 21:12:42 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.12.0
Subject: Re: [PATCH 29/29] mm: shrinker: move shrinker-related code into a
 separate file
Content-Language: en-US
To:     Vlastimil Babka <vbabka@suse.cz>, akpm@linux-foundation.org,
        david@fromorbit.com, tkhai@ya.ru, roman.gushchin@linux.dev,
        djwong@kernel.org, brauner@kernel.org, paulmck@kernel.org,
        tytso@mit.edu
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-arm-msm@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-nfs@vger.kernel.org, linux-xfs@vger.kernel.org,
        linux-btrfs@vger.kernel.org
References: <20230622085335.77010-1-zhengqi.arch@bytedance.com>
 <20230622085335.77010-30-zhengqi.arch@bytedance.com>
 <f90772f6-11fe-0d8a-7b1c-d630b884d775@suse.cz>
From:   Qi Zheng <zhengqi.arch@bytedance.com>
In-Reply-To: <f90772f6-11fe-0d8a-7b1c-d630b884d775@suse.cz>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Vlastimil,

On 2023/6/22 22:53, Vlastimil Babka wrote:
> On 6/22/23 10:53, Qi Zheng wrote:
>> The mm/vmscan.c file is too large, so separate the shrinker-related
>> code from it into a separate file. No functional changes.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> Maybe do this move as patch 01 so the further changes are done in the new
> file already?

Sure, I will do it in the v2.

Thanks,
Qi

> 
