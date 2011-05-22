From: Johannes Truschnigg <johannes@truschnigg.info>
Subject: Re: HBA Adaptor advice
Date: Sun, 22 May 2011 23:13:39 +0200
Message-ID: <4DD97C83.4050907@truschnigg.info>
References: <4DD50C89.8060006@wildgooses.com> <20110520020853.GC4759@bitfolk.com> <4DD61948.8050302@wildgooses.com> <4DD6409F.9070904@hardwarefreak.com> <4DD79F4E.7000509@wildgooses.com> <4DD8D1A7.1090803@hardwarefreak.com> <4DD8E0D3.1030905@fnarfbargle.com> <4DD9633E.5000101@hardwarefreak.com> <BANLkTi=az3ny5m7Mf20t5fnFj79CsowJWg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig8965803BC1DA7ECEE7E78986"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTi=az3ny5m7Mf20t5fnFj79CsowJWg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Tobias McNulty <tobias@caktusgroup.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig8965803BC1DA7ECEE7E78986
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 05/22/2011 10:57 PM, Tobias McNulty wrote:
> Case in point: I have 4 of these 2TB Green drives in a RAID5 array.  I
> assembled them from the raw devices (no partition table) without any
> special precautions.  Am I in trouble?  The array seems to be working
> fine...

No, you aren't. If you don't create a partition table in the first
place, there's no possibility for partition boundaries to be mis-aligned
in regard to the physical sector or erase block size of the underlying
blockdevice. You could probably still get it wrong if you chose (if
that's even possible, I don't know for sure off-hand) a very weird
non-power-of-two chunk size that happens to interfere with the sector
size of your disks in a bad way, but since md's default chunk sizes are
rather large powers of two, you'd have to put some effort into screwing
up (if that is at all possible, as I mentioned before) ;)


--=20
with best regards:
- Johannes Truschnigg ( johannes@truschnigg.info )

www: http://johannes.truschnigg.info/
phone: +43 650 2 133337
xmpp: johannes@truschnigg.info

Please do not bother me with HTML-eMail or attachments. Thank you.


--------------enig8965803BC1DA7ECEE7E78986
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.11 (GNU/Linux)
Comment: Using GnuPG with Fedora - http://enigmail.mozdev.org/

iEYEARECAAYFAk3ZfIYACgkQnnUApj8OcoK8tgCgkDUEt2q6txcM46oRh1LFGHOw
U3MAnREVZCWcV80pabLp4+eETIavANrd
=w5Nt
-----END PGP SIGNATURE-----

--------------enig8965803BC1DA7ECEE7E78986--
