From: NeilBrown <neilb@suse.de>
Subject: Re: MD RAID 1 fail/remove/add corruption in 3.10
Date: Wed, 17 Jul 2013 14:53:31 +1000
Message-ID: <20130717145331.5ee6c200@notabene.brown>
References: <20130716144920.39f428b7@jlaw-desktop.mno.stratus.com>
	<51E606EF.7070801@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/HkeQi9SN2PQ4tUx6gODPut9"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51E606EF.7070801@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, linux-raid@vger.kernel.org, Martin Wilck <mwilck@arcor.de>
List-Id: linux-raid.ids

--Sig_/HkeQi9SN2PQ4tUx6gODPut9
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jul 2013 10:52:31 +0800 Brad Campbell <lists2009@fnarfbargle.com>
wrote:

> On 17/07/13 02:49, Joe Lawrence wrote:
> > Hi Neil, Martin,
> >
> > While testing patches to fix RAID1 repair GPF crash w/3.10-rc7
> > ( http://thread.gmane.org/gmane.linux.raid/43351 ), I encountered disk
> > corruption when repeatedly failing, removing, and adding MD RAID1
> > component disks to their array.  The RAID1 was created with an internal
> > write bitmap and the test was run against alternating disks in the
> > set.  I bisected this behavior back to commit 7ceb17e8 "md: Allow
> > devices to be re-added to a read-only array", specifically these lines
> > of code:
>=20
> This sounds like an issue I just bumped up against in RAID-5.
> I have a test box with a RAID-5 comprised of 2 x 2TB drives, and 6=20
> RAID-0's of 2 x 1TB drives.
>=20
>=20
> root@test:/root# cat /proc/mdstat
> Personalities : [linear] [raid0] [raid1] [raid10] [raid6] [raid5] [raid4]
> md3 : active raid5 md20[0] md25[8] md24[7] md22[6] sdl[4] sdn[3] md23[2]=
=20
> md21[1]
>        13673683968 blocks super 1.2 level 5, 512k chunk, algorithm 2=20
> [8/8] [UUUUUUUU]
>        bitmap: 0/15 pages [0KB], 65536KB chunk
>=20
> md22 : active raid0 sdk[0] sdm[1]
>        1953524736 blocks super 1.2 512k chunks
>=20
> md20 : active raid0 sdj[0] sdo[1]
>        1953522688 blocks super 1.2 512k chunks
>=20
> md21 : active raid0 sdh[0] sdi[1]
>        1953524736 blocks super 1.2 512k chunks
>=20
> md25 : active raid0 sda[0] sdb[1]
>        2441900544 blocks super 1.2 512k chunks
>=20
> md23 : active raid0 sdd[0] sde[1]
>        1953522688 blocks super 1.2 512k chunks
>=20
> md24 : active raid0 sdf[0] sdg[1]
>        1953524736 blocks super 1.2 512k chunks
>=20
> I was running a check over md3 whilst rsyncing a load of data onto it.
> md20 was ejected some time during this process. (A smart query issued=20
> caused a timeout on one of the drives). I removed md20, stopped md20,=20
> started md20 and re-added md20.
>=20
> This should have caused a re-build as the bitmap would have been way out=
=20
> of sync, however it immediately reported the rebuild complete and left=20
> the array mostly trashed. (about 500,000 mismatch counts).
>=20
> kernel at the time was late in the 3.11-rc1 merge window.=20
> 3.10.0-09289-g9903883
>=20
> I've been meaning to try and reproduce it, but as each operation takes=20
> about 5 hours it's slow going.
>=20
> This is a test array, so it has no data value. I'm happy to try to=20
> reproduce this fault if it would help any.
>=20
> Regards,
> Brad


Hi Brad,
 yes, sounds like the same problem, with same solution for now.  Remove the
 code that Joe highlighted.

Thanks.

NeilBrown

--Sig_/HkeQi9SN2PQ4tUx6gODPut9
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeYjSznsnt1WYoG5AQJrAQ/6AtfrbZRODzcC49r1/9pKgcZkWhlh4pIr
DgyiAUPUe0n9hE1/wix0y4VHO0DrHnPYQudYWG9vMJJPplkehugSboEH6jBJe5rk
MXntM+wGKi5ykIa02K/rbuG2WZzeYLDx/LwYRPOTONuLX6a4B0x/mvC8iA0m2c6l
+kD5e9TUeTJxuMDzOGGEkrnHP493N/W6+atn91igeqxocpvKJMTJKP0xB4lNHc7L
iq0Zd2oSfD+iDMp8GdXORVLWa3mshvqCGPglXyrFMNjNvLrGIa1QI+kKuRPcz4VD
8756aFqqSebJ7WZkR33VRT+HxzuYfNC2ymqZTV6hQ1KF7/De/N4ma0J3VdMIfZ1a
ItE895jxki/klxFsrLUgqE0x6gWEhUYB/ksZix5okyXg3Ari4TkKmCYwFxCT+pb7
DfkRkATsiOPgLZXcDttjUEkyvXcWRCbta8KyNAAJCZBS4bwS6qLVoJV+ZAfEsHoR
5ct9t+B90IEBdLbhypm8CN4I65/MyEQa12+oHml59GMQPD1ZvKK73RdVebGJiNiB
G2Tiv7hTjd2IVZQ6WtByid0Qpbk9QKMMwI7djPpTF/FztVh0spgx33IWFVZr0P/b
XWmLyKlnBND88p2Hj5vk86wKyePwzfseAWWG1Kn6PMUm3DW8XXclzg0MalbQCLCK
Sct3OCSqVBk=
=oPjb
-----END PGP SIGNATURE-----

--Sig_/HkeQi9SN2PQ4tUx6gODPut9--
