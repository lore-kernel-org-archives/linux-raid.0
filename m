From: Lars Schimmer <l.schimmer@cgv.tugraz.at>
Subject: Re: RAID5 fill up?
Date: Fri, 08 Sep 2006 14:26:31 +0200
Message-ID: <45016177.8080604@cgv.tugraz.at>
References: <45013873.5040006@cgv.tugraz.at> <450142AC.8010304@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <450142AC.8010304@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Michael Tokarev wrote:
> Lars Schimmer wrote:
>> Hi!
>>
>> I=B4ve got a software RAiD5 with 6 250GB HDs.
>> Now I changed one disk after another to a 400GB HD and resynced the
>> raid5 after each change.
>> Now the RAID5 has got 6 400GB HDs and still uses only 6*250GB space.
>> How can I grow the md0 device to use 6*400GB?
>=20
> mdadm --grow is your friend.

Oh, damn, right. I was focussed on --grow to add a new HD to the RAID..=
=2E.
But isn=B4t there a switch to grow to max possible value?
Do I always have to search for the biggest value and type it in by hand=
?

> /mjt
>=20


MfG,
Lars Schimmer
- --
- -------------------------------------------------------------
TU Graz, Institut f=FCr ComputerGraphik & WissensVisualisierung
Tel: +43 316 873-5405       E-Mail: l.schimmer@cgv.tugraz.at
=46ax: +43 316 873-5402       PGP-Key-ID: 0x4A9B1723
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)
Comment: Using GnuPG with Mozilla - http://enigmail.mozdev.org

iD8DBQFFAWF3mWhuE0qbFyMRAn7QAJ9nZ7I+n/bxM22AoKbfSXoMovup8ACfS+i6
nYASA51BlYQaSavD7CWLL8c=3D
=3DS0dO
-----END PGP SIGNATURE-----
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
