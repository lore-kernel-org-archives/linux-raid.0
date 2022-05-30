Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 930F8C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 30 May 2022 10:21:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231720AbiE3KVU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 30 May 2022 06:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235201AbiE3KVS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 30 May 2022 06:21:18 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3D807C161
        for <linux-raid@vger.kernel.org>; Mon, 30 May 2022 03:21:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 671861FA84;
        Mon, 30 May 2022 10:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1653906075; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCGgRKYRDrc5DZpq77JPrrwlZE2+q/e8t1Qo+u+KAJU=;
        b=iBu3kfrlzOTpOHuxSLiFpLsFUbprLnUQaPYEQ3aGQqZIlTsiX8o6WkO+mu2OrCxbXMcYp7
        2CcHZjd1wSATfHNl9sA526NaoLzeCGsJo+t8l3anv6fC+h8RpqI4zD0dyE0CQ28VpfE1kO
        z4DgzWVMqiZGLdFVw7gpdK8dg2THdw0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1653906075;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OCGgRKYRDrc5DZpq77JPrrwlZE2+q/e8t1Qo+u+KAJU=;
        b=HRumxPWApIs7PGGRq7ozgQ9DzXJ/TlhgfRg2ofjnjAARfsCvK0cVXF1KMY4H49lhZVXEa2
        TzTP1NZ9WYoQ4rAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 90F0813AFD;
        Mon, 30 May 2022 10:21:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 2CXFFpqalGI2TQAAMHmgww
        (envelope-from <colyli@suse.de>); Mon, 30 May 2022 10:21:14 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 1/3] imsm: introduce get_disk_slot_in_dev()
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220419143714.16942-2-mariusz.tkaczyk@linux.intel.com>
Date:   Mon, 30 May 2022 18:21:11 +0800
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <D90E9CCE-8CFC-4470-B7E2-B07191E89BB0@suse.de>
References: <20220419143714.16942-1-mariusz.tkaczyk@linux.intel.com>
 <20220419143714.16942-2-mariusz.tkaczyk@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Mariusz,

I reply my comments in line.

> 2022=E5=B9=B44=E6=9C=8819=E6=97=A5 22:37=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> The routine was added to remove unnecessary get_imsm_dev() and
> get_imsm_map() calls, used only to determine disk slot.
>=20
> Additionally, enum for IMSM return statues was added for further =
usage.
>=20
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
> ---
> super-intel.c | 46 +++++++++++++++++++++++++++++++++++-----------
> 1 file changed, 35 insertions(+), 11 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index d5fad102..c16251c8 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -366,6 +366,17 @@ struct migr_record {
> };
> ASSERT_SIZE(migr_record, 128)
>=20
> +/**
> + * enum imsm_status - internal IMSM return values representation.
> + * @STATUS_OK: function succeeded.
> + * @STATUS_ERROR: General error ocurred (not specified).
> + */
> +enum {
> +	IMSM_STATUS_OK =3D 0,
> +	IMSM_STATUS_ERROR =3D -1,
> +
> +} imsm_status;


To minimize code reading confusion, it might be better to declare =
IMSM_STATUS_ERROR before IMSM_STATUS_OK, since IMSM_STATUS_OK is =
negative value.
For the rested part, they look good to me.

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li



> +
> struct md_list {
> 	/* usage marker:
> 	 *  1: load metadata
> @@ -1151,7 +1162,7 @@ static void set_imsm_ord_tbl_ent(struct imsm_map =
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
> @@ -1162,7 +1173,7 @@ static int get_imsm_disk_slot(struct imsm_map =
*map, unsigned idx)
> 			return slot;
> 	}
>=20
> -	return -1;
> +	return IMSM_STATUS_ERROR;
> }
>=20
> static int get_imsm_raid_level(struct imsm_map *map)
> @@ -1177,6 +1188,23 @@ static int get_imsm_raid_level(struct imsm_map =
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
> @@ -1193,13 +1221,9 @@ static int count_memberships(struct dl *dl, =
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
> @@ -1909,6 +1933,7 @@ void examine_migr_rec_imsm(struct intel_super =
*super)
>=20
> 		/* first map under migration */
> 		map =3D get_imsm_map(dev, MAP_0);
> +
> 		if (map)
> 			slot =3D get_imsm_disk_slot(map, =
super->disks->index);
> 		if (map =3D=3D NULL || slot > 1 || slot < 0) {
> @@ -9629,10 +9654,9 @@ static int apply_update_activate_spare(struct =
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

