Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AEB0FC56202
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:20:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64D4B207BC
	for <linux-raid@archiver.kernel.org>; Wed, 25 Nov 2020 23:20:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbgKYXUN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Nov 2020 18:20:13 -0500
Received: from sender11-op-o12.zoho.eu ([31.186.226.226]:17331 "EHLO
        sender11-op-o12.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728529AbgKYXUM (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Nov 2020 18:20:12 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1606346407; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=BqlyS93qEz1Xng2REJAfUxluW+byp4mD/V9f0sti3Uosrx2UPjo1dQlY8H/kcjQvsS2M2mnA4NOhT17KIaT60PGAhxyuBpl+D9lFPWpKtrmFmF4RS7ztD5SRtzQYiNP3mxc3AIqfqGtwpkzOJ1JbCFUhIJCOeTrLXpc1Ke37Xmg=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1606346407; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=oY+DrYQuWCK1JTE6VEoEZbVqEWqj9evppNOd7r941hU=; 
        b=Mt1krSZDaGZ5mtkkd1zynFmlrLBFFO3TAfe9XVGMniZPCdSEIO8rRrtZ2taq3B/wkGC+QBMiH+a4TUQRe1QD+QwwHO3582+cLB3S9OtzqwZIzICqW7e8Oqy4Zr6VLyz2QMqt3WUIuMyag9ede1vA9YBhWmda6ihj7BDE4utiJ38=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [IPv6:2620:10d:c0a8:1102::1844] (163.114.130.3 [163.114.130.3]) by mx.zoho.eu
        with SMTPS id 1606346405426603.2552125737786; Thu, 26 Nov 2020 00:20:05 +0100 (CET)
Subject: Re: [PATCH v5] mdadm/Detail: show correct state for clustered array
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org
Cc:     neilb@suse.de
References: <1603532592-11802-1-git-send-email-heming.zhao@suse.com>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <8e6bcd91-522d-9263-0472-6d9a77c33a97@trained-monkey.org>
Date:   Wed, 25 Nov 2020 18:20:04 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1603532592-11802-1-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/24/20 5:43 AM, Zhao Heming wrote:
> After kernel md module commit 480523feae581, in clustered env,
> mddev->in_sync always zero, it will make array.state never set
> up MD_SB_CLEAN. it causes "mdadm -D /dev/mdX" show state 'active'
> all the time.
> 
> bitmap.c: add a new API IsBitmapDirty() to support inquiry bitmap
> dirty or clean.
> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
> v5: (polish code)
> - Detail.c: change code logic to only examine valid dev.
> - bitmap.c: redesign bitmap_file_open() to support fd reuse. It won't
>             make dev multi-opened in clusterd env.
> v4:
> - Detail.c: follow Jes comment, split if into 2 lines.
> v3:
> - Detail.c: fix error logic: v2 code didn't check bitmap when dv is
>             null.
> v2:
> - Detail.c: follow Neil comments, change to read only one device.
> - bitmap.c: follow Neil comments, modify IsBitmapDirty() to check all
>             bitmap on the selected device.
> 
> ---
>  Detail.c | 20 ++++++++++++++-
>  bitmap.c | 75 +++++++++++++++++++++++++++++++++++++++++++++++++-------
>  mdadm.h  |  1 +
>  3 files changed, 86 insertions(+), 10 deletions(-)

Applied!

Thanks,
Jes


