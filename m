Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9447AC4167B
	for <linux-raid@archiver.kernel.org>; Mon, 19 Dec 2022 16:08:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231572AbiLSQIG (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 19 Dec 2022 11:08:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbiLSQH7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 19 Dec 2022 11:07:59 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FF5CDF0E
        for <linux-raid@vger.kernel.org>; Mon, 19 Dec 2022 08:07:58 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 51764227DB;
        Mon, 19 Dec 2022 16:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1671466077; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mo19j+48JSBItjyI0lClLEokej/XNZZ4cmaD5eykrU=;
        b=r4OZ7J+K2HBRwNWqfzIvohLgMMnZbTadxAP/8UaAoXkCnXhzNVozwkvCuijVvPXifakXcJ
        xthKqetWpgmsJMpsJ8m569lGAe9EUvjsDr5oDeP6n4i195RYtRMDzp8KwoFLYT8JTvd7yq
        bXiQP58RmeeoN1TzxnBC/+VbSejYjnc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1671466077;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=0mo19j+48JSBItjyI0lClLEokej/XNZZ4cmaD5eykrU=;
        b=eN1KNdoulwCFi3JVtv6qup+y6YXa/h7D5XI2BwX934Z/MoUHTyseDa+TcQ4rhuuIoUO2Ig
        BiRhyTnkVrmLoFBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 85FE413910;
        Mon, 19 Dec 2022 16:07:56 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 9dT1FFyMoGO4aAAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 19 Dec 2022 16:07:56 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH 1/2] Monitor: block if monitor modes are combined.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221219095835.686-2-blazej.kucman@intel.com>
Date:   Tue, 20 Dec 2022 00:07:44 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <93D41FA4-A000-4E1C-AB81-30D7D8FCDA98@suse.de>
References: <20221219095835.686-1-blazej.kucman@intel.com>
 <20221219095835.686-2-blazej.kucman@intel.com>
To:     Blazej Kucman <blazej.kucman@intel.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B412=E6=9C=8819=E6=97=A5 17:58=EF=BC=8CBlazej Kucman =
<blazej.kucman@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Block monitoring start if --scan mode and MD devices list are =
combined.
>=20
> Signed-off-by: Blazej Kucman <blazej.kucman@intel.com>
> Change-Id: Ic2b90662dbd297e8e2c8e88194155d65110ef517

I guess Change-ID is unnecessary for mdadm upstream?

Otherwise, it is fine to me,

Acked-by: Coly Li <colyli@suse.de <mailto:colyli@suse.de>>

Thanks.

Coly Li


> ---
> Monitor.c | 7 ++++++-
> 1 file changed, 6 insertions(+), 1 deletion(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index 7d7dc4d2..119e17d8 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -123,7 +123,7 @@ int Monitor(struct mddev_dev *devlist,
> *  and if we can get_disk_info and find a name
> *  Then we hot-remove and hot-add to the other array
> *
> - * If devlist is NULL, then we can monitor everything because --scan
> + * If devlist is NULL, then we can monitor everything if --scan
> * was given.  We get an initial list from config file and add anything
> * that appears in /proc/mdstat
> */
> @@ -136,6 +136,11 @@ int Monitor(struct mddev_dev *devlist,
> struct mddev_ident *mdlist;
> int delay_for_event =3D c->delay;
>=20
> + if (devlist && c->scan) {
> + pr_err("Devices list and --scan option cannot be combined - not =
monitoring.\n");
> + return 1;
> + }
> +
> if (!mailaddr)
> mailaddr =3D conf_get_mailaddr();
>=20
> --=20
> 2.35.3
>=20

