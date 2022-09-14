Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB473ECAAD3
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 14:49:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229941AbiINOtd (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 10:49:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiINOtb (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 10:49:31 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 251152E6
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 07:49:28 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id D59E433990;
        Wed, 14 Sep 2022 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663166966; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOQwPgEWOY+KzZX9jLp7nQzjQopFm9DbiRa4zI4reHU=;
        b=EZrnFFIzqjw75jCpoUi9/YOOcy13KU2zQNW6pOI66bTxcdxRmvO2eT6n138LvUh5mOXwiE
        KmTn/duNj9Gf27/CwxlapMcsIq/o92FfBuCbAKdghNgoDfK8EtTlGQKwRTP0RvI2f3Ebte
        zNTLzek+E0bmceHiMKNECrD2ZjYHptg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663166966;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IOQwPgEWOY+KzZX9jLp7nQzjQopFm9DbiRa4zI4reHU=;
        b=fiExIVr+/m1Jyo65hc8J70Aocaero/krprAYLTryt7Y9GrUW9BA581iLp7B7XdDGy4S2X0
        +5okO13v30CzsaAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E61F1134B3;
        Wed, 14 Sep 2022 14:49:25 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id ZDmdDvXpIWOoPgAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 14:49:25 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH v4] mdadm: replace container level checking with inline
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220902064923.19955-1-kinga.tanska@intel.com>
Date:   Wed, 14 Sep 2022 22:49:22 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <3BA9DBF6-5BE5-4EDD-BABB-23B2FA58A074@suse.de>
References: <20220902064923.19955-1-kinga.tanska@intel.com>
To:     Kinga Tanska <kinga.tanska@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B49=E6=9C=882=E6=97=A5 14:49=EF=BC=8CKinga Tanska =
<kinga.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> To unify all containers checks in code, is_container() function is
> added and propagated.
>=20
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>

Acked-by: Coly Li <colyli@suse.de>

BTW, this patch doesn=E2=80=99t apply due to conflict with other =
under-review patches. I rebased the conflict and push it to branch =
refs/heads/20220903-testing from the mdadm-CI repo. Could you please to =
check and confirm this version? If it is OK, you may use this version to =
submit to Jes with my Acked-by.

Thanks.

Coly Li


> ---
> Assemble.c    |  7 +++----
> Create.c      |  6 +++---
> Grow.c        |  6 +++---
> Incremental.c |  4 ++--
> mdadm.h       | 14 ++++++++++++++
> super-ddf.c   |  6 +++---
> super-intel.c |  4 ++--
> super0.c      |  2 +-
> super1.c      |  2 +-
> sysfs.c       |  2 +-
> 10 files changed, 33 insertions(+), 20 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 1dd82a8c..8b0af0c9 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1120,7 +1120,7 @@ static int start_array(int mdfd,
> 			       i/2, mddev);
> 	}
>=20
> -	if (content->array.level =3D=3D LEVEL_CONTAINER) {
> +	if (is_container(content->array.level)) {
> 		sysfs_rules_apply(mddev, content);
> 		if (c->verbose >=3D 0) {
> 			pr_err("Container %s has been assembled with %d =
drive%s",
> @@ -1549,8 +1549,7 @@ try_again:
> 			 */
> 			trustworthy =3D LOCAL;
>=20
> -		if (name[0] =3D=3D 0 &&
> -		    content->array.level =3D=3D LEVEL_CONTAINER) {
> +		if (!name[0] && is_container(content->array.level)) {
> 			name =3D content->text_version;
> 			trustworthy =3D METADATA;
> 		}
> @@ -1809,7 +1808,7 @@ try_again:
> 		}
> #endif
> 	}
> -	if (c->force && !clean && content->array.level !=3D =
LEVEL_CONTAINER &&
> +	if (c->force && !clean && !is_container(content->array.level) &&
> 	    !enough(content->array.level, content->array.raid_disks,
> 		    content->array.layout, clean, avail)) {
> 		change +=3D st->ss->update_super(st, content, =
"force-array",
> diff --git a/Create.c b/Create.c
> index e06ec2ae..953e7372 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -487,7 +487,7 @@ int Create(struct supertype *st, char *mddev,
> 			    st->minor_version >=3D 1)
> 				/* metadata at front */
> 				warn |=3D check_partitions(fd, dname, 0, =
0);
> -			else if (s->level =3D=3D 1 || s->level =3D=3D =
LEVEL_CONTAINER ||
> +			else if (s->level =3D=3D 1 || =
is_container(s->level) ||
> 				 (s->level =3D=3D 0 && s->raiddisks =3D=3D=
 1))
> 				/* partitions could be meaningful */
> 				warn |=3D check_partitions(fd, dname, =
freesize*2, s->size*2);
> @@ -997,7 +997,7 @@ int Create(struct supertype *st, char *mddev,
> 			 * again returns container info.
> 			 */
> 			st->ss->getinfo_super(st, &info_new, NULL);
> -			if (st->ss->external && s->level !=3D =
LEVEL_CONTAINER &&
> +			if (st->ss->external && !is_container(s->level) =
&&
> 			    !same_uuid(info_new.uuid, info.uuid, 0)) {
> 				map_update(&map, fd2devnm(mdfd),
> 					   info_new.text_version,
> @@ -1040,7 +1040,7 @@ int Create(struct supertype *st, char *mddev,
> 	map_unlock(&map);
> 	free(infos);
>=20
> -	if (s->level =3D=3D LEVEL_CONTAINER) {
> +	if (is_container(s->level)) {
> 		/* No need to start.  But we should signal udev to
> 		 * create links */
> 		sysfs_uevent(&info, "change");
> diff --git a/Grow.c b/Grow.c
> index 0f07a894..e362403a 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -2175,7 +2175,7 @@ size_change_error:
> 					devname, s->size);
> 		}
> 		changed =3D 1;
> -	} else if (array.level !=3D LEVEL_CONTAINER) {
> +	} else if (!is_container(array.level)) {
> 		s->size =3D get_component_size(fd)/2;
> 		if (s->size =3D=3D 0)
> 			s->size =3D array.size;
> @@ -2231,7 +2231,7 @@ size_change_error:
> 	info.component_size =3D s->size*2;
> 	info.new_level =3D s->level;
> 	info.new_chunk =3D s->chunk * 1024;
> -	if (info.array.level =3D=3D LEVEL_CONTAINER) {
> +	if (is_container(info.array.level)) {
> 		info.delta_disks =3D UnSet;
> 		info.array.raid_disks =3D s->raiddisks;
> 	} else if (s->raiddisks)
> @@ -2344,7 +2344,7 @@ size_change_error:
> 				printf("layout for %s set to %d\n",
> 				       devname, array.layout);
> 		}
> -	} else if (array.level =3D=3D LEVEL_CONTAINER) {
> +	} else if (is_container(array.level)) {
> 		/* This change is to be applied to every array in the
> 		 * container.  This is only needed when the metadata =
imposes
> 		 * restraints of the various arrays in the container.
> diff --git a/Incremental.c b/Incremental.c
> index 4d0cd9d6..5a5f4c4c 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -244,7 +244,7 @@ int Incremental(struct mddev_dev *devlist, struct =
context *c,
> 		c->autof =3D ci->autof;
>=20
> 	name_to_use =3D info.name;
> -	if (name_to_use[0] =3D=3D 0 && info.array.level =3D=3D =
LEVEL_CONTAINER) {
> +	if (name_to_use[0] =3D=3D 0 && is_container(info.array.level)) {
> 		name_to_use =3D info.text_version;
> 		trustworthy =3D METADATA;
> 	}
> @@ -472,7 +472,7 @@ int Incremental(struct mddev_dev *devlist, struct =
context *c,
>=20
> 	/* 7/ Is there enough devices to possibly start the array? */
> 	/* 7a/ if not, finish with success. */
> -	if (info.array.level =3D=3D LEVEL_CONTAINER) {
> +	if (is_container(info.array.level)) {
> 		char devnm[32];
> 		/* Try to assemble within the container */
> 		sysfs_uevent(sra, "change");
> diff --git a/mdadm.h b/mdadm.h
> index 941a5f38..3673494e 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1924,3 +1924,17 @@ enum r0layout {
>  * This is true for native and DDF, IMSM allows 16.
>  */
> #define MD_NAME_MAX 32
> +
> +/**
> + * is_container() - check if @level is &LEVEL_CONTAINER
> + * @level: level value
> + *
> + * return:
> + * 1 if level is equal to &LEVEL_CONTAINER, 0 otherwise.
> + */
> +static inline int is_container(const int level)
> +{
> +	if (level =3D=3D LEVEL_CONTAINER)
> +		return 1;
> +	return 0;
> +}
> diff --git a/super-ddf.c b/super-ddf.c
> index 949e7d15..9d1e3b94 100644
> --- a/super-ddf.c
> +++ b/super-ddf.c
> @@ -3325,7 +3325,7 @@ validate_geometry_ddf_container(struct supertype =
*st,
> 	int fd;
> 	unsigned long long ldsize;
>=20
> -	if (level !=3D LEVEL_CONTAINER)
> +	if (!is_container(level))
> 		return 0;
> 	if (!dev)
> 		return 1;
> @@ -3371,7 +3371,7 @@ static int validate_geometry_ddf(struct =
supertype *st,
>=20
> 	if (level =3D=3D LEVEL_NONE)
> 		level =3D LEVEL_CONTAINER;
> -	if (level =3D=3D LEVEL_CONTAINER) {
> +	if (is_container(level)) {
> 		/* Must be a fresh device to add to a container */
> 		return validate_geometry_ddf_container(st, level, =
raiddisks,
> 						       data_offset, dev,
> @@ -3488,7 +3488,7 @@ static int validate_geometry_ddf_bvd(struct =
supertype *st,
> 	struct dl *dl;
> 	unsigned long long maxsize;
> 	/* ddf/bvd supports lots of things, but not containers */
> -	if (level =3D=3D LEVEL_CONTAINER) {
> +	if (is_container(level)) {
> 		if (verbose)
> 			pr_err("DDF cannot create a container within an =
container\n");
> 		return 0;
> diff --git a/super-intel.c b/super-intel.c
> index 4d82af3d..b0565610 100644
> --- a/super-intel.c
> +++ b/super-intel.c
> @@ -6727,7 +6727,7 @@ static int =
validate_geometry_imsm_container(struct supertype *st, int level,
> 	struct intel_super *super =3D NULL;
> 	int rv =3D 0;
>=20
> -	if (level !=3D LEVEL_CONTAINER)
> +	if (!is_container(level))
> 		return 0;
> 	if (!dev)
> 		return 1;
> @@ -7692,7 +7692,7 @@ static int validate_geometry_imsm(struct =
supertype *st, int level, int layout,
> 	 * if given unused devices create a container
> 	 * if given given devices in a container create a member volume
> 	 */
> -	if (level =3D=3D LEVEL_CONTAINER)
> +	if (is_container(level))
> 		/* Must be a fresh device to add to a container */
> 		return validate_geometry_imsm_container(st, level, =
raiddisks,
> 							data_offset, =
dev,
> diff --git a/super0.c b/super0.c
> index 37f595ed..93876e2e 100644
> --- a/super0.c
> +++ b/super0.c
> @@ -1273,7 +1273,7 @@ static int validate_geometry0(struct supertype =
*st, int level,
> 	if (get_linux_version() < 3001000)
> 		tbmax =3D 2;
>=20
> -	if (level =3D=3D LEVEL_CONTAINER) {
> +	if (is_container(level)) {
> 		if (verbose)
> 			pr_err("0.90 metadata does not support =
containers\n");
> 		return 0;
> diff --git a/super1.c b/super1.c
> index 58345e68..0b505a7e 100644
> --- a/super1.c
> +++ b/super1.c
> @@ -2830,7 +2830,7 @@ static int validate_geometry1(struct supertype =
*st, int level,
> 	unsigned long long overhead;
> 	int fd;
>=20
> -	if (level =3D=3D LEVEL_CONTAINER) {
> +	if (is_container(level)) {
> 		if (verbose)
> 			pr_err("1.x metadata does not support =
containers\n");
> 		return 0;
> diff --git a/sysfs.c b/sysfs.c
> index 0d98a65f..ca1d888f 100644
> --- a/sysfs.c
> +++ b/sysfs.c
> @@ -763,7 +763,7 @@ int sysfs_add_disk(struct mdinfo *sra, struct =
mdinfo *sd, int resume)
>=20
> 	rv =3D sysfs_set_num(sra, sd, "offset", sd->data_offset);
> 	rv |=3D sysfs_set_num(sra, sd, "size", (sd->component_size+1) / =
2);
> -	if (sra->array.level !=3D LEVEL_CONTAINER) {
> +	if (!is_container(sra->array.level)) {
> 		if (sra->consistency_policy =3D=3D =
CONSISTENCY_POLICY_PPL) {
> 			rv |=3D sysfs_set_num(sra, sd, "ppl_sector", =
sd->ppl_sector);
> 			rv |=3D sysfs_set_num(sra, sd, "ppl_size", =
sd->ppl_size);
> --=20
> 2.26.2
>=20

