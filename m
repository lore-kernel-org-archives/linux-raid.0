From: Doug Ledford <dledford@redhat.com>
Subject: Re: Implementing low level timeouts within MD
Date: Mon, 29 Oct 2007 13:22:01 -0400
Message-ID: <1193678521.10336.486.camel@firewall.xsintricity.com>
References: <1193418753.4771.17.camel@w100>
	 <1193425254.10336.290.camel@firewall.xsintricity.com>
	 <1193521561.7690.14.camel@w100>
	 <1193529329.10336.366.camel@firewall.xsintricity.com>
	 <1193552822.6541.8.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature"; boundary="=-RBULkk6y3FWiUKxzZzIj"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1193552822.6541.8.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-RBULkk6y3FWiUKxzZzIj
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

On Sun, 2007-10-28 at 01:27 -0500, Alberto Alonso wrote:
> On Sat, 2007-10-27 at 19:55 -0400, Doug Ledford wrote:
> > On Sat, 2007-10-27 at 16:46 -0500, Alberto Alonso wrote:
> > > Regardless of the fact that it is not MD's fault, it does make
> > > software raid an invalid choice when combined with those drivers. A
> > > single disk failure within a RAID5 array bringing a file server down
> > > is not a valid option under most situations.
> >=20
> > Without knowing the exact controller you have and driver you use, I
> > certainly can't tell the situation.  However, I will note that there ar=
e
> > times when no matter how well the driver is written, the wrong type of
> > drive failure *will* take down the entire machine.  For example, on an
> > SPI SCSI bus, a single drive failure that involves a blown terminator
> > will cause the electrical signaling on the bus to go dead no matter wha=
t
> > the driver does to try and work around it.
>=20
> Sorry I thought I copied the list with the info that I sent to Richard.
> Here is the main hardware combinations.
>=20
> --- Excerpt Start ----
> Certainly. The times when I had good results (ie. failed drives
> with properly degraded arrays have been with old PATA based IDE=20
> controllers built in the motherboard and the Highpoint PATA
> cards). The failures (ie. single disk failure bringing the whole
> server down) have been with the following:
>=20
> * External disks on USB enclosures, both RAID1 and RAID5 (two different
>   systems) Don't know the actual controller for these. I assume it is
>   related to usb-storage, but can probably research the actual chipset,
>   if it is needed.

OK, these you don't get to count.  If you run raid over USB...well...you
get what you get.  IDE never really was a proper server interface, and
SATA is much better, but USB was never anything other than a means to
connect simple devices without having to put a card in your PC, it was
never intended to be a raid transport.

> * Internal serverworks PATA controller on a netengine server. The
>   server if off waiting to get picked up, so I can't get the important
>   details.

1 PATA failure.

> * Supermicro MB with ICH5/ICH5R controller and 2 RAID5 arrays of 3=20
>   disks each. (only one drive on one array went bad)
>=20
> * VIA VT6420 built into the MB with RAID1 across 2 SATA drives.
>=20
> * And the most complex is this week's server with 4 PCI/PCI-X cards.
>   But the one that hanged the server was a 4 disk RAID5 array on a
>   RocketRAID1540 card.

And 3 SATA failures, right?  I'm assuming the Supermicro is SATA or else
it has more PATA ports than I've ever seen.

Was the RocketRAID card in hardware or software raid mode?  It sounds
like it could be a combination of both, something like hardware on the
card, and software across the different cards or something like that.

What kernels were these under?

> --- Excerpt End ----
>=20
> >=20
> > > I wasn't even asking as to whether or not it should, I was asking if
> > > it could.
> >=20
> > It could, but without careful control of timeouts for differing types o=
f
> > devices, you could end up making the software raid less reliable instea=
d
> > of more reliable overall.
>=20
> Even if the default timeout was really long (ie. 1 minute) and then
> configurable on a per device (or class) via /proc it would really help.

It's a band-aid.  It's working around other bugs in the kernel instead
of fixing the real problem.

> > Generally speaking, most modern drivers will work well.  It's easier to
> > maintain a list of known bad drivers than known good drivers.
>=20
> That's what has been so frustrating. The old PATA IDE hardware always
> worked and the new stuff is what has crashed.

In all fairness, the SATA core is still relatively young.  IDE was
around for eons, where as Jeff started the SATA code just a few years
back.  In that time I know he's had to deal with both software bugs and
hardware bugs that would lock a SATA port up solid with no return.  What
it sounds like to me is you found some of those.

> > Be careful which hardware raid you choose, as in the past several brand=
s
> > have been known to have the exact same problem you are having with
> > software raid, so you may not end up buying yourself anything.  (I'm no=
t
> > naming names because it's been long enough since I paid attention to
> > hardware raid driver issues that the issues I knew of could have been
> > solved by now and I don't want to improperly accuse a currently well
> > working driver of being broken)
>=20
> I have settled for 3ware. All my tests showed that it performed quite
> well and kicked drives out when needed. Of course, I haven't had a
> bad drive on a 3ware production server yet, so.... I may end up
> pulling the little bit of hair I have left.
>=20
> I am now rushing the RocketRAID 2220 into production without testing
> due to it being the only thing I could get my hands on. I'll report
> any experiences as they happen.
>=20
> Thanks for all the info,
>=20
> Alberto
>=20
--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
              http://people.redhat.com/dledford

Infiniband specific RPMs available at
              http://people.redhat.com/dledford/Infiniband

--=-RBULkk6y3FWiUKxzZzIj
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: This is a digitally signed message part

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (GNU/Linux)

iD8DBQBHJha5TzP9PM7pjw8RAgStAJ9GMh3pj+tI5H0HA5YuahRzyMWsIgCfaJBD
gf+cx9/DxCWTDdTKdIrdAQM=
=STor
-----END PGP SIGNATURE-----

--=-RBULkk6y3FWiUKxzZzIj--

