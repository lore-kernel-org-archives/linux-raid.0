From: NeilBrown <neilb@suse.de>
Subject: Re: IMSM - problem with reshape+systemd
Date: Tue, 20 May 2014 17:02:49 +1000
Message-ID: <20140520170249.695a0638@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F078F1EE0@IRSMSX105.ger.corp.intel.com>
	<20140424143138.222bd1f8@notabene.brown>
	<20140515144520.483db580@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F07908533@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/W92Ep4ICNZxT5tkq02ut6FM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F07908533@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/W92Ep4ICNZxT5tkq02ut6FM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 16 May 2014 16:07:58 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> On Thursday, May 15, 2014 6:45 AM NeilBrown [neilb@suse.de] wrote:
> > To: NeilBrown
> > Cc: Baldysiak, Pawel; linux-raid@vger.kernel.org; Paszkiewicz, Artur
> > Subject: Re: IMSM - problem with reshape+systemd
> >=20
> > On Thu, 24 Apr 2014 14:31:38 +1000 NeilBrown <neilb@suse.de> wrote:
> >=20
> > > On Fri, 18 Apr 2014 09:24:35 +0000 "Baldysiak, Pawel"
> > > <pawel.baldysiak@intel.com> wrote:
> > >
> > > > Hi Neil/All.
> > > > We have discovered some problems with IMSM array reshape under OSs
> > managed by systemd.
> > > > In case of reshape of arrays with IMSM metadata, mdadm manages the
> > whole reshape process and it needs to be running in background.
> > > > If we reboot while reshaping, array will be assembled at startup=20
> > > > by udevworker by IMPORT{program}=3D"mdadm -I /dev/sdX --export --of=
froot"
> > part of udev rule array.
> > > > Mdadm will fork and continue to reshape an array from checkpoint.
> > > > However, systemd will treat udevworker as hanged process and it=20
> > > > will be
> > killed due to timeout with all its children (reshape will hang then).
> > > > I had planned to propose a patch for this problem, where=20
> > > > additional unit file will be added and udev will start=20
> > > > systemd-service for mdadm -I command (see below), but then we will=
=20
> > > > lose information about
> > exported variables - the ones that are used to trigger=20
> > mdadm-last-resort service.
> > > >
> > > > Do You have any idea how to solve this problem, and keep both
> > functionalities?
> > >
> > > Hi,
> > >  thanks for raising this issue.
> > >
> > >  I think we need to address this using "mdadm --grow --continue".
> > >
> > >  e.g. in used we run "mdadm -I --freeze-reshape --export" and=20
> > > arrange for  that to report some setting if a reshape is needed.
> > >  If it is needed, we set SYSTEMD_WANTS to some service which will=20
> > > run "mdadm  --grow --continue $device".
> > >
> > >  Possibly we could get mdadm to run "systemctl start mdadm-
> > reshape@$dev"
> > >  instead of forking, like it now does for running mdmon.
> > >
> > >  I might have a poke at the code and see what falls out.
> > >
> >=20
> > Hi,
> >  I've just pushed some changes out to git://neil.brown.name/mdadm (and
> > github) which will hopefully address this problem.
> >=20
> > I've added a new systemd unit, and mdadm will try to "systemctl start"=
=20
> > it rather than continuing on in the back ground.
> >=20
> > It seems to work in at least one simple test case for me.  Can you=20
> > check that it works for you?
> >=20
> > Thanks,
> > NeilBrown
>=20
> Hi Neil.
> I have tested your patch, and it seems it does not work well.=20
> In case of incremental assemble of IMSM RAID array - routine
> "reshape_array" is always called from "reshape_container" with "forked" v=
ariable set to "1".
> In this  case  starting new unit file will be skipped. If we want to
> do it that way - whole routine that starts mdadm-grow-continue unit
> file should be moved to assemble_container_content and be run instead of =
calling "Grow_continue".

Thanks for testing.  I've push out some changes which should fix this issue.


>=20
> Also, I have made patch with alternative method which you mentioned befor=
e:=20
> > >  e.g. in used we run "mdadm -I --freeze-reshape --export" and=20
> > > arrange for  that to report some setting if a reshape is needed.
> > >  If it is needed, we set SYSTEMD_WANTS to some service which will=20
> > > run "mdadm  --grow --continue $device".
> Please see below.
>=20
> What do you think about it? Which way is better?

Your approach only works when the array is assembled from udev.
However we really want systemd to be used in all cases, including when the
reshape is started from a terminal window.  Having a uniform approach is go=
od.

Thanks,
NeilBrown



