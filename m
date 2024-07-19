Received: from mgamail.intel.com (mgamail.intel.com [198.175.65.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57FE342076
	for <linux-raid@vger.kernel.org>; Fri, 19 Jul 2024 09:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.175.65.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721382750; cv=none; b=dbWZ2JqywIAeYbRXJwEc2wtMaieer+o/cJQK4bwjAnG6bzCNKVSthUBACVEvhV1p/ZtB3cYFHzpPq1qkp0osslowkeE6FkUhedLsZ3fsXFAzkgNeFph42sABZaIQMOyZR24wYjQnxrFMfbNm+TmPG02t0ELQG2u1h0H6p+t3vxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721382750; c=relaxed/simple;
	bh=T4aEbmaIqd3LONhKV3/L1YgT1OMqBgalv0JEvQRAjP4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=PDkG3rwaKIwcP350dwgXj+fgty76MxOHANxRJj/OOH4Vt6OdMjqb9En709f5LCl/kqz1dTu/2beNtTeC2Xvj/U9r9/j1qC6wq5U1FqZewsxvOZ5NS1AwLDX1bJCBeh48+sv0LLFsFFmq7CFFY46ZzEYBZoe51D7Cw7vx/599asA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com; spf=none smtp.mailfrom=linux.intel.com; dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b=QB4kl3j4; arc=none smtp.client-ip=198.175.65.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=linux.intel.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=intel.com header.i=@intel.com header.b="QB4kl3j4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1721382749; x=1752918749;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=T4aEbmaIqd3LONhKV3/L1YgT1OMqBgalv0JEvQRAjP4=;
  b=QB4kl3j4LAdEhZDhbhKn46WPwHJabjZYz42DlqKCf1IX3tXHcPH72Ffz
   YeWX0xhn5mWASXrEVenogt3vxE9O7uGIcEs2SjCu2Bru0wy3kxYT9QjFb
   lIHRQs2h+Ujm77L3O4MebQZturnnZjMbFL1Y5GbbGF0XF/7arpK4KUj6u
   HY6mQ8t/lGO1DST1CEwF5qvPfCbMPCimDNeYYGFZDFHsB8Ko45ewQ4e5C
   blHXhl+wVyXATNHkasWT3N02FiaGLbrK7m4O9rC7w8cjQEL+svE/ICprR
   cg15T3UYJ1tiJDC3ccbYDT2KSwcrpn/GdhbIQMdcl8zt+xTLKYZFjcW6i
   A==;
X-CSE-ConnectionGUID: sVgJnqO3TZWFyAUIogNPqQ==
X-CSE-MsgGUID: oXUSzgyAToCx+7jKDdea9g==
X-IronPort-AV: E=McAfee;i="6700,10204,11137"; a="22797031"
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="22797031"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by orvoesa106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 02:52:28 -0700
X-CSE-ConnectionGUID: dB3iwW4WS3qCVMGaD6V0rw==
X-CSE-MsgGUID: dhJwSZtjTx6e8asnmdHXyg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.09,220,1716274800"; 
   d="scan'208";a="55244946"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.246.17.194])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jul 2024 02:52:27 -0700
Date: Fri, 19 Jul 2024 11:52:21 +0200
From: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To: Xiao Ni <xni@redhat.com>
Cc: ncroxon@redhat.com, linux-raid@vger.kernel.org
Subject: Re: [PATCH 03/15] mdadm/Grow: fix coverity issue RESOURCE_LEAK
Message-ID: <20240719115221.0000150d@linux.intel.com>
In-Reply-To: <CALTww283LHH3+-jh=AOgoerbBphpch7+FCJrp3K29rt7dNP72w@mail.gmail.com>
References: <20240715073604.30307-1-xni@redhat.com>
 <20240715073604.30307-4-xni@redhat.com>
 <20240717132946.00002373@linux.intel.com>
 <CALTww283LHH3+-jh=AOgoerbBphpch7+FCJrp3K29rt7dNP72w@mail.gmail.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Thu, 18 Jul 2024 11:27:50 +0800
Xiao Ni <xni@redhat.com> wrote:

