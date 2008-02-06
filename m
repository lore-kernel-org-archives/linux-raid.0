From: Nagilum <nagilum@nagilum.org>
Subject: Re: Disk failure during grow, what is the current state.
Date: Wed, 06 Feb 2008 15:34:27 +0100
Message-ID: <20080206153427.8od37w9d0kwokcos@cakebox.homeunix.net>
References: <038301c868c0$07afcb30$0603a8c0@meanmachine>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_dtes5z1j9tc";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <038301c868c0$07afcb30$0603a8c0@meanmachine>
Sender: linux-raid-owner@vger.kernel.org
To: Steve Fairbairn <steve@fairbairn-family.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_dtes5z1j9tc
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from steve@fairbairn-family.com ---------
     Date: Wed, 6 Feb 2008 12:58:55 -0000
     From: Steve Fairbairn <steve@fairbairn-family.com>
Reply-To: Steve Fairbairn <steve@fairbairn-family.com>
  Subject: Disk failure during grow, what is the current state.
       To: linux-raid@vger.kernel.org


> As you can see, one of the original 5 devices has failed (sdd1) and
> automatically removed.  The reshape has stopped, but the new disk seems
> to be in and clean which is the bit I don't understand.  The new disk
> hasn't been added to the size, so it would seem that md has switched it
> to being used as a spare instead (possibly as the grow hadn't
> completed?).
>
> How come it seems to have recovered so nicely?
> Is there something I can do to check it's integrity?
> Was it just so much quicker than 2 days because it switched to only
> having to sort out the 1 disk? Would it be safe to run an fsck to check
> the integrity of the fs?  I don't want to inadvertently blat the raid
> array by 'using' it when it's in a dodgy state.
>
> I have unmounted the drive for the time being, so that it doesn't get
> any writes until I know what state it is really in.


----- End message from steve@fairbairn-family.com -----

If a drive failes during reshape the reshape will just continue.
The blocks which were on the failed drive are calculated from the the =20
other disks and writes to the failed disk are simply omitted.
The result is a raid5 with a failed drive.
You should get a new drive asap to restore the redundancy.
Also it's kinda important that you don't run 2.6.23 because it has a =20
nasty bug which would be triggered in this scenario.
The reshape probably increased in speed after the system was no longer =20
actively used and io bandwidth freed up.
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


--=_dtes5z1j9tc
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.8 (FreeBSD)

iEYEABECAAYFAkepxWwACgkQAKWN2UY+sLynogCdGVK3BYfP2kEKRcGOkHwKrA/J
RI4AnRfv6KVbkAnXcm3+YCqQBcRm7Ue/
=RVtu
-----END PGP SIGNATURE-----

--=_dtes5z1j9tc--
