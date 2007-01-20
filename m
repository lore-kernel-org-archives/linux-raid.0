From: Benjamin Schieder <blindcoder@scavenger.homeip.net>
Subject: RAID5 Resize Experience
Date: Sat, 20 Jan 2007 09:56:21 +0100
Message-ID: <20070120085621.GA5028@scavenger.homeip.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Kj7319i9nmIyA2yE"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Kj7319i9nmIyA2yE
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hi list.

I just added another 250 GB harddisk to my existing RAID configuration.
Here's my experience report.

blindcoder@ceres:~$ /sbin/mdadm --version
mdadm - v2.6 - 21 December 2006
blindcoder@ceres:~$ uname -a
Linux ceres 2.6.17.7-rock-dragon #4 SMP Thu Jan 18 13:10:52 CET 2007 i686 G=
NU/Linux

My setup is like this:

md0 : raid1 hdb1[0] hdc1[2] hda1[1]
	Ext2 Filesystem, mounted on /boot

md1 : active raid5 hdb3[0] hdc3[2] hda3[1]
	ReiserFS 3.6, mounted on /

md2 : active raid5 hdb5[0] hdc5[2] hda5[1]
	ReiserFS 3.6, mounted on /var

md3 : active raid5 hda6[0] hdb6[2] hdc6[1]
	ReiserFS 3.6, mounted on /opt

md4 : active raid5 hdb7[0] hdc7[2] hda7[1]
	ReiserFS 3.6, mounted on /usr

md5 : active raid5 hdb8[0] hdc8[2] hda8[1]
	Encrypted (dmcrypt) ReiserFS 3.6, mounted on /data

The RAID/Encryption is set up at boot-time using an initrd.

At first I did some testing with loop devices. A call to
root@ceres:~# mdadm --add /dev/md/12 /dev/loop/3
added the device as spare as expected. But the call to
root@ceres:~# mdadm -G /dev/md/12 -n 4
resulted in an error message despite the announcement that mdadm would now
support resizing RAID 5 arrays. dmesg said something about an error -22
(-EINVAL), so I dived into the md.c and raid5.c sources of the kernel to
find a #ifdef part around the resizing code. I reconfigured my kernel and
after a reboot, the resizing worked.

Two remarks at this point:
	It would be nice if mdadm would give an error message along the lines
	"mdadm: Have you configured resizing in your kernel?"

	And second, the manpage states the following:

=E2=80=90n, =E2=80=90=E2=80=90raid=E2=80=90devices=3D
	Specify  the  number  of  active  devices in the array.  This, plus
	the number of spare devices (see below) must equal the number of
	component devices (including "missing" devices) that are listed on
	the command line for =E2=80=90=E2=80=90create.  Setting a value of 1 is pr=
obably a
	mistake and so requires that =E2=80=90=E2=80=90force be specified first.  =
A value of
	1 will then be allowed for linear, multipath, raid0 and raid1.  It
	is never allowed for raid4 or raid5.  This number can only be
	changed using =E2=80=90=E2=80=90grow for RAID1 arrays, and only on kernels=
 which
				 ^^^^^	provide necessary support.
				 |||||
				 shouldn't RAID5 be mentioned here, too?

Anyway, after the test worked, I added sfdisk and resize_reiserfs to my ini=
trd.
Manually, I used sfdisk -d on an existing RAID disk and sfdisk on my new di=
sk
to mirror the correct partitioning.

I added all new partitions to the respective RAIDs using --add and then used
-G on all arrays. I waited for the resync to finish before issuing the next
-G command, though.

After the first resize, though, I was a bit shocked that
	# /sbin/mdadm -As --auto=3Dyes --symlink=3Dyes
no longer found the array! Manually assembling the array worked fine, thoug=
h.
I later realised, that /etc/mdadm.conf specifies the following parameter:
	num-devices=3D4
It would be nice of mdadm to remind the user that the config file might need
to be reconstructed using
	# /sbin/mdadm -Ebsc partitions

Resynching the arrays took around 12 hours and after that I could easily use
resize_reiserfs to resize the arrays. md0, being a RAID1, didn't need
resizing, of course :-)

I now have a working RAID setup with an additional disk:


Personalities : [linear] [raid0] [raid1] [raid5] [raid4]=20
md5 : active raid5 hdb8[0] hdf8[3] hdc8[2] hda8[1]
      677139456 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md4 : active raid5 hdb7[0] hdf7[3] hdc7[2] hda7[1]
      20988480 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md3 : active raid5 hda6[0] hdf6[3] hdb6[2] hdc6[1]
      12000192 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md2 : active raid5 hdb5[0] hdf5[3] hdc5[2] hda5[1]
      8987904 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md1 : active raid5 hdb3[0] hdf3[3] hdc3[2] hda3[1]
      8988096 blocks level 5, 64k chunk, algorithm 2 [4/4] [UUUU]

md0 : active raid1 hdb1[0] hdf1[3] hdc1[2] hda1[1]
      497856 blocks [4/4] [UUUU]


Thanks you for making this possible!


Greetings,
	Benjamin
--=20
The Nethack IdleRPG! Idle to your favorite Nethack messages!
http://pallas.crash-override.net/nethackidle/

--Kj7319i9nmIyA2yE
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.3 (GNU/Linux)

iD8DBQFFsdk1AsME5O4xgqgRAjXoAKDFmR8UbPQ6iCeUm9Q0dCI1GU2DRgCgwiMu
etCSffDhPF7+kGTR/SHjrko=
=ASRJ
-----END PGP SIGNATURE-----

--Kj7319i9nmIyA2yE--
