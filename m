From: Nagilum <nagilum@nagilum.org>
Subject: Re: Kicking the right drive out
Date: Sun, 14 Oct 2007 10:49:07 +0200
Message-ID: <20071014104907.3wduv63bpc00ggs4@cakebox.homeunix.net>
References: <1192298416.16416.246.camel@w100>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_3j3273zb59s0";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1192298416.16416.246.camel@w100>
Sender: linux-raid-owner@vger.kernel.org
To: Alberto Alonso <alberto@ggsys.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_3j3273zb59s0
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Have a look at
  mdadm -Q --detail /dev/md0
But I'd suspect the problematic disk is causing that slow resync.
I would add a new disk and then declare the one you suspect as bad.
If the other two are are ok it should resync to the new one and you're fine.
Otherwise you can re-add the declared failed disk and try again with =20
another one.
I would use dd to verify which disk is giving trouble (e.g. "dd =20
if=3D/dev/sda of=3D/dev/null" , use "iostat -d5 -k" to watch the read =20
speed).
I hope this helps..
Alex.

----- Message from alberto@ggsys.net ---------
     Date: Sat, 13 Oct 2007 13:00:16 -0500
     From: Alberto Alonso <alberto@ggsys.net>
Reply-To: Alberto Alonso <alberto@ggsys.net>
  Subject: Kicking the right drive out
       To: linux-raid@vger.kernel.org


> I have a need to kick a disk out of a RAID 5 array.
>
> I can do a fdisk on 2 out of the 3 devices that form part
> of the array, so I suspect I know which one is bad.
>
> The problem is that mdstat shows the array as follows:
>
> md3 : active raid5 sda6[0] sdc6[2] sdb6[1]
>       960863488 blocks level 5, 64k chunk, algorithm 2 [3/3] [UUU]
>       [>....................]  resync =3D  0.7% (3444348/480431744)
> finish=3D582280.4min speed=3D1K/sec
>
>
> Doesn't this mean that all three disks are active and in use?
>
> mdadm -D /dev/md3 shows:
>
>     Number   Major   Minor   RaidDevice State
>        0       8        6        0      active sync   /dev/sda6
>        1       8       22        1      active sync   /dev/sdb6
>        2       8       38        2      active sync   /dev/sdc6
>
> So, my question is as follows: can I remove sdc6 and be sure the
> array will not stop?
>
> To make things worse, I see no disk failures in any log file. So
> I am not sure how sdc is actually failing.
>
> Thanks,
>
> Alberto
>
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>


----- End message from alberto@ggsys.net -----



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


--=_3j3273zb59s0
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHEdgDAKWN2UY+sLwRAuz9AKCSzmMo/jSBzn/3vAznmb4PIxFMcACfYElR
CvrsOsOwK5cB6ubum6vSnaw=
=MZwp
-----END PGP SIGNATURE-----

--=_3j3273zb59s0--
