Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 72B26C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbiINPDE (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiINPDC (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:03:02 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2A9074CD6
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:03:01 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 097EF1FD8C;
        Wed, 14 Sep 2022 15:03:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167780; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ahxk6+0x/M71fRSxJ+57L6O0Q/UzsRb268jM7Q6DaQ=;
        b=SFINgvLQurskRZWO3y9WltVE8cVHuqZ13/bFiisNSruov7evwUQ3XPqf4nDYk+oYOpUFzo
        F1KvQO8mHZEpOc5XWGFsIuVRz7rv6Vp89IesgsoPycZHWz0C0+bbciKbf4WRYLmTXCc29o
        KuyzIqbtKambrXiU66uZBlhmQ1GYCgQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167780;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/ahxk6+0x/M71fRSxJ+57L6O0Q/UzsRb268jM7Q6DaQ=;
        b=AXYNT5ca4v103WA9E+K4/dapPKhvHRlWxOg12Tf3NKE45MSbCStRnZY1S+Bn8ncV2/JUE7
        Kaked+eRVsumr+Ag==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 71B54134B3;
        Wed, 14 Sep 2022 15:02:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id EOluCyLtIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:02:58 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 03/10] Add code specific update options to enum.
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-4-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:02:57 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <CB0606CC-499B-46A5-90CD-12ECFA547042@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-4-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Some of update options aren't taken from user input, but are =
hard-coded
> as strings.
> Include those options in enum.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>

Acked-by: Coly Li <colyli@suse.de>


Thanks.

Coly Li


> ---
> maps.c  | 21 +++++++++++++++++++++
> mdadm.h | 15 +++++++++++++++
> 2 files changed, 36 insertions(+)
>=20
> diff --git a/maps.c b/maps.c
> index b586679a..c59036f1 100644
> --- a/maps.c
> +++ b/maps.c
> @@ -194,6 +194,27 @@ mapping_t update_options[] =3D {
> 	{ "byteorder", UOPT_BYTEORDER },
> 	{ "help", UOPT_HELP },
> 	{ "?", UOPT_HELP },
> +	/*
> +	 * Those enries are temporary and will be removed in this =
patchset.
> +	 *
> +	 * Before update_super:update can be changed to enum,
> +	 * all update_super sub-functions must be adapted first.
> +	 * Update options will be passed as string (as it is for now),
> +	 * and then mapped, so all options must be handled temporarily.
> +	 *
> +	 * Those options code specific and should not be accessible for =
user.
> +	 */
> +	{ "force-one", UOPT_SPEC_FORCE_ONE },
> +	{ "force-array", UOPT_SPEC_FORCE_ARRAY },
> +	{ "assemble", UOPT_SPEC_ASSEMBLE },
> +	{ "linear-grow-new", UOPT_SPEC_LINEAR_GROW_NEW },
> +	{ "linear-grow-update", UOPT_SPEC_LINEAR_GROW_UPDATE },
> +	{ "_reshape_progress", UOPT_SPEC__RESHAPE_PROGRESS },
> +	{ "writemostly", UOPT_SPEC_WRITEMOSTLY },
> +	{ "readwrite", UOPT_SPEC_READWRITE },
> +	{ "failfast", UOPT_SPEC_FAILFAST },
> +	{ "nofailfast", UOPT_SPEC_NOFAILFAST },
> +	{ "revert-reshape-nobackup", UOPT_SPEC_REVERT_RESHAPE_NOBACKUP =
},
> 	{ NULL, UOPT_UNDEFINED}
> };
>=20
> diff --git a/mdadm.h b/mdadm.h
> index 43e6b544..7bc31b16 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -523,6 +523,21 @@ enum update_opt {
> 	UOPT_LAYOUT_UNSPECIFIED,
> 	UOPT_BYTEORDER,
> 	UOPT_HELP,
> +	UOPT_USER_ONLY,
> +	/*
> +	 * Code specific options, cannot be set by the user
> +	 */
> +	UOPT_SPEC_FORCE_ONE,
> +	UOPT_SPEC_FORCE_ARRAY,
> +	UOPT_SPEC_ASSEMBLE,
> +	UOPT_SPEC_LINEAR_GROW_NEW,
> +	UOPT_SPEC_LINEAR_GROW_UPDATE,
> +	UOPT_SPEC__RESHAPE_PROGRESS,
> +	UOPT_SPEC_WRITEMOSTLY,
> +	UOPT_SPEC_READWRITE,
> +	UOPT_SPEC_FAILFAST,
> +	UOPT_SPEC_NOFAILFAST,
> +	UOPT_SPEC_REVERT_RESHAPE_NOBACKUP,
> 	UOPT_UNDEFINED
> };
> extern void fprint_update_options(FILE *outf, enum update_opt =
update_mode);
> --=20
> 2.26.2
>=20

