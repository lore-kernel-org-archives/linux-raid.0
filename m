Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01026C6FA82
	for <linux-raid@archiver.kernel.org>; Sat,  3 Sep 2022 08:26:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiICI0P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Sep 2022 04:26:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICI0N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Sep 2022 04:26:13 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CAA087CAA7
        for <linux-raid@vger.kernel.org>; Sat,  3 Sep 2022 01:26:12 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 87E181F95E;
        Sat,  3 Sep 2022 08:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662193571; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Io1kR4LiPRAP4S5BiPbUqHb3pJPWHwomAOw/zWoJmh0=;
        b=Hy2gNlEpzTAhaE//d1WbVgP9T8MZ44YcoOcnbZ4f4sfYyju8/X+Gw5UYjpLsit9aEHPkza
        fAhv3SMn/0QI+Niqojd46nWPg+jTRG/f1D+9Xwqqo494aapq2ypX2okohy5h5F69YGTHnm
        qC4HZHyFtwZlqaGJuvRSQzheIpFC6mo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662193571;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Io1kR4LiPRAP4S5BiPbUqHb3pJPWHwomAOw/zWoJmh0=;
        b=zlH2Bm2MZCcKNRd+kvQSy9iCGZioK0F3rrFqSXeoD8eKAT3c145srcLL0jbaxM6ACMHVPl
        whfLctgp6vFpTABQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 23B6C139F9;
        Sat,  3 Sep 2022 08:26:09 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QDiLOKEPE2N9bAAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 03 Sep 2022 08:26:09 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 1/5 v2] parse_layout_faulty: fix memleak
From:   Coly Li <colyli@suse.de>
In-Reply-To: <19e8b467-a786-f42d-f07e-dfacae4f57c9@huawei.com>
Date:   Sat, 3 Sep 2022 16:26:09 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B1497379-1D1A-4373-A8E1-8734DBFC07D0@suse.de>
References: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
 <19e8b467-a786-f42d-f07e-dfacae4f57c9@huawei.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=882=E6=97=A5 10:15=EF=BC=8CWu Guanghao =
<wuguanghao3@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> char *m is allocated by xstrdup but not free() before return, will =
cause
> a memory leak
>=20
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
> util.c | 3 +++
> 1 file changed, 3 insertions(+)
>=20
> diff --git a/util.c b/util.c
> index 38f0420e..2e0f1de7 100644
> --- a/util.c
> +++ b/util.c
> @@ -427,8 +427,11 @@ int parse_layout_faulty(char *layout)
>        int ln =3D strcspn(layout, "0123456789");
>        char *m =3D xstrdup(layout);
>        int mode;
> +
>        m[ln] =3D 0;
>        mode =3D map_name(faultylayout, m);
> +       free(m);
> +
>        if (mode =3D=3D UnSet)
>                return -1;
>=20
> --
> 2.27.0

