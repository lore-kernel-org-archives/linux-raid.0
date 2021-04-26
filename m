Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E7E4C433B4
	for <linux-raid@archiver.kernel.org>; Mon, 26 Apr 2021 17:21:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BA9886115B
	for <linux-raid@archiver.kernel.org>; Mon, 26 Apr 2021 17:21:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235418AbhDZRWV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 26 Apr 2021 13:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235079AbhDZRWV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 26 Apr 2021 13:22:21 -0400
Received: from mail-il1-x130.google.com (mail-il1-x130.google.com [IPv6:2607:f8b0:4864:20::130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E3B2C061574
        for <linux-raid@vger.kernel.org>; Mon, 26 Apr 2021 10:21:38 -0700 (PDT)
Received: by mail-il1-x130.google.com with SMTP id c3so1061212ils.5
        for <linux-raid@vger.kernel.org>; Mon, 26 Apr 2021 10:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vf8CiupHbMr6TpLlvevNYVL32ZHF+5CfkkpFO+CzO8c=;
        b=IWQZPsIVpEjuiwXYbJa6DZZlu1ZRETyK7naNnwzroaShBmydrRpS2/9nC03asGk4ZD
         W6FP1p5jA3nPkU8NJf7n4NxVYuwiTbMnxEI3PJw+xpgQYUUYybCYG3S7TSg0eA8FxJqk
         HJjXsSc6WLSfbz8MpQIQTzFOQYOVWG7RG93Vexz0e1zM3EiZA+OqDGk86hc+bgukd88Y
         XOT08zf1n9kI/RODTaX5RZdkKEAF6gYqUW/y5o8QPmKpv3749coRm44yZgwMbxbeqAOh
         pkHF8YQ8WzS/Nuzoof2/ohugTc0qQRQ+9POOUml4uycirFgAQpROiPsqg6f8kyIrX8ZW
         4moQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vf8CiupHbMr6TpLlvevNYVL32ZHF+5CfkkpFO+CzO8c=;
        b=n0CuzgZVjDqNYpr2UBAveaXw2xTaxwEqwU56ggzJnFdRPJideH/aISRKKJoIuoIWnq
         qlcPqILNned2St1hSBJc45cr6gibUY0OSg8M+ep4NnVo0euEGsnsI9SzQFmw0xxBaTLN
         Pi6Ry1eQTqRvc4lGaL1HefLJOmcQ76LedtqVMHK0KpRGLeJP2jjv/Uvcwc7PK96c9XEI
         wuBs1kFjt3GNj6MUArzObnR+He9S0tdmDJsLYqKrmTkChz9DQSx7y8LlXe+1iCTBaOzp
         niOgnilXR544kON4MWGiIAH6o8BysssGdvKKRS8GRyvXDLbYU0imKetEdljl+mLFcYs0
         mMEg==
X-Gm-Message-State: AOAM532Sf1BfoAUGn3d4YP2PTjcialVGdwPiNq4eaEe/TeAn0JyqSJDv
        0a3s1efVV8NrjuhOkj3aj4lx0WcMU79VnA==
X-Google-Smtp-Source: ABdhPJyGro2oXM/WJ6VzevqHqc7CG0iV1dJbj1/t//RFbpGNjm3kZ5jhqXkK+OsPUyIeC0jD6Uhmmg==
X-Received: by 2002:a92:c80e:: with SMTP id v14mr14382319iln.138.1619457697663;
        Mon, 26 Apr 2021 10:21:37 -0700 (PDT)
Received: from [192.168.1.30] ([65.144.74.34])
        by smtp.gmail.com with ESMTPSA id v7sm218670ilo.25.2021.04.26.10.21.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 26 Apr 2021 10:21:36 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20210426
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Xiao Ni <xni@redhat.com>
References: <0BF1557C-1D28-4C7F-833C-FD57623D6F17@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <529b0edc-009a-a8a6-4c42-3721cde572d4@kernel.dk>
Date:   Mon, 26 Apr 2021 11:21:36 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <0BF1557C-1D28-4C7F-833C-FD57623D6F17@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/26/21 11:11 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your for-5.13/drivers branch.
> This change fixes raid5 on POWER8. 

Pulled, thanks.

-- 
Jens Axboe

