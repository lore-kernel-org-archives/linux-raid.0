From: Nagilum <nagilum@nagilum.org>
Subject: Re: Change Stripe size?
Date: Mon, 31 Dec 2007 18:30:57 +0100
Message-ID: <20071231183057.ahly3onzcgow4ggk@cakebox.homeunix.net>
References: <29a863790712310900o7c585e3bncfaf8d7bbc589998@mail.gmail.com>
	<Pine.LNX.4.64.0712311201420.23402@p34.internal.lan>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_1hjvw17n0jtw";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0712311201420.23402@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Greg Cormier <gcormier@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_1hjvw17n0jtw
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from jpiszcz@lucidpixels.com ---------
     Date: Mon, 31 Dec 2007 12:02:14 -0500 (EST)
     From: Justin Piszcz <jpiszcz@lucidpixels.com>
Reply-To: Justin Piszcz <jpiszcz@lucidpixels.com>
  Subject: Re: Change Stripe size?
       To: Greg Cormier <gcormier@gmail.com>
       Cc: linux-raid@vger.kernel.org


>
>
> On Mon, 31 Dec 2007, Greg Cormier wrote:
>
>> So I've been slowly expanding my knowledge of mdadm/linux raid.
>>
>> I've got a 1 terabyte array which stores mostly large media files, and
>> from my reading, increasing the stripe size should really help my
>> performance
>>
>> Is there any way to do this to an existing array, or will I need to
>> backup the array and re-create it with a larger stripe size?
>>
>
> Backup the array and re-create it is currently the only way with sw
> raid AFAIK..
>
> Justin.
----- End message from jpiszcz@lucidpixels.com -----

Yep, but I think increasing the readahead should do almost the same =20
without having to re-create the RAID.
See http://hep.kbfi.ee/index.php/IT/KernelTuning for instructions.
Happy new year everyone!

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_1hjvw17n0jtw
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHeSdQAKWN2UY+sLwRAs/zAJ9Wvb9A/vj+AeDrBCP5twxt69CpBQCdF1NO
cAXHu59kMhh1HLzHaW8uM0A=
=90u2
-----END PGP SIGNATURE-----

--=_1hjvw17n0jtw--
