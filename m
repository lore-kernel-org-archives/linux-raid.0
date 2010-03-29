From: Doug Ledford <dledford@redhat.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 19:35:30 -0400
Message-ID: <4BB13942.3030400@redhat.com>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com> <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com> <4BB0ED13.6020507@redhat.com> <4BB0F32F.9030803@anonymous.org.uk> <4BB0F820.4030707@redhat.com> <4BB12B77.8030902@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigBF5CA911DC6A9A6971B15902"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB12B77.8030902@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigBF5CA911DC6A9A6971B15902
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/29/2010 06:36 PM, John Robinson wrote:
> On 29/03/2010 19:57, Doug Ledford wrote:
>> On 03/29/2010 02:36 PM, John Robinson wrote:
> [...]
>>> Yes, but do create the partition(s), boot sector, etc and set up the
>>> spare(s).
>>
>> Really, we should never have to do this in the situation I listed: aka=

>> no degraded arrays exist.  This implies that if you had a raid1 /boot
>> array, that it's still intact.  So partitioning and setting up boot
>> loaders doesn't make sense as the new disk isn't going in to replace
>> anything.  You *might* want to add it to the raid1 /boot, but we don't=

>> know that so doing things automatically doesn't make sense.
>=20
> Actually I've just recently had the scenario where it would have made
> perfect sense. I hooked up the RAID chassis SATA[0-4] ports to the RAID=

> chassis and put 3 drives in the first 3 slots. Actually it turned out
> I'd wired it up R-L not L-R so if I'd added a new drive in one of the
> two right-hand slots it would have turned up as sda on the next boot.

Yes, but how do you want to fix that situation?  Would you want to make
the new drives be new boot drives, or would you prefer to shut down,
move all the previous drives over two slots, and then put the new drive
into the fourth slot that you previously thought was the second slot?  I
understand your situation, but were I in that position I'd just shuffle
my drives to correct my original mistake and go on with things, I
wouldn't make the new drives be boot drives.  So I'm still not sure I
see the point to making a new drive that isn't replacing an existing
drive automatically get set up for boot duty.

> OK, to some extent that's me being stupid, but at the same time I
> correctly hooked up the first 5 SATA ports to the hot-swap chassis and
> would want them considered the same group etc.

I understand wanting them in the same group, but unless something is
degraded, just being in the same group doesn't tell us if you want to
keep it as a spare or use it to grow things.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigBF5CA911DC6A9A6971B15902
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuxOUIACgkQg6WylM+/8ZRc7ACfTKrKKxOTG8Ca05iaEypPqQ5K
tSkAnixDHJSRUGnkS1d52t7tsTVXCQQE
=ljul
-----END PGP SIGNATURE-----

--------------enigBF5CA911DC6A9A6971B15902--
