Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 701E3C5AD4C
	for <linux-raid@archiver.kernel.org>; Mon, 20 Nov 2023 16:46:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233724AbjKTQqq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Nov 2023 11:46:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233956AbjKTQq1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Nov 2023 11:46:27 -0500
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F2C11C
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 08:46:19 -0800 (PST)
Received: by mail-io1-xd36.google.com with SMTP id ca18e2360f4ac-7a9541c9b2aso40993939f.0
        for <linux-raid@vger.kernel.org>; Mon, 20 Nov 2023 08:46:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1700498779; x=1701103579; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=y/Z1Y446/iKUQVKoJANFYDgAV3JUZ/TgDeVDaLHpQjw=;
        b=zxHQG7YLs/YhMchd3amk7EQOnVaRDAdd8YDQezP23kZa9/oQOvbJ3dNTPlq1Pxg+0m
         1/QNgC0w1DxwCxCHEcNRgeBK2OKNcLK+Q8I31o4LyO81vftNdyTKcBJ8Kd6eE9PCAaO4
         RZn8kr+tXI6JacfCnYYdMWppThw1CmUjTfWlwtFErt2CjotOCmVck9Pxv7YDxCoCx0QR
         z3ze/7txpqoiwRxkV8Ca52lvZ7l/yCsIqmveYDqgGVW4XzmMjKm/Yfx0DepO7pL7cz/i
         5tE+/oDmJVNxX2z2wBGbzccw6n6YQLN/yqCiDfBpwXAxDwyz/Zp9YoWBB6lILI5KXnrP
         zqZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700498779; x=1701103579;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=y/Z1Y446/iKUQVKoJANFYDgAV3JUZ/TgDeVDaLHpQjw=;
        b=G1hNc41R5lj5S895RIjd10iLHIKWopVYqX7Q/UiV8Ns/NMXLxorN4nFBtzeMHM/7Fl
         La5I395lDqrnI3b8D08sJ3sJokgAoSPUs0uJwr8pgSGhJ4OQ0L2jQYT2za3BqNx1pryx
         2Jb7EeCMWfkJ1zi7Q7JexuJDDgojcFnZmkfSiUyiki010F+rpqA8qNEmNgk+YuN2Kn45
         lTAkq0e648XHCXrh+SZ4JyWaMzeeH8QAxkiX5cV2aLUHAI1phOeAg2fQ/Mg54PxutM5o
         cXNJK/zIKN9IzGcx4UoCkmuQCagRofnQlFIVEFY585XgeF51zZ1sEpcmZvHigoHc3Qfu
         jNtg==
X-Gm-Message-State: AOJu0YwE1I/ZGLwZisB4rPKVHRSsYuyBfaj36Z26BrbLNmez89E2GBpT
        c+8l1DR+y/RThbRDJ20aL8DIYg==
X-Google-Smtp-Source: AGHT+IE6NXTUD6HPk0tJlLxVS6eoDqH96Lqpfuhl4XWtxsYupOmcqxHyWNQcV4suoiZotKsv9wR7KQ==
X-Received: by 2002:a05:6e02:1cae:b0:359:3fd2:adcc with SMTP id x14-20020a056e021cae00b003593fd2adccmr9301436ill.3.1700498778898;
        Mon, 20 Nov 2023 08:46:18 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id eh25-20020a056638299900b004182f88c368sm2142041jab.67.2023.11.20.08.46.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Nov 2023 08:46:18 -0800 (PST)
Message-ID: <ffd0c0c4-fd95-4856-856b-08a4ae3c36ef@kernel.dk>
Date:   Mon, 20 Nov 2023 09:46:17 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-fixes 20231120
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>
References: <763FACE7-AF11-4A42-AA5D-5AC8AF1FCE75@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <763FACE7-AF11-4A42-AA5D-5AC8AF1FCE75@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/20/23 9:34 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-fixes on top of your 
> block-6.7 branch. It fixes the regression reported in [1]. 

Pulled, thanks.

-- 
Jens Axboe


