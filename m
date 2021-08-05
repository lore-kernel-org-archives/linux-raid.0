Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.7 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28BA1C4338F
	for <linux-raid@archiver.kernel.org>; Thu,  5 Aug 2021 16:20:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 069C260243
	for <linux-raid@archiver.kernel.org>; Thu,  5 Aug 2021 16:20:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbhHEQUa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 5 Aug 2021 12:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40280 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229591AbhHEQUa (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 5 Aug 2021 12:20:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B531660243;
        Thu,  5 Aug 2021 16:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628180415;
        bh=VFxYgzBBWT1LiYLjgJFwyOgZryBAs4ErOSaZpv3EZ7M=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=TCJc3ksuFNWoSTvLjRCDBHd5BDMK6NTG3GFhDoT9OSgH9OPEUiyq6gI3vOgEWTvrt
         OQUN0buKgp7b5PLt/TVVZQGHH5HiHVtzD1d0FEG6R6ED32ym9zxAgFqhGa5XABbwCk
         6Tv+Nn7R1v46rgD+BhMFhiM04rzlnHj0jEtXHDR5EGDn/OrmeHReR+5/vnmihbYIiQ
         jHbTvMrvYlcZOpCERH/IpiS0y2x3GySP7otxw6qeb/Y8qr8WgyK1Q9C509IuJWzSBr
         DQi5ClJCfbU8BHO7Uk1WPWELQajChMr0W92VWftXG636KvF0u5ouyW5HLXOpROHuoa
         B57M8f7W3mtSA==
Received: by mail-lj1-f170.google.com with SMTP id n6so7830727ljp.9;
        Thu, 05 Aug 2021 09:20:15 -0700 (PDT)
X-Gm-Message-State: AOAM530P5nVzalIENM2zYHK3necltEuXDL2lud16j1/3c3MdG63yZaJG
        C4A5St9ifz42aikWfsqA//LvLIuJBmut7tUjsto=
X-Google-Smtp-Source: ABdhPJy2wEmnaOIK672fR2BPxWH4X/15JVu3FoK8wrn3vcX7eu33ioL4/XFmbV45r2tcQphqqesEVyOTg2twgm1HUUQ=
X-Received: by 2002:a2e:505b:: with SMTP id v27mr3531375ljd.177.1628180414057;
 Thu, 05 Aug 2021 09:20:14 -0700 (PDT)
MIME-Version: 1.0
References: <20210803141621.780504-1-bigeasy@linutronix.de> <20210803141621.780504-16-bigeasy@linutronix.de>
In-Reply-To: <20210803141621.780504-16-bigeasy@linutronix.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 5 Aug 2021 09:20:02 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4xCAAhvZPoaW8tq9uXrif45ubRLR4c=i7KJQsSzeO6EA@mail.gmail.com>
Message-ID: <CAPhsuW4xCAAhvZPoaW8tq9uXrif45ubRLR4c=i7KJQsSzeO6EA@mail.gmail.com>
Subject: Re: [PATCH 15/38] md/raid5: Replace deprecated CPU-hotplug functions.
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     open list <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <peterz@infradead.org>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 3, 2021 at 7:17 AM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> The functions get_online_cpus() and put_online_cpus() have been
> deprecated during the CPU hotplug rework. They map directly to
> cpus_read_lock() and cpus_read_unlock().
>
> Replace deprecated CPU-hotplug functions with the official version.
> The behavior remains unchanged.
>
> Cc: Song Liu <song@kernel.org>
> Cc: linux-raid@vger.kernel.org
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Song Liu <song@kernel.org>
