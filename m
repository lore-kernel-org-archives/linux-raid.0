Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8543EC00144
	for <linux-raid@archiver.kernel.org>; Tue, 26 Jul 2022 23:07:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239207AbiGZXHk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 26 Jul 2022 19:07:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbiGZXHj (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 26 Jul 2022 19:07:39 -0400
Received: from mail-pf1-x42b.google.com (mail-pf1-x42b.google.com [IPv6:2607:f8b0:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA0985FD6
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 16:07:36 -0700 (PDT)
Received: by mail-pf1-x42b.google.com with SMTP id b9so14533116pfp.10
        for <linux-raid@vger.kernel.org>; Tue, 26 Jul 2022 16:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9QC9HwmD20K+p+vb9pZuejrnz5/dN12PPJYLhl5yrSA=;
        b=O0ct/rOZ2DvdzDe4/bW+1dqBrtWz10AQbNOM34ujU4F9hWuxqdQiqQsuBrIZ7dwA85
         itKu1/hBr27mMfT1DV38asDhftr6WC7TxLRqm7qLy6ZeEiAyYGvmAw8BSM9tCuP68Uxs
         1NaFixRerlYJUEzU2fEqQ7oOdlWmckXdGi/fhu/D/74BRzCdczYxfJz6ZfubrlsdVj23
         N/Gc8cqeJDqxgtguONejQkbYhCFA0BAbkkA8G4Jcf6eGrCoASD7qnde1agGbWDyzgv2V
         GXqjeXpBEfBfFJcO8E/iiDBt5YODlm3hxOX3vq9daCp6ibXWcKWAhAOEsQmWzjbIZ/vo
         Q1Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9QC9HwmD20K+p+vb9pZuejrnz5/dN12PPJYLhl5yrSA=;
        b=MhPeK+7n+2ZeG7n+iTqH1HzAf+iERYReyjRZyBm4jmgCZTkkhZHOpFKtMDOvknrTQM
         39tzaj0Pgk4IgIaaQkcj+sZasA4pd45JEum06JD5jv7BqvT0yiePgFMkKF8GfYZgr/av
         mbjevLHmnhsi0qT2DLf7WHzUQ6u693xiWc1IAyTXjQNSWeq0zVCW/s8kvmnU99LRQvDR
         5EwABguwaTWBFKJjB7zN7YbRgpobHGCGfXZlK5JjOPdY7Y1VjSNlybusBznDsbEGw4Py
         DsEd6LEfURPf4xC98J8T34FtzXrfPLyOWzsk4XWEaFKei4G/2GqqwN8xsZiWT95NVSRU
         7LHw==
X-Gm-Message-State: AJIora8bYZNXDsHtDVYQdCuTupG0W97imrrnTbLYZEtrv2SobgkpRrNt
        G7xp04gld8mxf9silT3qfFjNoA==
X-Google-Smtp-Source: AGRyM1uXQIf+6MZnxCekuD6zR4BCFIH6vUnhM12S/QCm9UBzClkmMQaXKgmfmZgMVi1UeYcMFupDSQ==
X-Received: by 2002:a05:6a00:993:b0:52a:dd93:f02d with SMTP id u19-20020a056a00099300b0052add93f02dmr19511342pfg.12.1658876856212;
        Tue, 26 Jul 2022 16:07:36 -0700 (PDT)
Received: from [192.168.1.100] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id b4-20020a62cf04000000b0052ab92772a0sm12498894pfg.98.2022.07.26.16.07.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 Jul 2022 16:07:35 -0700 (PDT)
Message-ID: <5be77989-c2a7-cb23-8387-2daf1f562a06@kernel.dk>
Date:   Tue, 26 Jul 2022 17:07:34 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [GIT PULL] md-next 20220726
Content-Language: en-US
To:     Song Liu <songliubraving@fb.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        Mikulas Patocka <mpatocka@redhat.com>,
        Yang Li <yang.lee@linux.alibaba.com>
References: <035EEBB9-EAF5-4D48-9836-70E1FDEE8F13@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <035EEBB9-EAF5-4D48-9836-70E1FDEE8F13@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 7/26/22 4:27 PM, Song Liu wrote:
> Hi Jens,
> 
> Please consider the following changes for md-next on top of your 
> for-5.20/drivers-post branch. The major change is
> 
> 1. Refactoring md_alloc(), by Chrstioph. 
> 
> Thanks,
> Song
> 
> The following changes since commit 2dc9e74e37124f1b43ea60157e5990fd490c6e8f:
> 
>   remove the sx8 block driver (2022-07-25 17:25:18 -0600)
> 
> are available in the Git repository at:
> 
>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git md-next

I fixed up Christoph's name and I think you used the wrong pull
location, used https://git.kernel.org/pub/scm/linux/kernel/git/song/md
md-next as per usual and the diffstats match up.

-- 
Jens Axboe

