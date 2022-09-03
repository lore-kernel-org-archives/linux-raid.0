Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EB33ECAAD4
	for <linux-raid@archiver.kernel.org>; Sat,  3 Sep 2022 08:25:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229666AbiICIZs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Sep 2022 04:25:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54194 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICIZq (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Sep 2022 04:25:46 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 531CA74353
        for <linux-raid@vger.kernel.org>; Sat,  3 Sep 2022 01:25:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0F8491FAC5;
        Sat,  3 Sep 2022 08:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662193545; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWEWBgqWWY4TWs4k5WabL6paFxJD/8v1KT2y+gXPcyE=;
        b=L4xyQm9EUijS0jT/UGAYyBVeNTwX9ngX1xlfbv21vmxnxrS/LxpOxng/2VzNOrrsfLY2vs
        W9imXEfg0DjKviSXShuis9JAtvQuTNE2mRwem1oRpuTENgGMmEPsJM0glM5gOYKfLVJBMc
        F6NnL3K324QRoaDz24HK23nXCrK4fH8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662193545;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pWEWBgqWWY4TWs4k5WabL6paFxJD/8v1KT2y+gXPcyE=;
        b=x/FkVtypVag0Log211b7Yzyri+WSVgd76iyTdJSIGNKs06Cek32zkFqK57J9n3faAII7N8
        AGuy+udg5QvTYNAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 9B390139F9;
        Sat,  3 Sep 2022 08:25:43 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id reTzGYcPE2N9bAAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 03 Sep 2022 08:25:43 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 5/5 v2] get_vd_num_of_subarray: fix memleak
From:   Coly Li <colyli@suse.de>
In-Reply-To: <62b32172-f3b5-8c32-0a74-77e8b18927d1@huawei.com>
Date:   Sat, 3 Sep 2022 16:25:40 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>,
        linux-raid <linux-raid@vger.kernel.org>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <33C0CE99-29C7-488B-A318-D8F08C57FDC2@suse.de>
References: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
 <62b32172-f3b5-8c32-0a74-77e8b18927d1@huawei.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=882=E6=97=A5 10:17=EF=BC=8CWu Guanghao =
<wuguanghao3@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> sra =3D sysfs_read() should be free before return in
> get_vd_num_of_subarray()
>=20
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Hi Guanghao,

I have a question for this patch, please correct me if I am wrong.



> ---
> super-ddf.c | 9 +++++++--
> 1 file changed, 7 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-ddf.c b/super-ddf.c
> index abbc8b09..6d4618fe 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -1599,15 +1599,20 @@ static unsigned int =
get_vd_num_of_subarray(struct supertype *st)
>        sra =3D sysfs_read(-1, st->devnm, GET_VERSION);
>        if (!sra || sra->array.major_version !=3D -1 ||
>            sra->array.minor_version !=3D -2 ||
> -           !is_subarray(sra->text_version))
> +           !is_subarray(sra->text_version)) {
> +               if (sra)
> +                       sysfs_free(sra);
>                return DDF_NOTFOUND;
> +       }
>=20
>        sub =3D strchr(sra->text_version + 1, '/');
>        if (sub !=3D NULL)
>                vcnum =3D strtoul(sub + 1, &end, 10);
>        if (sub =3D=3D NULL || *sub =3D=3D '\0' || *end !=3D '\0' ||
> -           vcnum >=3D be16_to_cpu(ddf->active->max_vd_entries))
> +           vcnum >=3D be16_to_cpu(ddf->active->max_vd_entries)) {
> +               sysfs_free(sra);
>                return DDF_NOTFOUND;
> +       }
>=20
>        return vcnum;


Before return vcnum, should call sysfs_free(sra) ?

Thank you in advance.

Coly Li



> }
> --
> 2.27.0

