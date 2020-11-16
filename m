Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBC5FC6369E
	for <linux-raid@archiver.kernel.org>; Mon, 16 Nov 2020 17:31:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 85C8121D7E
	for <linux-raid@archiver.kernel.org>; Mon, 16 Nov 2020 17:31:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=kernel.org header.i=@kernel.org header.b="MX6ugVEQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733018AbgKPRav (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Nov 2020 12:30:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:46966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732924AbgKPRav (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 16 Nov 2020 12:30:51 -0500
Received: from mail-lj1-f180.google.com (mail-lj1-f180.google.com [209.85.208.180])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7F5982225B;
        Mon, 16 Nov 2020 17:30:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605547850;
        bh=UpQYpVjxWvfwphzD1YtzZKX4gJ1zajvx3CurLsFZ+60=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=MX6ugVEQerRMjIihGXuRuaBSd9U41KzRG79hPwln/sRIyBy6qOhQ8qDKwJMO9MTyl
         Cw4/oLQkcKwXNzi6Iuka91E5JX6xrEl2UMntabkWUhyRlZMUJb8CYBi6NbtG820zOz
         3Pba/5bjyuuGYg8CY6zxdqwEPP6ewom09xZAK0W4=
Received: by mail-lj1-f180.google.com with SMTP id y16so21080985ljk.1;
        Mon, 16 Nov 2020 09:30:50 -0800 (PST)
X-Gm-Message-State: AOAM532xqOVd0FxjvDPnVtCXytxqGNn5l1bMeQVuVxJAVfHEW5IKnisf
        bqBXUPxhXmnuGksnGTl/zUcIkzaF2NrapxOOmFk=
X-Google-Smtp-Source: ABdhPJyRWi+mnbDZNzQgnSLP2+UnefmQHMh4IVb1bM04Or4ZESnQGi5EDw/rg7q7PWuXK2IKYc6fMXCbzsa/whMb9lo=
X-Received: by 2002:a2e:3316:: with SMTP id d22mr160386ljc.392.1605547848865;
 Mon, 16 Nov 2020 09:30:48 -0800 (PST)
MIME-Version: 1.0
References: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
In-Reply-To: <20201111051658.18904-1-pankaj.gupta.linux@gmail.com>
From:   Song Liu <song@kernel.org>
Date:   Mon, 16 Nov 2020 09:30:37 -0800
X-Gmail-Original-Message-ID: <CAPhsuW6J9e+6Q69eTR+PzbCpgrmisBOQO-xE_qvBo=a1BtRVDQ@mail.gmail.com>
Message-ID: <CAPhsuW6J9e+6Q69eTR+PzbCpgrmisBOQO-xE_qvBo=a1BtRVDQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] md: code cleanups
To:     Pankaj Gupta <pankaj.gupta.linux@gmail.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Nov 10, 2020 at 9:17 PM Pankaj Gupta
<pankaj.gupta.linux@gmail.com> wrote:
>
> From: Pankaj Gupta <pankaj.gupta@cloud.ionos.com>
>
> This patch series does some cleanups during my attempt to understand
> the code.
>
> Pankaj Gupta (3):
>   md: improve variable names in md_flush_request()
>   md: add comments in md_flush_request()
>   md: use current request time as base for ktime comparisons

Thanks for the clean up. Applied to md-next.
