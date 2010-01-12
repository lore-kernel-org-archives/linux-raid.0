From: Doug Ledford <dledford@redhat.com>
Subject: Re: Minor mdadm fixes
Date: Mon, 11 Jan 2010 23:46:32 -0500
Message-ID: <4B4BFEA8.7020607@redhat.com>
References: <1263242294-5353-1-git-send-email-dledford@redhat.com> <alpine.LNX.2.01.1001111541200.3360@filesrv1.baby-dragons.com> <20100112031027.GL7517@skl-net.de> <4B4BEE48.1000305@redhat.com> <20100112043933.GO21495@skl-net.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enig2F23F9DF20A4F9538DDA100C"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100112043933.GO21495@skl-net.de>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Noll <maan@systemlinux.org>
Cc: "Mr. James W. Laferriere" <babydr@baby-dragons.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enig2F23F9DF20A4F9538DDA100C
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 01/11/2010 11:39 PM, Andre Noll wrote:
> On 22:36, Doug Ledford wrote:
>>> I believe (Doug, please correct me if the following is wrong) the
>>> advantage of storing mdmon's pid files in /dev is that in /dev they
>>> remain visible after the switch to the new root. That's the "handoff
>>> after pivotroot" in the subject.
>>
>> I'm a little fuzzy on this myself.  The original patch was from anothe=
r
>> Red Hatter that works on dracut, the new mkinitrd replacement in Fedor=
a
>> 12.  When integrating IMSM support in the md raid stack and dracut,
>> there became a problem with starting mdmon in the initramfs filesystem=

>> and then transitioning it to the new filesystem.  It turns out that, a=
s
>> you point out, because /dev is moved from the initramfs to the new roo=
t
>> (mainly because udev is now started in the initramfs), we could avoid =
a
>> number of issues caused by mdmon's files being in /var/run instead of
>> /dev.
>=20
> One could also mount /var/run in the initramfs and move it over
> like /dev, but that gets a bit messy because /var might be on a yet
> another fs..
>=20
>> This also allowed us to do the mdmon restart *after* the switchroot
>> had taken place and solved a number of issues with getting mdmon
>> support to work.
>=20
> Just out of interest: Why does mdmon need the restart at all?

Because of the design and limitation of page cache.  If you start a long
running program from the initramfs, then the page cache usage will pin
the initramfs in memory.  You need to reexec the program from the hard
drive so that the initramfs can be freed.  Of course, this is all
because superblock handling for imsm superblocks is in user
space...<grumble, grumble, grumble>.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enig2F23F9DF20A4F9538DDA100C
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.10 (GNU/Linux)

iEYEARECAAYFAktL/qgACgkQg6WylM+/8ZS9TgCeNm2+t3NDN76cVcknhymNozfE
qoEAoI8yWbQvb1cFIelxtdEtr9fUzH9f
=DaUf
-----END PGP SIGNATURE-----

--------------enig2F23F9DF20A4F9538DDA100C--
