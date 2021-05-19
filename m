Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 93093C433B4
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:47:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 72B116124C
	for <linux-raid@archiver.kernel.org>; Wed, 19 May 2021 01:47:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234012AbhESBsq (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 18 May 2021 21:48:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233971AbhESBsp (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 18 May 2021 21:48:45 -0400
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34EB6C06175F
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:47:27 -0700 (PDT)
Received: by mail-pl1-x635.google.com with SMTP id z4so3937947plg.8
        for <linux-raid@vger.kernel.org>; Tue, 18 May 2021 18:47:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=4BubrrEnehS4CW+SWXiHDRfHwVzNncQ3YiZbnFr/8Gg=;
        b=syYCAOGNhvZjx3JG0KIDl1yysEo+5aiUJdtaJ/Qa0mfPd8M2dHcwTalfZoW50wghgM
         XM5eItYBcp8a7e7SJB27Bn83K85m597wV+ZP05lulzg+JGT+XKwWZLIvqIabBOQyKOUE
         TfryKdcMDPMeBHFQ8MXYKp6IwEPOlFji/YYGMGumsmu3KjogdH45EtpBWB8y4Zg3atRX
         NT24aWT6Aa0cxd77fd7oUv8FPpxy4WdxgV085Ep03a9e57PSis7EdOSEbs+rQWWASpAm
         87Kf5dvVkn6SsQRvRpcL5N4rxCjnEs82YSdp/Ty+3z7rx7w9nsJGtl5XSCVrk3Hd8uhk
         qxJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=4BubrrEnehS4CW+SWXiHDRfHwVzNncQ3YiZbnFr/8Gg=;
        b=bluxvJCkMCl96YbgAoZpmcfsLk8JrNZtNbShhtZYrSJ16ngDQQeQs9UKup2gXmJzh/
         hDUnJyyEG0RSTbgj7GtBY2tvLXTzEGy57rb1zksZz+IE18njk3XWDYnfO0M32K21Vf+0
         3nO37JyDmhDIvuezATwjyQhDs7PkP2jqm3jRgo0m+A18aDuKiTwjJlE7TEXfHKQmFNH/
         YnLmNFYPFpF1l4O1D01S5CW15J5WRceIODhjvNp67A27IWnbcwa70mm1b1lfbJFlLo6s
         BpqnXx68R9jpioz8AUoxCzySuXqxG67Rv7ZARyE8IrfWKyRYmKz10N/0glLUpbBjEZvt
         8KJA==
X-Gm-Message-State: AOAM531zTQdj7gN2WsGzG4WXagJjmzoCtX4xIBFxtg0IY9e5EZPJ1Wqd
        CTilYEZTWd6vwSlwuG8HBDM=
X-Google-Smtp-Source: ABdhPJzBGO+p74vmWwR1A21ytU28aluuxnx68KU4RXr8dnRNeEbeaavv9iFXFjVxJ6QAiYKrj4xYkw==
X-Received: by 2002:a17:90a:e2d0:: with SMTP id fr16mr8458291pjb.140.1621388846669;
        Tue, 18 May 2021 18:47:26 -0700 (PDT)
Received: from [10.6.3.223] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id x22sm2717375pjp.42.2021.05.18.18.47.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 18 May 2021 18:47:26 -0700 (PDT)
Subject: Re: [PATCH 3/5] md-multipath: enable io accounting
To:     Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        artur.paszkiewicz@intel.com,
        Guoqing Jiang <jiangguoqing@kylinos.cn>
References: <20210518053225.641506-1-jiangguoqing@kylinos.cn>
 <20210518053225.641506-4-jiangguoqing@kylinos.cn>
 <YKPDLwAU5WJOkLKu@infradead.org>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <5b661ed7-187d-d6cd-a103-1635fdb44b32@gmail.com>
Date:   Wed, 19 May 2021 09:46:55 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <YKPDLwAU5WJOkLKu@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/18/21 9:37 PM, Christoph Hellwig wrote:
> Is anyone actually still using MD multipathing?  I wonder if we just
> need to deprecate and eventually remove this code..

Not sure about it, only linear is marked with deprecated.

drivers/md/md-linear.c:MODULE_ALIAS("md-personality-1"); /* LINEAR - 
deprecated*/

Perhaps better to mention they are deprecated in Kconfig.

Thanks,
Guoqing