> On Wed, Jul 17, 2024 at 7:29=E2=80=AFPM Mariusz Tkaczyk
> <mariusz.tkaczyk@linux.intel.com> wrote:
> >
> > On Mon, 15 Jul 2024 15:35:52 +0800
> > Xiao Ni <xni@redhat.com> wrote:
> > =20
> > > Signed-off-by: Xiao Ni <xni@redhat.com>
> > > ---
> > >  Grow.c | 53 ++++++++++++++++++++++++++++++++++++++++-------------
> > >  1 file changed, 40 insertions(+), 13 deletions(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index 7ae967bda067..632be7db8d38 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -485,6 +485,7 @@ int Grow_addbitmap(char *devname, int fd, struct
> > > context *c, struct shape *s) int bitmap_fd;
> > >               int d;
> > >               int max_devs =3D st->max_devs;
> > > +             int err =3D 0;
> > >
> > >               /* try to load a superblock */
> > >               for (d =3D 0; d < max_devs; d++) {
> > > @@ -525,13 +526,14 @@ int Grow_addbitmap(char *devname, int fd, struct
> > > context *c, struct shape *s) return 1;
> > >               }
> > >               if (ioctl(fd, SET_BITMAP_FILE, bitmap_fd) < 0) {
> > > -                     int err =3D errno;
> > > +                     err =3D errno;
> > >                       if (errno =3D=3D EBUSY)
> > >                               pr_err("Cannot add bitmap while array is
> > > resyncing or reshaping etc.\n"); pr_err("Cannot set bitmap file for %=
s:
> > > %s\n", devname, strerror(err));
> > > -                     return 1;
> > >               }
> > > +             close(bitmap_fd);
> > > +             return err; =20
> >
> > I don't think that we should return errno. I would say that mdadm should
> > define returned statues for functions, that is why I added mdadm_status=
_t.
> >
> > Otherwise, same value may have two meanings. For example, in some cases=
 we
> > are fine with particular error code from error might be misleading (it =
may
> > match allowed status).
> > This is not the case here, it is just an example.
> >
> > I think that we should not return errno outside if not intended i.e.
> > function is projected to return errno in every case. =20
>=20
> Ok, I'll keep the original way.
>=20
> @@ -530,8 +530,9 @@ int Grow_addbitmap(char *devname, int fd, struct
> context *c, struct shape *s)
>                                 pr_err("Cannot add bitmap while array
> is resyncing or reshaping etc.\n");
>                         pr_err("Cannot set bitmap file for %s: %s\n",
>                                 devname, strerror(err));
> -                       return 1;
>                 }
> +               close(bitmap_fd);
> +               return 1;
>         }
>=20
>=20
> > =20
> > >       }
> > >
> > >       return 0;
> > > @@ -3083,6 +3085,7 @@ static int reshape_array(char *container, int f=
d,
> > > char *devname, int done;
> > >       struct mdinfo *sra =3D NULL;
> > >       char buf[SYSFS_MAX_BUF_SIZE];
> > > +     bool located_backup =3D false;
> > >
> > >       /* when reshaping a RAID0, the component_size might be zero.
> > >        * So try to fix that up.
> > > @@ -3165,8 +3168,10 @@ static int reshape_array(char *container, int =
fd,
> > > char *devname, goto release;
> > >               }
> > >
> > > -             if (!backup_file)
> > > +             if (!backup_file) {
> > >                       backup_file =3D locate_backup(sra->sys_name);
> > > +                     located_backup =3D true;
> > > +             }
> > >
> > >               goto started;
> > >       }
> > > @@ -3612,15 +3617,15 @@ started:
> > >                       mdstat_wait(30 - (delayed-1) * 25);
> > >       } while (delayed);
> > >       mdstat_close();
> > > -     if (check_env("MDADM_GROW_VERIFY"))
> > > -             fd =3D open(devname, O_RDONLY | O_DIRECT);
> > > -     else
> > > -             fd =3D -1;
> > >       mlockall(MCL_FUTURE);
> > >
> > >       if (signal_s(SIGTERM, catch_term) =3D=3D SIG_ERR)
> > >               goto release;
> > >
> > > +     if (check_env("MDADM_GROW_VERIFY"))
> > > +             fd =3D open(devname, O_RDONLY | O_DIRECT);
> > > +     else
> > > +             fd =3D -1; =20
> >
> > close_fd() is used unconditionally on fd few line earlier so it seems t=
hat
> > else path is not needed but this code is massive so please double check=
 if
> > I'm right.
> >
> > We may call close_fd() on the closed resource and then it is not update=
d to
> > -1, assuming that close fails with EBADF. =20
>=20
> How about this:
> -       if (check_env("MDADM_GROW_VERIFY"))
> -               fd =3D open(devname, O_RDONLY | O_DIRECT);
> -       else
> -               fd =3D -1;
>         mlockall(MCL_FUTURE);
>=20
>         if (signal_s(SIGTERM, catch_term) =3D=3D SIG_ERR)
>                 goto release;
>=20
> +       if (check_env("MDADM_GROW_VERIFY"))
> +               fd =3D open(devname, O_RDONLY | O_DIRECT);
>         if (st->ss->external) {
>                 /* metadata handler takes it from here */
>                 done =3D st->ss->manage_reshape(
> @@ -3632,6 +3634,7 @@ started:
>                         fd, sra, &reshape, st, blocks, fdlist, offsets,
>                         d - odisks, fdlist + odisks, offsets + odisks);
>=20
> +       close_fd(&fd);
>         free(fdlist);
>         free(offsets);
> >
> > Right way to fix it is to replace all close(fd) by close_fd(fd). It will
> > give is credibility that double close is not possible. =20
>=20
> I'll replace them in the next version. But I think it should depend on
> the specific case. Sometimes, we don't need to reset fd to -1, because
> we don't use it anymore. So the standard close function is better.

If this is unused later then compiler will should skip the assignment (it s=
hould
be detected and optimized during compilation). Not a big deal I think
but you are right, if we know that, we don't have to use this extended close
logic.

In this case we have massive function and fd is closed and opened many times
and there is a fork in the middle of it. I cannot follow all usages.
I would prefer to make it safer. There must be a reason why there is else f=
d =3D
-1; branch. Having close_fd(&fd) instead of close(fd) everywhere has follow=
ing
advantages:
- double close attempt is not possible (because fd is updated to -1 each ti=
me)
- If fd value is the number now reused (we may open different file descript=
or
  after close(fd)), it won't be unexpectedly closed.
- if the mentioned close_fd(&fd) few lines earlier is not needed then is
  skipped.

I know that it might be not optimal but I accept that as a compromise betwe=
en
massive, overextended code and application security.

>=20
> >
> > =20
> > >       if (st->ss->external) {
> > >               /* metadata handler takes it from here */
> > >               done =3D st->ss->manage_reshape(
> > > @@ -3632,6 +3637,8 @@ started:
> > >                       fd, sra, &reshape, st, blocks, fdlist, offsets,
> > >                       d - odisks, fdlist + odisks, offsets + odisks);
> > >
> > > +     if (fd >=3D 0)
> > > +             close(fd);
> > >       free(fdlist);
> > >       free(offsets);
> > >
> > > @@ -3701,6 +3708,8 @@ out:
> > >       exit(0);
> > >
> > >  release:
> > > +     if (located_backup)
> > > +             free(backup_file); =20
> > =20
> > >       free(fdlist);
> > >       free(offsets);
> > >       if (orig_level !=3D UnSet && sra) {
> > > @@ -3839,6 +3848,7 @@ int reshape_container(char *container, char
> > > *devname, pr_err("Unable to initialize sysfs for %s\n",
> > >                              mdstat->devnm);
> > >                       rv =3D 1;
> > > +                     close(fd);
> > >                       break;
> > >               }
> > >
> > > @@ -4717,6 +4727,7 @@ int Grow_restart(struct supertype *st, struct m=
dinfo
> > > *info, int *fdlist, unsigned long long *offsets;
> > >       unsigned long long  nstripe, ostripe;
> > >       int ndata, odata;
> > > +     int fd, backup_fd =3D -1;
> > >
> > >       odata =3D info->array.raid_disks - info->delta_disks - 1;
> > >       if (info->array.level =3D=3D 6)
> > > @@ -4732,9 +4743,18 @@ int Grow_restart(struct supertype *st, struct
> > > mdinfo *info, int *fdlist,
> > >                * been used
> > >                */
> > >               old_disks =3D cnt;
> > > +
> > > +     if (backup_file) {
> > > +             backup_fd =3D open(backup_file, O_RDONLY);
> > > +             if (backup_fd < 0) {
> > > +                     pr_err("Can't open backup file %s : %s\n",
> > > +                             backup_file, strerror(errno));
> > > +                     return -EINVAL;
> > > +             }
> > > +     }
> > > +
> > >       for (i=3Dold_disks-(backup_file?1:0); i<cnt; i++) {
> > >               struct mdinfo dinfo;
> > > -             int fd;
> > >               int bsbsize;
> > >               char *devname, namebuf[20];
> > >               unsigned long long lo, hi;
> > > @@ -4747,12 +4767,9 @@ int Grow_restart(struct supertype *st, struct
> > > mdinfo *info, int *fdlist,
> > >                * else restore data and update all superblocks
> > >                */
> > >               if (i =3D=3D old_disks-1) {
> > > -                     fd =3D open(backup_file, O_RDONLY);
> > > -                     if (fd<0) {
> > > -                             pr_err("backup file %s inaccessible: %s=
\n",
> > > -                                     backup_file, strerror(errno));
> > > +                     if (backup_fd < 0)
> > >                               continue; =20
> >
> > You can use is_fd_valid(). Please also review other patches on that. =20
>=20
> I searched by command `cat * | grep "< 0"`, this is the only place.
> I'll change it. But is it really convenient? if_fd_valid just does the
> same thing. Because if_fd_valid is not a standard C api, developers
> may not know this api.
>=20

It is easy to find so I don't see it as a problem.

For example in systemd we have:

        _cleanup_close_ int fd =3D -1;

I don't know how it works and for that reason shouldn't I use it? I have to
believe that developer who added it implemented it correctly.

Same here, name is pretty straightforward so we can use this to avoid direct
comparisons which might be bug prone because it is easy to miss <=3D, > in
review. Especially, that our brains are likely to skip the common patterns.

We had following problem in the past:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=3Db71de056c=
ec70784ef2727e2febd7a6c88e580db

Thanks,
Mariusz
