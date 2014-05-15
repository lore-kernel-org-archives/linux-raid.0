From: NeilBrown <neilb@suse.de>
Subject: Re: IMSM - problem with reshape+systemd
Date: Thu, 15 May 2014 14:45:20 +1000
Message-ID: <20140515144520.483db580@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F078F1EE0@IRSMSX105.ger.corp.intel.com>
	<20140424143138.222bd1f8@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/RvlIB/ZF3EuGS0d6ymXVVmu"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140424143138.222bd1f8@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/RvlIB/ZF3EuGS0d6ymXVVmu
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Apr 2014 14:31:38 +1000 NeilBrown <neilb@suse.de> wrote:

> On Fri, 18 Apr 2014 09:24:35 +0000 "Baldysiak, Pawel"
> <pawel.baldysiak@intel.com> wrote:
>=20
> > Hi Neil/All.
> > We have discovered some problems with IMSM array reshape under OSs mana=
ged by systemd.
> > In case of reshape of arrays with IMSM metadata, mdadm manages the whol=
e reshape process and it needs to be running in background.
> > If we reboot while reshaping, array will be assembled at startup
> > by udevworker by IMPORT{program}=3D"mdadm -I /dev/sdX --export --offroo=
t" part of udev rule array.
> > Mdadm will fork and continue to reshape an array from checkpoint.
> > However, systemd will treat udevworker as hanged process and it will be=
 killed due to timeout with all its children (reshape will hang then).
> > I had planned to propose a patch for this problem, where additional uni=
t file will be added
> > and udev will start systemd-service for mdadm -I command (see below),
> > but then we will lose information about exported variables - the ones t=
hat are used to trigger mdadm-last-resort service.
> >=20
> > Do You have any idea how to solve this problem, and keep both functiona=
lities?
>=20
> Hi,
>  thanks for raising this issue.
>=20
>  I think we need to address this using "mdadm --grow --continue".
>=20
>  e.g. in used we run "mdadm -I --freeze-reshape --export" and arrange for
>  that to report some setting if a reshape is needed.
>  If it is needed, we set SYSTEMD_WANTS to some service which will run "md=
adm
>  --grow --continue $device".
>=20
>  Possibly we could get mdadm to run "systemctl start mdadm-reshape@$dev"
>  instead of forking, like it now does for running mdmon.
>=20
>  I might have a poke at the code and see what falls out.
>=20

Hi,
 I've just pushed some changes out to git://neil.brown.name/mdadm (and gith=
ub)
which will hopefully address this problem.

I've added a new systemd unit, and mdadm will try to "systemctl start" it
rather than continuing on in the back ground.

It seems to work in at least one simple test case for me.  Can you check th=
at
it works for you?

Thanks,
NeilBrown

--Sig_/RvlIB/ZF3EuGS0d6ymXVVmu
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU3RGYDnsnt1WYoG5AQIVAA/+MH6UoTs62I22G+FMGgWCcel4adLDYx1x
xBOVZYL2+ngiha/rX0ZoikIO8SUNhmOeG4tg0SNWaTrEY+gBGCL4KyBN6CP6aFSe
EU6kzl7iG9DF7Dbvq8ibNFPxT5nZ244K5af2LnLht9YrdHOKy52d6Nn63Ozs98CQ
z/bYulkYKWoAnHzmYlmJXzrNh+5N+VQq9Jsjdy0ZsbpbaTVu+18bd8lZJkXnlcI7
fgj22DIwJz+nWfInzWKTAenYm9mdGNkHvMilrc8nQCL/xcqsMi9Y41t/KqNtffXj
fSoSIu2gIOdt4SBqLI41sgyRSPiGmQ1woBDsZDipNP3h9Zk2AyURo96CmPj/2iZd
e62ErebjGIYG+clKu5a2HYHtTKiNZXGh9S+Hw9tuYKR4Ok5rfu9H7TNVtiiw6kwu
CP/qYYrXBL8N/pScX+WvZdMQV2jR36iIoLRcHPv/Y0v8UJG7U+7XOzZPllbgEF8X
KWIf7/H5S+3lFHeegJmXz9WegL7hBuocMVuVgux671BZyFINGzFXQBk3SH49gAqK
OpuopbJHE6hcxYZl0SzMKN6tw+9uuHa2mGU8XGtBeB/3J/Cqad49CBnGKFkhLsB/
haKqrx9yLhMA0qxalPNr2yViSLmZd1VpUCOuVFhcuRwZVmWDk8X/xEXLnx4To3CJ
OB3FsXCFqQ4=
=SYv7
-----END PGP SIGNATURE-----

--Sig_/RvlIB/ZF3EuGS0d6ymXVVmu--
