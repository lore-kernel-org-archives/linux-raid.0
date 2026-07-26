Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6DCE1C84DC;
	Sun, 26 Jul 2026 12:10:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785067841; cv=none; b=URpT1d79azZxBAXAcNVEct7DJbocKTs9RwX0LNyEAnexSGKGAmSDYhktQOdVn/bTONYQdl+tyJgpa5dMEEcPzEApRRrjud4rb3ejD7Sn6auNWfrY9X57FFVuEOe028UQBPwYs5BJxEmfdumgFfo9wDnVdKSKItEwCF6CGIKgf9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785067841; c=relaxed/simple;
	bh=Gx8sK5Lcu8DgaaXGC0Efi+q5oN+5Y0XzeSsQolG/Uds=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=psXpz7k0uscY82EtSUYzvxCTtamTA1TYY8ltORFts2xwQ0ajHX2g/lNhGiJE+X+vzZSCD/aXVt4Mi15SMgHHZeBZ5WNbcZt0dMCiIWMr8mb9Pdb/lWJPpbOMVJJixdHKaomVOg6NDEagW+1VCSgI3I4Fe9rbHOJUDMLVHXwLTW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=k29WUKuW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="k29WUKuW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E67031F000E9;
	Sun, 26 Jul 2026 12:10:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785067840;
	bh=GOAn7GTuELbCprA8aMRtaEC1Bk48QqZEQs+QTEgvA9w=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=k29WUKuWt9/KVWxZKFSlNA2wQV4mW9CswTirvwgriuw2Svk536L6xjOMGxm/ga7hD
	 LOFeGXPdm3Ecv2TWBQ4u4Yv+rYSWbxVuln55hmyTd/ojT+eMXgXCYZT4/F8NCG99ax
	 IE/3ocEwNPc4ENderOAEjZCwdEPp8S+Tw0HM9YyaXYDvxB6oqymb/39NtaM4+0Hor2
	 oytnNxdr15auI45CdmpsixcR0xlYEdhXimQYusxvrJUN5zbrosdQiS3o9//aOLCIBc
	 tzQNBEVBufHzJjvxPY+8g57ZFlohZ+w1usV+bPwTK2uyyKFzbqP9YsYJxvDi6qmqby
	 7/ExCwEdUNBWw==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 03/12] md/raid1: serialize non-write-behind writes on
 CollisionCheck rdevs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Mykola Marzhan" <mykola@meshstor.io>
Cc: yukuai@fygo.io, linux-pci@vger.kernel.org, linux-raid@vger.kernel.org
In-Reply-To: <20260726113229.2154269-4-mykola@meshstor.io>
References: <20260726113229.2154269-1-mykola@meshstor.io>
 <20260726113229.2154269-4-mykola@meshstor.io>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 26 Jul 2026 12:10:39 +0000
Message-Id: <20260726121039.E67031F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] A Time-of-Check to Time-of-Use (TOCTOU) race condition exists duri=
ng concurrent device removal, leading to a NULL pointer dereference in both=
 the read and write I/O submission paths.
--

--- Patch [3]: [PATCH v6 03/12] md/raid1: serialize non-write-behind writes=
 on CollisionCheck rdevs ---
commit c5339979d08defedb52fda8881d721fd1180c172
Author: Mykola Marzhan <mykola@meshstor.io>
   =20
md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
   =20
This commit serializes non-write-behind writes on CollisionCheck rdevs
to prevent older behind data from landing last and leaving stale data.
It replaces the previous MD_SERIALIZE_POLICY check with CollisionCheck,
which properly accounts for write-mostly members.

Link: https://lore.kernel.org/linux-raid/20260723112741.1206836-1-mwilck@su=
se.com/

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index afe2ca96ad8c2..997f79c05db7b 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c

[ ... ]

> @@ -1677,7 +1677,11 @@ static bool raid1_write_request(struct mddev *mdde=
v, struct bio *bio,
>  			mbio =3D bio_alloc_clone(rdev->bdev, bio, GFP_NOIO,
>  					       &mddev->bio_set);
> =20

[Severity: High]
This is a pre-existing issue, but can this second loop in
raid1_write_request() encounter a NULL pointer dereference during
concurrent device removal?

The loop re-fetches rdev from conf->mirrors[i].rdev which might have
been set to NULL by a concurrent raid1_remove_conf(). If
raid1_remove_conf() executes after the first loop incremented
nr_pending on the old pointer, re-fetching it here and accessing
rdev->bdev in bio_alloc_clone() could trigger a kernel panic.

A similar issue appears to exist in the read path where
update_read_sectors() implicitly re-fetches info->rdev after an active
disk is selected in choose_best_rdev(), potentially crashing on
atomic_inc(&info->rdev->nr_pending).

> -			if (test_bit(MD_SERIALIZE_POLICY, &mddev->flags))
> +			/*
> +			 * CollisionCheck marks every rdev with a serial
> +			 * tree; order against in-flight write-behind I/O.
> +			 */
> +			if (test_bit(CollisionCheck, &rdev->flags))
>  				wait_for_serialization(rdev, r1_bio);
>  		}

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260726113229.2154=
269-1-mykola@meshstor.io?part=3D3
