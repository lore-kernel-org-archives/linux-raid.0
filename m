Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B570C6FA82
	for <linux-raid@archiver.kernel.org>; Wed, 14 Sep 2022 15:03:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbiINPD4 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 14 Sep 2022 11:03:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229743AbiINPDs (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 14 Sep 2022 11:03:48 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A87174B9B
        for <linux-raid@vger.kernel.org>; Wed, 14 Sep 2022 08:03:46 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 8A5C01FDAF;
        Wed, 14 Sep 2022 15:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1663167825; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IYPSt9G1obmT6GRRvaijnMFCjPOFuwyS0vovtBFCGl0=;
        b=nBJqOCpb82JEl+maU8HNz4Cilrt4+SYPAIML7N9WSYtcIQEpORs/98KiqYopZIKO84Zt/p
        sQKDuwRPD6NZN7UnCQcKq43S8xQ653LF/gM8HuEn5EHaNkjPumbG0f4RhCeM5HZYl9C4Yj
        a7GRkDkZx0y5p6LuVCg0EIWOuyWEwCQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1663167825;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IYPSt9G1obmT6GRRvaijnMFCjPOFuwyS0vovtBFCGl0=;
        b=YjuAMRunTjnmdDuKal5yaxfh26tSK87O3cbYVLdIemiLmytW9enp2TDcuqSD8GQuIDLiiQ
        VqlZTLn80Z7hVbBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 7A95F134B3;
        Wed, 14 Sep 2022 15:03:44 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wHWiDlDtIWNdRAAAMHmgww
        (envelope-from <colyli@suse.de>); Wed, 14 Sep 2022 15:03:44 +0000
Content-Type: text/plain;
        charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3696.120.41.1.1\))
Subject: Re: [PATCH 09/10] Manage&Incremental: code refactor, string to enum
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20220818145621.21982-10-mateusz.kusiak@intel.com>
Date:   Wed, 14 Sep 2022 23:03:43 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>, jes@trained-monkey.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9DE036B9-1A8C-4CE8-A9AA-06725560FF05@suse.de>
References: <20220818145621.21982-1-mateusz.kusiak@intel.com>
 <20220818145621.21982-10-mateusz.kusiak@intel.com>
To:     Mateusz Kusiak <mateusz.kusiak@intel.com>
X-Mailer: Apple Mail (2.3696.120.41.1.1)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



> 2022=E5=B9=B48=E6=9C=8818=E6=97=A5 22:56=EF=BC=8CMateusz Kusiak =
<mateusz.kusiak@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> Prepare Manage and Incremental for later changing context->update to =
enum.
> Change update from string to enum in multiple functions and pass enum
> where already possible.
>=20
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>


Although I don=E2=80=99t test this change yet, it looks fine to me.

Acked-by: Coly Li <colyli@suse.de>

Thanks.

Coly Li


