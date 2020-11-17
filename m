Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1F55BC2D0E4
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 11:34:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AF8C7221FF
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 11:34:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PkTvE5TB"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728135AbgKQLeU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 17 Nov 2020 06:34:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727759AbgKQLeU (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 17 Nov 2020 06:34:20 -0500
Received: from mail-lj1-x231.google.com (mail-lj1-x231.google.com [IPv6:2a00:1450:4864:20::231])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACCAFC0613CF
        for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2020 03:34:19 -0800 (PST)
Received: by mail-lj1-x231.google.com with SMTP id r17so23856229ljg.5
        for <linux-raid@vger.kernel.org>; Tue, 17 Nov 2020 03:34:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=mDo72cCNWbYqoT4ueQ2GiN7yIASH47GNiu81Ss8KXwY=;
        b=PkTvE5TBpIgSLY6ZhoaRGzuiv7SJIGCC96Ge04tYHoDrxGS3LtzB+Bb67PwdfTfJCa
         EbLuTIvBM06vxST7Tkod8BQYCDlPkjvKgsYLQBM5tULW3X69iyrPB1ugKIAhSWCIl5E1
         1D1aCumD3Xqa2OdSXdcDGh8xKzQKkme3pE5GfdaMyWU/v+T7dB6wFk4SyVuwYGi+x5JQ
         M06dXmMzfzyJVyUzl6Wq//rQAtQHutn5AM0WalCndMgTn17gmvw0U99H+yozA7kcaRC+
         iwBSDjTbvJqtcbAi7oI+wMiJqKEvu/40TWLdIhE54bVFSCnh5cxSBx4QIMVH2ZF0NaBB
         urmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:content-transfer-encoding;
        bh=mDo72cCNWbYqoT4ueQ2GiN7yIASH47GNiu81Ss8KXwY=;
        b=C1S0/fRf03BACyTPD+ERBUVcjhLlh0AN5K0oUMfNRMmoOLhb+XQl1pLCkJM1JHUuCd
         CSwInDyl7r3PB798gTXUkTiBn23FPBY+d5EsojWkAXTwo5d4xxq7u4eIBqR+l+mWeMW0
         qNfbeXDbsMqi6DIvTes4AbCk3FKguGRfTs+itMB/mfNO972gB81IilUf5OiphZCAnylg
         eJ/aPIvZ1cn9t/UHtP8TzX/lPjgmtdF0lU6T7e3EoC/+BiFXWKtm6DPeW2o78YIDPnVT
         EL0Oh6ZbFmmHbjT2VZ7INAa+TOoOJ70GuCEmusGah450HrSmrjE8R9tHNaa2oYjZzF2H
         c/hQ==
X-Gm-Message-State: AOAM531uIjbFFZZKJRsonkIYoz2aNuF2RVP+mSySmUZw25r0Oz8JmfOr
        bJXYg7Qbkm8pTltJOWTDtCct3snEScgvfxZu7A14xNQWWnk=
X-Google-Smtp-Source: ABdhPJy9B5ulOUUukqtmu3p4ZJUmnLNrl1W0J8xVM/l0lEDIvWq0Z3ayTJ9QJogf9be35Pqt9e0EsxsceTaZ86/uVoo=
X-Received: by 2002:a05:651c:319:: with SMTP id a25mr1754427ljp.333.1605612858029;
 Tue, 17 Nov 2020 03:34:18 -0800 (PST)
MIME-Version: 1.0
References: <CAPpdf5-ji4YSMyCkwr8BRZLE4Jm8835TMOUfWGd2Xg6c=7TYBg@mail.gmail.com>
 <20201117042652.GU3103@bitfolk.com>
In-Reply-To: <20201117042652.GU3103@bitfolk.com>
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Tue, 17 Nov 2020 05:33:41 -0600
Message-ID: <CAPpdf58DZnHOQ-K86ypF6dW8tOOXbMsNJxZ3zrXhfBkPjsSe1g@mail.gmail.com>
Subject: Re: Information request
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Nov 16, 2020 at 10:43 PM Andy Smith <andy@strugglers.net> wrote:
>
> Hello,
>
> On Mon, Nov 16, 2020 at 08:43:12PM -0600, o1bigtenor wrote:
> > I managed to delete a file that would require a lot of hours to replace=
.
>
> [=E2=80=A6]
>
> > Looking for suggestions on how to recover the file.
>
> This is really a filesystem question - files are not something that
> RAID concerns itself with. So, what filesystem and what type of
> file? You might get lucky running photorec (it's not just for
> images) on the block device while it's unmounted.
>
>     https://www.cgsecurity.org/wiki/PhotoRec_Step_By_Step
>

Sorry for the noise folks!

Thanks for the tip Mr Andy - - - - had started that even before I
read your note. Help validate my findings!

Thanking you for your assistance (even if it weren't 100% raid
related - - - grin!).

Regards
