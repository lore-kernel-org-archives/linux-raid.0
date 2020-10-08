Return-Path: <SRS0=hplT=DP=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 85429C4363C
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 06:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 259C52083B
	for <linux-raid@archiver.kernel.org>; Thu,  8 Oct 2020 06:36:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1602138965;
	bh=2UXD9I9gQilDgjhkkb7oCv5EzEhCCbrYAd5JQFj3b5w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=NZVeemmICOpgzhUZg9726n5vvzEHv6gqVCDuAtnqJ7AV90A4+8PtfdVYv8x5/7m5E
	 whLvv4xYHEGENmYYbei+DZEcPB2kTOjUN+3pCHm0VW1IgmmKMlINw4M3xl7YhjPwmd
	 5chYl09rvM8xIVKDn+0LnGGL8+Zin7l0F3a94Xu0=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgJHGgE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 8 Oct 2020 02:36:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:48176 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726041AbgJHGgE (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Thu, 8 Oct 2020 02:36:04 -0400
Received: from mail-lf1-f45.google.com (mail-lf1-f45.google.com [209.85.167.45])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7A02A2083B
        for <linux-raid@vger.kernel.org>; Thu,  8 Oct 2020 06:36:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602138963;
        bh=2UXD9I9gQilDgjhkkb7oCv5EzEhCCbrYAd5JQFj3b5w=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=U7vDxqSNFeVtRkGcwTS9m7OpgGU3U3Oji+yGrWxVHTVPNid3aPWsiEcqDZMPnXlLB
         1/7mCUWZpSJ9NCfXpOl3vmxMel1JW5S22SWL8eZndvUGu8kUNvfff+Sh2LFdqjmRHX
         wA2L71eUdVlx6EunnIx8wzqfkIG1SzZba0pgVWwc=
Received: by mail-lf1-f45.google.com with SMTP id h6so5207637lfj.3
        for <linux-raid@vger.kernel.org>; Wed, 07 Oct 2020 23:36:03 -0700 (PDT)
X-Gm-Message-State: AOAM532tRXR6GbTdZrFJH6rP9Gs1WaenK5yr1LJ7gDzuDXMTulaZpa27
        /tPPKo52LJKSmSfr7C77SMPe9+CEm2Uz7kqgdSQ=
X-Google-Smtp-Source: ABdhPJwnY0G36LS6OUqnCs+KKsP5LtkoNUZmKsuaa4vR2g7AEVuqLgQbxi0VsxBSJxSC3IUnZvNGiN1guFw23Bqeqq0=
X-Received: by 2002:ac2:544e:: with SMTP id d14mr2058563lfn.482.1602138961701;
 Wed, 07 Oct 2020 23:36:01 -0700 (PDT)
MIME-Version: 1.0
References: <1601913624-27840-1-git-send-email-heming.zhao@suse.com>
In-Reply-To: <1601913624-27840-1-git-send-email-heming.zhao@suse.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 7 Oct 2020 23:35:50 -0700
X-Gmail-Original-Message-ID: <CAPhsuW4Uc84EzjfuGZ+FjRtkX3_AhKA8rYTsB+HpDiGPnGEBmQ@mail.gmail.com>
Message-ID: <CAPhsuW4Uc84EzjfuGZ+FjRtkX3_AhKA8rYTsB+HpDiGPnGEBmQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] [md/bitmap] md_bitmap_read_sb uses wrong bitmap blocks
To:     Zhao Heming <heming.zhao@suse.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Oct 5, 2020 at 9:02 AM Zhao Heming <heming.zhao@suse.com> wrote:
>
> The patched code is used to get chunks number, should use
> round-up div to replace current sector_div.
> The same code is in md_bitmap_resize():
> ```
> chunks = DIV_ROUND_UP_SECTOR_T(blocks, 1 << chunkshift);
> ```
>
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>

Applied both patches to md-next.

Thanks,
Song
