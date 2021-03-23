Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03AABC433C1
	for <linux-raid@archiver.kernel.org>; Tue, 23 Mar 2021 03:29:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A08ED61923
	for <linux-raid@archiver.kernel.org>; Tue, 23 Mar 2021 03:29:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbhCWD24 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 22 Mar 2021 23:28:56 -0400
Received: from mail.snapdragon.cc ([103.26.41.109]:46894 "EHLO
        mail.snapdragon.cc" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbhCWD21 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 22 Mar 2021 23:28:27 -0400
Received: by mail.snapdragon.cc (Postfix, from userid 65534)
        id 48F6419E0C28; Tue, 23 Mar 2021 03:28:13 +0000 (UTC)
Content-Type: text/plain;
        charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=snapdragon.cc;
        s=default; t=1616470088;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=c70VfJ7GbBB0hIgachq+68aaRjEkpZX2+GUl6JsLIRw=;
        b=OgZ57DX8e66BVkm83wVEd/mICYMjRUAwMTa/K/8Zy+LoOmRVaQ/lmishLuCag7Qrha2oO6
        byHWN7P1lRbYrwZKdDXTPKuXetL+lfVJTyZePjLjPJBRVkQDhEoKkFEocfuGRFtAaqJ0d+
        RPhe9xcDevPn65RuUcRjAzzbhg3674k=
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] md: warn about using another MD array as write journal
From:   Manuel Riel <manu@snapdragon.cc>
In-Reply-To: <CAPhsuW5urYTuOago=5sGiQ_7huQ6S+2rYkQ=n+_TwxQtxC3tWQ@mail.gmail.com>
Date:   Tue, 23 Mar 2021 11:27:58 +0800
Cc:     Linux-RAID <linux-raid@vger.kernel.org>,
        Vojtech Myslivec <vojtech@xmyslivec.cz>
Content-Transfer-Encoding: quoted-printable
Message-Id: <F89F6D83-1B8E-43F8-A2C9-3CF270BC5FDD@snapdragon.cc>
References: <DAEB6C2F-3AE0-4EBE-8775-7C6292F8749A@snapdragon.cc>
 <CAPhsuW4=XoyQV_HNVnFnMWS2PvvU1+Rtbh9SJB-FQTO3haa3ig@mail.gmail.com>
 <27EE5CBC-B1B8-4463-87F5-2AE73F30941B@snapdragon.cc>
 <C990C60B-FB5A-4709-949B-6D86AF9FA6B1@snapdragon.cc>
 <CAPhsuW5urYTuOago=5sGiQ_7huQ6S+2rYkQ=n+_TwxQtxC3tWQ@mail.gmail.com>
To:     Song Liu <song@kernel.org>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


> On Mar 23, 2021, at 1:13 AM, Song Liu <song@kernel.org> wrote:
>=20
> Thanks for the information. Quick question, does the kernel have the
> following change?
> It fixes an issue at recovery time. Since you see the issue in normal
> execution, it is probably
> something different.
>=20
> Thanks,
> Song
>=20
> commit c9020e64cf33f2dd5b2a7295f2bfea787279218a
> Author: Song Liu <songliubraving@fb.com>
> Date:   9 months ago
>=20
>    md/raid5-cache: clear MD_SB_CHANGE_PENDING before flushing stripes

Interesting. No, it doesn't have this change. My active kernel here is =
CentOS 4.18.0-240. They added this patch only in 4.18.0-277.[1]

I'll try a kernel with this commit then. Thanks for the hint!


1: =
https://rpmfind.net/linux/RPM/centos/8-stream/baseos/x86_64/Packages/kerne=
l-4.18.0-277.el8.x86_64.html=
