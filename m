Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E67AECAAD3
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229906AbiINPD5 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:03:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiINPDz (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:03:55 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD0AE7F245
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:03:52 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 5C5F43393A;
        Wed, 14 Sep 2022 15:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167831; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lgtyLiu/Mc0foPr8kSOb82WZ7XtQPZFertZscaL6+oQ=;
        b=trodthy/f3rC5mJkpaSzVjPUbb1knjDpfJme2m3OtPug3dn5TnO63BWMZJKzGEbTlQ8rd/
        z+cK9ije/CxHPJBuWHYqyHfJSxU9gd7Xa8vjlCBMqilb1wfpL1BXyY5N6fOwGn5Rm5DQpS
        pVQ5VKBtspTw+R0AuL262h1OBJ/IhkA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167831;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=lgtyLiu/Mc0foPr8kSOb82WZ7XtQPZFertZscaL6+oQ=;
        b=heLvolcyh51gfbRDfSB/7Wo5CJxItYQkfULx3QvPS3dxj8hSbevvbknXVas2dtBznOcwMr
        w4+zI8Xdjf+zlkAA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 571B2134B3;
        Wed, 14 Sep 2022 15:03:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id eOxYBlbtIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:03:50 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 10/10] Change char* to enum in context->update & refactor
 code
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-11-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:03:49 +0800
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <B230BB9A-E367-4A86-9968-04CFA3294A19@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-11-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Storing update option in string is bad for frequent comparisons and
> error prone.
> Replace char array with enum so already existing enum is passed around
> instead of string.
> Adapt code to changes.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>

