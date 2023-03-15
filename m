Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B76BC6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 18:09:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232276AbjCOSJ6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 14:09:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39302 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjCOSJw (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 14:09:52 -0400
Received: from mail-il1-x134.google.com (mail-il1-x134.google.com [IPv6:2607:f8b0:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E633912BC0
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:09:50 -0700 (PDT)
Received: by mail-il1-x134.google.com with SMTP id h7so10813019ila.5
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:09:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678903790;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2w4Wh20b9wXSJm6cWZLXJUV4x5cKe8MqxE/n+KWwq0c=;
        b=Q7cF53ejOs9g3Ct7RMvC51wJd17UctmLiB5Pwxfrdq2xTS9mHll5IuiQ6tq+EAH/hq
         nlfL/fyuMrQoaS1yOkmvnvnmJsREeCAcy1F5kAhI7ho8tYYltCn8C83yJeDZLSL07Fcx
         EEU7fxqNKzZzPdpZpZLfc+fC+Kn1kJH89dnyU2OlrXTnWzki+Tv26QXBRH4ZEqYHC5cX
         dWUTd3E2lBLh1i4HtIMgkiXycI0cZ5Ej1VKs49BCGXk9bjq29bJ4TexZzlWtHLRXB6vd
         Pdsa8KwFEvq+4iP/hPr+aDPpm0dUzywO4DiePbpXw/B0KzIg6ynVfCvNGeVhZxc0eBQU
         5OqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678903790;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2w4Wh20b9wXSJm6cWZLXJUV4x5cKe8MqxE/n+KWwq0c=;
        b=drMpL+L+8GnuPRVDX43Mg89PwM8OaOPT/mS65NTsY/VO2vOtOseEhrLQfIEZjePJkA
         jiqtrbrIQQShnG3/G4Ohpb9focIUgshQJV+CLp3XM4W6tyK2NEkX56zUh9uMJxl48SmB
         fYBsmDmZ/3vln199Yc+mRj1ZSLxxDjIkJvuPwYRtRdjaTtKxt9Q7ecLWc4c5kSBQguBo
         pRJ1rTluWsP9/ALdnt/NOzpGScz5C41EmtEkjIRHcahBa6ppMcJ9zSVBehkMiS7KoVRf
         iEINS0pQhcU3rQOeEic4RfeS3V9SDrUBJdtLfFKcm84ddvywh9yHGKLkROFaaZuOEqsY
         9zsg==
X-Gm-Message-State: AO0yUKWDWW2RYj6+OZGBmX1e4HjNQxN9SmSmfU3TJd/1X3/vWKH4RHoc
        wFA4bGh6ZRwP+UqXXBV1FAqLzrd82UBvISnDrrYIfQ==
X-Google-Smtp-Source: AK7set/A6WlhegDCqKFIXrkE/aV7buapNHggkNy0CC+CZPo2Lb5YeQ9f1ZJOdZER0GklyhOvCr0ZYA==
X-Received: by 2002:a92:c547:0:b0:318:8674:be8 with SMTP id a7-20020a92c547000000b0031886740be8mr118788ilj.2.1678903790229;
        Wed, 15 Mar 2023 11:09:50 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 6-20020a92c646000000b00322f1b34d92sm1797903ill.35.2023.03.15.11.09.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 11:09:49 -0700 (PDT)
Message-ID: <1890d32a-b4d7-b495-dada-3b1398b70137@kernel.dk>
Date:   Wed, 15 Mar 2023 12:09:49 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [GIT PULL] md-fixes 20230315
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
References: <ECA01A7B-4737-45A7-B853-2A41069173F7@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <ECA01A7B-4737-45A7-B853-2A41069173F7@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/15/23 12:04 PM, Song Liu wrote:
> Hi Jens,
> 
> Please consider pulling the following fixes on top of your for-6.3/block
> branch. This set contains two fixes for old issues (by Neil) and one fix
> for 6.3 (by Xiao). 
> 
> Thanks,
> Song
> 
> 
> The following changes since commit 49d24398327e32265eccdeec4baeb5a6a609c0bd:
> 
>   blk-mq: enforce op-specific segment limits in blk_insert_cloned_request (2023-03-02 21:00:20 -0700)
> 
> are available in the Git repository at:
> 
>   https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
> 
> for you to fetch changes up to f6bb5176318186880ff2f16ad65f519b70f04686:
> 
>   Subject: md: select BLOCK_LEGACY_AUTOLOAD (2023-03-13 13:34:29 -0700)
> 
> ----------------------------------------------------------------
> NeilBrown (2):
>       md: avoid signed overflow in slot_store()
>       Subject: md: select BLOCK_LEGACY_AUTOLOAD

This one looks like it got botched when applying?

-- 
Jens Axboe


