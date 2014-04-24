From: NeilBrown <neilb@suse.de>
Subject: Re: IMSM - problem with reshape+systemd
Date: Thu, 24 Apr 2014 14:31:38 +1000
Message-ID: <20140424143138.222bd1f8@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F078F1EE0@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7ktuTtAbmqmi/sPuAwdxriP"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F078F1EE0@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/7ktuTtAbmqmi/sPuAwdxriP
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Apr 2014 09:24:35 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> Hi Neil/All.
> We have discovered some problems with IMSM array reshape under OSs manage=
d by systemd.
> In case of reshape of arrays with IMSM metadata, mdadm manages the whole =
reshape process and it needs to be running in background.
> If we reboot while reshaping, array will be assembled at startup
> by udevworker by IMPORT{program}=3D"mdadm -I /dev/sdX --export --offroot"=
 part of udev rule array.
> Mdadm will fork and continue to reshape an array from checkpoint.
> However, systemd will treat udevworker as hanged process and it will be k=
illed due to timeout with all its children (reshape will hang then).
> I had planned to propose a patch for this problem, where additional unit =
file will be added
> and udev will start systemd-service for mdadm -I command (see below),
> but then we will lose information about exported variables - the ones tha=
t are used to trigger mdadm-last-resort service.
>=20
> Do You have any idea how to solve this problem, and keep both functionali=
ties?

Hi,
 thanks for raising this issue.

 I think we need to address this using "mdadm --grow --continue".

 e.g. in used we run "mdadm -I --freeze-reshape --export" and arrange for
 that to report some setting if a reshape is needed.
 If it is needed, we set SYSTEMD_WANTS to some service which will run "mdadm
 --grow --continue $device".

 Possibly we could get mdadm to run "systemctl start mdadm-reshape@$dev"
 instead of forking, like it now does for running mdmon.

 I might have a poke at the code and see what falls out.

NeilBrown



>=20
> Pawel Baldysiak
>=20
> -------------------------------------------------------------------------=
-------------------------------------
> My patch ("IMPORT{program}" behaves same as "RUN", but exports output as =
variables):
>=20
> >From 8549f0ffcd72589cedf24d07b496af2ce16d14ec Mon Sep 17 00:00:00 2001
> From: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Date: Thu, 10 Apr 2014 15:16:02 +0200
> Subject: [PATCH] Use unit file for incremental assemblation from udev.
>=20
> Incremental assemblation of an array at OS boot is started by RUN
> command triggered by udev, so far. RUN command is used for starting
> short-time processes that will complete quickly. Some operations, like
> reshape of IMSM arrays, are managed by mdadm. In OSs managed by systemd -
> udev worker that triggered "mdadm -I" will be terminated by SIGKILL due
> to timeout. This also kills mdadm process, so reshape will stop.
>=20
> This patch adds new unit file, that will be started in OSs managed by
> systemd instead of "RUN=3D" command. Udev rule will only start the new
> service and finish its work. Unit file will start "mdadm -I" for disk
> passed as an argument from rule.
>=20
> In scenario where we reshape IMSM array, general migration record is
> written only on two first disks of an array, so if we reboot OS and udev
> starts adding disks from e.g. the last one, "mdadm -I" will end with
> exit code "4" due to inaccessible general migration record. This should
> also be considered as success exit status, because disk is successfully
> assembled according to its metadata. Otherwise system will log
> information about service failure.
>=20
> Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> ---
> Makefile                    |  1 +
> systemd/mdadm-inc@.service  | 10 ++++++++++
> udev-md-raid-assembly.rules |  4 +++-
> 3 files changed, 14 insertions(+), 1 deletion(-)
> create mode 100644 systemd/mdadm-inc@.service
>=20
> diff --git a/Makefile b/Makefile
> index b823d85..b199efd 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -288,6 +288,7 @@ install-systemd: systemd/mdmon@.service
>                $(INSTALL) -D -m 644 systemd/mdmonitor.service $(DESTDIR)$=
(SYSTEMD_DIR)/mdmonitor.service
>                $(INSTALL) -D -m 644 systemd/mdadm-last-resort@.timer $(DE=
STDIR)$(SYSTEMD_DIR)/mdadm-last-resort@.timer
>                $(INSTALL) -D -m 644 systemd/mdadm-last-resort@.service $(=
DESTDIR)$(SYSTEMD_DIR)/mdadm-last-resort@.service
> +             $(INSTALL) -D -m 644 systemd/mdadm-inc@.service $(DESTDIR)$=
(SYSTEMD_DIR)/mdadm-inc@.service
>                $(INSTALL) -D -m 755 systemd/mdadm.shutdown $(DESTDIR)$(SY=
STEMD_DIR)-shutdown/mdadm.shutdown
>                if [ -f /etc/SuSE-release -o -n "$(SUSE)" ] ;then $(INSTAL=
L) -D -m 755 systemd/SUSE-mdadm_env.sh $(DESTDIR)$(SYSTEMD_DIR)/../scripts/=
mdadm_env.sh ;fi
> diff --git a/systemd/mdadm-inc@.service b/systemd/mdadm-inc@.service
> new file mode 100644
> index 0000000..b7a97a3
> --- /dev/null
> +++ b/systemd/mdadm-inc@.service
> @@ -0,0 +1,10 @@
> +[Unit]
> +Description=3DMD incremental assemblation on %I
> +DefaultDependencies=3Dno
> +Before=3Dinitrd-switch-root.target
> +
> +[Service]
> +Type=3Dforking
> +GuessMainPID=3Dfalse
> +ExecStart=3D/sbin/mdadm -I %I
> +SuccessExitStatus=3D0 4
> diff --git a/udev-md-raid-assembly.rules b/udev-md-raid-assembly.rules
> index 824e7a9..e295875 100644
> --- a/udev-md-raid-assembly.rules
> +++ b/udev-md-raid-assembly.rules
> @@ -27,7 +27,9 @@ LABEL=3D"md_inc"
>  # remember you can limit what gets auto/incrementally assembled by
> # mdadm.conf(5)'s 'AUTO' and selectively whitelist using 'ARRAY'
> -ACTION=3D=3D"add|change", IMPORT{program}=3D"/sbin/mdadm --incremental -=
-export $devnode --offroot ${DEVLINKS}"
> +ACTION=3D=3D"add|change", PROGRAM=3D"/bin/readlink /sbin/init", RESULT=
=3D=3D"*systemd", TAG+=3D"systemd", ENV{SYSTEMD_WANTS}=3D"mdadm-inc@$devnod=
e.service"
> +ACTION=3D=3D"add|change", ENV{SYSTEMD_WANTS}!=3D"?*", IMPORT{program}=3D=
"/sbin/mdadm --incremental --export $devnode --offroot ${DEVLINKS}"
> +
> ACTION=3D=3D"add|change", ENV{MD_STARTED}=3D=3D"*unsafe*", ENV{MD_FOREIGN=
}=3D=3D"no", ENV{SYSTEMD_WANTS}+=3D"mdadm-last-resort@$env{MD_DEVICE}.timer"
> ACTION=3D=3D"remove", ENV{ID_PATH}=3D=3D"?*", RUN+=3D"/sbin/mdadm -If $na=
me --path $env{ID_PATH}"
> ACTION=3D=3D"remove", ENV{ID_PATH}!=3D"?*", RUN+=3D"/sbin/mdadm -If $name"
> --
> 1.8.4.5
>=20