> If you decide to apply my patch - last commit "Grow: try to let "--grow -=
-continue" from systemd complete a reshape."should be reverted.
>=20
> Thanks
> Pawel Baldysiak
>=20
> ----
>=20
> Add new unit file - mdadm-reshape-continue
>=20
> If assemble operation is started by udev, then monitoring the reshape in =
the background won't work.
> So, if udev detects that array is started, and under reshape - it should =
ask systemd to start --grow --continue.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
>=20
> >From f36a416027a49c605e278a54e75b5cc03528b32c Mon Sep 17 00:00:00 2001
> From: NeilBrown <neilb@suse.de>
> Date: Wed, 14 May 2014 16:34:06 +1000
> Subject: [PATCH 1/1] Add new systemd unit file - mdadm-grow-continue
>=20
> If assemble operation is started by udev, then monitoring the reshape
> in the background won't work.
> So, if udev detects that array is started, and under reshape - it
> should ask systemd to start --grow --continue.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> ---
>  Assemble.c                           |  3 +++
>  Incremental.c                        |  5 +++++
>  Makefile                             |  1 +
>  mdadm.h                              |  1 +
>  systemd/mdadm-grow-continue@.service | 18 ++++++++++++++++++
>  udev-md-raid-assembly.rules          |  3 ++-
>  6 files changed, 30 insertions(+), 1 deletion(-)
>  create mode 100644 systemd/mdadm-grow-continue@.service
>=20
> diff --git a/Assemble.c b/Assemble.c
> index 8977928..8085e4d 100644
> --- a/Assemble.c
> +++ b/Assemble.c
> @@ -1913,6 +1913,9 @@ int assemble_container_content(struct supertype *st=
, int mdfd,
> =20
>  		err =3D Grow_continue(mdfd, st, content, c->backup_file,
>  				    c->freeze_reshape);
> +		if (c->export && result) {
> +			*result |=3D INCR_RESHAPE;
> +		}
>  	} else switch(content->array.level) {
>  		case LEVEL_LINEAR:
>  		case LEVEL_MULTIPATH:
> diff --git a/Incremental.c b/Incremental.c
> index c937258..903603a 100644
> --- a/Incremental.c
> +++ b/Incremental.c
> @@ -484,6 +484,9 @@ int Incremental(struct mddev_dev *devlist, struct con=
text *c,
>  		printf("MD_DEVICE=3D%s\n", fd2devnm(mdfd));
>  		printf("MD_DEVNAME=3D%s\n", md_devname);
>  		printf("MD_FOREIGN=3D%s\n", trustworthy =3D=3D FOREIGN ? "yes" : "no");
> +		if (!st->ss->external) {
> +			printf("MD_RESHAPE=3D%s\n", info.reshape_active !=3D 0 ? "yes" : "no"=
);
> +		}
>  	}
> =20
>  	/* 7/ Is there enough devices to possibly start the array? */
> @@ -1484,6 +1487,7 @@ static int Incremental_container(struct supertype *=
st, char *devname,
>  	else {
>  		if (c->export) {
>  			printf("MD_STARTED=3Dno\n");
> +			printf("MD_RESHAPE=3Dno\n");
>  		} else if (c->verbose)
>  			pr_err("not enough devices to start the container\n");
>  		return 0;
> @@ -1623,6 +1627,7 @@ static int Incremental_container(struct supertype *=
st, char *devname,
>  			sep =3D ',';
>  		}
>  		printf("\n");
> +		printf("MD_RESHAPE=3D%s\n", result & INCR_RESHAPE ? "yes" : "no");
>  	}
> =20
>  	/* don't move spares to container with volume being activated
> diff --git a/Makefile b/Makefile
> index b823d85..3af030b 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -288,6 +288,7 @@ install-systemd: systemd/mdmon@.service
>  	$(INSTALL) -D -m 644 systemd/mdmonitor.service $(DESTDIR)$(SYSTEMD_DIR)=
/mdmonitor.service
>  	$(INSTALL) -D -m 644 systemd/mdadm-last-resort@.timer $(DESTDIR)$(SYSTE=
MD_DIR)/mdadm-last-resort@.timer
>  	$(INSTALL) -D -m 644 systemd/mdadm-last-resort@.service $(DESTDIR)$(SYS=
TEMD_DIR)/mdadm-last-resort@.service
> +	$(INSTALL) -D -m 644 systemd/mdadm-grow-continue@.service $(DESTDIR)$(S=
YSTEMD_DIR)/mdadm-grow-continue@.service
>  	$(INSTALL) -D -m 755 systemd/mdadm.shutdown $(DESTDIR)$(SYSTEMD_DIR)-sh=
utdown/mdadm.shutdown
>  	if [ -f /etc/SuSE-release -o -n "$(SUSE)" ] ;then $(INSTALL) -D -m 755 =
systemd/SUSE-mdadm_env.sh $(DESTDIR)$(SYSTEMD_DIR)/../scripts/mdadm_env.sh =
;fi
> =20
> diff --git a/mdadm.h b/mdadm.h
> index a73d42a..c868c23 100644
> --- a/mdadm.h
> +++ b/mdadm.h
> @@ -1340,6 +1340,7 @@ extern int assemble_container_content(struct supert=
ype *st, int mdfd,
>  #define	INCR_UNSAFE	2
>  #define	INCR_ALREADY	4
>  #define	INCR_YES	8
> +#define INCR_RESHAPE	16
>  extern struct mdinfo *container_choose_spares(struct supertype *st,
>  					      unsigned long long min_size,
>  					      struct domainlist *domlist,
> diff --git a/systemd/mdadm-grow-continue@.service b/systemd/mdadm-grow-co=
ntinue@.service
> new file mode 100644
> index 0000000..391284f
> --- /dev/null
> +++ b/systemd/mdadm-grow-continue@.service
> @@ -0,0 +1,18 @@
> +#  This file is part of mdadm.
> +#
> +#  mdadm is free software; you can redistribute it and/or modify it
> +#  under the terms of the GNU General Public License as published by
> +#  the Free Software Foundation; either version 2 of the License, or
> +#  (at your option) any later version.
> +
> +[Unit]
> +Description=3DManage MD Reshape on /dev/%I
> +DefaultDependencies=3Dno
> +
> +[Service]
> +ExecStart=3D/sbin/mdadm --grow /dev/%i --continue
> +Type=3Dforking
> +StandardInput=3Dnull
> +StandardOutput=3Dnull
> +StandardError=3Dnull
> +KillMode=3Dnone
> diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
> index 824e7a9..e46bc93 100644
> --- a/udev-md-raid-assembly.rules
> +++ b/udev-md-raid-assembly.rules
> @@ -27,8 +27,9 @@ LABEL=3D"md_inc"
> =20
>  # remember you can limit what gets auto/incrementally assembled by
>  # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
> -ACTION=3D=3D"add|change", IMPORT{program}=3D"/sbin/mdadm --incremental -=
-export $devnode --offroot ${DEVLINKS}"
> +ACTION=3D=3D"add|change", IMPORT{program}=3D"/sbin/mdadm --incremental -=
-export $devnode --offroot ${DEVLINKS} --freeze-reshape"
>  ACTION=3D=3D"add|change", ENV{MD_STARTED}=3D=3D"*unsafe*", ENV{MD_FOREIG=
N}=3D=3D"no", ENV{SYSTEMD_WANTS}+=3D"mdadm-last-resort@$env{MD_DEVICE}.time=
r"
> +ACTION=3D=3D"add|change", ENV{MD_STARTED}=3D=3D"*yes*", ENV{MD_RESHAPE}=
=3D=3D"yes", ENV{SYSTEMD_WANTS}+=3D"mdadm-grow-continue@$env{MD_DEVICE}.ser=
vice"
>  ACTION=3D=3D"remove", ENV{ID_PATH}=3D=3D"?*", RUN+=3D"/sbin/mdadm -If $n=
ame --path $env{ID_PATH}"
>  ACTION=3D=3D"remove", ENV{ID_PATH}!=3D"?*", RUN+=3D"/sbin/mdadm -If $nam=
e"
> =20


--Sig_/W92Ep4ICNZxT5tkq02ut6FM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3r+GTnsnt1WYoG5AQK3Lw/+MlOU9I1xcZz9C0r86kMgm/FcFS1fQFD/
yS1+XbJQFSB8zyvHztvNNBrtKIXtsGUag8fLBkzatMtTCxHJQGgfUgVb+HVYQ+iB
bp3j73kofi91RqZ9DX8Mwc04al/yPixdReiGh1r/lG9qxSPBIQ2EC3rBHjIQFoFt
+C7ZfJDOXjGdRqAkDlaSplLnQMWpAPYdxrySXt3jjeP2x9LNDmHS+Lfw2o+Rwiz3
v/7hBJ5hwbXw8iuJ5hF4J8jJXYMSnbIeu4NXAsOKFG3XGWDEkPSybaqrxuh69JCS
DsHM9Bva1EhV17M0IROMLOMcjeT7X2uRHntdEdrXptmPjJprhbGDNzpj5mJPZxNj
cBwyxDxu2yqgukLXzJo3gKfTgSHoYJOqObja8/0V0wDnZNKI/khyvKk60eIVVOio
DE1bJg1cSFuqBQRE7HNfkQl1jVVekhrC81zWSK90JIONJVb4elyRR64Gx9+xlenQ
7o27pIhZwsVE9VNzkwN4SFeuUWEyIxrS7bQ5JuIZ9ya82MqZF7S9URk98sX18tgu
hyy6aVZJx2h1U3/b/kdNlTlYvknSW9ydhgL1RV8YtoAQALTsI8Hgdh8EBva6mzfd
5evBOqguN+ZwsP2Xy6qW8mM3GNCkEpI+Yxe3OP3HBbGd44dDx2P+eIRNxr44BzUz
n2aM661axNQ=
=jJ4d
-----END PGP SIGNATURE-----

--Sig_/W92Ep4ICNZxT5tkq02ut6FM--
