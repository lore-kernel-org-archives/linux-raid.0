From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Grow: Do not use grow-continue unit file if reshape is
 starting
Date: Tue, 8 Jul 2014 11:34:12 +1000
Message-ID: <20140708113412.10e3a8df@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F19CC0430@IRSMSX105.ger.corp.intel.com>
	<20140707110613.3b558b33@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F19CC0918@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/io9Y/T9pgi.IYa49Gi2Xtgw"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F19CC0918@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/io9Y/T9pgi.IYa49Gi2Xtgw
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 7 Jul 2014 14:18:40 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> > On Monday, July 07, 2014 3:06 AM Neil Brown wrote:
> > To: Baldysiak, Pawel
> > Cc: linux-raid@vger.kernel.org; Paszkiewicz, Artur
> > Subject: Re: [PATCH] Grow: Do not use grow-continue unit file if reshap=
e is
> > starting
> >=20
> > On Fri, 4 Jul 2014 08:59:00 +0000 "Baldysiak, Pawel"
> > <pawel.baldysiak@intel.com> wrote:
> >=20
> > > Mdadm should use mdadm-grow-continue unit file only if reshape is
> > > going to be continued. Otherwise, array specific reshape with IMSM
> > > metadata will fail to start, due to missing information about ongoing
> > > migration - grow-continue will try to start again the reshape process.
> >=20
> > I don't think I agree.  I think mdadm should always use mdadm-grow-
> > continue unit file if it is available.
> >=20
> > Please explain in more detail what problem you are seeing.
> >=20
> > NeilBrown
> >=20
>=20
> Hi Neil
>=20
> If we try to do array-specific reshape (e.g. change from level 0 to 5)=20
> mdadm will impose all changes to metadata and start reshape - before runn=
ing grow-continue.
> After that  grow-continue will see that reshape progress is '0', so will =
overwrite "restart" by setting it to =3D0.

I assume you are referring to this code:
	if (st->ss->external && restart && (info->reshape_progress =3D=3D 0)) {
          .....
		if ((verify_reshape_position(info, reshape.level) >=3D 0) &&
		    (info->reshape_progress =3D=3D 0))
			restart =3D 0;
	}

in reshape_array().

> Then it will try to impose all changes again and fail - with error:
> "Cannot set device shape for /dev/md/vol" - It will be unable to write ch=
anges to sysfs,
> due to already started reshape (which freeze at '0' progress).
>=20
> We can try to fix it by moving part of code that runs grow-continue in re=
shape_array earlier,
>  so "start_reshape() " will be executed by grow-continue (I am testing th=
at kind of patch now),=20
> or forbid running grow-continue when reshape is about to start (patch is =
tested, attach in my prev mail).
>=20
> What do you think about that?
> Do you have any other idea how to fix this issue?

I suspect that the real problem is in the code above.
Maybe it should read the "sync_action" attribute and if it is "reshape", th=
en
this is obviously a restart and it shouldn't set "restart" to 0.

Can you try something like that?

NeilBrown


>=20
> Thanks
> Pawel Baldysiak
>=20
> > >
> > > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > > ---
> > >  Grow.c | 2 +-
> > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > >
> > > diff --git a/Grow.c b/Grow.c
> > > index a2f4f14..0cd9442 100644
> > > --- a/Grow.c
> > > +++ b/Grow.c
> > > @@ -3272,7 +3272,7 @@ started:
> > >  		return 1;
> > >  	}
> > >
> > > -	if (!forked && !check_env("MDADM_NO_SYSTEMCTL"))
> > > +	if (restart && !forked && !check_env("MDADM_NO_SYSTEMCTL"))
> > >  		if (continue_via_systemd(container ?: sra->sys_name)) {
> > >  			free(fdlist);
> > >  			free(offsets);



--=20

--=20

--Sig_/io9Y/T9pgi.IYa49Gi2Xtgw
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU7tKlDnsnt1WYoG5AQIFqA//SoqSS3NF40m81NkVun9GbKjp6Mc9CxDl
4EX6q8G2/W68ltTzezkiaf5JhGfvOWdFvbAdAtb7pQnRtuc8b7xM9PxdefsiAJiM
3PZvWOuhu8LA2iCGmFWvyvY8VK8L1rscK96TFqjvraAmi0A5kAkeb0dh/l0+ZFei
PcgJroanDtjZDwqgrq9ppZ/P/34o8CiSqLtWpjr1+DhfuOkS3yU35LvQGW1C/gR5
ZpDw0RsTgq/3NMBlu0hDsg3RD82uD7MErg9Fb1djDxrBKCXlwnDT0ywSSoA+IBE4
O+z9j8D7h+30XpkHJfThQoqq5Tb+yeaSF4en5+JBmdcMlXZVRwPtEAtjvyHebR57
lsLA2InpQRK0P1Eyq2rtXJhDojQ72i5u4B7sk8orkFF3KwT11xsVvn8ch3alTip+
cy1gTkjBKL0pN+d+/kTE9jxmS0HdvSOG08n41Je/iXc5GeeIpArspKnmCQeOoKJ9
s67rEivvmfnyv2YpX3fbgJzeZRACTODc9C3HgCfVOzZgcWNECxCIprxN1qRytUsm
vUZGXLkek+MYcadCTTx+2dQ6d7eVui5lCWnz4ykfjXCwJbt0pyqShmcOET3vmg+y
/ts5aCrF84XzH6FA+v8y3kD4640aPdHitQ3ZjraoEvUlHe26r0Wu8D00DRvLymGO
3PZD5lFkcF8=
=25/a
-----END PGP SIGNATURE-----

--Sig_/io9Y/T9pgi.IYa49Gi2Xtgw--
