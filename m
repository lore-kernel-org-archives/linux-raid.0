From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: possibly silly question (raid failover)
Date: Tue, 1 Nov 2011 21:50:58 +0000
Message-ID: <20111101215058.GB20565@cthulhu.home.robinhill.me.uk>
References: <4EAF3F78.5060900@meetinghouse.net>
 <j8odkj$46h$1@dough.gmane.org>
 <4EAFEE95.6070608@meetinghouse.net>
 <4EAFF636.6060904@anonymous.org.uk>
 <j8p0g3$9r4$1@dough.gmane.org>
 <4EB052E6.4050400@meetinghouse.net>
 <20111101212023.GA20565@cthulhu.home.robinhill.me.uk>
 <4EB06561.8090706@meetinghouse.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="xXmbgvnjoT4axfJE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4EB06561.8090706@meetinghouse.net>
Sender: linux-raid-owner@vger.kernel.org
To: Miles Fidelman <mfidelman@meetinghouse.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--xXmbgvnjoT4axfJE
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Tue Nov 01, 2011 at 05:32:17 -0400, Miles Fidelman wrote:

> Robin Hill wrote:
> > On Tue Nov 01, 2011 at 04:13:26 -0400, Miles Fidelman wrote:
> >
> >> David Brown wrote:
> >>> No, md RAID10 does /not/ offer more redundancy than RAID1.  You are
> >>> right that md RAID10 offers more than RAID1 (or traditional RAID0 over
> >>> RAID1 sets) - but it is a convenience and performance benefit, not a
> >>> redundancy benefit.  In particular, it lets you build RAID10 from any
> >>> number of disks, not just two.  And it lets you stripe over all disks,
> >>> improving performance for some loads (though not /all/ loads - if you
> >>> have lots of concurrent small reads, you may be faster using plain
> >>> RAID1).
> >> wasn't suggesting that it does - just that it does things differently
> >> than normal raid 1+0 - for example, by doing mirroring and striping as=
 a
> >> unitary operation, it works across odd number of drives - it also (I
> >> think) allows for more than 2 copies of a block (not completely clear
> >> how many copies of a block would be made if you specified a 16 drive
> >> array) - sort of what I'm wondering here
> >>
> > By default it'll make 2 copies, regardless how many devices are in the
> > array. You can specify how many copies you want though, so -n3 will give
> > you a near configuration with 3 copies, -n4 for four copies, etc.
> >
> >
> cool, so with 16 drives, and say -n6 or -n8, and a far configuration -=20
> that gives a pretty good level of resistance to multi-disk failures, as=
=20
> well as an entire node failure (taking out 4 drives)
>=20
Sorry, my mistake - it should be -p n3, or -p n4. You'll want -p f6/-p
f8 to get a far configuration though, but yes, that should give good
redundancy against a single node failure.

> which then leaves the question of whether the md driver, itself, can be=
=20
> failed over from one node to another
>=20
I don't see why not. You'll probably need to force assembly though, as
it's likely the devices will be slightly out-of-synch after the node
failure.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--xXmbgvnjoT4axfJE
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.17 (GNU/Linux)

iEUEARECAAYFAk6wacEACgkQShxCyD40xBL/wwCgxW7LrnpwI755TMLlZtp7HiYl
iw0Al00P9j7KdarzUDwfxa9iRRSk9gk=
=8LR/
-----END PGP SIGNATURE-----

--xXmbgvnjoT4axfJE--
