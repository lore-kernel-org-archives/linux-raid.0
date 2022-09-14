Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C178EC6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230100AbiINPDs (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:03:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229861AbiINPDm (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:03:42 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 019F478223
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:03:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 958971FD93;
        Wed, 14 Sep 2022 15:03:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167816; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bPNTaVMbERvUugZV9yr79YnIPpoU304sLAIwO5jXT8k=;
        b=r3mz9YGwiZ/F9PizgVMgak7BY6uLfzsiIisSfv6Dajsc4O5BYfG9Avh1qdyE7AfPPst9KD
        DN4A/ZjUk7CtV7ex5k5SSVED5KJAg+7vauSWEh84IN6UZr0fFrBHy4d5fUlgyL9HGisnUy
        dU+3I9UamzcHB76biosenId/TPoLZsk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167816;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bPNTaVMbERvUugZV9yr79YnIPpoU304sLAIwO5jXT8k=;
        b=+SwCMGk1Bc4xoLwprD0Yw7VUBqFM0RlpTwkZQIOqImjeUTvGCINBhtU42TrOPFxWtqcxm3
        MXsV2jRBSUnSouDw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 85BC6134B3;
        Wed, 14 Sep 2022 15:03:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 8KIlEEftIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:03:35 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 08/10] Change update to enum in update_super and
 update_subarray
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-9-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:03:34 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9415B7D0-E2D6-486D-8143-AE53ED7657EF@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-9-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Use already existing enum, change update_super and update_subarray
> update to enum globally.
> Refactor function references also.
> Remove code specific options from update_options.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>
> ---
> Assemble.c    | 14 +++++++++-----
> Examine.c     |  2 +-
> Grow.c        |  9 +++++----
> Manage.c      | 14 ++++++++------
> maps.c        | 21 ---------------------
> mdadm.h       | 12 +++++++++---
> super-intel.c | 16 ++++++++--------
> super0.c      |  9 ++++-----
> super1.c      | 17 ++++++++---------
> 9 files changed, 52 insertions(+), 62 deletions(-)
>=20
>=20

[snipped]

> diff --git a/mdadm.h b/mdadm.h
> index 7bc31b16..afc2e2a8 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1010,7 +1010,7 @@ extern struct superswitch {
> 	 *                    it will resume going in the opposite =
direction.
> 	 */
> 	int (*update_super)(struct supertype *st, struct mdinfo *info,
> -			    char *update,
> +			    enum update_opt update,
> 			    char *devname, int verbose,
> 			    int uuid_set, char *homehost);
>=20
> @@ -1136,9 +1136,15 @@ extern struct superswitch {
> 	/* Permit subarray's to be deleted from inactive containers */
> 	int (*kill_subarray)(struct supertype *st,
> 			     char *subarray_id); /* optional */
> -	/* Permit subarray's to be modified */
> +	/**
> +	 * update_subarray() - Permit subarray to be modified.
> +	 * @st: Supertype.
> +	 * @subarray: Subarray name.
> +	 * @update: Update option.
> +	 * @ident: Optional identifiers.
> +	 */

Maybe we should follow existing comment code style like,

/* Commet start here,
 * and second line.
 */

This patch doesn=E2=80=99t apply on latest mdadm upstream, in the =
mdadm-CI tree, I rebased the patch and push it into =
remotes/origin/20220903-testing.
Could you please to check the rebased patch?

Thanks.

Coly Li=
