From: Tracy Reed <treed@ultraviolet.org>
Subject: Horrible mirror write performance, alignment?
Date: Tue, 27 Apr 2010 23:41:00 -0700
Message-ID: <20100428064059.GC2119@tracyreed.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="ImSVV91IQg5ga+3z"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--ImSVV91IQg5ga+3z
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable


Anyone know why my mirror devices would be doing (apparently)
unaligned writes to my ethernet SAN causing horrible performance and
massive seeking and lots of reading? BUT writing to the device
directly is very fast and no extra reads? I am measuring the
reads/writes on the SAN device in iostat as it is a Linux box.

I am running the 2.6.18-164.11.1.el5xen xen/kernel which came with
CentOS 5.4

After spending a lot of time banging my head on this I seem to have
finally tracked it down to mirroring.  I never would have thought it
would be this but it is extremely reproduceable. We're talking a
difference of 4-5x in write speed.  Reads are equally fast everywhere.

I am using AoE v72 kernel module (initiator) on a Dell R610's to talk
to vblade-19 (target) on Dell R710's all running CentOS 5.4. I have
striped two 7200 RPM SATA disks and exported the md with AoE (although
I have done these tests with individual disks also). Read performance
=66rom a raw device is excellent:

# dd of=3D/dev/null if=3D/dev/xvdg1 bs=3D4096 count=3D3000000
3000000+0 records in
3000000+0 records out
12288000000 bytes (12 GB) copied, 106.749 seconds, 115 MB/s

or from a mirror:

# dd if=3Dfoo of=3D/dev/null bs=3D4096
1073916+0 records in
1073916+0 records out
4398759936 bytes (4.4 GB) copied, 37.7441 seconds, 117 MB/s

foo is a 4.4G file I created in the filesystem.

I always dropped the cache with:

echo 1 > /proc/sys/vm/drop_caches

on both target and initiator before starting the test. This is great
for just a single gig-e link. This suggests that the network/SAN is
fine.

And iostat shows only writes and no reads happening.

However, write performance to a mirror is odious. Typically around
20MB/s. =20

# dd if=3D/dev/zero of=3Dfoo bs=3D4096 count=3D3000000
1724073+0 records in
1724073+0 records out
7061803008 bytes (7.1 GB) copied, 324.606 seconds, 21.8 MB/s

It should be more like 70MB/s per disk or better (7200rpm SATA) and
max out my gig-e with write performance similar to the above read
performance. I mentioned above that I suspect these are somewhow
unaligned writes because when running iostat on the target machine I
can see lots of reads happening which are surely causing seeks and
killing performance. Typical is something like 8MB/s of reads while
doing 16MB/s of writes.

I have tried manually aligning the disk by setting the beginning of
data on the partition from 63 to 64 (although I don't think this
should matter for a mirror as much as a stripe or raid5, right?)  and I have
tried changing the disk geometry to account for the extra partition
table which causes a half-block page-cache misalignment as described
by the ever insightful Kelsey Hudson in his writeup on the issue here:

http://copilotco.com/Virtualization/wiki/aoe-caching-alignment.pdf/at_downl=
oad/file

All to no avail. It remains that whenever I write to the mirrored
disks performance is terrible but when I write to each individual
block device with a filesystem on it performance is good. It seems to
point to some sort of problem with the mirroring.=20

Any ideas or suggestions would be very appreciated very much.

--=20
Tracy Reed
http://tracyreed.org

--ImSVV91IQg5ga+3z
Content-Type: application/pgp-signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQFL19h79PIYKZYVAq0RAu1hAKCMJYlbaUmu/dvSAEhbdx9uLluN1QCeI8F7
6YWUiYNWYJpa1twvy0C2iwY=
=fqSZ
-----END PGP SIGNATURE-----

--ImSVV91IQg5ga+3z--
