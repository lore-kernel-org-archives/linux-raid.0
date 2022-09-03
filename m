Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE141C6FA82
	for <linux-raid@archiver.kernel.org>; Sat,  3 Sep 2022 08:37:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiICIhV (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Sep 2022 04:37:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231128AbiICIhT (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Sep 2022 04:37:19 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEB5FD570C
        for <linux-raid@vger.kernel.org>; Sat,  3 Sep 2022 01:37:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 992D21FB76;
        Sat,  3 Sep 2022 08:37:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662194237; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tg83dXM7QgowKwPldjcxuYrHxvl31IMZ2Zb1sg98BpA=;
        b=OwAwj+nqfvxxoOAzHB/UwGKOpdjIf443LurXqX6IUwmPsjXepYLb2w8vkxijoUl48zBQk8
        cT4BONsK2r7Mdp4Gz9Z5i3fynDexPBwFSFHsZomtDqvCWA5W6HdtkE3uqQa+7z86+XFYg9
        dMGFDLYAhXEiKGaazKYsUIlCXTKY3Q4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662194237;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Tg83dXM7QgowKwPldjcxuYrHxvl31IMZ2Zb1sg98BpA=;
        b=GT1LIrHeKx/Dk3JEaCcFtuFVYrMz0CodUDGRWxQs0Ds39YqCkXCCFc5MmMIHK8K/jkjz7b
        fcC+ntUfN0BqYLBg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0DBAB139F9;
        Sat,  3 Sep 2022 08:37:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 7OdYMjsSE2OObwAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 03 Sep 2022 08:37:15 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 4/5 v2] find_disk_attached_hba: fix memleak
From:   Coly Li <colyli@suse.de>
In-Reply-To: <c9b240d7-cf0d-8a98-d1b5-9f4ae203526c@huawei.com>
Date:   Sat, 3 Sep 2022 16:37:13 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <B2CEFA0C-7E4F-4A2D-92C7-B3AB0452ABD2@suse.de>
References: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
 <c9b240d7-cf0d-8a98-d1b5-9f4ae203526c@huawei.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=882=E6=97=A5 10:16=EF=BC=8CWu Guanghao =
<wuguanghao3@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> If disk_path =3D diskfd_to_devpath(), we need free(disk_path) before
> return, otherwise there will be a memory leak
>=20
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> Reviewed-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

> ---
> super-intel.c | 4 ++--
> 1 file changed, 2 insertions(+), 2 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index ddbdd3e1..2a4019e7 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -713,12 +713,12 @@ static struct sys_dev* =
find_disk_attached_hba(int fd, const char *devname)
>=20
>        for (elem =3D list; elem; elem =3D elem->next)
>                if (path_attached_to_hba(disk_path, elem->path))
> -                       return elem;
> +                       break;
>=20
>        if (disk_path !=3D devname)
>                free(disk_path);
>=20
> -       return NULL;
> +       return elem;
> }
>=20
> static int find_intel_hba_capability(int fd, struct intel_super =
*super,
> --
> 2.27.0

