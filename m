From: Doug Ledford <dledford@redhat.com>
Subject: Re: Auto Rebuild on hot-plug
Date: Mon, 29 Mar 2010 14:57:36 -0400
Message-ID: <4BB0F820.4030707@redhat.com>
References: <20100325113543.0e2124c5@notabene.brown>	 <905EDD02F158D948B186911EB64DB3D11C510278@irsmsx503.ger.corp.intel.com> <e9c3a7c21003261737k1e753b08xc6f8eb45d0320be9@mail.gmail.com> <4BB0ED13.6020507@redhat.com> <4BB0F32F.9030803@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC5958835D31BB89741829033"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB0F32F.9030803@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Dan Williams <dan.j.williams@intel.com>, "Labun, Marcin" <Marcin.Labun@intel.com>, Neil Brown <neilb@suse.de>, "Hawrylewicz Czarnowski, Przemyslaw" <przemyslaw.hawrylewicz.czarnowski@intel.com>, "Ciechanowski, Ed" <ed.ciechanowski@intel.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Bill Davidsen <davidsen@tmr.com>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC5958835D31BB89741829033
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 03/29/2010 02:36 PM, John Robinson wrote:
> On 29/03/2010 19:10, Doug Ledford wrote:
> [...]
>> All of the above actions are related to domains that are degraded.  Bu=
t
>> what to do if the array isn't degraded?  We could add the device as a
>> spare, but if the array isn't degraded, adding a new hot spare doesn't=

>> really *do* anything.  No rebuild will start, nothing immediate happen=
s,
>> it just goes in and sits there.  And now that we have all these fancy
>> grow options, it's not entirely clear that a user would want that
>> anyway.  So, I would argue that if the array isn't degraded, then ther=
e
>> is no sense of emergency in our actions, and there exists multiple
>> options for what to do with the device, some include being a hot spare=

>> while others include using the device to grow the array, and the
>> possibilities and answers to what to do here are not at all clear.  Ev=
en
>> if the user had previously configured us to treat the device as a spar=
e,
>> they may change their mind and want to grow things.  Given that there'=
s
>> no immediate need to do anything as there aren't any degraded arrays, =
I
>> say let the user do whatever they want and don't try to do anything
>> automatically as it seems likely to me that the user's wants in this
>> area are likely to change from time to time based on circumstances and=

>> having them update the config file prior to inserting the device is mo=
re
>> klunky than just telling them to do whatever they want themselves afte=
r
>> inserting the device.
> [...]
>=20
> Yes, but do create the partition(s), boot sector, etc and set up the
> spare(s).

Really, we should never have to do this in the situation I listed: aka
no degraded arrays exist.  This implies that if you had a raid1 /boot
array, that it's still intact.  So partitioning and setting up boot
loaders doesn't make sense as the new disk isn't going in to replace
anything.  You *might* want to add it to the raid1 /boot, but we don't
know that so doing things automatically doesn't make sense.

> The user installed the system with anaconda or whatever, and
> may not know the incantations to partition his new disc or install a
> boot loader, so if he's managed to configure a mdadm.conf which says th=
e
> spare slots in his RAID chassis should belong to mdadm, prepare them fo=
r
> him. Then all he needs to do is issue whatever grow command.
>=20
> I think the exception to this is /boot on RAID-1, where I would prefer
> to be able to have the system automatically add the new partition as an=

> active mirror instead of a hot spare, in case this new drive is what we=

> have to boot off next time.

Again, I'm drawing a distinction here between a degraded array and a
non-degraded array.  If the current array isn't degraded, then we won't
be booting off the new drive next time unless the user goes into the
BIOS and sets the new drive as the active boot device.  And if the user
is going to do that, then they ought to be able to setup their new boot
mirror member themselves.

> I suppose there might be circumstances where you want to do something
> else, like Netgear do on their ReadyNAS, but while it might be nice to
> be able to configure that sort of automatic growing and reshaping, it
> doesn't belong in the default config.
>=20
> Cheers,
>=20
> John.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigC5958835D31BB89741829033
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAkuw+CAACgkQg6WylM+/8ZQw+ACcDP836p/LIRLo7iRJultffLqO
x5sAoJt3GnpOKPDDR8iMcWSdIR12KsVP
=qI6j
-----END PGP SIGNATURE-----

--------------enigC5958835D31BB89741829033--
