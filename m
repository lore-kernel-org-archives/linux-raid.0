Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A86EC433ED
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 15:56:10 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4662161139
	for <linux-raid@archiver.kernel.org>; Thu,  8 Apr 2021 15:56:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231791AbhDHP4T (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Apr 2021 11:56:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231772AbhDHP4S (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 8 Apr 2021 11:56:18 -0400
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87373C061760
        for <linux-raid@vger.kernel.org>; Thu,  8 Apr 2021 08:56:06 -0700 (PDT)
Received: by mail-pf1-x435.google.com with SMTP id m11so2125119pfc.11
        for <linux-raid@vger.kernel.org>; Thu, 08 Apr 2021 08:56:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20150623.gappssmtp.com; s=20150623;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=WBbfO8bed4E5ky1oL38Czl6Y0+skdD2QguDetUpLPV4=;
        b=nhdpmO2XykY3igPJXgxfjUkmzP3QA29CffBn2HQ6RHgvtSQPDsl/Ys4iFMILuc85Mu
         j54J1juH6iWQLUc9m84AezBR6MBO6VCB5UiD1K71YULGwzF1aiabs9/YDlN9nT08ZYBG
         b8+qsh/JMCq8gPCKRGgGAd6X8coTh++GteHF1canbjZHGfPPY12cdNM4EieXqOkAJ826
         twiGrsJ/gUPS/inzXXo+MfSk+26lCDdeoS85TRiahFrQq8q6lXbpx3uyb9gtdKWEvzhB
         4CiGeeGP+kySoa4etCDoGg0CjJqTVlre3/UIIhsfyL0VcJJszAcs8hP5ZVLA3RYYUYIJ
         N4Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WBbfO8bed4E5ky1oL38Czl6Y0+skdD2QguDetUpLPV4=;
        b=XPwuiwbdwXQJDicTw9QOQ5CTyC7TeL0juds6uDImjdHYNYLnUwlnKZpsqXaKZVeeeZ
         Tn0F5G8Xrj06LS02az0kpfi0nY0MQTrvuZI45QX9Pf1vDRK+Fd0cvTrSEfD0V7AG0cMe
         Yba1gLPYxFZoxzNLRAYO1RGCcqvxHwxCXuW0ZdnsrFCRkb9J/pwUqsKc26/flAWIDT4p
         ltu30QGz3BjowOUwJzz8ftL70diXb17mlRkJw6ti1+DpYByNuo/Vn6tPdoXyuDkPfgPn
         v/j4SGRJ/1yf32jLMuaQzNHNr52Z8Bv99KVcjP0dg9En3gEvtF4evjt4lQ24Cdz4Vuuq
         f6cA==
X-Gm-Message-State: AOAM530SVj7E60JDfNEdg0S4geVHaCg8yH510UsTho/Z0jIpJLjuwGC+
        znQKVSe89qyIvqCrlFxzL8lHxw==
X-Google-Smtp-Source: ABdhPJwkFWEin87ghkGOATC6FMI+j23omakCYoWZg/v8gwl7/3usiI5pOv0R7l3k4tsGrvYivbcKNg==
X-Received: by 2002:a63:9dc5:: with SMTP id i188mr8747943pgd.191.1617897365984;
        Thu, 08 Apr 2021 08:56:05 -0700 (PDT)
Received: from [192.168.4.41] (cpe-72-132-29-68.dc.res.rr.com. [72.132.29.68])
        by smtp.gmail.com with ESMTPSA id r1sm8992643pjo.26.2021.04.08.08.56.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Apr 2021 08:56:05 -0700 (PDT)
Subject: Re: [GIT PULL] md-next 20210407
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Christoph Hellwig <hch@lst.de>,
        Zhao Heming <heming.zhao@suse.com>
References: <EE2FD049-51D9-4348-9677-BDE75032E9EC@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <7e7aa639-dccb-474d-5102-b4363499de03@kernel.dk>
Date:   Thu, 8 Apr 2021 09:56:03 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <EE2FD049-51D9-4348-9677-BDE75032E9EC@fb.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 4/8/21 1:00 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes on top of your for-5.13/drivers 
> branch. These patches fix a race condition with md_release() and md_open().

Pulled, thanks.

-- 
Jens Axboe

