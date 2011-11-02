From: NeilBrown <neilb@suse.de>
Subject: Re: possibly silly question (raid failover)
Date: Wed, 2 Nov 2011 12:48:16 +1100
Message-ID: <20111102124816.33a55447@notabene.brown>
References: <4EAF3F78.5060900@meetinghouse.net>
	<j8odkj$46h$1@dough.gmane.org>
	<4EAFEE95.6070608@meetinghouse.net>
	<4EAFF636.6060904@anonymous.org.uk>
	<j8p0g3$9r4$1@dough.gmane.org>
	<4EB052E6.4050400@meetinghouse.net>
	<20111101221539.GA1319@www5.open-std.org>
	<20111102092526.50b410b1@notabene.brown>
	<20111102013756.GA10763@www5.open-std.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/7j9_m3px.lmW46dlZAza_Tp"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20111102013756.GA10763@www5.open-std.org>
Sender: linux-raid-owner@vger.kernel.org
To: keld@keldix.com
Cc: Miles Fidelman <mfidelman@meetinghouse.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/7j9_m3px.lmW46dlZAza_Tp
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Nov 2011 02:37:56 +0100 keld@keldix.com wrote:

> On Wed, Nov 02, 2011 at 09:25:26AM +1100, NeilBrown wrote:
> > On Tue, 1 Nov 2011 23:15:39 +0100 keld@keldix.com wrote:
> >=20
> > > On Tue, Nov 01, 2011 at 04:13:26PM -0400, Miles Fidelman wrote:
> > > > David Brown wrote:
> > > > >
> > > > >No, md RAID10 does /not/ offer more redundancy than RAID1.  You ar=
e=20
> > > > >right that md RAID10 offers more than RAID1 (or traditional RAID0 =
over=20
> > > > >RAID1 sets) - but it is a convenience and performance benefit, not=
 a=20
> > > > >redundancy benefit.  In particular, it lets you build RAID10 from =
any=20
> > > > >number of disks, not just two.  And it lets you stripe over all di=
sks,=20
> > > > >improving performance for some loads (though not /all/ loads - if =
you=20
> > > > >have lots of concurrent small reads, you may be faster using plain=
=20
> > > > >RAID1).
> > >=20
> > > In fact raid10 mas a bit less redundancy than raid1+0.
> > > It is as far as I know built as raid0+1 with a disk layout
> > > where you can only loose eg 1 out of 4 disks, while raid1+0
> > > in some cases can loose 2 disks out of 4.
> >=20
> > With md/raid10 you can in some case lose 2 out of 4 disks and survive, =
just
> > like raid1+0.
>=20
> OK, in which cases, and when is this not the case?
>=20
> best regards
> keld

"just like raid1+0"


NeilBrown

--Sig_/7j9_m3px.lmW46dlZAza_Tp
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTrChYDnsnt1WYoG5AQJY8hAAutudp/SCJAQr0cjIdb5T3ruKtmMShiOw
L3ifw9mWqd046Ko/VbqehkjPAFH9Q//ESNwdKb36y7qU0xDfvIH4fmz2+jUnxwFZ
KHWtznQHMJh+0PB5v+Pb3r7SZg1ByCxz88U7gRUAxQWODYoQx6JoP5+UTuAEKMEW
9Q+LD9PxpxFmyOBwaAZq+1ithWY3nMoyuUZXKlMbyUx6J+ztgzggCNRbOnCfzKUP
RXlL6OH6jDVvS6OOJ0B3M2bJfw8at3Km3ayiV2pxVeD3q/a/V/GU8D9wSQ1crcFz
QOG2x3fd54h8miWWkM0Cl/UifrKS3eGX4cd5JeM/V9Ysf6GJ2X+7a3BGpllURJmd
QhLMitRCaR1hhxJXdDzdgdXcuqeqVE2EKqWWgLJOvpm4uDjzgjhwfAvLVikidR6w
O4ZMVHJLCLwM1VMtQIgVlOD2zXUqQKgu2fQcC048G4rfbQ9WNoInvy7Tf6UtNaGA
2nsUggVBDDw2/YtYtUW6MNXFIc4AKk5PSwYovHerFawyPXcq/2cedBah9DFNLzre
TEfOO7IFCHKkISYrPTpYZAFIK276cG6D6BWVSS1XVz7O/t4yknR9SUj3aaz7Q3dm
l1cE1FNPhmUuCIz8hOquo5D+mESt5IjaemTgGE7ByTJa90fyfbFEinq3I3aVn5qN
fSvjzOUW81k=
=vF8u
-----END PGP SIGNATURE-----

--Sig_/7j9_m3px.lmW46dlZAza_Tp--