--Sig_/7ktuTtAbmqmi/sPuAwdxriP
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU1iTqjnsnt1WYoG5AQK/KQ/+JUhkSqUvz8siQts/4XQUSlZJ+bwFbcx2
STr/gbKdlhgV/1VpJPVuxR3+C044eKw5CtFGWgHPmFrROcu6XUFtW36hRiBHENsS
QP7mhU6SWoEMEeJJV3y8EC3ZNRJ32o33eJWfag1PrQcrBrfJPUUOyI34K2bJhNll
qyEV/AYsGK4xDj/gsw8GVd4L/DrCGi9iprXpdvwzHGHL4W70IrW74vsuD4h4lBiF
8EJK9kwys9r6nA5oY7p9LKH6vUscX4GHp91BvMRerV/yk2qYdOC3/LieAmpPr3gf
w3EJQ1FlHZFGn7/0JkRALMlG5VCqbp0OrQ8MpfmuCHms+FgFxlv6SJjbzC78gUUh
R0ToFJA/rPJzZLupzI2fSxmGGx9l5RH/0LpvqHFeQHULvixVgNC3GkuM3s9Ch9pp
wfLrnkpLSQs03iARlEq6F2lKDGojOCDUFUkBlMJBRiv2N8hkG96MKtwYaEtVUZoE
7OOWuq9Liliw8JnQHXUChocYiMnqfRS69sQDSmoFAkjsoDrcUJ2qVjROcmk+7VXh
F6muSw6lArbWJ41sefpvImU+LIVeu/JD3fpIKnoM+S0VRZNRX299LDzqrMTqvgSf
Nw8u5Oo2lpe/bOolMazFajQW8UhtqNSoOMHot4UMHUdGiBekbZv3RnFwcjYWrrhh
pnPskIZoUTM=
=Io2O
-----END PGP SIGNATURE-----

--Sig_/7ktuTtAbmqmi/sPuAwdxriP--
