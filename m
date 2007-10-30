From: Doug Ledford <dledford@redhat.com>
Subject: Re: Implementing low level timeouts within MD
Date: Tue, 30 Oct 2007 13:58:30 -0400
Message-ID: <1193767110.10336.534.camel@firewall.xsintricity.com>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <1193521561.7690.14.camel@w100>
	 <1193529329.10336.366.camel@firewall.xsintricity.com>
	 <1193552822.6541.8.camel@w100>
	 <1193678521.10336.486.camel@firewall.xsintricity.com>
	 <1193720887.3876.8.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-AyZQxtvkr6qdd53Poemh"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193720887.3876.8.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-AyZQxtvkr6qdd53Poemh
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Tue, 2007-10-30 at 00:08 -0500, Alberto Alonso wrote:
> On Mon, 2007-10-29 at 13:22 -0400, Doug Ledford wrote:
>=20
> > OK, these you don't get to count.  If you run raid over USB...well...yo=
u
> > get what you get.  IDE never really was a proper server interface, and
> > SATA is much better, but USB was never anything other than a means to
> > connect simple devices without having to put a card in your PC, it was
> > never intended to be a raid transport.
>=20
> I still count them ;-) I guess I just would of hoped for software raid
> to really don't care about the lower layers.

The job of software raid is to help protect your data.  In order to do
that, the raid needs to be run over something that *at least* provides a
minimum level of reliability itself.  The entire USB spec is written
under the assumption that a USB device can disappear at any time and the
stack must accept that (and it can, just trip on a cable some time and
watch your raid device get all pissy).  So, yes, software raid can run
over any block device, but putting it over an unreliable connection
medium is like telling a gladiator that he has to face the lion with no
sword, no shield, and his hands tied behind his back.  He might survive,
but you have so seriously handicapped him that it's all but over.

> >=20
> > > * Supermicro MB with ICH5/ICH5R controller and 2 RAID5 arrays of 3=20
> > >   disks each. (only one drive on one array went bad)
> > >=20
> > > * VIA VT6420 built into the MB with RAID1 across 2 SATA drives.
> > >=20
> > > * And the most complex is this week's server with 4 PCI/PCI-X cards.
> > >   But the one that hanged the server was a 4 disk RAID5 array on a
> > >   RocketRAID1540 card.
> >=20
> > And 3 SATA failures, right?  I'm assuming the Supermicro is SATA or els=
e
> > it has more PATA ports than I've ever seen.
> >=20
> > Was the RocketRAID card in hardware or software raid mode?  It sounds
> > like it could be a combination of both, something like hardware on the
> > card, and software across the different cards or something like that.
> >=20
> > What kernels were these under?
>=20
>=20
> Yes, these 3 were all SATA. The kernels (in the same order as above)=20
> are:
>=20
> * 2.4.21-4.ELsmp #1 (Basically RHEL v3)

*Really* old kernel.  RHEL3 is in maintenance mode already, and that was
the GA kernel.  It was also the first RHEL release with SATA support.
So, first gen driver on first gen kernel.

> * 2.6.18-4-686 #1 SMP on a Fedora Core release 2
> * 2.6.17.13 (compiled from vanilla sources)
>=20
> The RocketRAID was configured for all drives as legacy/normal and
> software RAID5 across all drives. I wasn't using hardware raid on
> the last described system when it crashed.

So, the system that died *just this week* was running 2.6.17.13?  Like I
said in my last email, the SATA stack has been evolving over the last
few years, and that's quite a few revisions behind.  My basic advice is
this: if you are going to use the latest and greatest hardware options,
then you should either make sure you are using an up to date distro
kernel of some sort or you need to watch the kernel update announcements
for fixes related to that hardware and update your kernels/drivers as
appropriate.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-AyZQxtvkr6qdd53Poemh
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJ3DGTzP9PM7pjw8RAs8HAJ0U3FL4lQ4Ww0HQLfF/1d4UhPcZcwCcCJoh
PfB3bHD2bEVlMb/BgnJ3YYk=
=Atuw
-----END PGP SIGNATURE-----

--=-AyZQxtvkr6qdd53Poemh--

