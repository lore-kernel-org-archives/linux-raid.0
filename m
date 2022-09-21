Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D987C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 21 Sep 2022 14:34:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229624AbiIUOed (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 21 Sep 2022 10:34:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229543AbiIUOeb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 21 Sep 2022 10:34:31 -0400
Received: from mail-io1-xd31.google.com (mail-io1-xd31.google.com [IPv6:2607:f8b0:4864:20::d31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8623EF5B7
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 07:34:28 -0700 (PDT)
Received: by mail-io1-xd31.google.com with SMTP id y141so5176997iof.5
        for <linux-raid@vger.kernel.org>; Wed, 21 Sep 2022 07:34:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=y9qJH4p5mVpa4a017Npx8Guug2HXx37SOnXReOlQQDI=;
        b=6neaLw7Rl2m8fqveO8b9p7b7NV80spZJC8zDn3ZoSFYLYAIH13wXecVlYPcFiOptaD
         vmaLnx9f7h95Ri0MaRTL/xBPTEWBF2r8FvErC5F9I1GpMaFmaYr9PgO7KOd1VR1WTc8/
         Fn3ju5Y42QSBnLEG4S24GK/vx8ymmiAaGu88Kq86/vq4x55nQNBly7VMEr+9ZSbDZfEn
         fWDiDZko4Qklq1qWsJXJoVZx7ukgrV7uG0gliFQlXxploBdaGFinQMVN39rFBz5PT6Ap
         +RNj8F7zrmIwDH5uTWLG6cNpEY/uP0J5rKC2AiVCd/ZsfrE3dgwojQ+3o/JC32rPOpSi
         MfXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=y9qJH4p5mVpa4a017Npx8Guug2HXx37SOnXReOlQQDI=;
        b=CXS35PczjyW1sD0e7Z+ZfB/ynmJ2kPgM+dipZbEqmO010EM0EJQAGr/1dYmfRBUnnv
         RiVCm51kKpfVDJ7UnUddq7PvKAmj4WQpwu7bG/oDNVE5eaPEUCCOIgmTafaDDkfZ3w3g
         nsZuBB3UVBDOTdHtse2gJK2lC/4DXdXd3gNoNfKMz/1tSFR86yVwfh6O4Ig5IzNvuLdI
         Bl05+V+vyqAAkC4bN4FXBwCtfMVNhTD1iLP5QdM+VlMMAGH9h9Tbz5aNbabw8WBJG/we
         QqbryHyLpnFYWDyI3uHiKs/h+uk2bxmhmqEPvHq6O8yn0QS391ypFTo5uoHqOo8XR/RH
         nwqQ==
X-Gm-Message-State: ACrzQf1uf8XPlXFCyjn+lKPF4km7ip9CrQGsHmK/sunsNhIDWus88fsy
        Pk1WB14M9jBN789xMPIWoSW08Q==
X-Google-Smtp-Source: AMsMyM5Y0ov9derzD5xgJgr5MKwNddz0GhXBBijeLFlGJnuvIzG2ySlyP7j3WrnvuVf3gorGGI/Sxg==
X-Received: by 2002:a6b:7d05:0:b0:68b:7243:63ff with SMTP id c5-20020a6b7d05000000b0068b724363ffmr11874700ioq.191.1663770867802;
        Wed, 21 Sep 2022 07:34:27 -0700 (PDT)
Received: from [192.168.1.94] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id y97-20020a02956a000000b0035b0ea27606sm999417jah.79.2022.09.21.07.34.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Sep 2022 07:34:27 -0700 (PDT)
Message-ID: <c7c909aa-71d9-b43c-293e-d4801a00861e@kernel.dk>
Date:   Wed, 21 Sep 2022 08:34:26 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: regression caused by block: freeze the queue earlier in
 del_gendisk
Content-Language: en-US
To:     Thorsten Leemhuis <regressions@leemhuis.info>,
        Christoph Hellwig <hch@lst.de>
Cc:     Dusty Mabe <dusty@dustymabe.com>, Ming Lei <ming.lei@redhat.com>,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-raid@vger.kernel.org,
        "regressions@lists.linux.dev" <regressions@lists.linux.dev>
References: <017845ae-fbae-70f6-5f9e-29aff2742b8c@dustymabe.com>
 <YxBZ4BBjxvAkvI2A@T590> <20220907073324.GB23826@lst.de>
 <Yxr4SD4d0rZ9TZik@T590> <20220912071618.GA4971@lst.de>
 <Yx/jLTknQm9VeHi4@T590> <95cbd47d-46ed-850e-7d4f-851b35d03069@dustymabe.com>
 <f2c28043-59e6-0aee-b8bf-df38525ee899@leemhuis.info>
 <d39e9149-fcb6-1f7c-4c19-234e74f286f8@kernel.dk>
 <20220920141217.GA12560@lst.de>
 <9594af4b-eb16-0a51-9a4a-e21bbce3317d@kernel.dk>
 <6a3660b2-fa7d-14a2-6977-f50926ad369c@leemhuis.info>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6a3660b2-fa7d-14a2-6977-f50926ad369c@leemhuis.info>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 9/21/22 3:25 AM, Thorsten Leemhuis wrote:
> On 20.09.22 16:14, Jens Axboe wrote:
>> On 9/20/22 8:12 AM, Christoph Hellwig wrote:
>>> On Tue, Sep 20, 2022 at 08:05:06AM -0600, Jens Axboe wrote:
>>>> Christoph and I discussed this one last week, and he has a plan to try
>>>> a flag approach. Christoph, did you get a chance to bang that out? Would
>>>> be nice to get this one wrapped up.
>>>
>>> I gave up on that as it will be far too much change so late in
>>> the cycle and sent you the revert yesterday.
>>
>> Gotcha, haven't made it all the way through the emails of the morning yet.
>> I'll queue it up.
> 
> Thx to both of you for taking care of this.
> 
> Nitpicking: that patch is missing a "CC: stable@..." tag to ensure
> automatic and quick backporting to 5.19.y. Or is the block layer among
> the subsystems that prefer to handle such things manually?
> 
> Ohh, and a fixes tag might have been good as well; a "Link:" tag
> pointing to the report, too. If either would have been there, regzbot
> would have noticed Christoph's patch posting and I wouldn't have
> bothered you yesterday. :-) But whatever, not that important.

We'll just have to ensure we ping stable on it when it goes in.

-- 
Jens Axboe


