From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] FIX: Cannot continue reshape if incremental assembly is
 used
Date: Mon, 19 Sep 2011 16:40:57 +1000
Message-ID: <20110919164057.1ddc79db@notabene.brown>
References: <D9FFE20C522965449E182ACE73889AEB020100@IRSMSX101.ger.corp.intel.com>
	<CABE8wwsRYSD=zUGJbhAtRFqGL+WPPP4Sy85ExsvSxog6k1JymQ@mail.gmail.com>
	<20110908112633.25a982b0@notabene.brown>
	<CABE8wwuheLbPA8JCJ0pw_nNOsWBWowHmLZ+piUOHXYcoFRtuHA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/fdG.T77/vwWYnWf+lY+Kzqh"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CABE8wwuheLbPA8JCJ0pw_nNOsWBWowHmLZ+piUOHXYcoFRtuHA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Williams, Dan J" <dan.j.williams@intel.com>
Cc: "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "Dorau, Lukasz" <lukasz.dorau@intel.com>
List-Id: linux-raid.ids

--Sig_/fdG.T77/vwWYnWf+lY+Kzqh
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 7 Sep 2011 21:42:28 -0700 "Williams, Dan J"
<dan.j.williams@intel.com> wrote:

> On Sep 7, 2011 6:26 PM, "NeilBrown" <neilb@suse.de> wrote:
> >
> > On Wed, 7 Sep 2011 18:11:12 -0700 "Williams, Dan J"
> > <dan.j.williams@intel.com> wrote:
> >
> > > On Wed, Sep 7, 2011 at 6:21 AM, Dorau, Lukasz <lukasz.dorau@intel.com>
> wrote:
> > > Hmm, this might just be cribbed from the initial DDF implementation,
> > > should be straightforward to reuse the count we use for
> > > container_enough, but I'm not seeing where Incremental uses
> > > working_disks for external arrays...
> >
> > Assemble.c: assemble_container_content()
> > ....
> >        if (runstop > 0 ||
> >                 (working + preexist + expansion) >=3D
> >                        content->array.working_disks) {
> > ....
> >
>=20
> ...so now i'd like to kill ->container_enough, because similar to the
> MD_SB_INVALID suggestion it's probably better to let ->container_content
> flag the true state rather than some sideband "don't call
> ->container_content yet" mechanism.

(catching up on some old mail).

I would be happy with that.

I don't exactly object to ->container_enough as it is conceivable that the
container knows something about the whole that you cannot deduce from the
member arrays.
But we definitely to want working_disks to be accurate so that we don't just
trust container_enough.

Thanks,
NeilBrown

--Sig_/fdG.T77/vwWYnWf+lY+Kzqh
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOduP5G5fc6gV+Wb0RAs1ZAKCzAwXSdsz+dtrqEfMDXkVKMrGMaACguCX+
v/Z7xXOh9dI4M9r2TLttqeA=
=NTq0
-----END PGP SIGNATURE-----

--Sig_/fdG.T77/vwWYnWf+lY+Kzqh--
