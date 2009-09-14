From: Ronny Adsetts <ronny.adsetts@amazinginternet.com>
Subject: Re: RAID mirror, resyncing from bad disk
Date: Mon, 14 Sep 2009 10:13:20 +0100
Message-ID: <4AAE0930.1030204@amazinginternet.com>
References: <4AAD45AE.6060503@amazinginternet.com> <4AAD5510.2060505@anonymous.org.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigE5B183DF01EC67B059C18B99"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AAD5510.2060505@anonymous.org.uk>
Sender: linux-raid-owner@vger.kernel.org
To: John Robinson <john.robinson@anonymous.org.uk>
Cc: Linux RAID ML <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigE5B183DF01EC67B059C18B99
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

John Robinson said at 13/09/2009 21:24:
> On 13/09/2009 20:19, Ronny Adsetts wrote:
> [...]
>> The problematic array is /dev/md2 and the dying disk is /dev/sdc.
>>
>> When I try to resync it gets to about 99.2% then gives load of I/O
>> errors in /var/log/kern.log and finally gives up and restarts the sync=
=2E
>>
>> Ideally I just want to tell the system to ignore the bad sector and
>> just resync the array.
>>
>> Does anyone have any ideas on how I can get this resolved short of
>> reinstalling?
>=20
> You need to ddrescue the contents of the dying drive onto a good one,
> then replace the dying drive with the fresh one. This will require
> taking the array down but you won't have to reinstall, unless you've
> lost something important in the lost sectors on the dying drive.

The bad sector is thankfully right at the end of the disk in an unallocat=
ed part of the LVM setup.

So, do I ddrescue the entire disk? I assume this will copy everything inc=
luding the partition table and other gubbins?

Thanks very much, this looks like a winner to me. :-).

Ronny
--=20
Ronny Adsetts
Technical Director
Amazing Internet Ltd, London
t: +44 20 8607 9535
f: +44 20 8607 9536
w: www.amazinginternet.com

Registered office: UK House, 82 Heath Road, Twickenham TW1 4BW
Registered in England. Company No. 4042957=20



--------------enigE5B183DF01EC67B059C18B99
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (MingW32)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org/

iEYEARECAAYFAkquCTAACgkQ/j4uMRUAlJ/YkQCg9b1/Augx74GFzWWsraUYGwlW
x+wAoLsRyiCtewOlgOJJU43fTW1iSl3p
=pjgo
-----END PGP SIGNATURE-----

--------------enigE5B183DF01EC67B059C18B99--
