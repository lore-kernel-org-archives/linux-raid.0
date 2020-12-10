Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A83F4C4361B
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 02:58:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67A1A2332A
	for <linux-raid@archiver.kernel.org>; Thu, 10 Dec 2020 02:58:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726843AbgLJC60 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Dec 2020 21:58:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725901AbgLJC6R (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Dec 2020 21:58:17 -0500
Received: from mail-pl1-x62a.google.com (mail-pl1-x62a.google.com [IPv6:2607:f8b0:4864:20::62a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94207C0613D6
        for <linux-raid@vger.kernel.org>; Wed,  9 Dec 2020 18:57:37 -0800 (PST)
Received: by mail-pl1-x62a.google.com with SMTP id p6so2033546plo.6
        for <linux-raid@vger.kernel.org>; Wed, 09 Dec 2020 18:57:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=KXj9D3NDi7BfyunRnGJM9LSlGJn6qDKIszeWtOiZAII=;
        b=ZS6vN2n2h7WXbbQjxioXsH17tB5XEYb9Kt5pg5quRfIuKz6X9MMidfb42wJhHcsFDG
         MDmT+sNGrgrT/ukycQwB8R5EUPS89q0g2Wtv2qMplTFU25Go7qIu7pzmDlv7MmRL/5GJ
         sRjs3c/1zt/jUlRQcPY+hIpg1QQds/ituv7Jiiskl3f5Eq2JjkTp6Zcdc85laBVEoSYO
         vRaPStQt157F4HH9xbJM1dhQO8GEetRP8qujZ8RoWq1lm6VakO/bOA0BvnrlSyQXzAOu
         18ouRJlfgYcOHI5e/My7fUlqtZy3Ebd0ebQPEyrsaP8TqOqh5xGinNXU0vtGrIJU0Kyp
         Z0aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=KXj9D3NDi7BfyunRnGJM9LSlGJn6qDKIszeWtOiZAII=;
        b=f754WOwAWDBWmNuXsNy98Zb6XXXTYbQv+CuNl4UUPxGKObHjueahhooyXv/D+7FXc/
         o0dPsmFKgkQ+iUhjom+ecLFXO85iTy2Irvmu7fUntNlHiNsw3i++CK3/YIZqSojsxbRk
         eBwymAS/gC1qeb8hR/uFJMHoU1nkEfMl2KPVWEXzDfr6yNhQsOsdMjtnYpeSvfeFOr3I
         1eQuDnA6lBcCCuwCJDCH16R94WGyO41MW7jZs9H57IXMQKqSkDD4AYIuddH30shVtPDz
         qPYZYQAgAtkjrRKhvHFdQQPFRAdj6RG0cDIlu7gQkRsOjNVxBO/ED6qUUVb5dpj9ci8D
         r2eg==
X-Gm-Message-State: AOAM533S1z9Ry1F+rtQTsqSVYX1cFRxXXTp+Q/5463niQTMMLFaQ3B7H
        Awru0jbg7eKJ2+hsbc7hoiOV63tbcxSq9w==
X-Google-Smtp-Source: ABdhPJwuuypJF20/VUUptITvU+/yJk7KLm9B8i8bcWBymSY8dls3K9S08fJto9MgXRJ4JLHZdDcXkQ==
X-Received: by 2002:a17:902:9894:b029:da:5698:7f7b with SMTP id s20-20020a1709029894b02900da56987f7bmr4594265plp.78.1607569057092;
        Wed, 09 Dec 2020 18:57:37 -0800 (PST)
Received: from [192.168.1.134] ([66.219.217.173])
        by smtp.gmail.com with ESMTPSA id 77sm3486848pfx.156.2020.12.09.18.57.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Dec 2020 18:57:36 -0800 (PST)
Subject: Re: [GIT PULL] md-fixes 20201208
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>,
        Matthew Ruffell <matthew.ruffell@canonical.com>,
        Mike Snitzer <snitzer@redhat.com>
References: <1D36E148-BF3D-41D0-8361-746FCD524C5A@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <e2942bd0-a70f-9934-4650-d4a396c3fb68@kernel.dk>
Date:   Wed, 9 Dec 2020 19:57:35 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1D36E148-BF3D-41D0-8361-746FCD524C5A@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 12/9/20 3:09 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your master branch. 
> This is to fix raid10 data corruption [1] in 5.10-rc7. 

Please send them against block-5.10. I considered moving it forward, but
you didn't even base this on 5.10-rc7 (it's one ahead).

-- 
Jens Axboe

