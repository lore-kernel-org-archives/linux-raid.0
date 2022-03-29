Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E3AEC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 29 Mar 2022 00:14:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231262AbiC2APp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 28 Mar 2022 20:15:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231222AbiC2APn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 28 Mar 2022 20:15:43 -0400
Received: from mail-lf1-x12a.google.com (mail-lf1-x12a.google.com [IPv6:2a00:1450:4864:20::12a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C06CB655F
        for <linux-raid@vger.kernel.org>; Mon, 28 Mar 2022 17:14:00 -0700 (PDT)
Received: by mail-lf1-x12a.google.com with SMTP id p15so27549434lfk.8
        for <linux-raid@vger.kernel.org>; Mon, 28 Mar 2022 17:14:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorremedies-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZLn4lDojZ8GKw5M7B0OEGOcpkIm8ezACIB5QpYAdbo=;
        b=TFdumsKnAcHjOKHJ7S65pWFQeP20dAYEN+I5pdQ8gViCVPTPj5v7idxnJXgcc2wx1O
         FVviDhCLNzU9yu9470MPW13yDDWj9u6p3e57IiLSFwe9Hj9TdNkEHHwI0IhK5ujy8tv5
         641AHJNIGU26cqQ1rhbICSiYp6qB4DrELUuWD/T7w8A3zP6iS0ulComAg97Z+GuXYERU
         dR8ssGBfveoHFw3bzcjMejzc/fuKfmY4P5uXrHGW5AqquAwzEs1eelLe7Wy6huFBDmTu
         OjdbBeIIndlMX8ViOMnyA+kjFepwadclJ/Qn4Sn+Z8DPFaAgm2NR24DQbwquddCv8Ff9
         16mA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZLn4lDojZ8GKw5M7B0OEGOcpkIm8ezACIB5QpYAdbo=;
        b=2pi1to7Wdy0u4WAiTDxqiC72sH3WXBgE+92uirYcK9v/LibLHiVWRIe3jz0Nmj6mAQ
         42t01u8KnSK9KVSdkf+KPJPfEhsKgQa6ocR3pOO255z6OtCyZZUmvykMA+PjzAd2oB9J
         4noQkUfYQrbbRbeXWqHzpRsihz6VKjnqBkWDdpNdSBLQlRcteg0x4VNA1T56bP1j+KQY
         +zj9kRSnQV5wOSGXgXf0rDQfTGKUgXyOhF8EH+MkjG93IZb+RBjU7UcYjYsPV4Fa7HmJ
         evnzRfOsPSomW2e+p8EXV51Rm8+9WZQeohMRJWiWNIJR8jRYM1V+Aql9D4s64cCofwu6
         k+rg==
X-Gm-Message-State: AOAM531BE8ZVREzIXV3tDMoacGhn7/vdMrByL9PVVvlFPp7Ij1XpDtLi
        wqcRsIJDw1ZCAj4Nz6q0I2i4fOQIGMKuGPgUs9mbt0ZgqdAeEAFw
X-Google-Smtp-Source: ABdhPJzUmKLPyj5elcZyDNjRq3ibvlt9uZ+Kp2zqU+eaQdJHU3oAmSzpqnDDxil6V/EYeyCx6f1AuseKyCmzCrDwzT0=
X-Received: by 2002:ac2:5bcb:0:b0:44a:1fd6:6b14 with SMTP id
 u11-20020ac25bcb000000b0044a1fd66b14mr97750lfn.186.1648512838863; Mon, 28 Mar
 2022 17:13:58 -0700 (PDT)
MIME-Version: 1.0
References: <20220318030855.GV3131742@merlins.org> <CAC6SzHKFga59KpzhRhE-sz3K5z+=LUXfyxSB14KaOj7DCxCj-Q@mail.gmail.com>
 <20220328020512.GP4113@merlins.org>
In-Reply-To: <20220328020512.GP4113@merlins.org>
From:   Chris Murphy <lists@colorremedies.com>
Date:   Mon, 28 Mar 2022 18:13:42 -0600
Message-ID: <CAJCQCtQyqG_zWhRVXjnc3Prc+J-7hK1hyp28mwyuKWWPJ8Uo5A@mail.gmail.com>
Subject: Re: new drive is 4 sectors shorter, can it be used for swraid5 array?
To:     Marc MERLIN <marc@merlins.org>
Cc:     d tbsky <tbskyd@gmail.com>,
        list Linux RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sun, Mar 27, 2022 at 8:05 PM Marc MERLIN <marc@merlins.org> wrote:
>
> OMG, using a USB adapter eats 4 setors? I had no idea...
> Sure enough, I did connect the drives via USB for diagnosis since I had
> run out of sata ports.

None of my SATA-USB enclosures behave this way. But what it does do is
mask (lie) the true physical sector size, claiming it's 512 bytes
instead of 4096 bytes.

I've also seen enclosures turn a 512 byte logical sector drive into a
4096 byte logical sector drive, which is a real PITA because it
completely messes up the GPT. My understanding of the logic of GPT
format is atomic modifications that are crash safe (that's up to the
tool to do correctly too but the spec has a pretty specific order each
sector is supposed to be written), but in practice this is another
PITA for a significant minority of users who end up putting an
internal drive into an enclosure and bam - can't read the drive at
all.

It'd be kinda neat if this condition could be detected and have a
device mapper target setup to deal with it.



-- 
Chris Murphy
