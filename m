Return-Path: <SRS0=1IH2=B7=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7DBD0C433E3
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 05:05:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4F5A021734
	for <linux-raid@archiver.kernel.org>; Fri, 21 Aug 2020 05:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1597986349;
	bh=OkGTwS+5MFi778OHquSeUV36MA1aTTvT0HvnmUzJ2dY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=yRgfYqJnF9lT1gbeRz1lYXhw8i/NRYqOigyfTXRPu4GT50Zl6FKn8EkZwTrbMX76F
	 F6xMGZp8nCFBJGvPcYOw9sn8Bog8fefXCTG++r81uc7l2nrzkjj6YFPi7QnT8TSqr2
	 vPoFEbgauWTFHo3kffNmF1oEwz9Fpqg93BV2+hco=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726725AbgHUFFp (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 21 Aug 2020 01:05:45 -0400
Received: from mail.kernel.org ([198.145.29.99]:38704 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725908AbgHUFFp (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Fri, 21 Aug 2020 01:05:45 -0400
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2CA6E21734;
        Fri, 21 Aug 2020 05:05:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597986344;
        bh=OkGTwS+5MFi778OHquSeUV36MA1aTTvT0HvnmUzJ2dY=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=WsRxtWOAYOsUXAzft6SE9ZDQ+7vRLil3O4EWp2Qz7oYTzNEoSfrvJFXVzqetney+2
         /lebxuD5Zgxqo63618/7fvKemgTTq0e3aArpstK4uzwuHJUUktlI1FagnTpHI0XX3C
         2hHjX1rGITheYlBlj2GE0yHdKYRBkEKGzr3DxDV8=
Received: by mail-lf1-f41.google.com with SMTP id v12so100014lfo.13;
        Thu, 20 Aug 2020 22:05:44 -0700 (PDT)
X-Gm-Message-State: AOAM530Uajwu7amLtbWAjXdQ25nAaOaOPcSuk3iQZVpTTsTZj10vJ6UL
        CnlfMFCSs26sdGVzNYgX11W6N4lkDXYTkofJDwE=
X-Google-Smtp-Source: ABdhPJxRQxWybbj5cxma0N8Adp5v9aDvEwGun5CN++U9h8yRuQeVraqULexBLUbc7BE9XskRmCcRcFz7saUu+4nW7w4=
X-Received: by 2002:a05:6512:6c1:: with SMTP id u1mr611890lff.28.1597986342462;
 Thu, 20 Aug 2020 22:05:42 -0700 (PDT)
MIME-Version: 1.0
References: <20200821012918.3302-1-thunder.leizhen@huawei.com>
In-Reply-To: <20200821012918.3302-1-thunder.leizhen@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Thu, 20 Aug 2020 22:05:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5Gc8PA=1mAyTZ6qUxRF=pq+01JRO_9NKcsvV_Wr2d+=Q@mail.gmail.com>
Message-ID: <CAPhsuW5Gc8PA=1mAyTZ6qUxRF=pq+01JRO_9NKcsvV_Wr2d+=Q@mail.gmail.com>
Subject: Re: [PATCH 1/1] md: Simplify code with existing definition
 RESYNC_SECTORS in raid10.c
To:     Zhen Lei <thunder.leizhen@huawei.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-raid-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Thu, Aug 20, 2020 at 6:29 PM Zhen Lei <thunder.leizhen@huawei.com> wrote:
>
> #define RESYNC_SECTORS (RESYNC_BLOCK_SIZE >> 9)
>
> "RESYNC_BLOCK_SIZE/512" is equal to "RESYNC_BLOCK_SIZE >> 9", replace it
> with RESYNC_SECTORS.
>
> Signed-off-by: Zhen Lei <thunder.leizhen@huawei.com>

Applied to md-next. Thanks!
