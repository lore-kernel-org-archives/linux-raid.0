Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6C6F2C04A68
	for <linux-raid@archiver.kernel.org>; Thu, 28 Jul 2022 16:30:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229625AbiG1Q36 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 28 Jul 2022 12:29:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229513AbiG1Q35 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 28 Jul 2022 12:29:57 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 200526FA1D
        for <linux-raid@vger.kernel.org>; Thu, 28 Jul 2022 09:29:56 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D5B511FCE8;
        Thu, 28 Jul 2022 16:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1659025794; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8MNG9/gqRnJk8PZ1m+ZA197BRDvj0d8uN5FHfERDmnI=;
        b=y9Rc/1VyikjQ23h0LssCiyPgyZrn6sVnb3RCou6eNDlHf7IlqabClRXgBibBkGF+JLbTwn
        v0kYS7U8exDDl3G5BAGXhSFGQDGDZCCzryRUrbYY2ID3BgyzHmp1l/l4fpS/2KP/e4bxnW
        FpCQYVKVDrXeJqF7ICrOXL5giLsTsiE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1659025794;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8MNG9/gqRnJk8PZ1m+ZA197BRDvj0d8uN5FHfERDmnI=;
        b=kphH4zVWpgpeSzl+kycQE4d+4tCDhLblNbcYm9OnLAkecllS9SX82dz4f4bx5nDe8LRtkQ
        zQ7bIYwe3CQrmTCA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A987013A7E;
        Thu, 28 Jul 2022 16:29:52 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id QukeEoC54mLCFAAAMHmgww
        (envelope-from <colyli@suse.de>); Thu, 28 Jul 2022 16:29:52 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.100.31\))
Subject: Re: [PATCH 2/2] Monitor: use snprintf to fill device name
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220714070211.9941-3-kinga.tanska@intel.com>
Date:   Fri, 29 Jul 2022 00:29:40 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <8C51EFAD-DF93-4724-A278-09B21D3BB567@suse.de>
References: <20220714070211.9941-1-kinga.tanska@intel.com>
 <20220714070211.9941-3-kinga.tanska@intel.com>
To:     Kinga Tanska <kinga.tanska@intel.com>
X-Mailer: Apple Mail (2.3696.100.31)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B47=E6=9C=8814=E6=97=A5 15:02=EF=BC=8CKinga Tanska =
<kinga.tanska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Safe string functions are propagated in Monitor.c.
>=20
> Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>


Personally I trends to avoid such change. The replacement for NAME by =
32, is not only in Monitor.c, it can be found in other files, for =
example the following result by =E2=80=98grep -nr \\\[32\\\]=E2=80=99,

