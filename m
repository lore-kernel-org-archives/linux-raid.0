Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 73D72C6FA82
	for <linux-raid@archiver.kernel.org>; Sat,  3 Sep 2022 08:26:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231666AbiICI02 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sat, 3 Sep 2022 04:26:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229515AbiICI01 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sat, 3 Sep 2022 04:26:27 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62C2F9F0CA
        for <linux-raid@vger.kernel.org>; Sat,  3 Sep 2022 01:26:25 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 0E33C337C4;
        Sat,  3 Sep 2022 08:26:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1662193584; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zhmDv0riLXMSFb8+veEYn4rYTyXEgvvzFivKFHwO5is=;
        b=qqXLr9Oe04+VYn9sYOcqnf82FqMrDwHAFXTC+B+fYutw0BbLvW9ZGlPwFtg9ZlaqvvbBRS
        drYTw5FrxR2FjcTSNvO4WLvPutq246IqLjgg7k/X5d/RK+8XAR1QLbPvQpuoN9iZTamnbc
        ov3vVE+69wL9PUHfxcgnKWvkJsIZhIY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1662193584;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zhmDv0riLXMSFb8+veEYn4rYTyXEgvvzFivKFHwO5is=;
        b=6J5pgzhh3ofEF2SxFvAvkEbS0C4VoxbKItrIVEHXX6wo09h6RyqzRPahMU37FHdoWR3W/2
        7+EKVCN5i3AFg6DQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 8B86B139F9;
        Sat,  3 Sep 2022 08:26:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id IL0lFq4PE2N9bAAAMHmgww
        (envelope-from <colyli@suse.de>); Sat, 03 Sep 2022 08:26:22 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 2/5 v2] Detail: fix memleak
From:   Coly Li <colyli@suse.de>
In-Reply-To: <32551992-ff6d-3d42-51dd-54e0a69e0cfd@huawei.com>
Date:   Sat, 3 Sep 2022 16:26:21 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>, linux-raid@vger.kernel.org,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        linfeilong <linfeilong@huawei.com>, lixiaokeng@huawei.com
Content-Transfer-Encoding: quoted-printable
Message-Id: <A3CDE1B7-BEAF-408D-AE26-62A82E228415@suse.de>
References: <11b7eff6-56a0-49ee-b2fd-50b402c3dde1@huawei.com>
 <32551992-ff6d-3d42-51dd-54e0a69e0cfd@huawei.com>
To:     Wu Guanghao <wuguanghao3@huawei.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=882=E6=97=A5 10:15=EF=BC=8CWu Guanghao =
<wuguanghao3@huawei.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> char *sysdev =3D xstrdup() but not free() in for loop, will cause =
memory
> leak
>=20
> Signed-off-by: Wu Guanghao <wuguanghao3@huawei.com>
> Acked-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li

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

