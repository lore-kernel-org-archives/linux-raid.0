Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76384C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Jun 2022 17:04:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235822AbiFTREe (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Jun 2022 13:04:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231484AbiFTREd (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 20 Jun 2022 13:04:33 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE0201AF1F
        for <linux-raid@vger.kernel.org>; Mon, 20 Jun 2022 10:04:31 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8880E1F969;
        Mon, 20 Jun 2022 17:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1655744670; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dV8nHJC3fWZBtQl6QyxXonosDRdFiDabVfOBLHnOQ14=;
        b=O9sQXYepxn/Q+0xr3u6SKoz//zp2Ib3bgYSZ85rPMJA7ibufoNVQN22L7VuLFSTU5SE+0F
        LseLIY7oGnyh8i9LrntzAhtUfr9KeICw7gkoej9qtcjFKzZb8ySqtYEd7dQOemPk95rqcb
        UxOUZk6ggolAmjRWhAZBm28L2VFJLr8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1655744670;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=dV8nHJC3fWZBtQl6QyxXonosDRdFiDabVfOBLHnOQ14=;
        b=9exun/lcvM1ASvbOjffveGYjd5eIUh1e6m4HLsoOu6L9vRC4PozlznruO7mWvOCOrH2+aP
        VDSqT74RrMpVi6BQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id D9A0B13638;
        Mon, 20 Jun 2022 17:04:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id VhIdKZyosGLiKAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 20 Jun 2022 17:04:28 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 2/5 v2] Detail: fix memleak
From:   Coly Li <colyli@suse.de>
In-Reply-To: <35fd23fc-4f3d-a6fe-c4b1-79a7b09acead@huawei.com>
Date:   Tue, 21 Jun 2022 01:04:26 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Paul Menzel <pmenzel@molgen.mpg.de>, linfeilong@huawei.com,
        lixiaokeng@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <90355833-EC43-4DE0-B925-8F3F8E887707@suse.de>
References: <fd86d427-2d3e-b337-6de8-d70dcbbd6ce1@huawei.com>
 <35fd23fc-4f3d-a6fe-c4b1-79a7b09acead@huawei.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Guanghao,


> 2022=E5=B9=B46=E6=9C=889=E6=97=A5 11:06=EF=BC=8CWu Guanghao =
<wuguanghao3@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> char *sysdev =3D xstrdup() but not free() in for loop, will cause =
memory
> leak.
>=20
> Reported-by: Coverity


The Reported-by tag might be incorrect. Maybe I am wrong but this is the =
first time I see a non-email reporter here.
Here I copy and past the Reported-by: tag explanation from Linux kernel =
document, I guess the meaning should be similar,

The Reported-by tag gives credit to people who find bugs and report them =
and it
hopefully inspires them to help us again in the future.  Please note =
that if
the bug was reported in private, then ask for permission first before =
using the
Reported-by tag. The tag is intended for bugs; please do not use it to =
credit
feature requests.

So you may have an email address for the Reported-by tag, for example =
the Hulk robot in Linux kernel patches from Huawei,
    Reported-by: Hulk Robot <hulkci@huawei.com>

Could you please to update all the Reported-by tags for the series? Then =
I will start to review the patches.

Thanks.

Coly Li


> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
> Detail.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/Detail.c b/Detail.c
> index ce7a8445..4ef26460 100644
> --- a/Detail.c
> +++ b/Detail.c
> @@ -303,6 +303,7 @@ int Detail(char *dev, struct context *c)
>                                if (path)
>                                        printf("MD_DEVICE_%s_DEV=3D%s\n",=

>                                               sysdev, path);
> +                               free(sysdev);
>                        }
>                }
>                goto out;
> --
> 2.27.0

