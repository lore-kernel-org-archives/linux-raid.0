Return-Path: <SRS0=vpcD=DH=vger.kernel.org=linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A0333C4363D
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 22:44:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5775F2071E
	for <linux-raid@archiver.kernel.org>; Wed, 30 Sep 2020 22:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1601505879;
	bh=fEWtRDcIOEsyywJAVhIx3J7i7mk+XvMl2xGXw2800ew=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:List-ID:From;
	b=F7gQmJNSFr2Tz5xen29KGdBqu3SY4FkxsiUIEw4PcVGLEEqVp0jRx7L7Hq8lhElHf
	 523ZyHiasMtfJ/cUOcaNPCwIdq5YluwVAjpMpxkRlJ6L96bk0V+mt71b89roo0yLS3
	 Y3couln9cEBVjKfbQpwO4dnP+zR54yKowibRsRs4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730981AbgI3Woj (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 30 Sep 2020 18:44:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729980AbgI3Woi (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Wed, 30 Sep 2020 18:44:38 -0400
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2EE282071E
        for <linux-raid@vger.kernel.org>; Wed, 30 Sep 2020 22:44:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601505878;
        bh=fEWtRDcIOEsyywJAVhIx3J7i7mk+XvMl2xGXw2800ew=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=V9vjw3PTSsrVy4733Fq+48A5H+cQlfu2exAPk19xl477z019eMNx2zj4dNDYYW8Rt
         pltkNrZaGXe/QE5kBSW8vVLxKbei3nQlrhqsptNjBcg5e2SsjYVSiRvYTktZQhLqMS
         Whi+uf9Pux5c1lkPsfyRvDnw9GuBtYG35aOFkcJA=
Received: by mail-lj1-f181.google.com with SMTP id u21so2981346ljl.6
        for <linux-raid@vger.kernel.org>; Wed, 30 Sep 2020 15:44:38 -0700 (PDT)
X-Gm-Message-State: AOAM533oiehk9f+EXgfaK6sQRJkHG03V6bonQ5UuGvQueedpKS2sYOae
        sYfOXRKvFoIU5ZqvbF30HPdf/9Npz0fE8pQQ/tc=
X-Google-Smtp-Source: ABdhPJwrXLdxVpKNFofvLoDWNty9mEP/LX491IQFeB1ClALB1ftKksS7U8trKf9pxpTeX9jmsWKHKHuchl/a65Bmruw=
X-Received: by 2002:a2e:b0d6:: with SMTP id g22mr1372259ljl.350.1601505876507;
 Wed, 30 Sep 2020 15:44:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200921063825.3501577-1-yanaijie@huawei.com> <96d8e516-511d-c2d4-4c93-ce2b9c38b226@huawei.com>
In-Reply-To: <96d8e516-511d-c2d4-4c93-ce2b9c38b226@huawei.com>
From:   Song Liu <song@kernel.org>
Date:   Wed, 30 Sep 2020 15:44:25 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5jbE4Mt8+vaztae+cHLLdCaHu7z+eFaYw=BJNfCbWN=Q@mail.gmail.com>
Message-ID: <CAPhsuW5jbE4Mt8+vaztae+cHLLdCaHu7z+eFaYw=BJNfCbWN=Q@mail.gmail.com>
Subject: Re: [PATCH] raid5: refactor raid5 personality definition
To:     Jason Yan <yanaijie@huawei.com>
Cc:     Yufen Yu <yuyufen@huawei.com>,
        linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 28, 2020 at 6:03 PM Jason Yan <yanaijie@huawei.com> wrote:
>
> Hi all, any comments?

Sorry for the late reply. I somehow missed the first email.

>
> =E5=9C=A8 2020/9/21 14:38, Jason Yan =E5=86=99=E9=81=93:
> > The definition of md personality for raid4/raid5/raid6 is almost the sa=
me.
> > So introduce a macro 'RAID5_PERSONALITY_ATTR' to help define the
> > personality. This can help us reduce some duplicated code.
> >
> > Signed-off-by: Jason Yan <yanaijie@huawei.com>
[...]
> > +}
> > +
> > +#define raid4_check_reshape raid5_check_reshape
> > +
> > +RAID5_PERSONALITY_ATTR(raid4, 4);
> > +RAID5_PERSONALITY_ATTR(raid5, 5);
> > +RAID5_PERSONALITY_ATTR(raid6, 6);

I don't think we benefit much from this change. It doesn't make the code
easier to read. Instead, this change adds another level of marco to the cod=
e.
I would rather keep this code as-is.

Thanks,
Song
