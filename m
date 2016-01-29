From: NeilBrown <neilb@suse.com>
Subject: [PATCH/mdadm] super1: Fix bblog_size accesses on big-ending machines.
Date: Fri, 29 Jan 2016 12:35:33 +1100
Message-ID: <87d1sl182i.fsf@notabene.neil.brown.name>
Mime-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
	micalg=pgp-sha256; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--=-=-=
Content-Type: text/plain
Content-Transfer-Encoding: quoted-printable


bblog_size is 16bit so using le32_to_cpu on it is not wise
and leads to errors on big-endian machines.
Change all such calls to use le16.

Bug was introduced in mdadm-3.3

Signed-off-by: NeilBrown <neilb@suse.com>
=2D--

Hi Jes,
 when you are ready to start queuing patches for mdadm, this will make
 sure you have something to work with:-)

Thanks,
NeilBrown

 super1.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/super1.c b/super1.c
index 8bcaa2fe02c8..9b877e504c4b 100644
=2D-- a/super1.c
+++ b/super1.c
@@ -730,12 +730,12 @@ static int copy_metadata1(struct supertype *st, int f=
rom, int to)
 	}
=20
 	if (super.bblog_size !=3D 0 &&
=2D	    __le32_to_cpu(super.bblog_size) <=3D 100 &&
+	    __le16_to_cpu(super.bblog_size) <=3D 100 &&
 	    super.bblog_offset !=3D 0 &&
 	    (super.feature_map & __le32_to_cpu(MD_FEATURE_BAD_BLOCKS))) {
 		/* There is a bad block log */
 		unsigned long long bb_offset =3D sb_offset;
=2D		int bytes =3D __le32_to_cpu(super.bblog_size) * 512;
+		int bytes =3D __le16_to_cpu(super.bblog_size) * 512;
 		int written =3D 0;
 		struct align_fd afrom, ato;
=20
@@ -832,7 +832,7 @@ static int examine_badblocks_super1(struct supertype *s=
t, int fd, char *devname)
 	__u64 *bbl, *bbp;
 	int i;
=20
=2D	if  (!sb->bblog_size || __le32_to_cpu(sb->bblog_size) > 100
+	if  (!sb->bblog_size || __le16_to_cpu(sb->bblog_size) > 100
 	     || !sb->bblog_offset){
 		printf("No bad-blocks list configured on %s\n", devname);
 		return 0;
@@ -843,7 +843,7 @@ static int examine_badblocks_super1(struct supertype *s=
t, int fd, char *devname)
 		return 0;
 	}
=20
=2D	size =3D __le32_to_cpu(sb->bblog_size)* 512;
+	size =3D __le16_to_cpu(sb->bblog_size)* 512;
 	if (posix_memalign((void**)&bbl, 4096, size) !=3D 0) {
 		pr_err("could not allocate badblocks list\n");
 		return 0;
@@ -986,7 +986,7 @@ static void getinfo_super1(struct supertype *st, struct=
 mdinfo *info, char *map)
 		if (sb->bblog_offset && sb->bblog_size) {
 			unsigned long long bbend =3D super_offset;
 			bbend +=3D (int32_t)__le32_to_cpu(sb->bblog_offset);
=2D			bbend +=3D __le32_to_cpu(sb->bblog_size);
+			bbend +=3D __le16_to_cpu(sb->bblog_size);
 			if (bbend > earliest)
 				earliest =3D bbend;
 		}
=2D-=20
2.7.0


--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIcBAEBCAAGBQJWqsHlAAoJEDnsnt1WYoG5BgoP/iSTSN1nbtJsr63omtRB2hy0
j9LJJjrhI1E3CbqoyqN7e9WZF+5qvE+cyrlyfPBmGPnxYxz19WfJfbldLzi2XMqH
VutHdDRqw0dyeE028IQ+/NJ9Ib+GmyNVDpfwd5ARPQ/ORQoQWzMm0SzGDJXSCTgJ
eR6ZwXUqfqZaMywJYthxvxBm1c9yrPjKIeIaKVvxHZgl3nLMUbTfj4ur8WTIoWed
0hJJxXt19CrrcGF/TVUCh3Zhra+xwgidM7ZxxRvJn6O9ENMrLi593MeuIFnHD28o
jERZ3ef2BALJEsSK/+xskTR7H0/lwpItRQiAfyBVt9nfCqiVYhpFeN3a2oTUCtH7
MOhaLB0OKMf803to4TzRXSc+XL8jz+ZPjDZh9I0MfXhb4vrVhToE1KgNsvzhOI0i
ka+mmszZDsOx8OjK4jtpvPz3D4eoKZdw46VVLZAztEbEq0nUOH20jGIvR2i4EC6x
X5Fh5rT7JItj0X32C08D6aGak/XDhFnPzeTBdcMXMu+4e/PMNkO6q/AsZCseXZyD
cYjm0HqwDUa88se5k0FmkIdmgG68Kv5xi6mBI5SHmHVCvJuBWKkkcFVkUM/bwv0d
pP81pMErZiCeSk0ueIrkSv+WB91ZjpZKr+Wu/AbOAOeSExd0Hb2rpixJuDuwFZJY
bW3Sq9bUU+CtqzoRGqFw
=cdTW
-----END PGP SIGNATURE-----
--=-=-=--
