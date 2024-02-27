Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 926B213EFE9
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 14:44:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709045094; cv=none; b=gF5b/NuG3J5QCZ2i2KPojzK+K4Q6IYAh1T2rRuklmCPeNbI6VG2yApkpJ0mGZSTngB/s13y0Rh0Tn7Y9GnBjGZOds7OcCx9aLtYzkHOjL4zytTIPOvuN1RuSc+iXclOvjYx10VxC79xvvgpjWNAtnK/X/8QqwMC11rtuDMJDLVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709045094; c=relaxed/simple;
	bh=W5ifiTMERjnmXd/BEweN2b47tvu0sarmNOsZq9amTwo=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=J7Bx8aK9mxla7m5TMYdtsP+2GNE6TPi6PwyDTXNilTIqqLm5Vm3Toy8JOmWrtdDQGVSw6rL5Tyk0usK4OfAYz7c//8CeCRmYOu4CEYtOhVPQqVVc1iMz/zKBCLmU4ZXf20gaCXnT++Sf7+5zhD+l0rHq8UdfxXiBerxQBLnpTmg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=O2hVXtIp; arc=none smtp.client-ip=198.175.65.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="O2hVXtIp"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1709045092; x=1740581092;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=W5ifiTMERjnmXd/BEweN2b47tvu0sarmNOsZq9amTwo=;
  b=O2hVXtIprvIJxlrGBuV22JaGyzmPxIZdw/l2vA72FDbWEVwoWbuOJUg1
   RYj9BlKXz3J+z8+r05y1xiwoqC5jrkvJNshJBJ2Owh8R2aBZkJyyX7Q6F
   om+Y5gQevcqln8lFQNhNDiCtv0vEVW0Ut6nUH4Kkytp/pOjCaZLAdw13s
   8pTtY1U5zNmkXQsM8lJq4IlDNgefLCDGKrtdIMJrbPIAlBnzxTfPvP6KT
   zH/hjRHAjolhRLOaQBt6ORPbLzOMLhluIQzNIpLfVOK8mNFfwAf/SUZqj
   WD8PVbe9ZF9pbHMg0VkoHAdstsC5NL5HTzOZBgNJPNQM9/EKFm/i/FlUN
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10996"; a="14829278"
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="14829278"
Received: from orviesa008.jf.intel.com ([10.64.159.148])
  by orvoesa104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 06:44:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.06,188,1705392000"; 
   d="scan'208";a="7624933"
Received: from ktanska-mobl1.ger.corp.intel.com (HELO intel.linux.com) ([10.246.34.147])
  by orviesa008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2024 06:44:47 -0800
Date: Tue, 27 Feb 2024 15:44:44 +0100
From: Kinga Tanska <kinga.tanska@linux.intel.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: Kinga Tanska <kinga.tanska@intel.com>, linux-raid@vger.kernel.org,
 jes@trained-monkey.org, mariusz.tkaczyk@linux.intel.com
Subject: Re: [PATCH] Detail: remove duplicated code
Message-ID: <20240227154302.0000798c@intel.linux.com>
In-Reply-To: <e6a839df-7830-4dff-9271-aa245e2be7ed@molgen.mpg.de>
References: <20240227063656.31511-1-kinga.tanska@intel.com>
 <e6a839df-7830-4dff-9271-aa245e2be7ed@molgen.mpg.de>
X-Mailer: Claws Mail 3.19.0 (GTK+ 2.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2024 14:44:59 +0100
Paul Menzel <pmenzel@molgen.mpg.de> wrote:

> Dear Kinga,
>=20
>=20
> Thank you for your patch.
>=20
> Am 27.02.24 um 07:36 schrieb Kinga Tanska:
> > Remove duplicated code from Detail(), where MD_UUID
> > and MD_DEVNAME are being set. Superblock is no longer
> > required to print system properties. Now it tries to
> > obtain map in two ways. =20
>=20
> Do you have the commit removing the requirement handy? If so, please
> add it.
>=20
> It=E2=80=99d be great if you used 72 characters per line, so less lines a=
re
> used.
>=20
>=20
> Kind regards,
>=20
> Paul
>=20
>=20
> > Signed-off-by: Kinga Tanska <kinga.tanska@intel.com>
> > ---
> >   Detail.c | 33 +++++++++++++--------------------
> >   1 file changed, 13 insertions(+), 20 deletions(-)
> >=20
> > diff --git a/Detail.c b/Detail.c
> > index 57ac336f..92affdc6 100644
> > --- a/Detail.c
> > +++ b/Detail.c
> > @@ -226,6 +226,9 @@ int Detail(char *dev, struct context *c)
> >   		str =3D map_num(pers, array.level);
> >  =20
> >   	if (c->export) {
> > +		char nbuf[64];
> > +		struct map_ent *mp =3D NULL, *map =3D NULL;
> > +
> >   		if (array.raid_disks) {
> >   			if (str)
> >   				printf("MD_LEVEL=3D%s\n", str);
> > @@ -247,32 +250,22 @@ int Detail(char *dev, struct context *c)
> >   				       array.minor_version);
> >   		}
> >  =20
> > -		if (st && st->sb && info) {
> > -			char nbuf[64];
> > -			struct map_ent *mp, *map =3D NULL;
> > -
> > -			fname_from_uuid(st, info, nbuf, ':');
> > -			printf("MD_UUID=3D%s\n", nbuf + 5);
> > +		if (info)
> >   			mp =3D map_by_uuid(&map, info->uuid);
> > +		if (!mp)
> > +			mp =3D map_by_devnm(&map, fd2devnm(fd));
> >  =20
> > -			if (mp && mp->path && strncmp(mp->path,
> > DEV_MD_DIR, DEV_MD_DIR_LEN) =3D=3D 0)
> > +		if (mp) {
> > +			__fname_from_uuid(mp->uuid, 0, nbuf, ':');
> > +			printf("MD_UUID=3D%s\n", nbuf + 5);
> > +			if (mp->path && strncmp(mp->path,
> > DEV_MD_DIR, DEV_MD_DIR_LEN) =3D=3D 0) printf("MD_DEVNAME=3D%s\n",
> > mp->path + DEV_MD_DIR_LEN);
> > +		}
> >  =20
> > +		map_free(map);
> > +		if (st && st->sb) {
> >   			if (st->ss->export_detail_super)
> >   				st->ss->export_detail_super(st);
> > -			map_free(map);
> > -		} else {
> > -			struct map_ent *mp, *map =3D NULL;
> > -			char nbuf[64];
> > -			mp =3D map_by_devnm(&map, fd2devnm(fd));
> > -			if (mp) {
> > -				__fname_from_uuid(mp->uuid, 0,
> > nbuf, ':');
> > -				printf("MD_UUID=3D%s\n", nbuf+5);
> > -			}
> > -			if (mp && mp->path && strncmp(mp->path,
> > DEV_MD_DIR, DEV_MD_DIR_LEN) =3D=3D 0)
> > -				printf("MD_DEVNAME=3D%s\n", mp->path
> > + DEV_MD_DIR_LEN); -
> > -			map_free(map);
> >   		}
> >   		if (!c->no_devices && sra) {
> >   			struct mdinfo *mdi; =20
>=20

Hi Paul,

I don't have commit which removes this requirement. This fix is based
on my findings. In previous version superblock was required to find map
by uuid and fill all of the properties. Sometimes map was not found,
which was caused by some time race or custom settings (for example when
using IMSM_DEVNAME_AS_SERIAL flag. That's why I've added another try to
obtain map using devname.
I've already sent v2 with description updated.=20

Regards,
Kinga
