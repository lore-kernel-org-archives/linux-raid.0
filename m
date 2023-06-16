Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DDE90EB64D7
	for <linux-raid@archiver.kernel.org>; Fri, 16 Jun 2023 05:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbjFPFaE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Jun 2023 01:30:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240784AbjFPFaD (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Jun 2023 01:30:03 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B352A2943
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 22:30:01 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id a640c23a62f3a-970028cfb6cso41570166b.1
        for <linux-raid@vger.kernel.org>; Thu, 15 Jun 2023 22:30:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1686893400; x=1689485400;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=4A8JxU3ZB0hKXO5HOtkftNUJmcLEICD5JZ84IHhOlE4=;
        b=ce9y8gtFHkqrwOX96P0VSEOquijZMgVeiZxM+JyY/H1LlRts7sArUsD65/9cIaTJ2G
         5xR21drgo+y0Gx3NG28Px0KHPlUBWTqgncTBL88DdTVg2jcYCdPDg9dCUH2Dm3H+7HlH
         koWOr3/MmTemLLZLVcrAUUfxSvfKOzmUtkJcUueOapq4DeF3rkBg3o8G2daDityF50KV
         tfUHHv+tP3od7P3+y6D/8opKEcc7ztwCos+xzYJMpdssCxLnu+hCPmbx2SedED5MKq6n
         G5iYBWLxmYbuOfQk3sPanejRsuj/BKtoc45Xr4x5xXkiei/tU2yB44NVJeMeRrMVsiB8
         D78w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686893400; x=1689485400;
        h=content-transfer-encoding:mime-version:user-agent:references
         :in-reply-to:message-id:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4A8JxU3ZB0hKXO5HOtkftNUJmcLEICD5JZ84IHhOlE4=;
        b=FDynLdbVEfKZ7V8rFew5e8zq4hS3AAJMjXx3/JBTYFS8F8CPBFg8Zo+8yKUmmkVxZX
         Hk5p3q4zpuTcoq8BRNTOH4l6GMDnGL1gIrsafHt5PYNM5YITnGMscBcZFwECSIdxL6kZ
         sqmKHrD0StMkQgOZNO228miwur17y5aETz9pbNzOxsEkF8UdSSwwe8KTkpn4inFTJ4FC
         0+5oeHYMKLoVIhFLnJyLWzyWjRYmvvJVZHCW+lNDEhP1n4TicztRyIAGKWqzmye2LnrD
         Ge8MgHUfNVxJeNXyZmE1qUrzzuwpAzz3p+MeRLFMpKdB7GHWbaVbdCO4og35id0zQmcW
         sWfg==
X-Gm-Message-State: AC+VfDySSPSDye5dZPtNKLhMVtoXEFsXwiPX39RtbRKAsxqgmx7+am7k
        Rg8JB1uKlrDlI43ZKQ9QIGJHfUSI3VI=
X-Google-Smtp-Source: ACHHUZ7ow6nOqud6A4+MVh8U8n7xFtHTUA6y6OutEkSRyyx7/KR5nyC2jp+Inkk69m7300E3y7h4LA==
X-Received: by 2002:a17:907:1c9e:b0:96b:6fb:38d6 with SMTP id nb30-20020a1709071c9e00b0096b06fb38d6mr1050562ejc.65.1686893399950;
        Thu, 15 Jun 2023 22:29:59 -0700 (PDT)
Received: from lilem.mirepesht ([5.236.100.66])
        by smtp.gmail.com with ESMTPSA id k9-20020a170906128900b00965ffb8407asm10202303ejb.87.2023.06.15.22.29.58
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 15 Jun 2023 22:29:59 -0700 (PDT)
Date:   Fri, 16 Jun 2023 08:50:57 +0330
From:   Ali Gholami Rudi <aligrudi@gmail.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     linux-raid@vger.kernel.org, song@kernel.org
Subject: Re: Unacceptably Poor RAID1 Performance with Many CPU Cores
Message-ID: <20231606085057@laper.mirepesht>
In-Reply-To: <CALTww2-HamETu5UppBiz079PZUP+rDRtQkaRA+03=s3wSQGRKA@mail.gmail.com>
References: <20231506112411@laper.mirepesht> <CALTww29UZ+WewVrvFDSpONqTHY=TR-Q7tobdRrhsTtXKtXvOBg@mail.gmail.com>
 <20231506203832@laper.mirepesht> <20231506210600@laper.mirepesht>
        <CALTww2-HamETu5UppBiz079PZUP+rDRtQkaRA+03=s3wSQGRKA@mail.gmail.com>
User-Agent: Neatmail/1.1 (https://github.com/aligrudi/neatmail)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

Xiao Ni <xni@redhat.com> wrote:
> > Ali Gholami Rudi <aligrudi@gmail.com> wrote:
> > > Xiao Ni <xni@redhat.com> wrote:
> > > > Because it can be reproduced easily in your environment. Can you try
> > > > with the latest upstream kernel? If the problem doesn't exist with
> > > > latest upstream kernel. You can use git bisect to find which patch can
> > > > fix this problem.
> > >
> > > I just tried the upstream.  I get almost the same result with 1G ramdisks.
> > >
> > > Without RAID (writing to /dev/ram0)
> > > READ:  IOPS=15.8M BW=60.3GiB/s
> > > WRITE: IOPS= 6.8M BW=27.7GiB/s
> > >
> > > RAID1 (writing to /dev/md/test)
> > > READ:  IOPS=518K BW=2028MiB/s
> > > WRITE: IOPS=222K BW= 912MiB/s
> 
> I can reproduce this with upstream kernel too.
> 
> RAID1
> READ: bw=3699MiB/s (3879MB/s)
> WRITE: bw=1586MiB/s (1663MB/s)
> 
> ram disk:
> READ: bw=5720MiB/s (5997MB/s)
> WRITE: bw=2451MiB/s (2570MB/s)
> 
> There is a performance problem. But not like your result. Your result
> has a huge gap. I'm not sure the reason. Any thoughts?

It may be the number of cores; in my setup there are 128 cores (256
threads).  If I understand it correctly, the problem is that
wakeup(...->wait_barrier) is called unconditionally at the same time
by many cores in functions like allow_barrier and flush_bio_list,
while no task is waiting in the task queue.  This results in a
lock contention for wq_head->lock in __wakekup_common_lock().

> > And this is perf's output:
> 
> I'm not familiar with perf, what's your command that I can use to see
> the same output?

perf record --call-graph dwarf fio fio.test

perf report

Thanks,
Ali

