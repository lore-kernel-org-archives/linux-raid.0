Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 755C5C0015E
	for <linux-raid@archiver.kernel.org>; Tue, 15 Aug 2023 07:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235209AbjHOHjN (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 15 Aug 2023 03:39:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235284AbjHOHig (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 15 Aug 2023 03:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04E5810F9
        for <linux-raid@vger.kernel.org>; Tue, 15 Aug 2023 00:38:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 903F762FD2
        for <linux-raid@vger.kernel.org>; Tue, 15 Aug 2023 07:38:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD387C433C9
        for <linux-raid@vger.kernel.org>; Tue, 15 Aug 2023 07:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692085114;
        bh=8C6SP4QUk+x0kV6GZcbbe5j1fWr08csvJqE6vlczAlA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=UPoGaGaM2ng9DFDAP3tg4eFN8DdzOIl0vAZnuQVg1lpYhde7WAtDMtmC7BK0wweJR
         fzUN6yVC9gdpGGkykal6jZOwvNRWKiGqM5vbNH5+gaYGadexruxo48JKKRh7NrVsSm
         KtodAe8fMKdAXzbT97apFeEHTlw0aZr/MZKv+UTWZEwSQgz9vHuuEzuAMCx4DYwqDE
         xAIz6meEQzP6ozQfq/SCZYk8EKUbVlTGDPylypjxC7bO2A9WqBq5dX0GiAq+JVFFRe
         BpmrELJNTe+RFmWOrly3FbWbo7sgPRfnF4AuTYx+pDaz6aRQSKcFEMXbFZzGSfmGfl
         Ni1+/nDcYJuBg==
Received: by mail-lf1-f46.google.com with SMTP id 2adb3069b0e04-4ff72830927so3058418e87.3
        for <linux-raid@vger.kernel.org>; Tue, 15 Aug 2023 00:38:34 -0700 (PDT)
X-Gm-Message-State: AOJu0YwhcNPHNqAKvkCoWqMcm9DmkB1SARmog+Cwhc37vmKBtoAepYas
        LrxlQl7ME5Of+cX9xBTcjfbNsRIRoylm9S/hbD0=
X-Google-Smtp-Source: AGHT+IHpPNyOvvuEBSuoOwuq8a7lNwWSY9dLAQspR7DytrCZx8c+VpdO1bwxlybWhHX/zWWaQi7MRJXoL+r+QbY4QU0=
X-Received: by 2002:ac2:51a4:0:b0:4f6:1779:b1c1 with SMTP id
 f4-20020ac251a4000000b004f61779b1c1mr7030158lfk.48.1692085112848; Tue, 15 Aug
 2023 00:38:32 -0700 (PDT)
MIME-Version: 1.0
References: <20230814091452.9670-1-jack@suse.cz> <20230814092720.3931-1-jack@suse.cz>
 <15c8b08c-96f3-e862-73e8-e5a25228e87f@huaweicloud.com>
In-Reply-To: <15c8b08c-96f3-e862-73e8-e5a25228e87f@huaweicloud.com>
From:   Song Liu <song@kernel.org>
Date:   Tue, 15 Aug 2023 15:38:19 +0800
X-Gmail-Original-Message-ID: <CAPhsuW68xWFrydjiA6aY1Zot3Ts_YxeTyco9G7PCeZdT8pVLOA@mail.gmail.com>
Message-ID: <CAPhsuW68xWFrydjiA6aY1Zot3Ts_YxeTyco9G7PCeZdT8pVLOA@mail.gmail.com>
Subject: Re: [PATCH 1/2] md/raid0: Factor out helper for mapping and
 submitting a bio
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     Jan Kara <jack@suse.cz>, linux-raid@vger.kernel.org,
        Neil Brown <neilb@suse.de>, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, Aug 15, 2023 at 9:33=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> =E5=9C=A8 2023/08/14 17:27, Jan Kara =E5=86=99=E9=81=93:
> > Factor out helper function for mapping and submitting a bio out of
> > raid0_make_request(). We will use it later for submitting both parts of
> > a split bio.
> >
> LGTM
>
> Reviewed-by: Yu Kuai <yukuai3@huawei.com>
>
> > Signed-off-by: Jan Kara <jack@suse.cz>
> > ---

Applied the set to md-next. Thanks!

Song
