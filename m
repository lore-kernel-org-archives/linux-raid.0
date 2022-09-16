Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A459FECAAA1
	for <linux-raid@archiver.kernel.org>; Fri, 16 Sep 2022 15:04:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiIPPEJ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 16 Sep 2022 11:04:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231446AbiIPPEH (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 16 Sep 2022 11:04:07 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28608A6C4
        for <linux-raid@vger.kernel.org>; Fri, 16 Sep 2022 08:04:05 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 4F81C33C69;
        Fri, 16 Sep 2022 15:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663340644; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGWeuiur9NYzFanSW87QXG9d04zSoAYmVFeiWhbLaSc=;
        b=u8Y0GOlLR88iP4JyGLW89aCuIYj4HiSkIvPXZzaCMa6x9tD2gGR0BKohb3bnOwF9/+NAkM
        oJE5BhNlznu/gR6d2LC8PH37ZTc4jVa8lEtBzdOTrWlQAFt22ODMG+sYTqWhvWnwlo9Qbt
        cVEB8q//xA2OzwjI/pVvsp8TW1cpHqw=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663340644;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=hGWeuiur9NYzFanSW87QXG9d04zSoAYmVFeiWhbLaSc=;
        b=b9QmvgXRjnQEX6hUAdiZBejGhLc8VYvHlrSIJxAMxN+yrb7i2FHdzuNXF4GvP4pwKgO/RX
        jSNv5xYtgIsiCKDA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 29EC81346B;
        Fri, 16 Sep 2022 15:04:02 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id lngIN2KQJGNuZwAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 16 Sep 2022 15:04:02 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v2 1/2] mdadm: Add Documentation entries to systemd
 services
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220909135034.14397-2-mariusz.tkaczyk@linux.intel.com>
Date:   Fri, 16 Sep 2022 23:03:59 +0800
Cc:     Jes Sorensen <jes@trained-monkey.org>, felix.lechner@lease-up.com,
        linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <1AA9035E-B7D0-46A6-AFAD-DBE3FB17D561@suse.de>
References: <20220909135034.14397-1-mariusz.tkaczyk@linux.intel.com>
 <20220909135034.14397-2-mariusz.tkaczyk@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=889=E6=97=A5 21:50=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Add documentation section.
> Copied from Debian.
>=20
> Cc: Felix Lechner <felix.lechner@lease-up.com>
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li



> ---
> systemd/mdadm-grow-continue@.service | 1 +
> systemd/mdadm-last-resort@.service   | 1 +
> systemd/mdcheck_continue.service     | 3 ++-
> systemd/mdcheck_start.service        | 1 +
> systemd/mdmon@.service               | 1 +
> systemd/mdmonitor-oneshot.service    | 1 +
> systemd/mdmonitor.service            | 1 +
> 7 files changed, 8 insertions(+), 1 deletion(-)
>=20
> diff --git a/systemd/mdadm-grow-continue@.service =
b/systemd/mdadm-grow-continue@.service
> index 9fdc8ec..64b8254 100644
> --- a/systemd/mdadm-grow-continue@.service
> +++ b/systemd/mdadm-grow-continue@.service
> @@ -8,6 +8,7 @@
> [Unit]
> Description=3DManage MD Reshape on /dev/%I
> DefaultDependencies=3Dno
> +Documentation=3Dman:mdadm(8)
>=20
> [Service]
> ExecStart=3DBINDIR/mdadm --grow --continue /dev/%I
> diff --git a/systemd/mdadm-last-resort@.service =
b/systemd/mdadm-last-resort@.service
> index efeb3f6..e938112 100644
> --- a/systemd/mdadm-last-resort@.service
> +++ b/systemd/mdadm-last-resort@.service
> @@ -2,6 +2,7 @@
> Description=3DActivate md array %I even though degraded
> DefaultDependencies=3Dno
> ConditionPathExists=3D!/sys/devices/virtual/block/%i/md/sync_action
> +Documentation=3Dman:mdadm(8)
>=20
> [Service]
> Type=3Doneshot
> diff --git a/systemd/mdcheck_continue.service =
b/systemd/mdcheck_continue.service
> index 854317f..f532490 100644
> --- a/systemd/mdcheck_continue.service
> +++ b/systemd/mdcheck_continue.service
> @@ -7,7 +7,8 @@
>=20
> [Unit]
> Description=3DMD array scrubbing - continuation
> -ConditionPathExistsGlob =3D /var/lib/mdcheck/MD_UUID_*
> +ConditionPathExistsGlob=3D/var/lib/mdcheck/MD_UUID_*
> +Documentation=3Dman:mdadm(8)
>=20
> [Service]
> Type=3Doneshot
> diff --git a/systemd/mdcheck_start.service =
b/systemd/mdcheck_start.service
> index 3bb3d13..703a658 100644
> --- a/systemd/mdcheck_start.service
> +++ b/systemd/mdcheck_start.service
> @@ -8,6 +8,7 @@
> [Unit]
> Description=3DMD array scrubbing
> Wants=3Dmdcheck_continue.timer
> +Documentation=3Dman:mdadm(8)
>=20
> [Service]
> Type=3Doneshot
> diff --git a/systemd/mdmon@.service b/systemd/mdmon@.service
> index 7753395..97a1acd 100644
> --- a/systemd/mdmon@.service
> +++ b/systemd/mdmon@.service
> @@ -9,6 +9,7 @@
> Description=3DMD Metadata Monitor on /dev/%I
> DefaultDependencies=3Dno
> Before=3Dinitrd-switch-root.target
> +Documentation=3Dman:mdmon(8)
>=20
> [Service]
> # mdmon should never complain due to lack of a platform,
> diff --git a/systemd/mdmonitor-oneshot.service =
b/systemd/mdmonitor-oneshot.service
> index 373955a..ba86b44 100644
> --- a/systemd/mdmonitor-oneshot.service
> +++ b/systemd/mdmonitor-oneshot.service
> @@ -7,6 +7,7 @@
>=20
> [Unit]
> Description=3DReminder for degraded MD arrays
> +Documentation=3Dman:mdadm(8)
>=20
> [Service]
> Environment=3DMDADM_MONITOR_ARGS=3D--scan
> diff --git a/systemd/mdmonitor.service b/systemd/mdmonitor.service
> index 46f7b88..9c36478 100644
> --- a/systemd/mdmonitor.service
> +++ b/systemd/mdmonitor.service
> @@ -8,6 +8,7 @@
> [Unit]
> Description=3DMD array monitor
> DefaultDependencies=3Dno
> +Documentation=3Dman:mdadm(8)
>=20
> [Service]
> Environment=3D  MDADM_MONITOR_ARGS=3D--scan
> --=20
> 2.26.2
>=20

