From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: "No such device" on --remove
Date: Tue, 8 May 2007 19:04:41 +0200
Message-ID: <20070508170441.GB4333@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="O5XBE6gyVG5Rl6Rj"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--O5XBE6gyVG5Rl6Rj
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list.

I recently had a crash on my RAID machine and now two out of five RAIDs
don't start anymore. I don't even understand the error:

blindcoder@crazyhorse:~$ cat /proc/mdstat
Personalities : [linear] [raid0] [raid1] [raid5] [raid4]
md5 : active raid5 hdh8[0] hde8[3] hdf8[2] hdg8[1]
      677139456 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md4 : active raid5 hdh7[0] hdg7[1] hde7[3] hdf7[2]
      20988480 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md3 : active raid5 hdh6[2] hdg6[0] hde6[3] hdf6[1]
      12000192 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md2 : inactive hdh5[4](S) hdg5[1] hde5[3] hdf5[2]
      11983872 blocks

md1 : inactive hdg3[1] hdh3[4](S) hde3[3] hdf3[2]
      11984128 blocks

md0 : active raid1 hdh1[0] hde1[3] hdf1[2] hdg1[1]
      497856 blocks [4/4] [UUUU]

unused devices: <none>
blindcoder@crazyhorse:~$ su -
Password:
root@crazyhorse:~# mdadm -R /dev/md/2
mdadm: failed to run array /dev/md/2: Input/output error
root@crazyhorse:~# mdadm /dev/md/
0  1  2  3  4  5
root@crazyhorse:~# mdadm /dev/md/2 -r /dev/hdh5
mdadm: hot remove failed for /dev/hdh5: No such device

md1 and md2 are supposed to be raid5 arrays.

The relevant software versions are:
root@crazyhorse:~# mine -q linux26 mdadm
linux26 2.6.17.7 0
mdadm 2.5.6 0


Anyone got an idea?


Greetings,
	Benjamin
--=20
Go away, or I will replace you with a very small shellscript!
	http://shellscripts.org/

--O5XBE6gyVG5Rl6Rj
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFGQK2pAsME5O4xgqgRAkX/AKDtkQu8OlxHAjVb2xnEZYQBIEjnjwCgjO6g
sgU3VUJGkx3UfqvEQeh07YU=
=NSJC
-----END PGP SIGNATURE-----

--O5XBE6gyVG5Rl6Rj--
