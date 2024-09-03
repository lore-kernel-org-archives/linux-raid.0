Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2BD21CE71A
	for <linux-raid@vger.kernel.org>; Tue,  3 Sep 2024 07:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=192.198.163.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725347840; cv=none; b=tXL5/cefINKRUnUFBq4uir/rv706gGHH0LlavssSGLF51gQGyk7ZcRAPIrOMMfpjUwefN1cCkLuoIJGG5w5NGQzSDqN9E+Jyji3LdT0BsE/5OJSNwsGc1PhfbHQ0p3NhWbiN8++7rHRIyJdvS0tnJZ9QXT367oViZU2hv8nYxA4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725347840; c=relaxed/simple;
	bh=WcPHDq/ZMHWN0Yn/ogDoR/noT9h7C7s3w76X+xxKWKA=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=lgABDc6m8JDGVD4+/b3NX4DlVOvt+mF0PNSBMtX29bxQA+xAzhc00Il8pPIS5KBxK1MWEi7zgQlhiCpeUIRws+KTPNLsvh2ufUfyZ3p21qxyB6QOdzJKF2wwyxljzl82nk01h298azkQuvhakRyzO9a2+Tb1gEzR2smph3vWlSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=EA7szS+0; arc=none smtp.client-ip=192.198.163.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="EA7szS+0"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1725347838; x=1756883838;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=WcPHDq/ZMHWN0Yn/ogDoR/noT9h7C7s3w76X+xxKWKA=;
  b=EA7szS+0m6xTK3cT/jg4exSxAWxGtCGt2cjmHFqRsAGSTpO2k3PHH8cG
   fuuyJZNRMeo7qOTV7Hp2vZk+je1LIWvKAJMVWRAFee/DbWWjueuy27j5B
   cPNEd7C2FZmemGjkressBJCGi1IbjCAK2OIt8T7dRUG5wjatx6GcAD6zV
   vK5YzXhUm8/3asgdEZhljqx+xIPFhwjgfHJFK32TbffraY51TjJm1gqpQ
   CeFmrajhGqzUHXm8H+KVW2G52J32VCpKWAL19UvdOE48OJDUFyKSDRVHu
   E5Hzw9xfL3jl3JmF/OqrCblkUsDRqot6zvF2+rpSw/gOQrolO4YlnFOYl
   g==;
X-CSE-ConnectionGUID: 7MqJutDSQ8u+GEGKCO/hsg==
X-CSE-MsgGUID: NnEVeOSVSMCeN6esNPD/sA==
X-IronPort-AV: E=McAfee;i="6700,10204,11183"; a="13339531"
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="13339531"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa110.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:17:18 -0700
X-CSE-ConnectionGUID: 6Pxt8KCQQ/K4O5hYVGRYOg==
X-CSE-MsgGUID: gnHNIhZaT3Ou50+Xso6TSg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.10,198,1719903600"; 
   d="scan'208";a="69674580"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.1.223])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2024 00:17:16 -0700
Date: Tue, 3 Sep 2024 09:17:10 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, yukuai1@huaweicloud.com
Subject: Re: [PATCH md-6.12 1/1] md: add new_level sysfs interface
Message-ID: <20240903091710.00005cb2@linux.intel.com>
In-Reply-To: <CALTww2-G0EEaOma8z8ymoPkRWeX+m1f8RPaw3T2qbVM6XKXmUA@mail.gmail.com>
References: <20240828021828.63447-1-xni@redhat.com>
	<20240902121323.0000589d@linux.intel.com>
	<CALTww2-G0EEaOma8z8ymoPkRWeX+m1f8RPaw3T2qbVM6XKXmUA@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Sep 2024 08:18:19 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Mon, Sep 2, 2024 at 6:14=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Wed, 28 Aug 2024 10:18:28 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > This interface is used to updating new level during reshape progress.
> > > Now it doesn't update new level during reshape. So it can't know the
> > > new level when systemd service mdadm-grow-continue runs. And it can't
> > > finally change to new level.
> > >
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >  drivers/md/md.c | 29 +++++++++++++++++++++++++++++
> > >  1 file changed, 29 insertions(+)
> > >
> > > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > > index d3a837506a36..c639eca03df9 100644
> > > --- a/drivers/md/md.c
> > > +++ b/drivers/md/md.c
> > > @@ -4141,6 +4141,34 @@ level_store(struct mddev *mddev, const char *b=
uf,
> > > size_t len) static struct md_sysfs_entry md_level =3D
> > >  __ATTR(level, S_IRUGO|S_IWUSR, level_show, level_store);
> > >
> > > +static ssize_t
> > > +new_level_show(struct mddev *mddev, char *page)
> > > +{
> > > +     return sprintf(page, "%d\n", mddev->new_level);
> > > +}
> > > +
> > > +static ssize_t
> > > +new_level_store(struct mddev *mddev, const char *buf, size_t len)
> > > +{
> > > +     unsigned int n;
> > > +     int err;
> > > +
> > > +     err =3D kstrtouint(buf, 10, &n);
> > > +     if (err < 0)
> > > +             return err;
> > > +     err =3D mddev_lock(mddev);
> > > +     if (err)
> > > +             return err;
> > > +
> > > +     mddev->new_level =3D n;
> > > +     md_update_sb(mddev, 1); =20
> >
> > I don't see any code behind mddev->new_level handling so I suspect that
> > md_update_sb() does nothing in this case. Is there something I'm missin=
g? =20
>=20
> You mean the calling path md_update_sb->sync_sbs->super_1_sync?
>=20

No, I missed that mddev->new_level is a exiting property and it is already
implemented in kernel. Now, I understand that it is super0 metadata property
and you just presented it. This is fine.

What I can see is that calling md_update_super() in case of
external might be unnecessary but it is fine anyway I think.

maybe: if (!mddev->external)
               md_update_sb(mddev, 1);

but I don't see it used in the code anywhere. metadata update path is
still black box to me. Maybe Kuai can comment?

Thanks,
Mariusz
