From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] Forbid merging with partially assembled IMSM array
Date: Wed, 4 Jun 2014 12:30:46 +1000
Message-ID: <20140604123046.02e224d6@notabene.brown>
References: <84A53BEA6EAC69439B7E311E9B17A76F07918BDA@IRSMSX105.ger.corp.intel.com>
	<20140602121955.10a72b32@notabene.brown>
	<84A53BEA6EAC69439B7E311E9B17A76F0791C0DD@IRSMSX105.ger.corp.intel.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/awVa=HvqXy=8HG9yVb_VUWW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <84A53BEA6EAC69439B7E311E9B17A76F0791C0DD@IRSMSX105.ger.corp.intel.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Baldysiak, Pawel" <pawel.baldysiak@intel.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Paszkiewicz, Artur" <artur.paszkiewicz@intel.com>
List-Id: linux-raid.ids

--Sig_/awVa=HvqXy=8HG9yVb_VUWW
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 3 Jun 2014 09:03:16 +0000 "Baldysiak, Pawel"
<pawel.baldysiak@intel.com> wrote:

> >On Monday, June 02, 2014 4:20 AM NeilBrown [neilb@suse.de] wrote:=20
> > On Fri, 30 May 2014 13:11:43 +0000 "Baldysiak, Pawel"
> > <pawel.baldysiak@intel.com> wrote:
> >=20
> > > Changes introduced in commit:
> > > 0431869cec4c673309d9aa30a2df4b778bc0bd24
> > > enabled adding devices to partially assembled array.
> > > It causes assemble process to override checking controller of device.
> > >
> > > For example:
> > > If ones created IMSM array will be stopped, and some disks will be
> > > attached to different controller, mdadm will allow to fully assemble
> > > this array as one md device (due to marge one part to another).
> > >
> > > This patch resolve this problem by forbidding merge operation on
> > > arrays with IMSM metadata.
> >=20
> > Why do you think this is a good thing?
> > You seem to be saying "You cannot access that data  because I don't like
> > which controllers you have attached it to".
> >=20
> > My thought is that you should provide access to data whenever possible.
> >=20
> > Is there some important situation where the current behaviour will cause
> > real problems?
> >=20
> > Maybe a warning might be appropriate, but failure doesn't seem sensible=
...
> >=20
> > NeilBrown
> >=20
> Hi Neil,
>=20
> Sorry for all this mess with white-space corruption.
>=20
> Intel platforms have separate OpROMs for each controller.
> OpROMs manage SW RAIDs at startup and don't support arrays spanned across=
 different controllers.
> In this case array will become degraded or failed after reboot anyway, be=
cause each OpROM will overwrite metadata on disks based on disks attached t=
o specific controller.

If this is true, then surely we will never get into the situation where the
same metadata is seen on different controller: the OpROM will have 'fixed' =
it
already.

> User should never be able to assemble IMSM array with disks under differe=
nt controllers by default.

I ask again:
   "Is there some important situation where the current behaviour will cause
    real problems?"

If not, I don't feel that the change is justified.

NeilBrown

> You can always use "--force" to override this check.
>=20
> Pawel Baldysiak
>=20
> > >
> > > Signed-off-by: Pawel Baldysiak <pawel.baldysiak@intel.com>
> > > Reviewed-by: Artur Paszkiewicz <artur.paszkiewicz@intel.com>
> > >
> > > ---
> > > Assemble.c | 23 +++++++++++++++++++++++
> > > 1 file changed, 23 insertions(+)
> > >
> > > diff --git a/Assemble.c b/Assemble.c
> > > index a57d384..9fb65e5 100644
> > > --- a/Assemble.c
> > > +++ b/Assemble.c
> > > @@ -1329,6 +1329,29 @@ try_again:
> > >                                                return 1;
> > >                                }
> > >                                for (dv =3D pre_exist->devs; dv; dv =3D
> > > dv->next) {
> > > +                                             if (strncmp(mp->metadat=
a, "imsm", 4) =3D=3D 0 && !c-
> > >force) {
> > > +                                                             int dfd;
> > > +                                                             char dn=
[20];
> > > +                                                             struct =
supertype *st2;
> > > +                                                             sprintf=
(dn, "%d:%d", dv->disk.major,
> > > +                                                                    =
                         dv->disk.minor);
> > > +                                                             st2 =3D=
 dup_super(st);
> > > +                                                             dfd =3D=
 dev_open(dn, O_RDONLY);
> > > +                                                             if ((df=
d > 0) && (st2->ss->load_super(st2,
> > dfd, NULL) ||
> > > +                                                                  (s=
t->ss->compare_super(st, st2) !=3D 0))) {
> > > +                                                                    =
         pr_err("IMSM metadata
> > mismatch!\n");
> > > +                                                                    =
         pr_err("Aborting...\n");
> > > +                                                                    =
         close(dfd);
> > > +                                                             } else {
> > > +                                                                    =
         pr_err("IMSM Array already
> > partially assembled!\n");
> > > +                                                                    =
         pr_err("Aborting...\n");
> > > +                                                             }
> > > +                                                             if (st2=
) {
> > > +                                                                    =
         st2->ss->free_super(st2);
> > > +                                                                    =
         free(st2);
> > > +                                                             }
> > > +                                                             return =
1;
> > > +                                             }
> > >                                                /* We want to add this=
 device to our list,
> > >                                                 * but it could alread=
y be there if "mdadm -I"
> > >                                                 * started *after* we =
checked for O_EXCL.
> > > --
> > > 1.9.0
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/awVa=HvqXy=8HG9yVb_VUWW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU46E1jnsnt1WYoG5AQKh4Q/8C97jQ9/ELBp5m6U9kjGVlKf27mjMBXtN
p7x9u4b9ZRd2nhSgcUpdhdPLFBbSTqrgMulsHV4JglE/gn3Z3VeFzurokmQ9jClZ
XqMJ6YbJM9hCzwSdINB/FlwEDOOt78xAMdUQt1Gadzgufgg6U4O0KA4I4xwjhdky
Y5YHTlnAUAC6QQauGqWXI+4RXhvwL04xGCZ1py1q8jDOK0yU12TV0f2BGdFwh8wX
h6fzmGfl2d7l67wWSK+5+flMuWwS29vTLeoySs5doWUnt6oTL1gCLvPhyOX6RxFA
k8iJIT/xvahgyrHdyhMQMGmSxELOFDRNeBINJHWM85B/BvuDKH2faBLGhM+h9JmP
m/X83MHPP8oFl6SbaplE4gK1P+xG2c97vdLq5fNqU2ULg2Trg2pfK59o8SOOYOwt
MU92UIWxU371tSX92oAjUhT/xXf+37izoYnQkK10vStg3ZJgqcr5dQZUoTRWRP/n
Nhnr3t25/XLANypOZppDeq/7bLupoBkVboROkOgb0j6Ai7y+Qh6+qBE2vUZRMR1p
uVkSfv/pyafgiRqCeOuzD+vP+OhBSuLm8j00KwLDs9rKJe2PBEL2VFMiGDG7dSrj
Wnji1ww5ra1UCMT1MFQGbsAfCyXQ6ZD49hsKRUHNvGgNUA9YxgJePGIwANziG0p5
6fAz1ux5WcY=
=HC0q
-----END PGP SIGNATURE-----

--Sig_/awVa=HvqXy=8HG9yVb_VUWW--