Although I don=E2=80=99t test this patch yet, it looks good to me.

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
> Assemble.c | 40 +++++++++++++++++-----------------------
> mdadm.c    | 52 +++++++++++++++++++---------------------------------
> mdadm.h    |  2 +-
> 3 files changed, 37 insertions(+), 57 deletions(-)
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 8cd3d533..942e352e 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -135,17 +135,17 @@ static int ident_matches(struct mddev_ident =
*ident,
> 			 struct mdinfo *content,
> 			 struct supertype *tst,
> 			 char *homehost, int require_homehost,
> -			 char *update, char *devname)
> +			 enum update_opt update, char *devname)
> {
>=20
> -	if (ident->uuid_set && (!update || strcmp(update, "uuid")!=3D 0) =
&&
> +	if (ident->uuid_set && update !=3D UOPT_UUID &&
> 	    same_uuid(content->uuid, ident->uuid, tst->ss->swapuuid)=3D=3D=
0 &&
> 	    memcmp(content->uuid, uuid_zero, sizeof(int[4])) !=3D 0) {
> 		if (devname)
> 			pr_err("%s has wrong uuid.\n", devname);
> 		return 0;
> 	}
> -	if (ident->name[0] && (!update || strcmp(update, "name")!=3D 0) =
&&
> +	if (ident->name[0] && update !=3D UOPT_NAME &&
> 	    name_matches(content->name, ident->name, homehost, =
require_homehost)=3D=3D0) {
> 		if (devname)
> 			pr_err("%s has wrong name.\n", devname);
> @@ -648,11 +648,10 @@ static int load_devices(struct devs *devices, =
char *devmap,
> 			int err;
> 			fstat(mdfd, &stb2);
>=20
> -			if (strcmp(c->update, "uuid") =3D=3D 0 && =
!ident->uuid_set)
> +			if (c->update =3D=3D UOPT_UUID && =
!ident->uuid_set)
> 				random_uuid((__u8 *)ident->uuid);
>=20
> -			if (strcmp(c->update, "ppl") =3D=3D 0 &&
> -			    ident->bitmap_fd >=3D 0) {
> +			if (c->update =3D=3D UOPT_PPL && =
ident->bitmap_fd >=3D 0) {
> 				pr_err("PPL is not compatible with =
bitmap\n");
> 				close(mdfd);
> 				free(devices);
> @@ -684,34 +683,30 @@ static int load_devices(struct devs *devices, =
char *devmap,
> 			strcpy(content->name, ident->name);
> 			content->array.md_minor =3D minor(stb2.st_rdev);
>=20
> -			if (strcmp(c->update, "byteorder") =3D=3D 0)
> +			if (c->update =3D=3D UOPT_BYTEORDER)
> 				err =3D 0;
> -			else if (strcmp(c->update, "home-cluster") =3D=3D =
0) {
> +			else if (c->update =3D=3D UOPT_HOME_CLUSTER) {
> 				tst->cluster_name =3D c->homecluster;
> 				err =3D tst->ss->write_bitmap(tst, dfd, =
NameUpdate);
> -			} else if (strcmp(c->update, "nodes") =3D=3D 0) =
{
> +			} else if (c->update =3D=3D UOPT_NODES) {
> 				tst->nodes =3D c->nodes;
> 				err =3D tst->ss->write_bitmap(tst, dfd, =
NodeNumUpdate);
> -			} else if (strcmp(c->update, "revert-reshape") =
=3D=3D 0 &&
> -				   c->invalid_backup)
> +			} else if (c->update =3D=3D UOPT_REVERT_RESHAPE =
&& c->invalid_backup)
> 				err =3D tst->ss->update_super(tst, =
content,
> 							    =
UOPT_SPEC_REVERT_RESHAPE_NOBACKUP,
> 							    devname, =
c->verbose,
> 							    =
ident->uuid_set,
> 							    =
c->homehost);
> 			else
> -				/*
> -				 * Mapping is temporary, will be removed =
in this patchset
> -				 */
> 				err =3D tst->ss->update_super(tst, =
content,
> -							    =
map_name(update_options, c->update),
> +							    c->update,
> 							    devname, =
c->verbose,
> 							    =
ident->uuid_set,
> 							    =
c->homehost);
> 			if (err < 0) {
> 				if (err =3D=3D -1)
> 					pr_err("--update=3D%s not =
understood for %s metadata\n",
> -					       c->update, =
tst->ss->name);
> +					       map_num(update_options, =
c->update), tst->ss->name);
> 				tst->ss->free_super(tst);
> 				free(tst);
> 				close(mdfd);
> @@ -721,7 +716,7 @@ static int load_devices(struct devs *devices, char =
*devmap,
> 				*stp =3D st;
> 				return -1;
> 			}
> -			if (strcmp(c->update, "uuid")=3D=3D0 &&
> +			if (c->update =3D=3D UOPT_UUID &&
> 			    !ident->uuid_set) {
> 				ident->uuid_set =3D 1;
> 				memcpy(ident->uuid, content->uuid, 16);
> @@ -730,7 +725,7 @@ static int load_devices(struct devs *devices, char =
*devmap,
> 				pr_err("Could not re-write superblock on =
%s.\n",
> 				       devname);
>=20
> -			if (strcmp(c->update, "uuid")=3D=3D0 &&
> +			if (c->update =3D=3D UOPT_UUID &&
> 			    ident->bitmap_fd >=3D 0 && !bitmap_done) {
> 				if (bitmap_update_uuid(ident->bitmap_fd,
> 						       content->uuid,
> @@ -1188,8 +1183,7 @@ static int start_array(int mdfd,
> 				pr_err("%s: Need a backup file to =
complete reshape of this array.\n",
> 				       mddev);
> 				pr_err("Please provided one with =
\"--backup-file=3D...\"\n");
> -				if (c->update &&
> -				    strcmp(c->update, "revert-reshape") =
=3D=3D 0)
> +				if (c->update =3D=3D =
UOPT_REVERT_RESHAPE)
> 					pr_err("(Don't specify =
--update=3Drevert-reshape again, that part succeeded.)\n");
> 				return 1;
> 			}
> @@ -1487,7 +1481,7 @@ try_again:
> 	 */
> 	if (map_lock(&map))
> 		pr_err("failed to get exclusive lock on mapfile - =
continue anyway...\n");
> -	if (c->update && strcmp(c->update,"uuid") =3D=3D 0)
> +	if (c->update =3D=3D UOPT_UUID)
> 		mp =3D NULL;
> 	else
> 		mp =3D map_by_uuid(&map, content->uuid);
> @@ -1635,7 +1629,7 @@ try_again:
> 		goto out;
> 	}
>=20
> -	if (c->update && strcmp(c->update, "byteorder")=3D=3D0)
> +	if (c->update =3D=3D UOPT_BYTEORDER)
> 		st->minor_version =3D 90;
>=20
> 	st->ss->getinfo_super(st, content, NULL);
> @@ -1904,7 +1898,7 @@ try_again:
> 	/* First, fill in the map, so that udev can find our name
> 	 * as soon as we become active.
> 	 */
> -	if (c->update && strcmp(c->update, "metadata")=3D=3D0) {
> +	if (c->update =3D=3D UOPT_METADATA) {
> 		content->array.major_version =3D 1;
> 		content->array.minor_version =3D 0;
> 		strcpy(content->text_version, "1.0");
> diff --git a/mdadm.c b/mdadm.c
> index b55e0d9a..dc6d6a95 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -746,7 +746,7 @@ int main(int argc, char *argv[])
> 		case O(MISC,'U'):
> 			if (c.update) {
> 				pr_err("Can only update one aspect of =
superblock, both %s and %s given.\n",
> -					c.update, optarg);
> +					map_num(update_options, =
c.update), optarg);
> 				exit(2);
> 			}
> 			if (mode =3D=3D MISC && !c.subarray) {
> @@ -754,8 +754,7 @@ int main(int argc, char *argv[])
> 				exit(2);
> 			}
>=20
> -			c.update =3D optarg;
> -			enum update_opt updateopt =3D =
map_name(update_options, c.update);
> +			c.update =3D map_name(update_options, optarg);
> 			enum update_opt print_mode =3D UOPT_HELP;
> 			const char *error_addon =3D "update option";
>=20
> @@ -763,14 +762,14 @@ int main(int argc, char *argv[])
> 				print_mode =3D UOPT_SUBARRAY_ONLY;
> 				error_addon =3D "update-subarray =
option";
>=20
> -				if (updateopt > UOPT_SUBARRAY_ONLY && =
updateopt < UOPT_HELP)
> -					updateopt =3D UOPT_UNDEFINED;
> +				if (c.update > UOPT_SUBARRAY_ONLY && =
c.update < UOPT_HELP)
> +					c.update =3D UOPT_UNDEFINED;
> 			}
>=20
> -			switch (updateopt) {
> +			switch (c.update) {
> 			case UOPT_UNDEFINED:
> 				pr_err("'--update=3D%s' is invalid %s. =
",
> -					c.update, error_addon);
> +					optarg, error_addon);
> 				outf =3D stderr;
> 			case UOPT_HELP:
> 				if (!outf)
> @@ -795,14 +794,14 @@ int main(int argc, char *argv[])
> 			}
> 			if (c.update) {
> 				pr_err("Can only update one aspect of =
superblock, both %s and %s given.\n",
> -					c.update, optarg);
> +					map_num(update_options, =
c.update), optarg);
> 				exit(2);
> 			}
> -			c.update =3D optarg;
> -			if (strcmp(c.update, "devicesize") !=3D 0 &&
> -			    strcmp(c.update, "bbl") !=3D 0 &&
> -			    strcmp(c.update, "force-no-bbl") !=3D 0 &&
> -			    strcmp(c.update, "no-bbl") !=3D 0) {
> +			c.update =3D map_name(update_options, optarg);
> +			if (c.update !=3D UOPT_DEVICESIZE &&
> +			    c.update !=3D UOPT_BBL &&
> +			    c.update !=3D UOPT_NO_BBL &&
> +			    c.update !=3D UOPT_FORCE_NO_BBL) {
> 				pr_err("only 'devicesize', 'bbl', =
'no-bbl', and 'force-no-bbl' can be updated with --re-add\n");
> 				exit(2);
> 			}
> @@ -1388,7 +1387,7 @@ int main(int argc, char *argv[])
> 		}
> 	}
>=20
> -	if (c.update && strcmp(c.update, "nodes") =3D=3D 0 && c.nodes =3D=3D=
 0) {
> +	if (c.update && c.update =3D=3D UOPT_NODES && c.nodes =3D=3D 0) =
{
> 		pr_err("Please specify nodes number with --nodes\n");
> 		exit(1);
> 	}
> @@ -1433,22 +1432,10 @@ int main(int argc, char *argv[])
> 		/* readonly, add/remove, readwrite, runstop */
> 		if (c.readonly > 0)
> 			rv =3D Manage_ro(devlist->devname, mdfd, =
c.readonly);
> -		if (!rv && devs_found > 1) {
> -			/*
> -			 * This is temporary and will be removed in next =
patches
> -			 * Null c.update will cause segfault
> -			 */
> -			if (c.update)
> -				rv =3D Manage_subdevs(devlist->devname, =
mdfd,
> -						devlist->next, =
c.verbose, c.test,
> -						map_name(update_options, =
c.update),
> -						c.force);
> -			else
> -				rv =3D Manage_subdevs(devlist->devname, =
mdfd,
> -						devlist->next, =
c.verbose, c.test,
> -						UOPT_UNDEFINED,
> -						c.force);
> -		}
> +		if (!rv && devs_found > 1)
> +			rv =3D Manage_subdevs(devlist->devname, mdfd,
> +					    devlist->next, c.verbose,
> +					    c.test, c.update, c.force);
> 		if (!rv && c.readonly < 0)
> 			rv =3D Manage_ro(devlist->devname, mdfd, =
c.readonly);
> 		if (!rv && c.runstop > 0)
> @@ -1970,14 +1957,13 @@ static int misc_list(struct mddev_dev =
*devlist,
> 			rv |=3D Kill_subarray(dv->devname, c->subarray, =
c->verbose);
> 			continue;
> 		case UpdateSubarray:
> -			if (c->update =3D=3D NULL) {
> +			if (!c->update) {
> 				pr_err("-U/--update must be specified =
with --update-subarray\n");
> 				rv |=3D 1;
> 				continue;
> 			}
> 			rv |=3D Update_subarray(dv->devname, =
c->subarray,
> -					      map_name(update_options, =
c->update),
> -					      ident, c->verbose);
> +					      c->update, ident, =
c->verbose);
> 			continue;
> 		case Dump:
> 			rv |=3D Dump_metadata(dv->devname, =
dump_directory, c, ss);
> diff --git a/mdadm.h b/mdadm.h
> index fe09fd46..c732a936 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -616,7 +616,7 @@ struct context {
> 	int	export;
> 	int	test;
> 	char	*subarray;
> -	char	*update;
> +	enum	update_opt update;
> 	int	scan;
> 	int	SparcAdjust;
> 	int	autof;
> --=20
> 2.26.2
>=20

