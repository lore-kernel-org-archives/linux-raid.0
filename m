Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D63C9EB64DA
	for <linux-raid@archiver.kernel.org>; Sat,  1 Jul 2023 02:12:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbjGACMR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 30 Jun 2023 22:12:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbjGACMQ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 30 Jun 2023 22:12:16 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B936EB4
        for <linux-raid@vger.kernel.org>; Fri, 30 Jun 2023 19:12:14 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id d2e1a72fcca58-6748a616e17so637752b3a.1
        for <linux-raid@vger.kernel.org>; Fri, 30 Jun 2023 19:12:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1688177534; x=1690769534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4/EDsj4PlwF/xWAR4TDb9cVNGDCwaYrP9o0xdTMAM8M=;
        b=1I+Kj/8FtWzVbEy7UUkLK8tVdk5uO9TdxLddvSvXJ53iA/uG2dANOXbqoED5FCLCaJ
         WTP1l0TXBx1DnXYukq2+s+c1yiOHjIWxl15ISfxGkGVWmExJTsbzqvUta9PlM5kOBnHr
         mVJ1rOFQqbsJYqAKw8GuI+y6PzSV+V9Wjdl33E5VmO3/2cY/pNyG43ElMbLs3VumeTZO
         TmmXTETKPmzj7nJeUQGpQC91fHuhQksQvz4sA/jAUzil97AFCZt1gRELVuvQxgUPHwJt
         nwqOlxPZILKQCRfj0LImcplMstrr6FIzIAcUhBOPTuc3DuuoKQT6NAWk2/yNPhCHtoX1
         zH6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688177534; x=1690769534;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=4/EDsj4PlwF/xWAR4TDb9cVNGDCwaYrP9o0xdTMAM8M=;
        b=V4RjbQw1hZ/FHXqjmqlcphMSO0Cdrtj+E2XwrUqxgQz8YkobqqTCl9cyMHceNkeN0Y
         +9VW7OrBd7/qcyzONvDFb4/soQn8cGX3obG9+4Wr3Mb+vnumYWCILiN7W+Wj0bOVmkxf
         k4BO4E6DFSZePMoJdmzH702TOoAjy1ssS6liebez54EVypikRaMbpKUpoQinlgeHJODT
         1FVT8V7IxM3DEcQSVfWMrWjVH/GuvRamCe/TJz7xDpyX5tH6n0tV+HrJFwxAMvDiukGo
         K1SZgSW+SbRJiBMj581DQIJStyRiH09kPholypZLxqfqWlI97Lw+p8KIOKNYKGbuiSv5
         Z1ng==
X-Gm-Message-State: AC+VfDwaHV8GGfoUZo5mei5Ro16/4+yB1oN9Asa+PNt/+3JYQfv0AzQo
        RWPsAdrWMlrkmtbEOe7byBrulw==
X-Google-Smtp-Source: ACHHUZ71DJVFRI7TyMVM7pLw6gpU8T2aoAg/e3snxmJX1GDuANg1/vMCM04UV7sT/Rwo/MkYym8T5A==
X-Received: by 2002:a05:6a20:8e08:b0:121:84ce:c629 with SMTP id y8-20020a056a208e0800b0012184cec629mr6128438pzj.0.1688177534190;
        Fri, 30 Jun 2023 19:12:14 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id j6-20020aa78006000000b00643355ff6a6sm10941730pfi.99.2023.06.30.19.12.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Jun 2023 19:12:13 -0700 (PDT)
Message-ID: <a2213cd8-0273-1943-f5aa-e38ca3a9beeb@kernel.dk>
Date:   Fri, 30 Jun 2023 20:12:12 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] md-fixes 20230630
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Jason Baron <jbaron@akamai.com>
References: <A098F73A-40A2-4B8D-8BDC-BB228B4F70A0@fb.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <A098F73A-40A2-4B8D-8BDC-BB228B4F70A0@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/30/23 6:12 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-fixes on top of your
> block-6.5 branch. This patch fixes data corruption caused by discard on
> raid0 array with original layout. 

Pulled, thanks.

-- 
Jens Axboe


