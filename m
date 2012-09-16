From: Robin Hill <robin@robinhill.me.uk>
Subject: Re: raid1 issue after disk failure: both disks of the array are
 still active
Date: Sun, 16 Sep 2012 11:18:16 +0100
Message-ID: <20120916101816.GA26357@cthulhu.home.robinhill.me.uk>
References: <20120913103432.GA11764@cthulhu.home.robinhill.me.uk>
 <B9AFB9BB-22CE-470D-AB47-E4CDA91C307B@colorremedies.com>
 <alpine.DEB.2.00.1209140912350.13902@uplift.swm.pp.se>
 <5052E096.5040509@linuxsystems.it>
 <45F26B36-1890-4F8E-BDF9-0DB49FDEE922@colorremedies.com>
 <20120914182755.GA2534@cthulhu.home.robinhill.me.uk>
 <7664099D-4C11-4254-B970-2DCAD5F86A46@colorremedies.com>
 <5054D175.5070303@linuxsystems.it>
 <20120915194102.GA10403@cthulhu.home.robinhill.me.uk>
 <5054FBF8.8070901@linuxsystems.it>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="GvXjxJ+pjyke8COw"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5054FBF8.8070901@linuxsystems.it>
Sender: linux-raid-owner@vger.kernel.org
To: =?iso-8859-1?Q?Niccol=F2?= Belli <darkbasic@linuxsystems.it>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--GvXjxJ+pjyke8COw
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On Sun Sep 16, 2012 at 12:06:48 +0200, Niccol=F2 Belli wrote:

> Il 15/09/2012 21:41, Robin Hill ha scritto:
> > If md hasn't failed the drive then either:
> >    - md didn't get a read error
> >    - md got a success message when re-writing the block
> >    - there's a bug in md and it's not handled the error at all
>=20
> It seems it's case one, while manually verifying the checksums with
>=20
> for i in $(seq 50); do dd if=3D/dev/sda1 of=3Dsda${i} bs=3D100000 count=
=3D50=20
> skip=3D$((($i-1)*50+10)) > /dev/null 2> /dev/null; dd if=3D/dev/sdb1=20
> of=3Dsdb${i} bs=3D100000 count=3D50 skip=3D$((($i-1)*50+10)) > /dev/null =
2>=20
> /dev/null; md5sum sda${i}; md5sum sdb${i}; echo; done
>=20
> I get this in syslog:
>=20
> Sep 15 23:50:09 asterisk kernel: [273828.407914] scsi_verify_blk_ioctl:=
=20
> 30 callbacks suppressed
> Sep 15 23:50:09 asterisk kernel: [273828.407920] dd: sending ioctl=20
> 80306d02 to a partition!
> Sep 15 23:50:09 asterisk kernel: [273828.407925] dd: sending ioctl=20
> 80306d02 to a partition!
> Sep 15 23:50:10 asterisk kernel: [273829.422247] ata3.00: exception=20
> Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> Sep 15 23:50:10 asterisk kernel: [273829.424071] ata3.00: BMDMA stat 0x44
> Sep 15 23:50:10 asterisk kernel: [273829.425855] ata3.00: failed=20
> command: READ DMA
> Sep 15 23:50:10 asterisk kernel: [273829.427625] ata3.00: cmd=20
> c8/00:00:68:17:00/00:00:00:00:00/e0 tag 0 dma 131072 in
> Sep 15 23:50:10 asterisk kernel: [273829.427627]          res=20
> 51/40:00:90:17:00/40:00:00:00:00/e0 Emask 0x9 (media error)
> Sep 15 23:50:10 asterisk kernel: [273829.431184] ata3.00: status: { DRDY=
=20
> ERR }
> Sep 15 23:50:10 asterisk kernel: [273829.432992] ata3.00: error: { UNC }
> Sep 15 23:50:11 asterisk kernel: [273830.404203] ata3.00: configured for=
=20
> UDMA/133
> Sep 15 23:50:11 asterisk kernel: [273830.404217] ata3: EH complete
>=20
>=20
>=20
> but this is the output of the command:
>=20
>=20
> b7d4e3c3bb461a1aa6619c22ef11d072  sda1
> b7d4e3c3bb461a1aa6619c22ef11d072  sdb1
>
<- snip sets of identical checksums ->
>
> 94f883b45084b72cd9269a4821b2d509  sda50
> 94f883b45084b72cd9269a4821b2d509  sdb50
>=20
Okay, so it looks like the drive is managing to return the correct data
eventually (or it's returning some default value which has also been
written to the other mirror now).

> *BUT* if I start reading from the start of partition (+0 instead of +10=
=20
> in count=3D) I get a mismatch, on both md0 and md1 (which is supposed to=
=20
> be ok)!!!
>=20
> root@asterisk:~# i=3D1; dd if=3D/dev/sda1 of=3Dsda${i} bs=3D100000 count=
=3D50=20
> skip=3D$((($i-1)*50+0)) > /dev/null 2> /dev/null; dd if=3D/dev/sdb1=20
> of=3Dsdb${i} bs=3D100000 count=3D50 skip=3D$((($i-1)*50+0)) > /dev/null 2=
>=20
> /dev/null; md5sum sda${i}; md5sum sdb${i}
> 9f9f11ffeb0aed0abc8097417b293f41  sda1
> 394efde218ad700774bfcb3c43255529  sdb1
> root@asterisk:~# i=3D1; dd if=3D/dev/sda2 of=3Dsda${i} bs=3D100000 count=
=3D50=20
> skip=3D$((($i-1)*50+0)) > /dev/null 2> /dev/null; dd if=3D/dev/sdb2=20
> of=3Dsdb${i} bs=3D100000 count=3D50 skip=3D$((($i-1)*50+0)) > /dev/null 2=
>=20
> /dev/null; md5sum sda${i}; md5sum sdb${i}
> 8cb0b6fa2bf7f0f88a2a2a91598429d4  sda1
> 732c42e14b8e78930d08cdb4f1c49a40  sdb1
>=20
> Shouldn't raid1 match even at the very beginning of the partition?
>=20
No, the start of the partition will contain the md superblock (for 1.1
and 1.2 metadata formats), which will be slightly different for the two
devices.

Cheers,
    Robin
--=20
     ___       =20
    ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
   / / )      | Little Jim says ....                            |
  // !!       |      "He fallen in de water !!"                 |

--GvXjxJ+pjyke8COw
Content-Type: application/pgp-signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iEYEARECAAYFAlBVp2cACgkQShxCyD40xBKfhQCfVi/Def+rsKCT96SKW1vEKEHA
B9cAoJQMUSbnDPCtZk6lp/r4c6gN57Mf
=uLOE
-----END PGP SIGNATURE-----

--GvXjxJ+pjyke8COw--
