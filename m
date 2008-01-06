From: Nagilum <nagilum@nagilum.org>
Subject: Re: Why "mdadm --monitor --program" sometimes only gives 2
	command-line arguments to the program?
Date: Sun, 06 Jan 2008 12:06:06 +0100
Message-ID: <20080106120606.3q07vau3k080g8og@cakebox.homeunix.net>
References: <14642331.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_34gmshgb1n40";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <14642331.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: Hxsrmeng <hxsrmeng@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_34gmshgb1n40
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from hxsrmeng@gmail.com ---------
     Date: Sat, 5 Jan 2008 18:11:38 -0800 (PST)
     From: Hxsrmeng <hxsrmeng@gmail.com>

> I hope the mdadm monitor function can pass all three command-line
> arguments to my-script, including the name of the event, the name of the
> md device and the name of a related device if relevant.
>
> But my-script doesn't get the third one, which should be /dev/sda2. Is
> this not "relevant"?
>
> If I really need to know it's /dev/sda2 that fails, what can I do?

Since you have the array name (e.g. /dev/md1) you could run "mdadm -Q =20
--detail /dev/md1" and parse the output or have a look at /proc/mdstat =20
or /sys/block/md1/* .
Kind regards,
Alex.


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


--=_34gmshgb1n40
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHgLYbAKWN2UY+sLwRAhOSAJ9zER+ppAOSls9OBf4/UwXXnQ+a7ACfZFaB
/Vc/kMq2U92O4soRsaBBjf0=
=GZjY
-----END PGP SIGNATURE-----

--=_34gmshgb1n40--
