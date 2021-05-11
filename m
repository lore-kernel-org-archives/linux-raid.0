Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9822C433B4
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 02:13:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1E646147E
	for <linux-raid@archiver.kernel.org>; Tue, 11 May 2021 02:13:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbhEKCPE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 10 May 2021 22:15:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230408AbhEKCPE (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 10 May 2021 22:15:04 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 969CAC061574;
        Mon, 10 May 2021 19:13:58 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id c13so1529348pfv.4;
        Mon, 10 May 2021 19:13:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=jDMDtI5ZeUZZn3Tp1DS29j8oWnTCCdYeGMtIJRV9a58=;
        b=SLe71s8PLm2/U1FyGaIJfbFIJ0jYYTFkICVkqAdZDlNTnUFfAavJeIV7AoY2Kp+JI3
         fi/XL2kUlbadEEJKguNd0nuEIJQPtSYWs9qIR9HrrPd0CfxnyEjDsCZ3vFpFbj2KxBAs
         JfgLCXJT+0o4UXNIrGcvFHCCbbWPelOipIu9O7KrKfOmnRat5wqLpSCw14c8F3v78vSJ
         o+0mzqS6sxPVmVaDHI83M9Zd/cwcmL9CElHLlgy8dCvS99DCvqRfYSANytjQVDZOqYcY
         atdLk2UDjPHYLG2fONqka4qT4uFvChfGTYM6x59EukJfpDlJVA7/nG/knTT5og6hjng6
         3K1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=jDMDtI5ZeUZZn3Tp1DS29j8oWnTCCdYeGMtIJRV9a58=;
        b=Hu7EXBdcsfJaxkJrglI+LI+urhZQMF9KUkCtCRdNEz9lZ+h8XhkbRDlQnCiSbxZlBU
         xK4SuLTCpK4hj80kf/oXbL7RndNdUB8yBYT0h54v+0d7fGt1CL48kHxVHhmBx+UBFa/Q
         VnQrYki+IcNRoBmpccvCmL/o6kP/eN8q7e7ojf+s8IM60zwD7vHKdR0UhXNH9renf+bZ
         9BMPGAobRzBr6vbozXZzxkCbn85b0a4mDWcuLbg8CKnTxJOujzsnoqWMZ5anjbo5tJfP
         u2qk2OK6Oj7Nf6LswwGNs/6gYxzEldBiJOihKDP0hHKeytv5Wk05bxd6hyfIB20rmfDW
         EyRQ==
X-Gm-Message-State: AOAM531G2HOmLo6hKs4+xleegM8cc1sNvjV9D9Eoc7qk6HaQ69iInHJp
        lB2VKljM3VpvJ92tma8ZASI=
X-Google-Smtp-Source: ABdhPJxju11rPgW1dJndQ2UkTeg/w2VfXfpx3Fk9f1H0xq9f3A8GWvzuXRPleXVYHR8CYRmLqUFjAg==
X-Received: by 2002:a63:ab05:: with SMTP id p5mr28060151pgf.149.1620699238111;
        Mon, 10 May 2021 19:13:58 -0700 (PDT)
Received: from [10.6.2.172] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id c195sm12161658pfb.5.2021.05.10.19.13.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 May 2021 19:13:57 -0700 (PDT)
Subject: Re: [PATCH] md: don't account io stat for split bio
To:     Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Christoph Hellwig <hch@infradead.org>
Cc:     song@kernel.org, linux-raid@vger.kernel.org,
        linux-block@vger.kernel.org, pawel.wiejacha@rtbhouse.com
References: <20210508034815.123565-1-jgq516@gmail.com>
 <YJjL6AQ+mMgzmIqM@infradead.org>
 <14a350ee-1ec9-6a15-dd76-fb01d8dd2235@gmail.com>
 <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <c1bc42ff-eae7-d0ba-505d-9c6a19d60e93@gmail.com>
Date:   Tue, 11 May 2021 10:13:41 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <6ffb719e-bb56-8f61-9cd3-a0852c4acb7d@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/11/21 3:49 AM, Artur Paszkiewicz wrote:
> On 5/10/21 9:46 AM, Guoqing Jiang wrote:
>> On 5/10/21 2:00 PM, Christoph Hellwig wrote:
>>> On Sat, May 08, 2021 at 11:48:15AM +0800, Guoqing Jiang wrote:
>>>> It looks like stack overflow happened for split bio, to fix this,
>>>> let's keep split bio untouched in md_submit_bio.
>>>>
>>>> As a side effect, we need to export bio_chain_endio.
>>> Err, no.  The right answer is to not change ->bi_end_io of bios that
>>> you do not own instead of using a horrible hack to skip accounting for
>>> bios that have no more or less reason to be accounted than others bios.
>> Thanks for the reply. I suppose that md needs to revert current
>> implementation of accounting io stats, then re-implement it.
>>
>> Song and Artur, what are your opinion?
> In the initial version of the io accounting patch the bio was cloned instead
> of just overriding bi_end_io and bi_private. Would this be the right approach?
>
> https://lore.kernel.org/linux-raid/20200601161256.27718-1-artur.paszkiewicz@intel.com/

Maybe we can have different approach for different personality layers.

1. raid1 and raid10 can do the accounting in their own layer since they 
already
     clone bio here.
2. make the initial version handles other personality such as raid0 and 
raid5
     in the md layer.

Also a sysfs node which can enable/disable the accounting could be helpful.

Thanks,
Guoqing
