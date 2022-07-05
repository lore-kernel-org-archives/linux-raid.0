Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39283C43334
	for <linux-raid@archiver.kernel.org>; Tue,  5 Jul 2022 12:06:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234065AbiGEMGS (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 5 Jul 2022 08:06:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233821AbiGEMFo (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 5 Jul 2022 08:05:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C985518E25
        for <linux-raid@vger.kernel.org>; Tue,  5 Jul 2022 05:05:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657022707; x=1688558707;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=Rp2aEjODkkrUGRgU0sKuGhZF/XxGoyoN+HeAO1JQ5KA=;
  b=SPCMf4yHsZhp42ZprEcc8ikWeUuV4qJiDnK4bB0ziX/qaul5e3tPv9aw
   TQFmDKXfumhRAQj/Q8Hdo4akh9BsVF52+CCJCUT3M0JNx6CtzMegxh3lG
   8A9hz91Og+04OsEzQpCuXBuwJwvPvOuCxIvdoKLS/Hgt+yKT0yaondJBr
   dTe1TgUxX5nBKbNOysSGm3W+1GQJdQ/+BS+03mnPAooXNb/uF93f8WuuD
   t0wZQdpqNVvyuO3knhAuNlO1N59bEyxqTAD3HAfAwbPQdht5vM8evXx1R
   ZIGRQozRGw+caqU74ZBcw0qT4aTqTfCS9dOSViM15XuSyVmwzgFk6X8l/
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10398"; a="263126165"
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="263126165"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 05:05:07 -0700
X-IronPort-AV: E=Sophos;i="5.92,245,1650956400"; 
   d="scan'208";a="650111534"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.213.2.192])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jul 2022 05:05:06 -0700
Date:   Tue, 5 Jul 2022 14:05:01 +0200
From:   Kinga Tanska <kinga.tanska@linux.intel.com>
To:     Coly Li <colyli@suse.de>
Cc:     linux-raid@vger.kernel.org, jes@trained-monkey.org
Subject: Re: [PATCH v3] Monitor: use devname as char array instead of
 pointer
Message-ID: <20220705140501.00007ad3@intel.linux.com>
In-Reply-To: <393687D9-6540-48FE-A4B2-E0A85A3C519A@suse.de>
References: <20220620140659.20822-1-kinga.tanska@intel.com>
        <393687D9-6540-48FE-A4B2-E0A85A3C519A@suse.de>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, 25 Jun 2022 15:03:32 +0800
Coly Li <colyli@suse.de> wrote:

