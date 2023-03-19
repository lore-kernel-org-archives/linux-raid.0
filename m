Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2E329C7618A
	for <linux-raid@archiver.kernel.org>; Sun, 19 Mar 2023 19:52:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229575AbjCSTwN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 19 Mar 2023 15:52:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60454 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229599AbjCSTwL (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 19 Mar 2023 15:52:11 -0400
Received: from mail-oa1-x2d.google.com (mail-oa1-x2d.google.com [IPv6:2001:4860:4864:20::2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADBE119107
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 12:52:10 -0700 (PDT)
Received: by mail-oa1-x2d.google.com with SMTP id 586e51a60fabf-17e140619fdso2639978fac.11
        for <linux-raid@vger.kernel.org>; Sun, 19 Mar 2023 12:52:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679255529;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kpy44NKFgUe8Oq1ABLakQSHcc2YAnxnOySx04vvfn3M=;
        b=J8ba+SBgNZrE7U35ivv1vCssm7npFPlFDRARkWqchaitEy+mP0q5OInYNnhp9k/nG3
         u3zn0XV7Ryff987hlgLk5+qGH15yTVGF5e2V5OiyFO0moq8p0W2sHHNWz6B2Nk2G+02U
         kqHFdQqaJ0LVzEe4TAE89q6VvDGLfpqbauHV2WY0ybGbVQEZM6Xbfl6P33MKDW6e0OXy
         C2Zf1txpY/5SSt7BU6jvsx6Ylk/p8n61ERhCO7L2sDk7qtRPdFt/DWG1iUFgXNHJ9Dhd
         RqdNeroQKDbFNvgQGJJvULONcD7n0Bh9Cs4PDYxB2vk0RfMF1t4vY1LO9abypSfi99+7
         xiuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679255529;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kpy44NKFgUe8Oq1ABLakQSHcc2YAnxnOySx04vvfn3M=;
        b=XMYc0KebujXIH7GVCx38Q58LaIOCQkRreVymMPi9Ot+boOsb+1a2P9mk2xOa4FHkeE
         a9P3rgnjzVhng7rYrq0iwSeTRmOVY0Se8+V8s2ALJDqX5maLle+L/NATeVxiKJQKfjd3
         WUnnVf52ZeOEFHIDm3Ztm8KvNIEvlHM0LVoYHm5G20WtpgJWBuc5uAw9Mciyi/omGpZk
         zNx9hhEE30mLuETPO16h/MR4ig4Dju6cRJ5r9wGMybWE88VDh1H5S3LCISU43OLp6ATn
         B6Zz5zbC1earsWyjj5+0X5vla13QeC2wOTNhIfdu/pGp56ybVdFzSbCQNV/C/A3wTZCD
         0k2Q==
X-Gm-Message-State: AO0yUKUN5FpXZYuR3hviAEh+/tsTTUVXnXn47Oq6VzKPaEaJii8+Vns0
        WNtE+xzLNmnIljpuYvNO85o=
X-Google-Smtp-Source: AK7set9qW2L6wBx0Z7t8iOomKbh9Hg7ZajJnEqBc8+3D2VNEIjQgQbW18LvYHmT33DpIxfPlPLsU8A==
X-Received: by 2002:a05:6870:2389:b0:17a:c141:ffdc with SMTP id e9-20020a056870238900b0017ac141ffdcmr3452137oap.58.1679255529461;
        Sun, 19 Mar 2023 12:52:09 -0700 (PDT)
Received: from [192.168.3.92] ([47.189.247.51])
        by smtp.gmail.com with ESMTPSA id zh17-20020a0568716b9100b0017281100b75sm2677651oab.42.2023.03.19.12.52.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 19 Mar 2023 12:52:09 -0700 (PDT)
Message-ID: <f3b25d87-0ab7-3f74-c6ed-da1cc04db97f@gmail.com>
Date:   Sun, 19 Mar 2023 14:52:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: Renaming md raid and moving md raid to a different machine.
Content-Language: en-US
To:     Reindl Harald <h.reindl@thelounge.net>,
        Linux Raid <linux-raid@vger.kernel.org>
References: <f237651e-536a-e305-8c1c-475e4c14d906@gmail.com>
 <97945e22-f0d4-96d7-ef66-284ae6f8b016@gmail.com>
 <07163ff3-9e2b-72be-8de2-e4d5e9127e36@thelounge.net>
From:   Ram Ramesh <rramesh2400@gmail.com>
In-Reply-To: <07163ff3-9e2b-72be-8de2-e4d5e9127e36@thelounge.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/19/23 14:29, Reindl Harald wrote:

> * create new arrays
> * mount both on the new machine (1 disk is enough for RAID1)
> * use dd
> 

Mmmm... I need to move 6 disk RAID6 and not RAID1. For now RAID1 will 
stay with old machine. Also, I am trying to avoid coping 24TB of files 
(if possible) as we are talking about 3 days of copying or resyncing.


Regards
Ramesh

