Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 186A1C001DF
	for <linux-raid@archiver.kernel.org>; Fri, 20 Oct 2023 16:43:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377917AbjJTQnU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 20 Oct 2023 12:43:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377908AbjJTQnT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 20 Oct 2023 12:43:19 -0400
Received: from mail-io1-xd2d.google.com (mail-io1-xd2d.google.com [IPv6:2607:f8b0:4864:20::d2d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 374D7197
        for <linux-raid@vger.kernel.org>; Fri, 20 Oct 2023 09:43:17 -0700 (PDT)
Received: by mail-io1-xd2d.google.com with SMTP id ca18e2360f4ac-79fc0068cb5so10402339f.1
        for <linux-raid@vger.kernel.org>; Fri, 20 Oct 2023 09:43:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697820196; x=1698424996; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gTdxqS67i7ng/6wm9iJH/mU1cpqJgDjmihlnCdwOyak=;
        b=sGK5aXjFbnfBFInEps06XyEP1YWqfXE+O8IdUHe9TCPH1VPIOwFO4ksU7RekPVWyG6
         8MHSfYUPSpdnDT0AHzFCndix/qH3lCyCuMYuwWf9KElImZPxABX4YVAuwZugp7XkYY/p
         2U/7aVXoy+bYbX/SteWj45nsO24MdGJ9Zey0rzIXg9nDQDB8wQF4NbrPKx2fwcPhoEBY
         uMkLU1MC6YhZOYvc+OPwWfPo4pj1J7OLa9bpudtGRZk9R5KeMDZxteQPSPGGf6cqjpTg
         3/s7iUgOxmBIGHB1u5DHAbdpRGc2Bh3KbAp8NgTBdAJt2mxGb/pYEgZZvJc5hK/0y7Fe
         WPwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697820196; x=1698424996;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gTdxqS67i7ng/6wm9iJH/mU1cpqJgDjmihlnCdwOyak=;
        b=J9/0Ph87Lg21GwElZ0PpZM7TpvLGJAtXymEuxKlKk0l9dML5eS5Pe1W4Hwv2h8Isuh
         BtXNaTV78s3q2LF/vPetXXLlrS1lbEFV66BwODDihs45wyjr6vgbvCOYupVI9ByxP42l
         4me0wK6sibexHplmig4U/bRaaKCQY7xyXkfxhYUtRX0/URjFkJT+FZ8LMoGU04pHDQG0
         I8UecgYXsLuLlc4DB9AMZIGHvfx5aKCWUQBFUk5SXFIgGdilvZwILfccze9lo3UZ8Oxc
         49kvOHRU/bqDS9ugs0paB0phkTJSrktNDTwdZgnTrdBasU2vbsJDb3NdqQkUG4oybgTP
         EhUQ==
X-Gm-Message-State: AOJu0YwT7S30UhQNqBLvabZZgh71TIlTijGDFeJ2ntYOYSseEMOrDAiY
        2LvoNApjBMpk+dYxsyvxCicPJw==
X-Google-Smtp-Source: AGHT+IFg6iGuwudULLeQuaPKN0GR2qL1Z2rupk667kxuGhvDl1hA4p83yTLIOqUkXD45LGlvp1cjsw==
X-Received: by 2002:a05:6e02:5af:b0:357:9e82:6ca7 with SMTP id k15-20020a056e0205af00b003579e826ca7mr2383768ils.3.1697820195790;
        Fri, 20 Oct 2023 09:43:15 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id k4-20020a056e02156400b0034cd2c0afe8sm675833ilu.56.2023.10.20.09.43.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Oct 2023 09:43:15 -0700 (PDT)
Message-ID: <e81df8ad-18f7-4d36-aba8-e99fb1cbe09c@kernel.dk>
Date:   Fri, 20 Oct 2023 10:43:13 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-next 20231020
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Denis Plotnikov <den-plotnikov@yandex-team.ru>
References: <50A926AD-D6BB-4635-90FF-DB6DEAF62EE0@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <50A926AD-D6BB-4635-90FF-DB6DEAF62EE0@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/20/23 10:21 AM, Song Liu wrote:
> Hi Jens,
> 
> Please consider pulling the following changes for md-next on top of your 
> for-6.7/block branch. This batch contains:
> 
> 1. Handle timeout in md-cluster, by Denis Plotnikov;
> 2. Cleanup pers->prepare_suspend, by Yu Kuai. 

Pulled, thanks Song.

-- 
Jens Axboe