> > 2022=E5=B9=B46=E6=9C=8820=E6=97=A5 22:06=EF=BC=8CKinga Tanska <kinga.ta=
nska@intel.com> =E5=86=99=E9=81=93=EF=BC=9A
> >=20
> > Device name wasn't filled properly due to incorrect use of strcpy.
> > Strcpy was used twice. Firstly to fill devname with "/dev/md/"
> > and then to add chosen name. First strcpy result was overwritten by
> > second one (as a result <device_name> instead of
> > "/dev/md/<device_name>" was assigned). This commit changes this
> > implementation to use snprintf and devname with fixed size. Also
> > safer string functions are propagated.
> >=20
> > Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> > ---
> > Monitor.c | 30 +++++++++++-------------------
> > 1 file changed, 11 insertions(+), 19 deletions(-)
> >=20
> > diff --git a/Monitor.c b/Monitor.c
> > index 6ca1ebe5..04112791 100644
> > --- a/Monitor.c
> > +++ b/Monitor.c
> > @@ -33,8 +33,8 @@
> > #endif
> >=20
> > struct state {
> > -	char *devname;
> > -	char devnm[32];	/* to sync with mdstat info */
> > +	char devname[MD_NAME_MAX + 8];
> > +	char devnm[MD_NAME_MAX];	/* to sync with mdstat
> > info */ unsigned int utime;
> > 	int err;
> > 	char *spare_group;
> > @@ -45,7 +45,7 @@ struct state {
> > 	int devstate[MAX_DISKS];
> > 	dev_t devid[MAX_DISKS];
> > 	int percent;
> > -	char parent_devnm[32]; /* For subarray, devnm of parent.
> > +	char parent_devnm[MD_NAME_MAX]; /* For subarray, devnm of
> > parent.
> > 				* For others, ""
> > 				*/
> > 	struct supertype *metadata;
> > @@ -187,13 +187,7 @@ int Monitor(struct mddev_dev *devlist,
> > 				continue;
> >=20
> > 			st =3D xcalloc(1, sizeof *st);
> > -			if (mdlist->devname[0] =3D=3D '/')
> > -				st->devname =3D
> > xstrdup(mdlist->devname);
> > -			else {
> > -				st->devname =3D
> > xmalloc(8+strlen(mdlist->devname)+1);
> > -				strcpy(strcpy(st->devname,
> > "/dev/md/"),
> > -				       mdlist->devname);
> > -			}
> > +			snprintf(st->devname, MD_NAME_MAX + 8,
> > "/dev/md/%s", basename(mdlist->devname)); =20
>=20
> Hi Kinga,
>=20
> The above location is what the whole patch wants to fix. It is not
> worth to change other locations. IMHO the change set is a bit large
> than what it should be, just a suggestion maybe a following style
> change is enough (not test it),
>=20
> @@ -190,9 +190,13 @@ int Monitor(struct mddev_dev *devlist,
>                         if (mdlist->devname[0] =3D=3D '/')
>                                 st->devname =3D
> xstrdup(mdlist->devname); else {
> -                               st->devname =3D
> xmalloc(8+strlen(mdlist->devname)+1);
> -                               strcpy(strcpy(st->devname,
> "/dev/md/"),
> -                                      mdlist->devname);
> +                               int _len;
> +
> +                               _len =3D 8 + strlen(mdlist->devname);
> +                               st->devname =3D xmalloc(_len + 1);
> +                               memset(st->devname, 0, _len + 1);
> +                               snprintf(st->devname, _len,
> "/dev/md/%s",
> +                                        mdlist->devname);
>                         }
>                         if (!is_mddev(mdlist->devname))
>                                 return 1;
>=20
> Thanks.
>=20
> Coly Li
>=20
>=20
>=20
> > 			if (!is_mddev(mdlist->devname))
> > 				return 1;
> > 			st->next =3D statelist;
> > @@ -216,7 +210,7 @@ int Monitor(struct mddev_dev *devlist,
> >=20
> > 			st =3D xcalloc(1, sizeof *st);
> > 			mdlist =3D conf_get_ident(dv->devname);
> > -			st->devname =3D xstrdup(dv->devname);
> > +			snprintf(st->devname, MD_NAME_MAX + 8,
> > "%s", dv->devname); st->next =3D statelist;
> > 			st->devnm[0] =3D 0;
> > 			st->percent =3D RESYNC_UNKNOWN;
> > @@ -299,7 +293,6 @@ int Monitor(struct mddev_dev *devlist,
> > 		for (stp =3D &statelist; (st =3D *stp) !=3D NULL; ) {
> > 			if (st->from_auto && st->err > 5) {
> > 				*stp =3D st->next;
> > -				free(st->devname);
> > 				free(st->spare_group);
> > 				free(st);
> > 			} else
> > @@ -552,7 +545,7 @@ static int check_array(struct state *st, struct
> > mdstat_ent *mdstat, goto disappeared;
> >=20
> > 	if (st->devnm[0] =3D=3D 0)
> > -		strcpy(st->devnm, fd2devnm(fd));
> > +		snprintf(st->devnm, MD_NAME_MAX, "%s",
> > fd2devnm(fd));
> >=20
> > 	for (mse2 =3D mdstat; mse2; mse2 =3D mse2->next)
> > 		if (strcmp(mse2->devnm, st->devnm) =3D=3D 0) {
> > @@ -682,7 +675,7 @@ static int check_array(struct state *st, struct
> > mdstat_ent *mdstat, strncmp(mse->metadata_version, "external:", 9)
> > =3D=3D 0 && is_subarray(mse->metadata_version+9)) {
> > 		char *sl;
> > -		strcpy(st->parent_devnm, mse->metadata_version +
> > 10);
> > +		snprintf(st->parent_devnm, MD_NAME_MAX, "%s",
> > mse->metadata_version + 10); sl =3D strchr(st->parent_devnm, '/');
> > 		if (sl)
> > 			*sl =3D 0;
> > @@ -770,14 +763,13 @@ static int add_new_arrays(struct mdstat_ent
> > *mdstat, struct state **statelist, continue;
> > 			}
> >=20
> > -			st->devname =3D xstrdup(name);
> > +			snprintf(st->devname, MD_NAME_MAX + 8,
> > "%s", name); if ((fd =3D open(st->devname, O_RDONLY)) < 0 ||
> > 			    md_get_array_info(fd, &array) < 0) {
> > 				/* no such array */
> > 				if (fd >=3D 0)
> > 					close(fd);
> > 				put_md_name(st->devname);
> > -				free(st->devname);
> > 				if (st->metadata) {
> > 					st->metadata->ss->free_super(st->metadata);
> > 					free(st->metadata);
> > @@ -789,7 +781,7 @@ static int add_new_arrays(struct mdstat_ent
> > *mdstat, struct state **statelist, st->next =3D *statelist;
> > 			st->err =3D 1;
> > 			st->from_auto =3D 1;
> > -			strcpy(st->devnm, mse->devnm);
> > +			snprintf(st->devnm, MD_NAME_MAX, "%s",
> > mse->devnm); st->percent =3D RESYNC_UNKNOWN;
> > 			st->expected_spares =3D -1;
> > 			if (mse->metadata_version &&
> > @@ -797,8 +789,8 @@ static int add_new_arrays(struct mdstat_ent
> > *mdstat, struct state **statelist, "external:", 9) =3D=3D 0 &&
> > 			    is_subarray(mse->metadata_version+9)) {
> > 				char *sl;
> > -				strcpy(st->parent_devnm,
> > -					mse->metadata_version+10);
> > +				snprintf(st->parent_devnm,
> > MD_NAME_MAX,
> > +					 "%s",
> > mse->metadata_version + 10); sl =3D strchr(st->parent_devnm, '/');
> > 				*sl =3D 0;
> > 			} else
> > --=20
> > 2.26.2
> >  =20
>=20

Hi Coly,

Yes, fragment of code, which you selected, is enough to fix it. I have
changed also 32 to define, and fixed unsafe functions in this file to
improve code quality and avoid magic number. What's your opinion, is
this change worth to add?
Would you mind getting two patches, one with this specific fix, and
other one with another improvements in this file?

Regards,
Kinga
