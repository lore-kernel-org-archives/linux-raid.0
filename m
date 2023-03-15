Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 959EDC6FD1D
	for <linux-raid@archiver.kernel.org>; Wed, 15 Mar 2023 18:18:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231527AbjCOSS6 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 15 Mar 2023 14:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231244AbjCOSS5 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 15 Mar 2023 14:18:57 -0400
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2699420F
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:18:56 -0700 (PDT)
Received: by mail-io1-xd2a.google.com with SMTP id o14so2664743ioa.3
        for <linux-raid@vger.kernel.org>; Wed, 15 Mar 2023 11:18:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112; t=1678904336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SEepGgrDfslGeZwL2p/8h1F0VHmFA5M9/NDwcfqwadk=;
        b=gtVhAKBtUleXo5lBtsNeMgUqRB5J7HGhJ8NhT1+9QqQzJS9d3qSwYnbApn/qN16u5N
         rLtLCOKE9bthXfTR6a/PY9jOjvHFyas7WI1Diy7u6kz6ShV7z+YcYi+Zl0y1dLHGY+Ah
         Nzbt3TGpIoldR6JDjPCiTEvmGxMyuoRLrS+T93CyD85Fms0MuQh7JpvBjvFwbmX6Ruy3
         BoNZ+y8JixIpj5Hm3HSjegdIvJReBcCGlvPsDqEEQgVjyoL/+azQ2hfYJ0yFTDOEXwSp
         5d85ijyDHBPLLhoH08vv6T4mqJ5RDtIhIyqIiVdL5QnLAgSx298WO6IWaj5VfLgRa7s/
         7+ag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678904336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=SEepGgrDfslGeZwL2p/8h1F0VHmFA5M9/NDwcfqwadk=;
        b=M5MgO23p5epBKHkgUvMmqxAP3qr4ogKpKsuJ97RSSw3Uy/6FsdyFTkJzIZl/RULiBr
         7536npHsx4QmpKzuMP/tABERqoG6UUp7wEdxzRBvIzG+LJvHcZejfHVLlEEYbgjnwbtE
         j4kCUuB82wb8H9/jnk3XBBa3Io70of+UCO6SMuCWDPwxDKY/A6Eb2YsqwNcxfB9Y4z75
         pGwx8Aye2uz3oYVnO3aCl55bIpNq1vWEmx6UnsDC6KM9yHJTT8xxKSdrzZjLkeY7kEjs
         sSeH5bw3+OGI4Y16q1Kj4aCEZPAYQKPcM+FbFhU7cV3wCxKOC6gcCN780cOcZPGSTH6/
         hhow==
X-Gm-Message-State: AO0yUKWy/eHkNj0K5kXpwkBnROq4lJYlcZIxJZnw+UuGAmHb3qBRsnA0
        06iLDbJiwkgXXY04gCBoyCy31w2aNvzoX5vy1M82VQ==
X-Google-Smtp-Source: AK7set8LAg6TqUBoFDB1ywDxYPNJd4sdHdbB6mgRFkv+fiRQ/0Eu3pu+AbhnqcX7DRfaak+4XDWNPQ==
X-Received: by 2002:a05:6602:2c07:b0:74e:5fba:d5df with SMTP id w7-20020a0566022c0700b0074e5fbad5dfmr257771iov.0.1678904335969;
        Wed, 15 Mar 2023 11:18:55 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o3-20020a6bf803000000b0074ca5ac5037sm1878927ioh.26.2023.03.15.11.18.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Mar 2023 11:18:55 -0700 (PDT)
Message-ID: <80411e8d-3cc3-a0a0-1642-c1db5ef96581@kernel.dk>
Date:   Wed, 15 Mar 2023 12:18:54 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [GIT PULL] md-fixes 20230315
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>
References: <ECA01A7B-4737-45A7-B853-2A41069173F7@fb.com>
 <1890d32a-b4d7-b495-dada-3b1398b70137@kernel.dk>
 <07E84E9F-BB2E-4800-99A0-0187460A0669@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <07E84E9F-BB2E-4800-99A0-0187460A0669@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/15/23 12:14?PM, Song Liu wrote:
> 
> 
>> On Mar 15, 2023, at 11:09 AM, Jens Axboe <axboe@kernel.dk> wrote:
>>
>> On 3/15/23 12:04?PM, Song Liu wrote:
>>> Hi Jens,
>>>
>>> Please consider pulling the following fixes on top of your for-6.3/block
>>> branch. This set contains two fixes for old issues (by Neil) and one fix
>>> for 6.3 (by Xiao). 
>>>
>>> Thanks,
>>> Song
>>>
>>>
>>> The following changes since commit 49d24398327e32265eccdeec4baeb5a6a609c0bd:
>>>
>>>  blk-mq: enforce op-specific segment limits in blk_insert_cloned_request (2023-03-02 21:00:20 -0700)
>>>
>>> are available in the Git repository at:
>>>
>>>  https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git md-fixes
>>>
>>> for you to fetch changes up to f6bb5176318186880ff2f16ad65f519b70f04686:
>>>
>>>  Subject: md: select BLOCK_LEGACY_AUTOLOAD (2023-03-13 13:34:29 -0700)
>>>
>>> ----------------------------------------------------------------
>>> NeilBrown (2):
>>>      md: avoid signed overflow in slot_store()
>>>      Subject: md: select BLOCK_LEGACY_AUTOLOAD
>>
>> This one looks like it got botched when applying?
> 
> Yeah, I messed up the subject. Thanks for catching it. I just fixed the 
> subject. Please pull the following instead.

Pulled.

-- 
Jens Axboe

