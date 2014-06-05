From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Forbid merging with partially assembled IMSM array
Date: Thu, 5 Jun 2014 16:27:30 +1000
Message-ID: <20140605162730.33e36f25@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BDA@IRSMSX105.ger.corp.intel.com>
	<20140602121955.10a72b32@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791C0DD@IRSMSX105.ger.corp.intel.com>
	<20140604123046.02e224d6@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791D2DE@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/YIi9/Dr1ZTj7M3oTnw7rUws"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F0791D2DE@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/YIi9/Dr1ZTj7M3oTnw7rUws
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 4 Jun 2014 09:25:47 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:


> Hi Neil
> =20
> There are several cases where not forbidding this operation can cause pro=
blems.
> For example, if user will create IMSM array at one platform, then stop it=
, detach devices,
> and hotplug them to another platform (mixed between two different control=
lers) -=20
> everything will be looking good (array will be incrementally assembled wi=
thout any errors) until reboot.
> After that, user will be confused why array is degraded/failed and will b=
e at risk of losing data.
> Also, creation of IMSM array under different controllers is forbidden, so=
 there is no point in allowing that it in assemble process.
>=20
> If you really think this is no justification - I will prepare a patch tha=
t will print warning,
> but in my opinion this operation should be allowed only with "--force"...=
=20
>=20

I came across a situation once where someone was trying to crash-dump onto =
an
IMSM array.  'crashdump' does some sort of kexec thing and runs a very
minimal kernel/installation  which just does crash dumps.

It didn't work because mdadm couldn't find the OpROM in that context and so
refused the assemble the array.
I really don't like that sort of thing happening.
If the OpROM is going to destroy your data (or whatever it does) when you
plug different devices into different controllers, then that is the OpROM's
problem, not mine.  I just want to make sure people can get at their data
in as many situations as possible.


A warning is probably OK, though I wonder if anyone would ever see it.
However the code would need improvement.
Doing a strcmp for "imsm" is not acceptable.

I'm not even sure I understand what they rest of the code is trying to do.
It doesn't seem to make reference to separate OpROMs....

NeilBrown




> Thanks
> Pawel Baldysiak
>=20
> >=20
> > > You can always use "--force" to override this check.
> > >
> > > Pawel Baldysiak
> > >
> > > > >
> > > > > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > > > > Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> > > > >
> > > > > ---
> > > > > Assemble.c | 23 +++++++++++++++++++++++
> > > > > 1 file changed, 23 insertions(+)
> > > > >
> > > > > diff --git a/Assemble.c b/Assemble.c index a57d384..9fb65e5 100644
> > > > > --- a/Assemble.c
> > > > > +++ b/Assemble.c
> > > > > @@ -1329,6 +1329,29 @@ try_again:
> > > > >                                                return 1;
> > > > >                                }
> > > > >                                for (dv =3D pre_exist->devs; dv; d=
v =3D
> > > > > dv->next) {
> > > > > +                                             if
> > > > > + (strncmp(mp->metadata, "imsm", 4) =3D=3D 0 && !c-
> > > > >force) {
> > > > > +                                                             int=
 dfd;
> > > > > +                                                             cha=
r dn[20];
> > > > > +                                                             str=
uct supertype *st2;
> > > > > +                                                             spr=
intf(dn, "%d:%d", dv->disk.major,
> > > > > +                                                                =
                             dv->disk.minor);
> > > > > +                                                             st2=
 =3D dup_super(st);
> > > > > +                                                             dfd=
 =3D dev_open(dn, O_RDONLY);
> > > > > +                                                             if
> > > > > + ((dfd > 0) && (st2->ss->load_super(st2,
> > > > dfd, NULL) ||
> > > > > +                                                                =
  (st->ss->compare_super(st, st2) !=3D
> > 0))) {
> > > > > +
> > > > > + pr_err("IMSM metadata
> > > > mismatch!\n");
> > > > > +                                                                =
             pr_err("Aborting...\n");
> > > > > +                                                                =
             close(dfd);
> > > > > +                                                             } e=
lse {
> > > > > +
> > > > > + pr_err("IMSM Array already
> > > > partially assembled!\n");
> > > > > +                                                                =
             pr_err("Aborting...\n");
> > > > > +                                                             }
> > > > > +                                                             if =
(st2) {
> > > > > +                                                                =
             st2->ss->free_super(st2);
> > > > > +                                                                =
             free(st2);
> > > > > +                                                             }
> > > > > +                                                             ret=
urn 1;
> > > > > +                                             }
> > > > >                                                /* We want to add =
this device to our list,
> > > > >                                                 * but it could al=
ready be there if "mdadm -I"
> > > > >                                                 * started *after*=
 we checked for O_EXCL.
> > > > > --
> > > > > 1.9.0
> > >
> > > --
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"
> > > in the body of a message to majordomo@vger.kernel.org More
> > majordomo
> > > info at  http://vger.kernel.org/majordomo-info.html
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/YIi9/Dr1ZTj7M3oTnw7rUws
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5AN0jnsnt1WYoG5AQJ7kBAAuaDIYlC32BuX5aqeeruIcMP3jwx4PzJl
pPMUX/yWiLhg1K/kOI/CFkpmowJKbVMlyRWgp/0CNhnbRMb9ikY6J9oyUFyCBtbz
HmmUM3hd1C9cRjtJUQQ3nTfOv1fZFozH1HK/jr1pzk74O5wy/S+K5QJ1Rda2ULv5
1tJRPSqQyvhkg8eRWYqNOrk+xRKBPhLZVYNL4Wx8KZCMyYbF3h2gxgRnVENbUMtW
WRFH69qXn1fatO3id1VsBwmbX7jHCP48cL16nCk9xu4al4IXvTT3ZpMnxf6pjbHC
H4o+dpZ0548U06xMK++OI1U5K8rjePp0ASgI6ovfvviGyFKxPORspdEzTYugz19h
HFJoDI/x020rjEOVpJ/1LlscaGxgAuDvqeYpiDUY3C7gMyLiA+fJbAGpVDM21rKm
DJDRComHztPukUtZ20NE9jhvIkoD+GDI2X/r36892dgkvwR0EpoHn/dZoyqMYDnb
D3EmSS/ZaE5jOzLyefr3caUVsIjSI4l2CcWL9XVx6S6XEPhtgKiRDG92YrzNpPzL
Xy6j/g9c6F6iHQGOiCy2KjzWbNTb5niCPi2SMADl4TIacyK2meLnhyjh9D4Bd2nT
UDTJaJB4n/X4PDgPeDZVj0i6WlUbKhfNg4on+lP9zVmmKGnWXKW4wgsTGQk0yrkY
1RZG4qzXpFs=
=ZrEK
-----END PGP SIGNATURE-----

--Sig_/YIi9/Dr1ZTj7M3oTnw7rUws--
