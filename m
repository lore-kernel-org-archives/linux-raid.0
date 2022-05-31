Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D4B6AC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 17:48:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346677AbiEaRsX (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 13:48:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346633AbiEaRsV (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 13:48:21 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E51D254691
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 10:48:17 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 773BE1FD3C;
        Tue, 31 May 2022 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654019296; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NhcUYPERS0+1j26BcSRIP7CSNG0OleHp6euBAMcXHCU=;
        b=y6MgTTI8NVmMFh4zLBsejgBnyDBhfNtWaVEVKthAYcpZ5hKkw4PrAZZiv6Tc8fPCij7M3Q
        BB9llUHtwYAbPjYyzHPVMjyye2wN1KnodL1NMS13ODkys6EuzyexIHqYOLnmilyFEwhI8Y
        FlS7DTkLmudKBj248rkirO5PnVc0UJo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654019296;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=NhcUYPERS0+1j26BcSRIP7CSNG0OleHp6euBAMcXHCU=;
        b=sOhR5LK+hJEcN8jfn2XeoEEDanRcHtdtGLPiNo3P0ZzEuU2UeU6D2QxSpsBgH/RIvKuDIw
        8T/gVeXEid6oN4Cw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id C46EC13AA2;
        Tue, 31 May 2022 17:48:15 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cu+nJd9UlmIsFgAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 31 May 2022 17:48:15 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 1/3 v2] imsm: introduce get_disk_slot_in_dev()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220531102727.9315-2-mariusz.tkaczyk@linux.intel.com>
Date:   Wed, 1 Jun 2022 01:48:13 +0800
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <261C4581-6320-4838-AB01-F150FA3E9F5E@suse.de>
References: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
 <20220531102727.9315-2-mariusz.tkaczyk@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B45=E6=9C=8831=E6=97=A5 18:27=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> The routine was added to remove unnecessary get_imsm_dev() and
> get_imsm_map() calls, used only to determine disk slot.
>=20
> Additionally, enum for IMSM return statues was added for further =
usage.
>=20
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
> super-intel.c | 47 ++++++++++++++++++++++++++++++++++++-----------
> 1 file changed, 36 insertions(+), 11 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index d5fad102..f0196948 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -366,6 +366,18 @@ struct migr_record {
> };
> ASSERT_SIZE(migr_record, 128)
>=20
> +/**
> + * enum imsm_status - internal IMSM return values representation.
> + * @STATUS_OK: function succeeded.
> + * @STATUS_ERROR: General error ocurred (not specified).
> + *
> + * Typedefed to imsm_status_t.
> + */
> +typedef enum imsm_status {
> +	IMSM_STATUS_ERROR =3D -1,
> +	IMSM_STATUS_OK =3D 0,
> +} imsm_status_t;
> +
> struct md_list {
> 	/* usage marker:
> 	 *  1: load metadata
> @@ -1151,7 +1163,7 @@ static void set_imsm_ord_tbl_ent(struct imsm_map =
*map, int slot, __u32 ord)
> 	map->disk_ord_tbl[slot] =3D __cpu_to_le32(ord);
> }
>=20
> -static int get_imsm_disk_slot(struct imsm_map *map, unsigned idx)
> +static int get_imsm_disk_slot(struct imsm_map *map, const unsigned =
int idx)
> {
> 	int slot;
> 	__u32 ord;
> @@ -1162,7 +1174,7 @@ static int get_imsm_disk_slot(struct imsm_map =
*map, unsigned idx)
> 			return slot;
> 	}
>=20
> -	return -1;
> +	return IMSM_STATUS_ERROR;
> }
>=20
> static int get_imsm_raid_level(struct imsm_map *map)
> @@ -1177,6 +1189,23 @@ static int get_imsm_raid_level(struct imsm_map =
*map)
> 	return map->raid_level;
> }
>=20
> +/**
> + * get_disk_slot_in_dev() - retrieve disk slot from &imsm_dev.
> + * @super: &intel_super pointer, not NULL.
> + * @dev_idx: imsm device index.
> + * @idx: disk index.
> + *
> + * Return: Slot on success, IMSM_STATUS_ERROR otherwise.
> + */
> +static int get_disk_slot_in_dev(struct intel_super *super, const __u8 =
dev_idx,
> +				const unsigned int idx)
> +{
> +	struct imsm_dev *dev =3D get_imsm_dev(super, dev_idx);
> +	struct imsm_map *map =3D get_imsm_map(dev, MAP_0);
> +
> +	return get_imsm_disk_slot(map, idx);
> +}
> +
> static int cmp_extent(const void *av, const void *bv)
> {
> 	const struct extent *a =3D av;
> @@ -1193,13 +1222,9 @@ static int count_memberships(struct dl *dl, =
struct intel_super *super)
> 	int memberships =3D 0;
> 	int i;
>=20
> -	for (i =3D 0; i < super->anchor->num_raid_devs; i++) {
> -		struct imsm_dev *dev =3D get_imsm_dev(super, i);
> -		struct imsm_map *map =3D get_imsm_map(dev, MAP_0);
> -
> -		if (get_imsm_disk_slot(map, dl->index) >=3D 0)
> +	for (i =3D 0; i < super->anchor->num_raid_devs; i++)
> +		if (get_disk_slot_in_dev(super, i, dl->index) >=3D 0)
> 			memberships++;
> -	}
>=20
> 	return memberships;
> }
> @@ -1909,6 +1934,7 @@ void examine_migr_rec_imsm(struct intel_super =
*super)
>=20
> 		/* first map under migration */
> 		map =3D get_imsm_map(dev, MAP_0);
> +
> 		if (map)
> 			slot =3D get_imsm_disk_slot(map, =
super->disks->index);
> 		if (map =3D=3D NULL || slot > 1 || slot < 0) {
> @@ -9629,10 +9655,9 @@ static int apply_update_activate_spare(struct =
imsm_update_activate_spare *u,
> 		/* count arrays using the victim in the metadata */
> 		found =3D 0;
> 		for (a =3D active_array; a ; a =3D a->next) {
> -			dev =3D get_imsm_dev(super, =
a->info.container_member);
> -			map =3D get_imsm_map(dev, MAP_0);
> +			int dev_idx =3D a->info.container_member;
>=20
> -			if (get_imsm_disk_slot(map, victim) >=3D 0)
> +			if (get_disk_slot_in_dev(super, dev_idx, victim) =
>=3D 0)
> 				found++;
> 		}
>=20
> --=20
> 2.26.2
>=20

