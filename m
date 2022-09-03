Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2F8C0ECAAD4
	for <linux-raid@archiver.kernel.org>; Sat,  3 Sep 2022 08:39:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiICIjE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Sep 2022 04:39:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiICIjC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Sep 2022 04:39:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5389D570C
        for <linux-raid@vger.kernel.org>; Sat,  3 Sep 2022 01:39:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 83E7F1FE74;
        Sat,  3 Sep 2022 08:39:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662194340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pyVxDDxk2IkRxwJSBx3mIB7FD+XLx7pdyK7LRzo/iI4=;
        b=pcsdu69d9OnDFl76hYMo32bqpn9pGdiu1e4SmvqcgPfRwPY6Qv0Cp1GmL9o7OdwTVmPtdd
        piCDOO0Xzzf1WiYof5oNuI11++OZgmwko139sYL/leH8zGjlkeukRd4Rds+PNvGlXiGxS3
        WvShvTgwS4h0VOYDsqymeqKVU2Xs/Lc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662194340;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pyVxDDxk2IkRxwJSBx3mIB7FD+XLx7pdyK7LRzo/iI4=;
        b=CNbzGXa3tr0qOWB+Js+RGSro4oXK+3JTv8Jc5o747iX3l0Rsimal35g2vsSR+Gayl40FbM
        GHePujaEgTY/XiDg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E86B0139F9;
        Sat,  3 Sep 2022 08:38:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZhW9K6ISE2MDcAAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 03 Sep 2022 08:38:58 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 3/5 v2] load_imsm_mpb: fix double free
From:   Coly Li <colyli@suse.de>
In-Reply-To: <2b2cdeac-d052-bd11-a3d6-d82d9b3fe10e@huawei.com>
Date:   Sat, 3 Sep 2022 16:38:56 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <D258B7B2-CFB5-4C02-8174-039D489118F1@suse.de>
References: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
 <2b2cdeac-d052-bd11-a3d6-d82d9b3fe10e@huawei.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=882=E6=97=A5 10:16=EF=BC=8CWu Guanghao =
<wuguanghao3@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> When free(super->buf) but not set super->buf =3D NULL, will be double =
free
>=20
> get_super_block
>        err =3D load_and_parse_mpb
>                load_imsm_mpb(.., s, ..)
>                        if (posix_memalign(&super->buf, =
MAX_SECTOR_SIZE, super->len) !=3D 0) // true, super->buf !=3D NULL
>                        if (posix_memalign(&super->migr_rec_buf, =
MAX_SECTOR_SIZE,); // false
>                                free(super->buf); //but super->buf not =
set NULL
>                                return 2;
>=20
>        if err ! =3D 0
>                if (s)
>                        free_imsm(s)
>                                 __free_imsm(s)
>                                        if (s)
>                                                free(s->buf); //double =
free
>=20
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
> super-intel.c | 1 +
> 1 file changed, 1 insertion(+)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index 4ddfcf94..ddbdd3e1 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -4510,6 +4510,7 @@ static int load_imsm_mpb(int fd, struct =
intel_super *super, char *devname)
>            MIGR_REC_BUF_SECTORS*MAX_SECTOR_SIZE) !=3D 0) {
>                pr_err("could not allocate migr_rec buffer\n");
>                free(super->buf);
> +               super->buf =3D NULL;
>                return 2;
>        }
>        super->clean_migration_record_by_mdmon =3D 0;
> --
> 2.27.0

