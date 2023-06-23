Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CAB5CEB64DD
	for <linux-raid@archiver.kernel.org>; Fri, 23 Jun 2023 15:41:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232625AbjFWPlS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 23 Jun 2023 11:41:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232630AbjFWPlP (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 23 Jun 2023 11:41:15 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B93EA2116
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:41:11 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id 41be03b00d2f7-5539ada6075so129109a12.0
        for <linux-raid@vger.kernel.org>; Fri, 23 Jun 2023 08:41:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1687534871; x=1690126871;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5cjMmMkB6AvxBwRIpFbL5cgHPy1d6e0I4qrwtkgV9D8=;
        b=ZokP5f7lKaJavkB+oooLi8TFfn9vvs41QjFsGxm/+IvbM6nds7SPR9qQQepiuHsz97
         HgxcabgJF/tnt2qDvherDtdp4NVmxRSpSVQGDCOXRSCapxpyYLVcAbqwnHzBEdn0aG2e
         bU3v8jzrZiY1KPQR9EJgoP8esnTE2REzyzd2gnzOJUMxp4srqvNH1I3JDMJncNUHBh51
         MozxYlQiZ8VttETCHtNgwpnVGn4nDbfBv4KFRXC3hiB0zMFknfYB0Q7N2CpqGb4VbUu2
         NTCjnvcztRzSjGsxY70dbDQH/sdJhCQImJM2trpYzWkadnxmuwwTHJICb900/ek2m2AI
         7YPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687534871; x=1690126871;
        h=content-transfer-encoding:in-reply-to:references:cc:to:from
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5cjMmMkB6AvxBwRIpFbL5cgHPy1d6e0I4qrwtkgV9D8=;
        b=ajSXK35fXWy/lS7AcGClz/MlcY7/Q7eDBorR2kM3bt6tRHT1kU4I7In2AFubia9vC/
         sHNFXTgoNHOsuu2mmA7mGl+Wc4+HJ7LbM335+iIT1bYnGUbdyuDfnpjN5CYY7XMHnYab
         cxKceG3BsKP9a845il3omSMut6vorbjsaDOn0qDrtSjKfTbbcLiaZGMR9nc+wA+F0FfX
         fAaF33oIBMq0qWJVqGsd+bat5HH0RJUv0h8HLWfhqSWtUJWycERMyX2HIOyBYAHel4bg
         bPUZah4Vlpjs0Q1Ku4aj6xoS/nup5hJO0btsM2/BnWTO0U/hYjuPGV2xHVg2aDOckviZ
         y3TQ==
X-Gm-Message-State: AC+VfDwD+7DL19tKRKuS0w++YwwEMAnLo9rst1mA+sAdGvzxdw2w60jN
        LR1IWh209IIY8jdvU5eU4ky32g==
X-Google-Smtp-Source: ACHHUZ4lrr6GdXe6dTR7d3jJHe3zPM0KBfoj4YKs8MHbhihudwsI3qdZeUE3k7zTnf/9h0i1pNMCBQ==
X-Received: by 2002:a17:90b:4d85:b0:25b:88bc:bb6b with SMTP id oj5-20020a17090b4d8500b0025b88bcbb6bmr26117767pjb.2.1687534871197;
        Fri, 23 Jun 2023 08:41:11 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 13-20020a17090a190d00b00256bedb4bedsm1731068pjg.52.2023.06.23.08.41.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Jun 2023 08:41:10 -0700 (PDT)
Message-ID: <bb837894-de92-62f8-05ce-f06b86876ea0@kernel.dk>
Date:   Fri, 23 Jun 2023 09:41:09 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [GIT PULL] md-next 20230622
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
To:     Song Liu <songliubraving@meta.com>, Christoph Hellwig <hch@lst.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>
References: <BCD9738E-472D-4AA7-B4F9-CCF36B5DA0E1@fb.com>
 <83240030-681c-9ff5-6e2c-600e83b0cc71@kernel.dk>
 <392A5BF5-2961-4F2C-A1C6-D6532B5AAFC2@fb.com>
 <480ac9e9-9257-b1a9-520e-50feb54dfdf5@kernel.dk>
In-Reply-To: <480ac9e9-9257-b1a9-520e-50feb54dfdf5@kernel.dk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 6/23/23 9:16?AM, Jens Axboe wrote:
>> I will prepare another PR with just fixes. 
>>
>> Christoph, 
>>
>> Please let me know if you need set #1 (deprecate file bitmap) to 
>> unblock other work. Otherwise, we will delay it until 6.6. 
> 
> I've done a for-6.5/block-late and put your stuff there, but it can be
> dropped very easily. It doesn't really matter if Christoph's stuff can
> get pushed, it's still a lot of commits late. So regardless of that, the
> only real difference with a new PR would be that we'd drop some bits.
> It'd still go into a late branch, as it is indeed late.

On second thought, yes let's go your suggested route. Make a branch with
JUST the fixes, and send them my way. Anything else will have to wait
for 6.6 at this point. I'll drop my late branch for now.

-- 
Jens Axboe

