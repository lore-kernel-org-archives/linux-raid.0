Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36C5FC77B75
	for <linux-raid@archiver.kernel.org>; Fri, 24 Feb 2023 16:05:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229714AbjBXQFo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 24 Feb 2023 11:05:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229737AbjBXQFn (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 24 Feb 2023 11:05:43 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43B99199E7
        for <linux-raid@vger.kernel.org>; Fri, 24 Feb 2023 08:05:41 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E1CA95D8BC;
        Fri, 24 Feb 2023 16:05:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1677254739; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BALsa6lp85Shj1vR6lMTUp93/te3MAFgWWGfHCCk/Gw=;
        b=taeq8axGRTG+VQv3XFbI8oj+H9siuvxA5xUmlNEP1vJnyC2dNNmk3+LroNiQ/AEyr350PE
        6ZbbTlAGY3KaPb6zgCVdE2Oa8ILhJqFAPY5ypVtifu65vfnSbbIEu3MCMqjAx1Gpoqb4OP
        XigZnbQ0zC5NuKj1sh4i65cqOZjZLD4=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1677254739;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BALsa6lp85Shj1vR6lMTUp93/te3MAFgWWGfHCCk/Gw=;
        b=QV7t10xdvu+Lt24yMMCzNiROgXFMm3psL3xCZNTTFJ6N82Yxo6Fhb3RdyFZHhunx5Lxwcl
        bbKNpdA5utXNxYAg==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 47F8613A3A;
        Fri, 24 Feb 2023 16:05:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id uNbPBVHg+GPhJAAAMHmgww
        (envelope-from <colyli@suse.de>); Fri, 24 Feb 2023 16:05:37 +0000
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3731.300.101.1.3\))
Subject: Re: [PATCH mdadm v6 3/7] Create: Factor out add_disks() helpers
From:   Coly Li <colyli@suse.de>
In-Reply-To: <20221123190954.95391-4-logang@deltatee.com>
Date:   Sat, 25 Feb 2023 00:05:26 +0800
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Jes Sorensen <jes@trained-monkey.org>,
        Guoqing Jiang <guoqing.jiang@linux.dev>,
        Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>,
        Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Jonmichael Hands <jm@chia.net>,
        Stephen Bates <sbates@raithlin.com>,
        Martin Oliveira <Martin.Oliveira@eideticom.com>,
        David Sloan <David.Sloan@eideticom.com>,
        Kinga Tanska <kinga.tanska@linux.intel.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <67EE0C8C-7CDE-4E00-8B33-82622742EE9C@suse.de>
References: <20221123190954.95391-1-logang@deltatee.com>
 <20221123190954.95391-4-logang@deltatee.com>
To:     Logan Gunthorpe <logang@deltatee.com>
X-Mailer: Apple Mail (2.3731.300.101.1.3)
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, Nov 23, 2022 at 12:09:50PM -0700, Logan Gunthorpe wrote:
> The Create function is massive with a very large number of variables.
> Reading and understanding the function is almost impossible. To help
> with this, factor out the two pass loop that adds the disks to the =
array.
>=20
> This moves about 160 lines into three new helper functions and removes
> a bunch of local variables from the main Create function. The main new
> helper function add_disks() does the two pass loop and calls into
> add_disk_to_super() and update_metadata(). Factoring out the
> latter two helpers also helps to reduce a ton of indentation.
>=20

I do appreciate for this change! Thanks.


> No functional changes intended.
>=20
> Signed-off-by: Logan Gunthorpe <logang@deltatee.com>
> Acked-by: Kinga Tanska <kinga.tanska@linux.intel.com>

Acked-by: Coly Li <colyli@suse.de>

