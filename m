From: Markus Krause <markus.krause@gmx.net>
Subject: Re: recover short-time-power-failure of raid 5?
Date: 28 Nov 2002 10:26:22 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <1038475582.1601.2.camel@marvin>
References: <15841.25746.94261.22043@notabene.cse.unsw.edu.au>
	<E18GFks-0001XZ-00@config8.kundenserver.de>
	<15841.62611.118178.276815@notabene.cse.unsw.edu.au>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1; protocol="application/pgp-signature";
	boundary="=-KlfBna4nhi8oL8MSJF7G"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15841.62611.118178.276815@notabene.cse.unsw.edu.au>
To: Neil Brown <neilb@cse.unsw.edu.au>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--=-KlfBna4nhi8oL8MSJF7G
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable

Am Mon, 2002-11-25 um 10.59 schrieb Neil Brown:=20
> On Monday November 25, krause@mogli-soft.de wrote:
> >=20
> > hello neilbrown,=20
> >=20
> > thanks a lot for your fast response!
> > i tried the command as you suggested but i am not sure if it really
> > worked, it seems that /dev/sdc2 is not yet used (but of course i may be
> > wrong! ;-) )
> .....
> >=20
> > what about disk /dev/sdc2 ? i have tried to access /dev/sdc1 (a small
> > ext2 partition) and the data there was correct, so it seems that the
> > disk is accessable and did not got damaged by the shot power failure.
> >=20
> > how can i get the third disk back into the raid system? or do i have to
> > backup all reconstructed data from the two disks and reinit the raid
> > from the start?
>=20
> mdadm -A --force
> will only 'force' into the array enough drives to make it work.  For
> your 3 drive raid5 array, it ony needs to force in 2 drives, so it
> takes the two most recent drives and uses them.  They will have all
> the data on them, but no redundancy.
>=20
> I suggest that after assembling the array, you 'fsck' the filesystem
> on md0 just to make sure that the data is fine and then simply hot-add
> the third device:
>   mdadm /dev/md0 -a /dev/sdc
>=20
> If fsck reports lots of error..... maybe try force the assmbly from a
> different pair of drives. e.g.
>    mdadm -A --force /dev/sda1 /dev/sdc2
>=20
> and then do the fsck.
>=20
> NeilBrown
hi again and sorry for the delayed answer, i had to work a few days=20
"on the road" and could not test your suggestion until some minutes ago!
and i worked exactly as you described! great! thanks a lot, thats real
cool!=20

what i did exactly (maybe someone else is interested):=20
(i snipped the output)=20

  [root@merlin root]# mdadm -A /dev/md0 --force /dev/sda1 /dev/sdb1
/dev/sdc2

  [root@merlin root]# fsck.ext3 -n /dev/md0=20

  [root@merlin root]# mdadm /dev/md0 -a /dev/sdc

and everything worked, all the data is back again!

well, except the fact, that now its a ext2 file system and not ext3, but
right now (till the current project is done in about two weeks) thats ok
for me, i can (must!) life without a journal file system.

thanks again for all your help!

   markus

--=-KlfBna4nhi8oL8MSJF7G
Content-Type: application/pgp-signature; name=signature.asc
Content-Description: Dies ist ein digital signierter Nachrichtenteil

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.0.6 (GNU/Linux)
Comment: Weitere Infos: siehe http://www.gnupg.org

iD8DBQA95eE+kTxNDyi6FVwRAjbzAKCBQh1QD6e0riFB7WXBxDnBSncVjACeIZpV
ir0dHBFSRtClm81KJv8TLzs=
=oHe9
-----END PGP SIGNATURE-----

--=-KlfBna4nhi8oL8MSJF7G--

