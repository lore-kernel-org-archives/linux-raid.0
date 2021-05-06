Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9CE79C433B4
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 23:47:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7D63C61006
	for <linux-raid@archiver.kernel.org>; Thu,  6 May 2021 23:47:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233100AbhEFXsH (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 6 May 2021 19:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233085AbhEFXsG (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 6 May 2021 19:48:06 -0400
Received: from mail-pg1-x52b.google.com (mail-pg1-x52b.google.com [IPv6:2607:f8b0:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78551C061574
        for <linux-raid@vger.kernel.org>; Thu,  6 May 2021 16:47:07 -0700 (PDT)
Received: by mail-pg1-x52b.google.com with SMTP id i14so5870590pgk.5
        for <linux-raid@vger.kernel.org>; Thu, 06 May 2021 16:47:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=vNAsVLI+S42kshjpIZQRLpT80lkmeqydX93DGx2oNQQ=;
        b=VEXuLHPdPCrj2r7emCvtH9fusdOM55VovHSFuWOrkY6rVFSpT7kVn6Zpx2nbsAcnau
         k6utpKtmRSIUccrFKOGh4LpiO2DgbBV4XHyrOqxilBVybLjH7WKl//afCeaCO2riL1Ce
         FISJ8o36lIJLjiuv3ucnJKKL0yf1a6oHoTsQ3DJBt+ZJ7rTELZuyllmKsvqznpICyoCj
         so86Cqxx6PMiEnA89/nETR/Zp0xq5bSXnZDd8o16SI2YossRDhtenx1IKlIcM5joNtJn
         U1rLh7BrJSQ5+wQViGR91cYx6OkFv65noqriSs+F+PXU3Qno0QWf/ZVGGMdYx1G/k+sI
         Xkbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=vNAsVLI+S42kshjpIZQRLpT80lkmeqydX93DGx2oNQQ=;
        b=hDpxquKUBqcRjMc2TZ5Z1SSGVLEF0IIAk0UhRk2mksXzoXcR3Gn9Ypb2ZS37Ychi1h
         ZerUn6mN8RrrL+tGhcZGksWA2areC73tvtuqjmoFK4uwDrcmZwakH6jw2ueoLLFpJX8H
         wb4p0lzfc2+ArcU9OfGb4fMOP4ZUxg5JLTMNf7vWUGyCZ8uKPAZXXAUuXiV++BsXPDax
         1AI0n5djQ4+LwecbB7I711W9bcBNLukNacFmYaDf0S3+O1yEdOISs9CgcLAH795XDSQm
         k6AS6qrdOgRsia9Adz0IqiMotYJksHIqww8kULor+gUVFU3hWrYE0NTYF5sMVu7WNkQp
         g/wQ==
X-Gm-Message-State: AOAM532cQnOTbJqEuUxYd6XyXLj6zPF0kJqpYPcN/YsGJ+iQ4LHYP9FA
        KKQrWH36g2bbE9oFYfc2ToE=
X-Google-Smtp-Source: ABdhPJz98QGj34/ddOp5+ofjpIRYG1ickpgp1BgD/4zlNjC2AGsgrC5YjJoO4WfhqtuLJtO8YuKXiQ==
X-Received: by 2002:a65:558a:: with SMTP id j10mr6702452pgs.404.1620344826828;
        Thu, 06 May 2021 16:47:06 -0700 (PDT)
Received: from ?IPv6:2409:8950:621:7b0:35da:b248:3f09:bae5? ([2409:8950:621:7b0:35da:b248:3f09:bae5])
        by smtp.gmail.com with ESMTPSA id u18sm3008263pfm.4.2021.05.06.16.47.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 May 2021 16:47:06 -0700 (PDT)
Subject: Re: PROBLEM: double fault in md_end_io
To:     Song Liu <song@kernel.org>,
        =?UTF-8?Q?Pawe=c5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
 <ddbacea2-13d9-28ca-7ba2-50b581ac658a@gmail.com>
 <CAPhsuW743nJCFOv1SHyVU-hcOWMCdFhL4-404e0vE+BdTD3=CQ@mail.gmail.com>
 <CADLTsw340wuEoX02ad-M6mN_48uDdnkj0dZSJGYMFrjgB+y80Q@mail.gmail.com>
 <CAPhsuW7ZzhXtg5MikTG+NtpQbYBZfpU5tDWzbZXDF4bhj9wwdA@mail.gmail.com>
From:   Guoqing Jiang <jgq516@gmail.com>
Message-ID: <9d644350-12b1-e32d-ba69-31be8ac2f6cf@gmail.com>
Date:   Fri, 7 May 2021 07:46:52 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <CAPhsuW7ZzhXtg5MikTG+NtpQbYBZfpU5tDWzbZXDF4bhj9wwdA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/6/21 1:48 PM, Song Liu wrote:
> Hi Paweł,
>
> On Tue, May 4, 2021 at 2:18 PM Paweł Wiejacha
> <pawel.wiejacha@rtbhouse.com> wrote:
>> Guoqing's patch fixes the problem. Here's the actual patch I am using:
> Thanks for running the tests.

Thanks for the test, the better way could be just call bio_flagged(bio, 
BIO_CHAIN)
then no need to export bi_chain_endio.

>
> Hi Guoqing,
>
> Could you please send official patch for this fix?

Will do, and I think then we need to figure out a way to account the 
statistic of split
bio properly.

Thanks,
Guoqing
