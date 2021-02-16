Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 65F3AC433E0
	for <linux-raid@archiver.kernel.org>; Tue, 16 Feb 2021 14:29:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1C99764DEC
	for <linux-raid@archiver.kernel.org>; Tue, 16 Feb 2021 14:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbhBPO3i (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 16 Feb 2021 09:29:38 -0500
Received: from us-smtp-delivery-124.mimecast.com ([170.10.133.124]:29313 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230104AbhBPO3e (ORCPT
        <rfc822;linux-raid@vger.kernel.org>);
        Tue, 16 Feb 2021 09:29:34 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1613485686;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=kT8OQv/AhVbJZfxFFIWK9G3TxTZ5snJNw2OyCKigk7Y=;
        b=aVomsOzdbFYhaZYGeo9FHXQuYaJfYaR/r77wFqZ4mKwIKhWNE0H7cGO5gYAbe7JFMnaCO3
        h56NqsYomel5Sr7uGY6XSvDSeFJjffr8mxGcTWLgMoFgf5ESplUzwOoTMyYOMRfK1Z8jIs
        hNZ2X/dXOqOR8c8ul9VruHUcDxhK/D4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-6-GW_9Y8NLMCi18l9WfEL_mw-1; Tue, 16 Feb 2021 09:28:05 -0500
X-MC-Unique: GW_9Y8NLMCi18l9WfEL_mw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 081F2814304;
        Tue, 16 Feb 2021 14:28:04 +0000 (UTC)
Received: from ovpn-113-83.rdu2.redhat.com (ovpn-113-83.rdu2.redhat.com [10.10.113.83])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 7D0FF60CE9;
        Tue, 16 Feb 2021 14:28:03 +0000 (UTC)
From:   Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain;
        charset=us-ascii
Content-Transfer-Encoding: quoted-printable
Mime-Version: 1.0 (Mac OS X Mail 14.0 \(3654.60.0.2.21\))
Subject: Re: [PATCH] mdadm: fix reshape from RAID5 to RAID6 with backup file
Date:   Tue, 16 Feb 2021 09:28:02 -0500
References: <20210120200542.19139-1-ncroxon@redhat.com>
To:     linux-raid@vger.kernel.org, jes@trained-monkey.org,
        Xiao Ni <xni@redhat.com>
In-Reply-To: <20210120200542.19139-1-ncroxon@redhat.com>
Message-Id: <8BA6E41D-F35C-4261-88BE-6A32EB27F57D@redhat.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Any update on accepting this patch ?

> On Jan 20, 2021, at 3:05 PM, Nigel Croxon <ncroxon@redhat.com> wrote:
>=20
> Reshaping a 3-disk RAID5 to 4-disk RAID6 will cause a hang of
> the resync after the grow.
>=20
> Adding a spare disk to avoid degrading the array when growing
> is successful, but not successful when supplying a backup file
> on the command line. If the reshape job is not already running,
> set the sync_max value to max.
>=20
> Signed-off-by: Nigel Croxon <ncroxon@redhat.com>
> ---
> Grow.c | 7 +++++--
> 1 file changed, 5 insertions(+), 2 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 6b8321c..5c2512f 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -931,12 +931,15 @@ int start_reshape(struct mdinfo *sra, int =
already_running,
> 	err =3D err ?: sysfs_set_num(sra, NULL, "sync_max", =
sync_max_to_set);
> 	if (!already_running && err =3D=3D 0) {
> 		int cnt =3D 5;
> +		int err2;
> 		do {
> 			err =3D sysfs_set_str(sra, NULL, "sync_action",
> 					    "reshape");
> -			if (err)
> +			err2 =3D sysfs_set_str(sra, NULL, "sync_max",
> +					    "max");
> +			if (err || err2)
> 				sleep(1);
> -		} while (err && errno =3D=3D EBUSY && cnt-- > 0);
> +		} while (err && err2 && errno =3D=3D EBUSY && cnt-- > =
0);
> 	}
> 	return err;
> }
> --=20
> 2.20.1
>=20