> ---
> Create.c | 382 +++++++++++++++++++++++++++++++------------------------
> 1 file changed, 213 insertions(+), 169 deletions(-)
>=20
> diff --git a/Create.c b/Create.c
> index 8ded81dc265d..6a0446644e04 100644
> --- a/Create.c
> +++ b/Create.c
> @@ -91,6 +91,214 @@ int default_layout(struct supertype *st, int =
level, int verbose)
> 	return layout;
> }
>=20
> +static int add_disk_to_super(int mdfd, struct shape *s, struct =
context *c,
> +		struct supertype *st, struct mddev_dev *dv,
> +		struct mdinfo *info, int have_container, int major_num)
> +{
> +	dev_t rdev;
> +	int fd;
> +
> +	if (dv->disposition =3D=3D 'j') {
> +		info->disk.raid_disk =3D MD_DISK_ROLE_JOURNAL;
> +		info->disk.state =3D (1<<MD_DISK_JOURNAL);
> +	} else if (info->disk.raid_disk < s->raiddisks) {
> +		info->disk.state =3D (1<<MD_DISK_ACTIVE) |
> +			(1<<MD_DISK_SYNC);
> +	} else {
> +		info->disk.state =3D 0;
> +	}
> +
> +	if (dv->writemostly =3D=3D FlagSet) {
> +		if (major_num =3D=3D BITMAP_MAJOR_CLUSTERED) {
> +			pr_err("Can not set %s --write-mostly with a =
clustered bitmap\n",dv->devname);
> +			return 1;
> +		} else {
> +			info->disk.state |=3D (1<<MD_DISK_WRITEMOSTLY);
> +		}
> +
> +	}
> +
> +	if (dv->failfast =3D=3D FlagSet)
> +		info->disk.state |=3D (1<<MD_DISK_FAILFAST);
> +
> +	if (have_container) {
> +		fd =3D -1;
> +	} else {
> +		if (st->ss->external && st->container_devnm[0])
> +			fd =3D open(dv->devname, O_RDWR);
> +		else
> +			fd =3D open(dv->devname, O_RDWR|O_EXCL);
> +
> +		if (fd < 0) {
> +			pr_err("failed to open %s after earlier success =
- aborting\n",
> +			       dv->devname);
> +			return 1;
> +		}
> +		if (!fstat_is_blkdev(fd, dv->devname, &rdev))
> +			return 1;
> +		info->disk.major =3D major(rdev);
> +		info->disk.minor =3D minor(rdev);
> +	}
> +	if (fd >=3D 0)
> +		remove_partitions(fd);
> +	if (st->ss->add_to_super(st, &info->disk, fd, dv->devname,
> +				 dv->data_offset)) {
> +		ioctl(mdfd, STOP_ARRAY, NULL);
> +		return 1;
> +	}
> +	st->ss->getinfo_super(st, info, NULL);
> +
> +	if (have_container && c->verbose > 0)
> +		pr_err("Using %s for device %d\n",
> +		       map_dev(info->disk.major, info->disk.minor, 0),
> +		       info->disk.number);
> +
> +	if (!have_container) {
> +		/* getinfo_super might have lost these ... */
> +		info->disk.major =3D major(rdev);
> +		info->disk.minor =3D minor(rdev);
> +	}
> +
> +	return 0;
> +}
> +
> +static int update_metadata(int mdfd, struct shape *s, struct =
supertype *st,
> +			   struct map_ent **map, struct mdinfo *info,
> +			   char *chosen_name)
> +{
> +	struct mdinfo info_new;
> +	struct map_ent *me =3D NULL;
> +
> +	/* check to see if the uuid has changed due to these
> +	 * metadata changes, and if so update the member array
> +	 * and container uuid.  Note ->write_init_super clears
> +	 * the subarray cursor such that ->getinfo_super once
> +	 * again returns container info.
> +	 */
> +	st->ss->getinfo_super(st, &info_new, NULL);
> +	if (st->ss->external && is_container(s->level) &&
> +	    !same_uuid(info_new.uuid, info->uuid, 0)) {
> +		map_update(map, fd2devnm(mdfd),
> +			   info_new.text_version,
> +			   info_new.uuid, chosen_name);
> +		me =3D map_by_devnm(map, st->container_devnm);
> +	}
> +
> +	if (st->ss->write_init_super(st)) {
> +		st->ss->free_super(st);
> +		return 1;
> +	}
> +
> +	/*
> +	 * Before activating the array, perform extra steps
> +	 * required to configure the internal write-intent
> +	 * bitmap.
> +	 */
> +	if (info_new.consistency_policy =3D=3D CONSISTENCY_POLICY_BITMAP =
&&
> +	    st->ss->set_bitmap && st->ss->set_bitmap(st, info)) {
> +		st->ss->free_super(st);
> +		return 1;
> +	}
> +
> +	/* update parent container uuid */
> +	if (me) {
> +		char *path =3D xstrdup(me->path);
> +
> +		st->ss->getinfo_super(st, &info_new, NULL);
> +		map_update(map, st->container_devnm, =
info_new.text_version,
> +			   info_new.uuid, path);
> +		free(path);
> +	}
> +
> +	flush_metadata_updates(st);
> +	st->ss->free_super(st);
> +
> +	return 0;
> +}
> +
> +static int add_disks(int mdfd, struct mdinfo *info, struct shape *s,
> +		     struct context *c, struct supertype *st,
> +		     struct map_ent **map, struct mddev_dev *devlist,
> +		     int total_slots, int have_container, int =
insert_point,
> +		     int major_num, char *chosen_name)
> +{
> +	struct mddev_dev *moved_disk =3D NULL;
> +	int pass, raid_disk_num, dnum;
> +	struct mddev_dev *dv;
> +	struct mdinfo *infos;
> +	int ret =3D 0;
> +
> +	infos =3D xmalloc(sizeof(*infos) * total_slots);
> +	enable_fds(total_slots);
> +	for (pass =3D 1; pass <=3D 2; pass++) {
> +		for (dnum =3D 0, raid_disk_num =3D 0, dv =3D devlist; =
dv;
> +		     dv =3D (dv->next) ? (dv->next) : moved_disk, =
dnum++) {
> +			if (dnum >=3D total_slots)
> +				abort();
> +			if (dnum =3D=3D insert_point) {
> +				raid_disk_num +=3D 1;
> +				moved_disk =3D dv;
> +				continue;
> +			}
> +			if (strcasecmp(dv->devname, "missing") =3D=3D 0) =
{
> +				raid_disk_num +=3D 1;
> +				continue;
> +			}
> +			if (have_container)
> +				moved_disk =3D NULL;
> +			if (have_container && dnum < total_slots - 1)
> +				/* repeatedly use the container */
> +				moved_disk =3D dv;
> +
> +			switch(pass) {
> +			case 1:
> +				infos[dnum] =3D *info;
> +				infos[dnum].disk.number =3D dnum;
> +				infos[dnum].disk.raid_disk =3D =
raid_disk_num++;
> +
> +				if (dv->disposition =3D=3D 'j')
> +					raid_disk_num--;
> +
> +				ret =3D add_disk_to_super(mdfd, s, c, =
st, dv,
> +						&infos[dnum], =
have_container,
> +						major_num);
> +				if (ret)
> +					goto out;
> +
> +				break;
> +			case 2:
> +				infos[dnum].errors =3D 0;
> +
> +				ret =3D add_disk(mdfd, st, info, =
&infos[dnum]);
> +				if (ret) {
> +					pr_err("ADD_NEW_DISK for %s =
failed: %s\n",
> +					       dv->devname, =
strerror(errno));
> +					if (errno =3D=3D EINVAL &&
> +					    info->array.level =3D=3D 0) =
{
> +						pr_err("Possibly your =
kernel doesn't support RAID0 layouts.\n");
> +						pr_err("Either upgrade, =
or use --layout=3Ddangerous\n");
> +					}
> +					goto out;
> +				}
> +				break;
> +			}
> +			if (!have_container &&
> +			    dv =3D=3D moved_disk && dnum !=3D =
insert_point) break;
> +		}
> +
> +		if (pass =3D=3D 1) {
> +			ret =3D update_metadata(mdfd, s, st, map, info,
> +					      chosen_name);
> +			if (ret)
> +				goto out;
> +		}
> +	}
> +
> +out:
> +	free(infos);
> +	return ret;
> +}
> +
> int Create(struct supertype *st, char *mddev,
> 	   char *name, int *uuid,
> 	   int subdevs, struct mddev_dev *devlist,
> @@ -117,7 +325,7 @@ int Create(struct supertype *st, char *mddev,
> 	unsigned long long minsize =3D 0, maxsize =3D 0;
> 	char *mindisc =3D NULL;
> 	char *maxdisc =3D NULL;
> -	int dnum, raid_disk_num;
> +	int dnum;
> 	struct mddev_dev *dv;
> 	dev_t rdev;
> 	int fail =3D 0, warn =3D 0;
> @@ -126,14 +334,13 @@ int Create(struct supertype *st, char *mddev,
> 	int missing_disks =3D 0;
> 	int insert_point =3D subdevs * 2; /* where to insert a missing =
drive */
> 	int total_slots;
> -	int pass;
> 	int rv;
> 	int bitmap_fd;
> 	int have_container =3D 0;
> 	int container_fd =3D -1;
> 	int need_mdmon =3D 0;
> 	unsigned long long bitmapsize;
> -	struct mdinfo info, *infos;
> +	struct mdinfo info;
> 	int did_default =3D 0;
> 	int do_default_layout =3D 0;
> 	int do_default_chunk =3D 0;
> @@ -869,174 +1076,11 @@ int Create(struct supertype *st, char *mddev,
> 		}
> 	}
>=20
> -	infos =3D xmalloc(sizeof(*infos) * total_slots);
> -	enable_fds(total_slots);
> -	for (pass =3D 1; pass <=3D 2; pass++) {
> -		struct mddev_dev *moved_disk =3D NULL; /* the disk that =
was moved out of the insert point */
> -
> -		for (dnum =3D 0, raid_disk_num =3D 0, dv =3D devlist; =
dv;
> -		     dv =3D (dv->next) ? (dv->next) : moved_disk, =
dnum++) {
> -			int fd;
> -			struct mdinfo *inf =3D &infos[dnum];
> -
> -			if (dnum >=3D total_slots)
> -				abort();
> -			if (dnum =3D=3D insert_point) {
> -				raid_disk_num +=3D 1;
> -				moved_disk =3D dv;
> -				continue;
> -			}
> -			if (strcasecmp(dv->devname, "missing") =3D=3D 0) =
{
> -				raid_disk_num +=3D 1;
> -				continue;
> -			}
> -			if (have_container)
> -				moved_disk =3D NULL;
> -			if (have_container && dnum < =
info.array.raid_disks - 1)
> -				/* repeatedly use the container */
> -				moved_disk =3D dv;
> -
> -			switch(pass) {
> -			case 1:
> -				*inf =3D info;
> -
> -				inf->disk.number =3D dnum;
> -				inf->disk.raid_disk =3D raid_disk_num++;
> -
> -				if (dv->disposition =3D=3D 'j') {
> -					inf->disk.raid_disk =3D =
MD_DISK_ROLE_JOURNAL;
> -					inf->disk.state =3D =
(1<<MD_DISK_JOURNAL);
> -					raid_disk_num--;
> -				} else if (inf->disk.raid_disk < =
s->raiddisks)
> -					inf->disk.state =3D =
(1<<MD_DISK_ACTIVE) |
> -						(1<<MD_DISK_SYNC);
> -				else
> -					inf->disk.state =3D 0;
> -
> -				if (dv->writemostly =3D=3D FlagSet) {
> -					if (major_num =3D=3D =
BITMAP_MAJOR_CLUSTERED) {
> -						pr_err("Can not set %s =
--write-mostly with a clustered bitmap\n",dv->devname);
> -						goto abort_locked;
> -					} else
> -						inf->disk.state |=3D =
(1<<MD_DISK_WRITEMOSTLY);
> -				}
> -				if (dv->failfast =3D=3D FlagSet)
> -					inf->disk.state |=3D =
(1<<MD_DISK_FAILFAST);
> -
> -				if (have_container)
> -					fd =3D -1;
> -				else {
> -					if (st->ss->external &&
> -					    st->container_devnm[0])
> -						fd =3D open(dv->devname, =
O_RDWR);
> -					else
> -						fd =3D open(dv->devname, =
O_RDWR|O_EXCL);
> -
> -					if (fd < 0) {
> -						pr_err("failed to open =
%s after earlier success - aborting\n",
> -							dv->devname);
> -						goto abort_locked;
> -					}
> -					if (!fstat_is_blkdev(fd, =
dv->devname, &rdev))
> -						goto abort_locked;
> -					inf->disk.major =3D major(rdev);
> -					inf->disk.minor =3D minor(rdev);
> -				}
> -				if (fd >=3D 0)
> -					remove_partitions(fd);
> -				if (st->ss->add_to_super(st, &inf->disk,
> -							 fd, =
dv->devname,
> -							 =
dv->data_offset)) {
> -					ioctl(mdfd, STOP_ARRAY, NULL);
> -					goto abort_locked;
> -				}
> -				st->ss->getinfo_super(st, inf, NULL);
> -
> -				if (have_container && c->verbose > 0)
> -					pr_err("Using %s for device =
%d\n",
> -						map_dev(inf->disk.major,
> -							inf->disk.minor,
> -							0), dnum);
> -
> -				if (!have_container) {
> -					/* getinfo_super might have lost =
these ... */
> -					inf->disk.major =3D major(rdev);
> -					inf->disk.minor =3D minor(rdev);
> -				}
> -				break;
> -			case 2:
> -				inf->errors =3D 0;
> -
> -				rv =3D add_disk(mdfd, st, &info, inf);
> -
> -				if (rv) {
> -					pr_err("ADD_NEW_DISK for %s =
failed: %s\n",
> -					       dv->devname, =
strerror(errno));
> -					if (errno =3D=3D EINVAL &&
> -					    info.array.level =3D=3D 0) {
> -						pr_err("Possibly your =
kernel doesn't support RAID0 layouts.\n");
> -						pr_err("Either upgrade, =
or use --layout=3Ddangerous\n");
> -					}
> -					goto abort_locked;
> -				}
> -				break;
> -			}
> -			if (!have_container &&
> -			    dv =3D=3D moved_disk && dnum !=3D =
insert_point) break;
> -		}
> -		if (pass =3D=3D 1) {
> -			struct mdinfo info_new;
> -			struct map_ent *me =3D NULL;
> -
> -			/* check to see if the uuid has changed due to =
these
> -			 * metadata changes, and if so update the member =
array
> -			 * and container uuid.  Note ->write_init_super =
clears
> -			 * the subarray cursor such that ->getinfo_super =
once
> -			 * again returns container info.
> -			 */
> -			st->ss->getinfo_super(st, &info_new, NULL);
> -			if (st->ss->external && !is_container(s->level) =
&&
> -			    !same_uuid(info_new.uuid, info.uuid, 0)) {
> -				map_update(&map, fd2devnm(mdfd),
> -					   info_new.text_version,
> -					   info_new.uuid, chosen_name);
> -				me =3D map_by_devnm(&map, =
st->container_devnm);
> -			}
> -
> -			if (st->ss->write_init_super(st)) {
> -				st->ss->free_super(st);
> -				goto abort_locked;
> -			}
> -			/*
> -			 * Before activating the array, perform extra =
steps
> -			 * required to configure the internal =
write-intent
> -			 * bitmap.
> -			 */
> -			if (info_new.consistency_policy =3D=3D
> -				    CONSISTENCY_POLICY_BITMAP &&
> -			    st->ss->set_bitmap &&
> -			    st->ss->set_bitmap(st, &info)) {
> -				st->ss->free_super(st);
> -				goto abort_locked;
> -			}
> -
> -			/* update parent container uuid */
> -			if (me) {
> -				char *path =3D xstrdup(me->path);
> -
> -				st->ss->getinfo_super(st, &info_new, =
NULL);
> -				map_update(&map, st->container_devnm,
> -					   info_new.text_version,
> -					   info_new.uuid, path);
> -				free(path);
> -			}
> +	if (add_disks(mdfd, &info, s, c, st, &map, devlist, total_slots,
> +		      have_container, insert_point, major_num, =
chosen_name))
> +		goto abort_locked;
>=20
> -			flush_metadata_updates(st);
> -			st->ss->free_super(st);
> -		}
> -	}
> 	map_unlock(&map);
> -	free(infos);
>=20
> 	if (is_container(s->level)) {
> 		/* No need to start.  But we should signal udev to
> --=20
> 2.30.2
>=20

--=20
Coly Li