Grow.c:3692:	char last_devnm[32] =3D "";
super-ddf.c:171:	__u8	header_ext[32];	/* reserved: fill with =
0xff */
super-ddf.c:356:	__u8	v0[32];	/* reserved- 0xff */
super-ddf.c:357:	__u8	v1[32];	/* reserved- 0xff */
super-ddf.c:360:	__u8	vendor[32];
super-ddf.c:405:	__u8	vendor[32];
sha1.h:84:  sha1_uint32 buffer[32];
Manage.c:160:	char nm[32], *nmp;
Manage.c:179:	char devnm[32];
Manage.c:180:	char container[32];
Manage.c:183:	char buf[32];
Manage.c:982:		char devnm[32];
Manage.c:1079:		char devnm[32];
mdstat.c:157:		char devnm[32];
lib.c:80:	static char devnm[32];
lib.c:123:	static char devnm[32];
util.c:1050:	char devname[32];
util.c:1179:	char container[32] =3D "";
sg_io.c:28:	unsigned char sense[32];
Incremental.c:476:		char devnm[32];
Incremental.c:1318:	char container[32];
Incremental.c:1699:	char buf[32];
Create.c:769:			char devnm[32];
super-intel.c:537:	char devnm[32];
super-intel.c:5250:	char nm[32];
super-intel.c:11246:	static char devnm[32];
super1.c:42:	char	set_name[32];	/* set and interpreted by =
user-space */
super1.c:1139:	info->name[32] =3D 0;
super1.c:1234:		info->name[32] =3D 0;
mapfile.c:183:	char devnm[32];
mdadm.h:357:	char		sys_name[32];
mdadm.h:622:	char		devnm[32];
mdadm.h:649:	char	devnm[32];
mdadm.h:1239:	char container_devnm[32];    /* devnm of container */
mdadm.h:1256:	char devnm[32]; /* e.g. md0.  This appears in =
metadata_version:
Monitor.c:37:	char devnm[32];	/* to sync with mdstat info */
Monitor.c:48:	char parent_devnm[32]; /* For subarray, devnm of parent.
Monitor.c:1127:	char devnm[32];
Monitor.c:1202:	char devnm[32];
mdopen.c:176:	char devnm[32];
mdopen.c:497:	static char devnm[32];

Many of them may related to the similar MD_NAME_MAX replace. Such =
replacement doesn=E2=80=99t fix real bug, but introduces many change to =
already working code. I don=E2=80=99t support such modification.

Maybe Jes has different opinion, this patch can be taken by him directly =
if he is fine with the change.

Thanks.

Coly Li


> ---
> Monitor.c | 37 ++++++++++++++-----------------------
> 1 file changed, 14 insertions(+), 23 deletions(-)
>=20
> diff --git a/Monitor.c b/Monitor.c
> index a5b11ae2..93f36ac0 100644
> --- a/Monitor.c
> +++ b/Monitor.c
> @@ -33,8 +33,8 @@
> #endif
>=20
> struct state {
> -	char *devname;
> -	char devnm[32];	/* to sync with mdstat info */
> +	char devname[MD_NAME_MAX + sizeof("/dev/md/")];	/* length of =
"/dev/md/" + device name + terminating byte*/
> +	char devnm[MD_NAME_MAX];	/* to sync with mdstat info */
> 	unsigned int utime;
> 	int err;
> 	char *spare_group;
> @@ -45,9 +45,9 @@ struct state {
> 	int devstate[MAX_DISKS];
> 	dev_t devid[MAX_DISKS];
> 	int percent;
> -	char parent_devnm[32]; /* For subarray, devnm of parent.
> -				* For others, ""
> -				*/
> +	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of =
parent.
> +					* For others, ""
> +					*/
> 	struct supertype *metadata;
> 	struct state *subarray;/* for a container it is a link to first =
subarray
> 				* for a subarray it is a link to next =
subarray
> @@ -187,15 +187,8 @@ int Monitor(struct mddev_dev *devlist,
> 				continue;
>=20
> 			st =3D xcalloc(1, sizeof *st);
> -			if (mdlist->devname[0] =3D=3D '/')
> -				st->devname =3D =
xstrdup(mdlist->devname);
> -			else {
> -				/* length of "/dev/md/" + device name + =
terminating byte */
> -				size_t _len =3D sizeof("/dev/md/") + =
strnlen(mdlist->devname, PATH_MAX);
> -
> -				st->devname =3D xcalloc(_len, =
sizeof(char));
> -				snprintf(st->devname, _len, =
"/dev/md/%s", mdlist->devname);
> -			}
> +			snprintf(st->devname, MD_NAME_MAX + =
sizeof("/dev/md/"),
> +				 "/dev/md/%s", =
basename(mdlist->devname));
> 			if (!is_mddev(mdlist->devname))
> 				return 1;
> 			st->next =3D statelist;
> @@ -218,7 +211,7 @@ int Monitor(struct mddev_dev *devlist,
>=20
> 			st =3D xcalloc(1, sizeof *st);
> 			mdlist =3D conf_get_ident(dv->devname);
> -			st->devname =3D xstrdup(dv->devname);
> +			snprintf(st->devname, MD_NAME_MAX + =
sizeof("/dev/md/"), "%s", dv->devname);
> 			st->next =3D statelist;
> 			st->devnm[0] =3D 0;
> 			st->percent =3D RESYNC_UNKNOWN;
> @@ -301,7 +294,6 @@ int Monitor(struct mddev_dev *devlist,
> 		for (stp =3D &statelist; (st =3D *stp) !=3D NULL; ) {
> 			if (st->from_auto && st->err > 5) {
> 				*stp =3D st->next;
> -				free(st->devname);
> 				free(st->spare_group);
> 				free(st);
> 			} else
> @@ -554,7 +546,7 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
> 		goto disappeared;
>=20
> 	if (st->devnm[0] =3D=3D 0)
> -		strcpy(st->devnm, fd2devnm(fd));
> +		snprintf(st->devnm, MD_NAME_MAX, "%s", fd2devnm(fd));
>=20
> 	for (mse2 =3D mdstat; mse2; mse2 =3D mse2->next)
> 		if (strcmp(mse2->devnm, st->devnm) =3D=3D 0) {
> @@ -684,7 +676,7 @@ static int check_array(struct state *st, struct =
mdstat_ent *mdstat,
> 	    strncmp(mse->metadata_version, "external:", 9) =3D=3D 0 &&
> 	    is_subarray(mse->metadata_version+9)) {
> 		char *sl;
> -		strcpy(st->parent_devnm, mse->metadata_version + 10);
> +		snprintf(st->parent_devnm, MD_NAME_MAX, "%s", =
mse->metadata_version + 10);
> 		sl =3D strchr(st->parent_devnm, '/');
> 		if (sl)
> 			*sl =3D 0;
> @@ -772,14 +764,13 @@ static int add_new_arrays(struct mdstat_ent =
*mdstat, struct state **statelist,
> 				continue;
> 			}
>=20
> -			st->devname =3D xstrdup(name);
> +			snprintf(st->devname, MD_NAME_MAX + =
sizeof("/dev/md/"), "%s", name);
> 			if ((fd =3D open(st->devname, O_RDONLY)) < 0 ||
> 			    md_get_array_info(fd, &array) < 0) {
> 				/* no such array */
> 				if (fd >=3D 0)
> 					close(fd);
> 				put_md_name(st->devname);
> -				free(st->devname);
> 				if (st->metadata) {
> 					=
st->metadata->ss->free_super(st->metadata);
> 					free(st->metadata);
> @@ -791,7 +782,7 @@ static int add_new_arrays(struct mdstat_ent =
*mdstat, struct state **statelist,
> 			st->next =3D *statelist;
> 			st->err =3D 1;
> 			st->from_auto =3D 1;
> -			strcpy(st->devnm, mse->devnm);
> +			snprintf(st->devnm, MD_NAME_MAX, "%s", =
mse->devnm);
> 			st->percent =3D RESYNC_UNKNOWN;
> 			st->expected_spares =3D -1;
> 			if (mse->metadata_version &&
> @@ -799,8 +790,8 @@ static int add_new_arrays(struct mdstat_ent =
*mdstat, struct state **statelist,
> 				    "external:", 9) =3D=3D 0 &&
> 			    is_subarray(mse->metadata_version+9)) {
> 				char *sl;
> -				strcpy(st->parent_devnm,
> -					mse->metadata_version+10);
> +				snprintf(st->parent_devnm, MD_NAME_MAX,
> +					 "%s", mse->metadata_version + =
10);
> 				sl =3D strchr(st->parent_devnm, '/');
> 				*sl =3D 0;
> 			} else
> --=20
> 2.26.2
>=20

