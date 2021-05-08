Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E31CFC433ED
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 01:17:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B4B166143B
	for <linux-raid@archiver.kernel.org>; Sat,  8 May 2021 01:17:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbhEHBSv (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 7 May 2021 21:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58164 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbhEHBSv (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 7 May 2021 21:18:51 -0400
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C73E7C061574
        for <linux-raid@vger.kernel.org>; Fri,  7 May 2021 18:17:49 -0700 (PDT)
Received: by mail-pf1-x42a.google.com with SMTP id v191so9075759pfc.8
        for <linux-raid@vger.kernel.org>; Fri, 07 May 2021 18:17:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=rk4hDE4sHjvPjZXwznS69vj82MjtBFOTFgH/bkCxRcc=;
        b=sVzor52OQiNkwbsNoY8AMMC8avYzH4Zqxowzy4lt2z/jil1iwK/fEege6JEOi7Pj82
         D4VA2bjVEAZmgMaAs8CQMDCZC9kbS9L3EZKEAc2ur2YAudcScYFJaZYDg9QU6TlXrIKq
         6QIO6NDbC+zy8gmIS19rFVyY++bYgTYgC3EJtHw/bG93EUhz30G+ezbULUWunajdOWQ/
         1zXZpQ/CtC5wEU2YX6b7/hZuiGfs1VBib6WrDhzustp/IJEDiCezdDcACajdpNzbaNqE
         bMO5WrgeLBVinuubmCnkcfwakI068DN64sxB0DzPAlDEa/vtb4Ooq7OmNVBVDBegdLap
         hU2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=rk4hDE4sHjvPjZXwznS69vj82MjtBFOTFgH/bkCxRcc=;
        b=dZv1tgvqugx6FMNSP40bkTzlamcmDDvyFba/jChj3WJOmo52VXj6CZWNGW/9yY6SoK
         h1YAoYf84CRbgkGTIOwLA4GGQy4lap9bfZd0BwFyhCz37ndJfUbQosleTIKbpmkbUOV+
         v0tH5gofQnMwy5m1UM1Z30EeF+NLy16+QBT6VQkJlRSk7IxI49fLRnipy7UtsDXp7IjW
         Cv8Wn3F/yRB7FHS7N8JL9a6MTPI+/OAtI5rgSl/aWkWwOxhYwRxIgioPEngEljluoxAA
         nfXNWMFbrbUPCDnAZA12CJE8bd3OgauDg9gA2WHo85SuYXHS6HxAmHPrehud2ehAIyPb
         tuYA==
X-Gm-Message-State: AOAM531msEJG4oHSY4smaXVRi7XpsaLOuLrLwq4YDstC2fukLlV+Lj65
        GhzsWt13zAE2gYQEA33ha4w=
X-Google-Smtp-Source: ABdhPJzKluzb0qt0cil+TvgFG2/nduhkumbi9UXq/r6AJL+68QStdd4+S2Ug7KWiZfjdI111ODYZsQ==
X-Received: by 2002:a62:fb14:0:b029:22e:e189:c6b1 with SMTP id x20-20020a62fb140000b029022ee189c6b1mr13607980pfm.31.1620436669353;
        Fri, 07 May 2021 18:17:49 -0700 (PDT)
Received: from [10.6.1.237] ([89.187.161.155])
        by smtp.gmail.com with ESMTPSA id c9sm5157133pfl.169.2021.05.07.18.17.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 May 2021 18:17:48 -0700 (PDT)
Subject: Re: PROBLEM: double fault in md_end_io
From:   Guoqing Jiang <jgq516@gmail.com>
To:     Song Liu <song@kernel.org>,
        =?UTF-8?Q?Pawe=c5=82_Wiejacha?= <pawel.wiejacha@rtbhouse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>
References: <CADLTsw2OJtc30HyAHCpQVbbUyoD7P9bK-ZfaH+nrdZc+Je4b6g@mail.gmail.com>
 <ddbacea2-13d9-28ca-7ba2-50b581ac658a@gmail.com>
 <CAPhsuW743nJCFOv1SHyVU-hcOWMCdFhL4-404e0vE+BdTD3=CQ@mail.gmail.com>
 <CADLTsw340wuEoX02ad-M6mN_48uDdnkj0dZSJGYMFrjgB+y80Q@mail.gmail.com>
 <CAPhsuW7ZzhXtg5MikTG+NtpQbYBZfpU5tDWzbZXDF4bhj9wwdA@mail.gmail.com>
 <9d644350-12b1-e32d-ba69-31be8ac2f6cf@gmail.com>
Message-ID: <3bf04253-3fad-434a-63a7-20214e38cf26@gmail.com>
Date:   Sat, 8 May 2021 09:17:32 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <9d644350-12b1-e32d-ba69-31be8ac2f6cf@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 5/7/21 7:46 AM, Guoqing Jiang wrote:
>
>
> On 5/6/21 1:48 PM, Song Liu wrote:
>> Hi Paweł,
>>
>> On Tue, May 4, 2021 at 2:18 PM Paweł Wiejacha
>> <pawel.wiejacha@rtbhouse.com> wrote:
>>> Guoqing's patch fixes the problem. Here's the actual patch I am using:
>> Thanks for running the tests.
>
> Thanks for the test, the better way could be just call 
> bio_flagged(bio, BIO_CHAIN)
> then no need to export bi_chain_endio.

Err, BIO_CHAIN is set for parent bio, then we have to export 
bi_chain_endio if there
is no way to detect whether the bio was split from parent bio or not.

Thanks,
Guoqing