> ---
> Grow.c        |  8 ++++----
> Incremental.c |  8 ++++----
> Manage.c      | 35 +++++++++++++++++------------------
> mdadm.c       | 23 ++++++++++++++++++-----
> mdadm.h       |  4 ++--
> 5 files changed, 45 insertions(+), 33 deletions(-)
>=20
> diff --git a/Grow.c b/Grow.c
> index 83b38a71..3cd4db48 100644
> --- a/Grow.c
> +++ b/Grow.c
> @@ -602,12 +602,12 @@ int Grow_consistency_policy(char *devname, int =
fd, struct context *c, struct sha
> 	}
>=20
> 	if (subarray) {
> -		char *update;
> +		enum update_opt update;
>=20
> 		if (s->consistency_policy =3D=3D CONSISTENCY_POLICY_PPL)
> -			update =3D "ppl";
> +			update =3D UOPT_PPL;
> 		else
> -			update =3D "no-ppl";
> +			update =3D UOPT_NO_PPL;
>=20
> 		sprintf(container_dev, "/dev/%s", st->container_devnm);
>=20
> @@ -3234,7 +3234,7 @@ static int reshape_array(char *container, int =
fd, char *devname,
> 	 * level and frozen, we can safely add them.
> 	 */
> 	if (devlist) {
> -		if (Manage_subdevs(devname, fd, devlist, verbose, 0, =
NULL, 0))
> +		if (Manage_subdevs(devname, fd, devlist, verbose, 0, =
UOPT_UNDEFINED, 0))
> 			goto release;
> 	}
>=20
> diff --git a/Incremental.c b/Incremental.c
> index 4d0cd9d6..cfee582f 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -1025,7 +1025,7 @@ static int array_try_spare(char *devname, int =
*dfdp, struct dev_policy *pol,
> 			close(dfd);
> 			*dfdp =3D -1;
> 			rv =3D  Manage_subdevs(chosen->sys_name, mdfd, =
&devlist,
> -					     -1, 0, NULL, 0);
> +					     -1, 0, UOPT_UNDEFINED, 0);
> 			close(mdfd);
> 		}
> 		if (verbose > 0) {
> @@ -1666,7 +1666,7 @@ static void remove_from_member_array(struct =
mdstat_ent *memb,
>=20
> 	if (subfd >=3D 0) {
> 		rv =3D Manage_subdevs(memb->devnm, subfd, devlist, =
verbose,
> -				    0, NULL, 0);
> +				    0, UOPT_UNDEFINED, 0);
> 		if (rv & 2) {
> 			if (sysfs_init(&mmdi, -1, memb->devnm))
> 				pr_err("unable to initialize sysfs for: =
%s\n",
> @@ -1758,7 +1758,7 @@ int IncrementalRemove(char *devname, char =
*id_path, int verbose)
> 		free_mdstat(mdstat);
> 	} else {
> 		rv |=3D Manage_subdevs(ent->devnm, mdfd, &devlist,
> -				    verbose, 0, NULL, 0);
> +				    verbose, 0, UOPT_UNDEFINED, 0);
> 		if (rv & 2) {
> 		/* Failed due to EBUSY, try to stop the array.
> 		 * Give udisks a chance to unmount it first.
> @@ -1770,7 +1770,7 @@ int IncrementalRemove(char *devname, char =
*id_path, int verbose)
>=20
> 	devlist.disposition =3D 'r';
> 	rv =3D Manage_subdevs(ent->devnm, mdfd, &devlist,
> -			    verbose, 0, NULL, 0);
> +			    verbose, 0, UOPT_UNDEFINED, 0);
> end:
> 	close(mdfd);
> 	free_mdstat(ent);
> diff --git a/Manage.c b/Manage.c
> index c47b6262..e560bdb9 100644
> --- a/Manage.c
> +++ b/Manage.c
> @@ -598,14 +598,12 @@ static void add_set(struct mddev_dev *dv, int =
fd, char set_char)
>=20
> int attempt_re_add(int fd, int tfd, struct mddev_dev *dv,
> 		   struct supertype *dev_st, struct supertype *tst,
> -		   unsigned long rdev,
> -		   char *update, char *devname, int verbose,
> -		   mdu_array_info_t *array)
> +		   unsigned long rdev, enum update_opt update,
> +		   char *devname, int verbose, mdu_array_info_t *array)
> {
> 	struct mdinfo mdi;
> 	int duuid[4];
> 	int ouuid[4];
> -	enum update_opt update_enum =3D map_name(update_options, =
update);
>=20
> 	dev_st->ss->getinfo_super(dev_st, &mdi, NULL);
> 	dev_st->ss->uuid_from_super(dev_st, ouuid);
> @@ -683,7 +681,7 @@ int attempt_re_add(int fd, int tfd, struct =
mddev_dev *dv,
> 					devname, verbose, 0, NULL);
> 			if (update)
> 				rv =3D dev_st->ss->update_super(
> -					dev_st, NULL, update_enum,
> +					dev_st, NULL, update,
> 					devname, verbose, 0, NULL);
> 			if (rv =3D=3D 0)
> 				rv =3D dev_st->ss->store_super(dev_st, =
tfd);
> @@ -715,8 +713,8 @@ skip_re_add:
> int Manage_add(int fd, int tfd, struct mddev_dev *dv,
> 	       struct supertype *tst, mdu_array_info_t *array,
> 	       int force, int verbose, char *devname,
> -	       char *update, unsigned long rdev, unsigned long long =
array_size,
> -	       int raid_slot)
> +	       enum update_opt update, unsigned long rdev,
> +	       unsigned long long array_size, int raid_slot)
> {
> 	unsigned long long ldsize;
> 	struct supertype *dev_st;
> @@ -1288,7 +1286,7 @@ int Manage_with(struct supertype *tst, int fd, =
struct mddev_dev *dv,
>=20
> int Manage_subdevs(char *devname, int fd,
> 		   struct mddev_dev *devlist, int verbose, int test,
> -		   char *update, int force)
> +		   enum update_opt update, int force)
> {
> 	/* Do something to each dev.
> 	 * devmode can be
> @@ -1676,12 +1674,13 @@ int autodetect(void)
> 	return rv;
> }
>=20
> -int Update_subarray(char *dev, char *subarray, char *update, struct =
mddev_ident *ident, int verbose)
> +int Update_subarray(char *dev, char *subarray, enum update_opt =
update,
> +		    struct mddev_ident *ident, int verbose)
> {
> 	struct supertype supertype, *st =3D &supertype;
> 	int fd, rv =3D 2;
> 	struct mdinfo *info =3D NULL;
> -	enum update_opt update_enum =3D map_name(update_options, =
update);
> +	char *update_verb =3D map_num(update_options, update);
>=20
> 	memset(st, 0, sizeof(*st));
>=20
> @@ -1699,7 +1698,7 @@ int Update_subarray(char *dev, char *subarray, =
char *update, struct mddev_ident
> 	if (is_subarray_active(subarray, st->devnm)) {
> 		if (verbose >=3D 0)
> 			pr_err("Subarray %s in %s is active, cannot =
update %s\n",
> -			       subarray, dev, update);
> +				subarray, dev, update_verb);
> 		goto free_super;
> 	}
>=20
> @@ -1708,23 +1707,23 @@ int Update_subarray(char *dev, char *subarray, =
char *update, struct mddev_ident
>=20
> 	info =3D st->ss->container_content(st, subarray);
>=20
> -	if (strncmp(update, "ppl", 3) =3D=3D 0 && =
!is_level456(info->array.level)) {
> +	if (update =3D=3D UOPT_PPL && !is_level456(info->array.level)) {
> 		pr_err("RWH policy ppl is supported only for raid4, =
raid5 and raid6.\n");
> 		goto free_super;
> 	}
>=20
> -	rv =3D st->ss->update_subarray(st, subarray, update_enum, =
ident);
> +	rv =3D st->ss->update_subarray(st, subarray, update, ident);
>=20
> 	if (rv) {
> 		if (verbose >=3D 0)
> 			pr_err("Failed to update %s of subarray-%s in =
%s\n",
> -				update, subarray, dev);
> +				update_verb, subarray, dev);
> 	} else if (st->update_tail)
> 		flush_metadata_updates(st);
> 	else
> 		st->ss->sync_metadata(st);
>=20
> -	if (rv =3D=3D 0 && strcmp(update, "name") =3D=3D 0 && verbose >=3D=
 0)
> +	if (rv =3D=3D 0 && update =3D=3D UOPT_NAME && verbose >=3D 0)
> 		pr_err("Updated subarray-%s name from %s, UUIDs may have =
changed\n",
> 		       subarray, dev);
>=20
> @@ -1765,10 +1764,10 @@ int move_spare(char *from_devname, char =
*to_devname, dev_t devid)
> 	sprintf(devname, "%d:%d", major(devid), minor(devid));
>=20
> 	devlist.disposition =3D 'r';
> -	if (Manage_subdevs(from_devname, fd2, &devlist, -1, 0, NULL, 0) =
=3D=3D 0) {
> +	if (Manage_subdevs(from_devname, fd2, &devlist, -1, 0, =
UOPT_UNDEFINED, 0) =3D=3D 0) {
> 		devlist.disposition =3D 'a';
> 		if (Manage_subdevs(to_devname, fd1, &devlist, -1, 0,
> -				   NULL, 0) =3D=3D 0) {
> +				   UOPT_UNDEFINED, 0) =3D=3D 0) {
> 			/* make sure manager is aware of changes */
> 			ping_manager(to_devname);
> 			ping_manager(from_devname);
> @@ -1778,7 +1777,7 @@ int move_spare(char *from_devname, char =
*to_devname, dev_t devid)
> 		}
> 		else
> 			Manage_subdevs(from_devname, fd2, &devlist,
> -				       -1, 0, NULL, 0);
> +				       -1, 0, UOPT_UNDEFINED, 0);
> 	}
> 	close(fd1);
> 	close(fd2);
> diff --git a/mdadm.c b/mdadm.c
> index 3705d114..b55e0d9a 100644
> --- a/mdadm.c
> +++ b/mdadm.c
> @@ -1433,10 +1433,22 @@ int main(int argc, char *argv[])
> 		/* readonly, add/remove, readwrite, runstop */
> 		if (c.readonly > 0)
> 			rv =3D Manage_ro(devlist->devname, mdfd, =
c.readonly);
> -		if (!rv && devs_found>1)
> -			rv =3D Manage_subdevs(devlist->devname, mdfd,
> -					    devlist->next, c.verbose, =
c.test,
> -					    c.update, c.force);
> +		if (!rv && devs_found > 1) {
> +			/*
> +			 * This is temporary and will be removed in next =
patches
> +			 * Null c.update will cause segfault
> +			 */
> +			if (c.update)
> +				rv =3D Manage_subdevs(devlist->devname, =
mdfd,
> +						devlist->next, =
c.verbose, c.test,
> +						map_name(update_options, =
c.update),
> +						c.force);
> +			else
> +				rv =3D Manage_subdevs(devlist->devname, =
mdfd,
> +						devlist->next, =
c.verbose, c.test,
> +						UOPT_UNDEFINED,
> +						c.force);
> +		}
> 		if (!rv && c.readonly < 0)
> 			rv =3D Manage_ro(devlist->devname, mdfd, =
c.readonly);
> 		if (!rv && c.runstop > 0)
> @@ -1964,7 +1976,8 @@ static int misc_list(struct mddev_dev *devlist,
> 				continue;
> 			}
> 			rv |=3D Update_subarray(dv->devname, =
c->subarray,
> -					      c->update, ident, =
c->verbose);
> +					      map_name(update_options, =
c->update),
> +					      ident, c->verbose);
> 			continue;
> 		case Dump:
> 			rv |=3D Dump_metadata(dv->devname, =
dump_directory, c, ss);
> diff --git a/mdadm.h b/mdadm.h
> index afc2e2a8..fe09fd46 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1477,7 +1477,7 @@ extern int Manage_stop(char *devname, int fd, =
int quiet,
> 		       int will_retry);
> extern int Manage_subdevs(char *devname, int fd,
> 			  struct mddev_dev *devlist, int verbose, int =
test,
> -			  char *update, int force);
> +			  enum update_opt update, int force);
> extern int autodetect(void);
> extern int Grow_Add_device(char *devname, int fd, char *newdev);
> extern int Grow_addbitmap(char *devname, int fd,
> @@ -1533,7 +1533,7 @@ extern int Monitor(struct mddev_dev *devlist,
>=20
> extern int Kill(char *dev, struct supertype *st, int force, int =
verbose, int noexcl);
> extern int Kill_subarray(char *dev, char *subarray, int verbose);
> -extern int Update_subarray(char *dev, char *subarray, char *update, =
struct mddev_ident *ident, int quiet);
> +extern int Update_subarray(char *dev, char *subarray, enum update_opt =
update, struct mddev_ident *ident, int quiet);
> extern int Wait(char *dev);
> extern int WaitClean(char *dev, int verbose);
> extern int SetAction(char *dev, char *action);
> --=20
> 2.26.2
>=20

