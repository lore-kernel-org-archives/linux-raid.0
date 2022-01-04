Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA1A2C433F5
	for <linux-raid@archiver.kernel.org>; Tue,  4 Jan 2022 04:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbiADE0C (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 3 Jan 2022 23:26:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232825AbiADE0C (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 3 Jan 2022 23:26:02 -0500
Received: from mail-il1-x133.google.com (mail-il1-x133.google.com [IPv6:2607:f8b0:4864:20::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D9B8C061761
        for <linux-raid@vger.kernel.org>; Mon,  3 Jan 2022 20:26:02 -0800 (PST)
Received: by mail-il1-x133.google.com with SMTP id u8so27427016ilk.0
        for <linux-raid@vger.kernel.org>; Mon, 03 Jan 2022 20:26:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vij5nkHSlsH/FGJLjrs1+obkJ7Ro/bx/HwYUNsX7fYg=;
        b=n6ycA3XXCbLy47knEWpKD34JeA8ETb8B0KV+dwKYK4eJGVYwE0Rvu0G54t0qhrUVVF
         cSjQEyhFR/Yz9uPiREfTaBpoHjf8YY/eNn0QI2fLveGgteNmSJLzpY/1OD8kYZHJX6Ea
         CBREzfFk9XU3aZXSiPZGRqYCkXDlkmrmcFhm8wrZnq6SuYJr7Ub6nDTl9hcbCJqKrPwK
         sFLDBcCoHGdqCUfRtgHHU22owuSI1t1z6ug3FW0bA5fgJEXTuIgz2KxGMH709SjvM3jJ
         Agt3GqxnZey9N51qnEea+ad9Ck3/72gRJfjn7QYU+dmeC+ImwnOd33uWem6k+qCYfuot
         u6/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vij5nkHSlsH/FGJLjrs1+obkJ7Ro/bx/HwYUNsX7fYg=;
        b=xELPDQt7rX/R8TB/3hOlyvhgXoIuzurJFAYF0XJ4SjJqqfecHvw6FKAbIqGUIkf6Dq
         TrRR/QgsVuK65hNJJjMWyJypNKuAYujVgS+OTKIbkfBb1P6pbSWohRuf69Y/hn4EnVW+
         d+R31zle4Qcnx+geYQVNxNut8Mh6ZyMyoR6bWGYBXzjygYCRG78HTB6m8XADXBCdMMf/
         wQEkQL1VreUVn0+1T99pdLysZpL6XdWYch7Bzg6t+pMdQ74dV5i0/wKOkjJddIYlvs63
         eyBzDsy14+adWIlN6mh63qnQ/y4gXVpksh0PkPevyHBZyO/edFx0385ZUmfPDSNzYZLw
         3v/w==
X-Gm-Message-State: AOAM5329QQdaGbdLQhpe894xxvz96YWrNx1JHD6p0t7O3kfami3pLPlJ
        5t7Zy7QTTP6esG4yN20UjkNBQA==
X-Google-Smtp-Source: ABdhPJyTKekCKbRgotBTNfLVoBraeZg+yA08JFsN7ScZWxlYoswvBoHbN5Ll7A5kpNaXTl+WBnREXQ==
X-Received: by 2002:a92:c7c4:: with SMTP id g4mr22404671ilk.112.1641270361648;
        Mon, 03 Jan 2022 20:26:01 -0800 (PST)
Received: from [192.168.1.116] ([66.219.217.159])
        by smtp.gmail.com with ESMTPSA id u14sm22054068ill.70.2022.01.03.20.26.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Jan 2022 20:26:01 -0800 (PST)
Subject: Re: [Regression] md/raid1: write-intent logging/bitmap issue since
 fd3b6975e9c1 - v5.16-rc1
To:     Linus Torvalds <torvalds@linux-foundation.org>,
        Norbert Warmuth <nwarmuth@t-online.de>
Cc:     Guoqing Jiang <guoqing.jiang@linux.dev>,
        Song Liu <songliubraving@fb.com>, linux-raid@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <m3tuekbos5.fsf@nogrod.ivcecceob.t-online.de>
 <CAHk-=whzdxBuoeTP1uJrxRQYtwOxPDYuP92c8e=_K5T1xHy7Ug@mail.gmail.com>
From:   Jens Axboe <axboe@kernel.dk>
Message-ID: <eddcc94a-2cd4-6258-5614-88c4d1dbbca2@kernel.dk>
Date:   Mon, 3 Jan 2022 21:26:00 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <CAHk-=whzdxBuoeTP1uJrxRQYtwOxPDYuP92c8e=_K5T1xHy7Ug@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 1/3/22 11:53 AM, Linus Torvalds wrote:
> [ Jens wasn't cc'd for some reason but was the signer-off-on the patch
> you bisected to. Added him to the cc. I'll bounce the original
> separately, as I also don't see this on lore.kernel.org - it might not
> have gotten there yet ]

Thanks for adding me in, Song took care of it now. Will get sent out
shortly.

-- 
Jens Axboe

