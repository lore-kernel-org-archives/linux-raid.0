Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80AE4C433FE
	for <linux-raid@archiver.kernel.org>; Sun,  6 Mar 2022 14:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233546AbiCFOSu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 6 Mar 2022 09:18:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232115AbiCFOSu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 6 Mar 2022 09:18:50 -0500
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BECD1BE80
        for <linux-raid@vger.kernel.org>; Sun,  6 Mar 2022 06:17:57 -0800 (PST)
Received: by mail-pj1-x102b.google.com with SMTP id mv5-20020a17090b198500b001bf2a039831so5100679pjb.5
        for <linux-raid@vger.kernel.org>; Sun, 06 Mar 2022 06:17:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ILaW05fUQ1dnyzBz2lx6yZLVLQRGUBkLodqqsOJxlfI=;
        b=Uwa0QMeKDwN0s9YWycovMkoEzs1FonPzncoYixFDaCLKKWE8NRke377Ds+vQRw0zvF
         vLD1tb4jZaXTOOc6LfZ3AhSIf/h8bq9qMqjEJIimGkMROi1V8OTwG2adZGKUuZoudFQc
         uI9b8RW139golTXremkXKYtTHWAb0MBX1qjV+CLhQ7VxjKH/syB8PgU21dNujv4d27+2
         O4KgLszw9f2gyrH+NYrdqkfqUVG5+cKgj1BGVkx7O2SfBvPrnnESD/Z9FYYgG8vSH3jv
         oMboe/pScahu/N4HXDrbMuMpS4rglMGUnTodetPWhllk9E+0IRq2qaWyTPOM8h4CgCe4
         G35Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ILaW05fUQ1dnyzBz2lx6yZLVLQRGUBkLodqqsOJxlfI=;
        b=zbukD4ICY183hP8zaKZrWWSUd+frPqIMmNpwXC5bz49pknVWqZ5PVTP4CSdsDHWHa7
         rfVTxhOUf98He/VvXDStAnNrBLN4rjny2hv/A/4FJQEkXpyLvdAKgCeuqTs79zw1Zi5W
         +O3rHr8jRMTVVr4kEl1OMkoer1xQuJIIEZPBJXf6qXBrhC1bp1IDsg3IUHzaLjhSLSEy
         spuResJi21m0S9OpOtlJ6iezAjBdrigBLILzDZApTpJmtbguEtT7yfZbR2/SCYh2jcK8
         Zn1ALrrs6LNSF7q+nsptwYDUTvJ4gHU3k/F+Lzg5Hbm4d9cVlEFSEVsY8AXXkdMOUcBC
         0zSQ==
X-Gm-Message-State: AOAM531v/SjY/UFepqRryJJa7YFXHjYlDIb1HBvQpYSFD3TW6FP6L998
        bY1kfvIY3DgPIx+6281h27Jx+w==
X-Google-Smtp-Source: ABdhPJx6LAZv4jYCV9Zgk/CzJKt97QDYhDOzKJXDgh9qczi9Rnn5hhrALqKfNFxkUtAziLz7Ggy7Ag==
X-Received: by 2002:a17:902:ea02:b0:14f:fd0e:e433 with SMTP id s2-20020a170902ea0200b0014ffd0ee433mr8070303plg.24.1646576277022;
        Sun, 06 Mar 2022 06:17:57 -0800 (PST)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id s42-20020a056a0017aa00b004df8133df4asm13133348pfg.179.2022.03.06.06.17.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 06 Mar 2022 06:17:55 -0800 (PST)
Message-ID: <c94f9c70-7052-0bae-ca0e-9b9ccc48c46b@kernel.dk>
Date:   Sun, 6 Mar 2022 07:17:54 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Subject: Re: bcache patches for Linux v5.18
Content-Language: en-US
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <084b5385-ebe7-5fca-8b56-a66276005e78@suse.de>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <084b5385-ebe7-5fca-8b56-a66276005e78@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 3/6/22 3:35 AM, Coly Li wrote:
> Hi Jens,
> 
> I have technical problem to send patches via email this time, please
> consider to pull the bcache changes from my bcache tree. They can be
> applied on top of your for-5.18/drivers branch.
> 
> We have 2 patches for Linux v5.18, both of them are from Mingzhe Zou.
> The first patch improves bcache initialization speed by avoid
> unnecessary cost of cache consistency, the second one fixes a
> potential NULL pointer deference in bcache initialization time,
> 
> Please take them for Linux v5.18, thanks in advance.

I can take a git pull, but don't base it on something that isn't a tree
of mine. If I pull your branch right now, I'll get a ton of unrelated
changes.

If you want to do a git pull vs sending patches, base it on
for-5.18/drivers instead.

-- 
Jens Axboe

