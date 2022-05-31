Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C7441C433F5
	for <linux-raid@archiver.kernel.org>; Tue, 31 May 2022 17:50:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244911AbiEaRum (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 31 May 2022 13:50:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241081AbiEaRul (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 31 May 2022 13:50:41 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5595D9A9B2
        for <linux-raid@vger.kernel.org>; Tue, 31 May 2022 10:50:40 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0CC1B1FD3E;
        Tue, 31 May 2022 17:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1654019439; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vLiKbcGRfjTuQHnG7HcGndgas5ESSIf4IdYZElh6oI8=;
        b=KjZmoJMFB4Hg6QuWsPCO02F8OARbUtRDSH6NNuEP2NMlGqL7dUooCXpvyRLYcrzZdVUAQ7
        9QYQRgpcS59/wqEfFSky8R7tQjf/88dqceVBc4mB5fqqiqBbTO7z5wBaC6CEoHqkQ3DCth
        st7pgpzvCGWc5N6BydWg+FIVcLNuEqo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1654019439;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vLiKbcGRfjTuQHnG7HcGndgas5ESSIf4IdYZElh6oI8=;
        b=csnbJGZ7yGxEr+B8tksHCepTChLIWyOsmOCQ6K6s8ArDG2qTlfm/Sv51C0r7tkjBLyuMxH
        ls5b/KEyRoL57GAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 04AEE13AA2;
        Tue, 31 May 2022 17:50:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 82O2MG1VlmJVFwAAMHmgww
        (envelope-from <colyli@suse.de>); Tue, 31 May 2022 17:50:37 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 2/3 v2] imsm: use same slot across container
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220531102727.9315-3-mariusz.tkaczyk@linux.intel.com>
Date:   Wed, 1 Jun 2022 01:50:35 +0800
Cc:     jes@trained-monkey.org, linux-raid@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <E7F52F8C-52F7-4944-9CE9-172B935E24AA@suse.de>
References: <20220531102727.9315-1-mariusz.tkaczyk@linux.intel.com>
 <20220531102727.9315-3-mariusz.tkaczyk@linux.intel.com>
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B45=E6=9C=8831=E6=97=A5 18:27=EF=BC=8CMariusz Tkaczyk =
<mariusz.tkaczyk@linux.intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Autolayout relies on drives order on super->disks list, but
> it is not quaranted by readdir() in sysfs_read(). As a result
> drive could be put in different slot in second volume.
>=20
> Make it consistent by reffering to first volume, if exists.
>=20
> Use enum imsm_status to unify error handling.
>=20
> Signed-off-by: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>


Coly Li


> ---
> super-intel.c | 169 ++++++++++++++++++++++++++++++++------------------
> 1 file changed, 108 insertions(+), 61 deletions(-)
>=20
> diff --git a/super-intel.c b/super-intel.c
> index f0196948..3c02d2f6 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -7493,11 +7493,27 @@ static int =
validate_geometry_imsm_volume(struct supertype *st, int level,
> 	return 1;
> }
>=20
> -static int imsm_get_free_size(struct supertype *st, int raiddisks,
> -			 unsigned long long size, int chunk,
> -			 unsigned long long *freesize)
> +/**
> + * imsm_get_free_size() - get the biggest, common free space from =
members.
> + * @super: &intel_super pointer, not NULL.
> + * @raiddisks: number of raid disks.
> + * @size: requested size, could be 0 (means max size).
> + * @chunk: requested chunk.
> + * @freesize: pointer for returned size value.
> + *
> + * Return: &IMSM_STATUS_OK or &IMSM_STATUS_ERROR.
> + *
> + * @freesize is set to meaningful value, this can be @size, or =
calculated
> + * max free size.
> + * super->create_offset value is modified and set appropriately in
> + * merge_extends() for further creation.
> + */
> +static imsm_status_t imsm_get_free_size(struct intel_super *super,
> +					const int raiddisks,
> +					unsigned long long size,
> +					const int chunk,
> +					unsigned long long *freesize)
> {
> -	struct intel_super *super =3D st->sb;
> 	struct imsm_super *mpb =3D super->anchor;
> 	struct dl *dl;
> 	int i;
> @@ -7541,12 +7557,10 @@ static int imsm_get_free_size(struct supertype =
*st, int raiddisks,
> 		/* chunk is in K */
> 		minsize =3D chunk * 2;
>=20
> -	if (cnt < raiddisks ||
> -	    (super->orom && used && used !=3D raiddisks) ||
> -	    maxsize < minsize ||
> -	    maxsize =3D=3D 0) {
> +	if (cnt < raiddisks || (super->orom && used && used !=3D =
raiddisks) ||
> +	    maxsize < minsize || maxsize =3D=3D 0) {
> 		pr_err("not enough devices with space to create =
array.\n");
> -		return 0; /* No enough free spaces large enough */
> +		return IMSM_STATUS_ERROR;
> 	}
>=20
> 	if (size =3D=3D 0) {
> @@ -7559,37 +7573,69 @@ static int imsm_get_free_size(struct supertype =
*st, int raiddisks,
> 	}
> 	if (mpb->num_raid_devs > 0 && size && size !=3D maxsize)
> 		pr_err("attempting to create a second volume with size =
less then remaining space.\n");
> -	cnt =3D 0;
> -	for (dl =3D super->disks; dl; dl =3D dl->next)
> -		if (dl->e)
> -			dl->raiddisk =3D cnt++;
> -
> 	*freesize =3D size;
>=20
> 	dprintf("imsm: imsm_get_free_size() returns : %llu\n", size);
>=20
> -	return 1;
> +	return IMSM_STATUS_OK;
> }
>=20
> -static int reserve_space(struct supertype *st, int raiddisks,
> -			 unsigned long long size, int chunk,
> -			 unsigned long long *freesize)
> +/**
> + * autolayout_imsm() - automatically layout a new volume.
> + * @super: &intel_super pointer, not NULL.
> + * @raiddisks: number of raid disks.
> + * @size: requested size, could be 0 (means max size).
> + * @chunk: requested chunk.
> + * @freesize: pointer for returned size value.
> + *
> + * We are being asked to automatically layout a new volume based on =
the current
> + * contents of the container. If the parameters can be satisfied =
autolayout_imsm
> + * will record the disks, start offset, and will return size of the =
volume to
> + * be created. See imsm_get_free_size() for details.
> + * add_to_super() and getinfo_super() detect when autolayout is in =
progress.
> + * If first volume exists, slots are set consistently to it.
> + *
> + * Return: &IMSM_STATUS_OK on success, &IMSM_STATUS_ERROR otherwise.
> + *
> + * Disks are marked for creation via dl->raiddisk.
> + */
> +static imsm_status_t autolayout_imsm(struct intel_super *super,
> +				     const int raiddisks,
> +				     unsigned long long size, const int =
chunk,
> +				     unsigned long long *freesize)
> {
> -	struct intel_super *super =3D st->sb;
> -	struct dl *dl;
> -	int cnt;
> -	int rv =3D 0;
> +	int curr_slot =3D 0;
> +	struct dl *disk;
> +	int vol_cnt =3D super->anchor->num_raid_devs;
> +	imsm_status_t rv;
>=20
> -	rv =3D imsm_get_free_size(st, raiddisks, size, chunk, freesize);
> -	if (rv) {
> -		cnt =3D 0;
> -		for (dl =3D super->disks; dl; dl =3D dl->next)
> -			if (dl->e)
> -				dl->raiddisk =3D cnt++;
> -		rv =3D 1;
> +	rv =3D imsm_get_free_size(super, raiddisks, size, chunk, =
freesize);
> +	if (rv !=3D IMSM_STATUS_OK)
> +		return IMSM_STATUS_ERROR;
> +
> +	for (disk =3D super->disks; disk; disk =3D disk->next) {
> +		if (!disk->e)
> +			continue;
> +
> +		if (curr_slot =3D=3D raiddisks)
> +			break;
> +
> +		if (vol_cnt =3D=3D 0) {
> +			disk->raiddisk =3D curr_slot;
> +		} else {
> +			int _slot =3D get_disk_slot_in_dev(super, 0, =
disk->index);
> +
> +			if (_slot =3D=3D -1) {
> +				pr_err("Disk %s is not used in first =
volume, aborting\n",
> +				       disk->devname);
> +				return IMSM_STATUS_ERROR;
> +			}
> +			disk->raiddisk =3D _slot;
> +		}
> +		curr_slot++;
> 	}
>=20
> -	return rv;
> +	return IMSM_STATUS_OK;
> }
>=20
> static int validate_geometry_imsm(struct supertype *st, int level, int =
layout,
> @@ -7625,35 +7671,35 @@ static int validate_geometry_imsm(struct =
supertype *st, int level, int layout,
> 	}
>=20
> 	if (!dev) {
> -		if (st->sb) {
> -			struct intel_super *super =3D st->sb;
> -			if (!validate_geometry_imsm_orom(st->sb, level, =
layout,
> -							 raiddisks, =
chunk, size,
> -							 verbose))
> +		struct intel_super *super =3D st->sb;
> +
> +		/*
> +		 * Autolayout mode, st->sb and freesize must be set.
> +		 */
> +		if (!super || !freesize) {
> +			pr_vrb("freesize and superblock must be set for =
autolayout, aborting\n");
> +			return 1;
> +		}
> +
> +		if (!validate_geometry_imsm_orom(st->sb, level, layout,
> +						 raiddisks, chunk, size,
> +						 verbose))
> +			return 0;
> +
> +		if (super->orom) {
> +			imsm_status_t rv;
> +			int count =3D count_volumes(super->hba, =
super->orom->dpa,
> +					      verbose);
> +			if (super->orom->vphba <=3D count) {
> +				pr_vrb("platform does not support more =
than %d raid volumes.\n",
> +				       super->orom->vphba);
> 				return 0;
> -			/* we are being asked to automatically layout a
> -			 * new volume based on the current contents of
> -			 * the container.  If the the parameters can be
> -			 * satisfied reserve_space will record the =
disks,
> -			 * start offset, and size of the volume to be
> -			 * created.  add_to_super and getinfo_super
> -			 * detect when autolayout is in progress.
> -			 */
> -			/* assuming that freesize is always given when =
array is
> -			   created */
> -			if (super->orom && freesize) {
> -				int count;
> -				count =3D count_volumes(super->hba,
> -						      super->orom->dpa, =
verbose);
> -				if (super->orom->vphba <=3D count) {
> -					pr_vrb("platform does not =
support more than %d raid volumes.\n",
> -					       super->orom->vphba);
> -					return 0;
> -				}
> 			}
> -			if (freesize)
> -				return reserve_space(st, raiddisks, =
size,
> -						     *chunk, freesize);
> +
> +			rv =3D autolayout_imsm(super, raiddisks, size, =
*chunk,
> +					     freesize);
> +			if (rv !=3D IMSM_STATUS_OK)
> +				return 0;
> 		}
> 		return 1;
> 	}
> @@ -11524,7 +11570,7 @@ enum imsm_reshape_type =
imsm_analyze_change(struct supertype *st,
> 	unsigned long long current_size;
> 	unsigned long long free_size;
> 	unsigned long long max_size;
> -	int rv;
> +	imsm_status_t rv;
>=20
> 	getinfo_super_imsm_volume(st, &info, NULL);
> 	if (geo->level !=3D info.array.level && geo->level >=3D 0 &&
> @@ -11643,9 +11689,10 @@ enum imsm_reshape_type =
imsm_analyze_change(struct supertype *st,
> 		}
> 		/* check the maximum available size
> 		 */
> -		rv =3D  imsm_get_free_size(st, =
dev->vol.map->num_members,
> -					 0, chunk, &free_size);
> -		if (rv =3D=3D 0)
> +		rv =3D imsm_get_free_size(super, =
dev->vol.map->num_members,
> +					0, chunk, &free_size);
> +
> +		if (rv !=3D IMSM_STATUS_OK)
> 			/* Cannot find maximum available space
> 			 */
> 			max_size =3D 0;
> --=20
> 2.26.2
>=20

