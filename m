From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 03/10] Create n bitmaps for clustered mode
Date: Thu, 30 Apr 2015 12:51:53 +1000
Message-ID: <20150430125153.428f4884@notabene.brown>
References: <1429860641-5839-1-git-send-email-gqjiang@suse.com>
	<1429860641-5839-4-git-send-email-gqjiang@suse.com>
	<20150429113632.0a211e3c@notabene.brown>
	<554044EB.5050303@suse.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/yl05wPhcVz5fmVMR0A3luxj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <554044EB.5050303@suse.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goldwyn Rodrigues <rgoldwyn@suse.de>
Cc: gqjiang@suse.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yl05wPhcVz5fmVMR0A3luxj
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Apr 2015 21:41:47 -0500 Goldwyn Rodrigues <rgoldwyn@suse.de> wro=
te:

>=20
>=20
> On 04/28/2015 08:36 PM, NeilBrown wrote:
> > On Fri, 24 Apr 2015 15:30:34 +0800 gqjiang@suse.com wrote:
> >
> >> From: Guoqing Jiang <gqjiang@suse.com>
> >>
> >> For a clustered MD, create bitmaps equal to number of nodes so
> >> each node has an independent bitmap.
> >>
> >> Only the first bitmap is has the bits set so that the first node
> >> that assembles the device also performs the sync.
> >>
> >> The bitmaps are aligned to 4k boundaries.
> >>
> >> On-disk format:
> >>
> >> 0                    4k                     8k                    12k
> >> -------------------------------------------------------------------
> >> | idle                | md super            | bm super [0] + bits |
> >> | bm bits[0, contd]   | bm super[1] + bits  | bm bits[1, contd]   |
> >> | bm super[2] + bits  | bm bits [2, contd]  | bm super[3] + bits  |
> >> | bm bits [3, contd]  |                     |                     |
> >>
> >> Signed-off-by: Goldwyn Rodrigues <rgoldwyn@suse.com>
> >> Signed-off-by: Guoqing Jiang <gqjiang@suse.com>
> >> ---
> >>   Create.c   |  3 ++-
> >>   bitmap.h   |  7 +++++--
> >>   mdadm.8.in |  7 ++++++-
> >>   mdadm.c    | 17 ++++++++++++++++-
> >>   super1.c   | 59 +++++++++++++++++++++++++++++++++++++++++-----------=
-------
> >>   5 files changed, 70 insertions(+), 23 deletions(-)
> >>
> >> diff --git a/Create.c b/Create.c
> >> index cd5485b..9663dc4 100644
> >> --- a/Create.c
> >> +++ b/Create.c
> >> @@ -752,7 +752,8 @@ int Create(struct supertype *st, char *mddev,
> >>   #endif
> >>   	}
> >>
> >> -	if (s->bitmap_file && strcmp(s->bitmap_file, "internal")=3D=3D0) {
> >> +	if (s->bitmap_file && (strcmp(s->bitmap_file, "internal")=3D=3D0
> >> +			|| strcmp(s->bitmap_file, "clustered")=3D=3D0)) {
> >>   		if ((vers%100) < 2) {
> >>   			pr_err("internal bitmaps not supported by this kernel.\n");
> >>   			goto abort_locked;
> >> diff --git a/bitmap.h b/bitmap.h
> >> index c8725a3..adbf0b4 100644
> >> --- a/bitmap.h
> >> +++ b/bitmap.h
> >> @@ -154,8 +154,11 @@ typedef struct bitmap_super_s {
> >>   	__u32 chunksize;    /* 52  the bitmap chunk size in bytes */
> >>   	__u32 daemon_sleep; /* 56  seconds between disk flushes */
> >>   	__u32 write_behind; /* 60  number of outstanding write-behind write=
s */
> >> -
> >> -	__u8  pad[256 - 64]; /* set to zero */
> >> +	__u32 sectors_reserved; /* 64 number of 512-byte sectors that are
> >> +				 * reserved for the bitmap. */
> >> +	__u32 nodes;        /* 68 the maximum number of nodes in cluster. */
> >> +	__u8 cluster_name[64]; /* 72 cluster name to which this md belongs */
> >> +	__u8  pad[256 - 136]; /* set to zero */
> >>   } bitmap_super_t;
> >>
> >>   /* notes:
> >> diff --git a/mdadm.8.in b/mdadm.8.in
> >> index a0e8288..c015cbf 100644
> >> --- a/mdadm.8.in
> >> +++ b/mdadm.8.in
> >> @@ -700,7 +700,12 @@ and so is replicated on all devices.  If the word
> >>   .B "none"
> >>   is given with
> >>   .B \-\-grow
> >> -mode, then any bitmap that is present is removed.
> >> +mode, then any bitmap that is present is removed. If the word
> >> +.B "clustered"
> >> +is given, the array is created for a clustered environment. One bitmap
> >> +is created for each node as defined by the
> >> +.B \-\-nodes
> >> +parameter and are stored internally.
> >>
> >>   To help catch typing errors, the filename must contain at least one
> >>   slash ('/') if it is a real file (not 'internal' or 'none').
> >> diff --git a/mdadm.c b/mdadm.c
> >> index e4f8568..6963a09 100644
> >> --- a/mdadm.c
> >> +++ b/mdadm.c
> >> @@ -1111,6 +1111,15 @@ int main(int argc, char *argv[])
> >>   				s.bitmap_file =3D optarg;
> >>   				continue;
> >>   			}
> >> +			if (strcmp(optarg, "clustered")=3D=3D 0) {
> >> +				s.bitmap_file =3D optarg;
> >> +				/* Set the default number of cluster nodes
> >> +				 * to 4 if not already set by user
> >> +				 */
> >> +				if (c.nodes < 1)
> >> +					c.nodes =3D 4;
> >> +				continue;
> >> +			}
> >>   			/* probable typo */
> >>   			pr_err("bitmap file must contain a '/', or be 'internal', or 'non=
e'\n"
> >>   				"       not '%s'\n", optarg);
> >> @@ -1404,7 +1413,13 @@ int main(int argc, char *argv[])
> >>   		if (c.delay =3D=3D 0)
> >>   			c.delay =3D DEFAULT_BITMAP_DELAY;
> >>
> >> -		if (!strncmp(s.bitmap_file, "internal", 9) ||
> >> +		if (!strncmp(s.bitmap_file, "clustered", 9)) {
> >> +			if (s.level !=3D 1) {
> >> +				pr_err("--bitmap=3Dclustered is currently supported with RAID mir=
ror only\n");
> >> +				rv =3D 1;
> >> +				break;
> >> +			}
> >> +		} else if (!strncmp(s.bitmap_file, "internal", 9) ||
> >>   			!strncmp(s.bitmap_file,"none", 4)) {
> >>   			if (c.nodes) {
> >>   				pr_err("--nodes argument is incompatible with --bitmap=3D%s.\n",
> >> diff --git a/super1.c b/super1.c
> >> index f0508fe..ac1b011 100644
> >> --- a/super1.c
> >> +++ b/super1.c
> >> @@ -2144,6 +2144,10 @@ add_internal_bitmap1(struct supertype *st,
> >>   	bms->daemon_sleep =3D __cpu_to_le32(delay);
> >>   	bms->sync_size =3D __cpu_to_le64(size);
> >>   	bms->write_behind =3D __cpu_to_le32(write_behind);
> >> +	bms->nodes =3D __cpu_to_le32(st->nodes);
> >> +	if (st->cluster_name)
> >> +		strncpy((char *)bms->cluster_name,
> >> +				st->cluster_name, strlen(st->cluster_name));
> >>
> >>   	*chunkp =3D chunk;
> >>   	return 1;
> >> @@ -2177,6 +2181,7 @@ static int write_bitmap1(struct supertype *st, i=
nt fd)
> >>   	void *buf;
> >>   	int towrite, n;
> >>   	struct align_fd afd;
> >> +	unsigned int i;
> >>
> >>   	init_afd(&afd, fd);
> >>
> >> @@ -2185,27 +2190,45 @@ static int write_bitmap1(struct supertype *st,=
 int fd)
> >>   	if (posix_memalign(&buf, 4096, 4096))
> >>   		return -ENOMEM;
> >>
> >> -	memset(buf, 0xff, 4096);
> >> -	memcpy(buf, (char *)bms, sizeof(bitmap_super_t));
> >> -
> >> -	towrite =3D __le64_to_cpu(bms->sync_size) / (__le32_to_cpu(bms->chun=
ksize)>>9);
> >> -	towrite =3D (towrite+7) >> 3; /* bits to bytes */
> >> -	towrite +=3D sizeof(bitmap_super_t);
> >> -	towrite =3D ROUND_UP(towrite, 512);
> >> -	while (towrite > 0) {
> >> -		n =3D towrite;
> >> -		if (n > 4096)
> >> -			n =3D 4096;
> >> -		n =3D awrite(&afd, buf, n);
> >> -		if (n > 0)
> >> -			towrite -=3D n;
> >> +	/* We use bms->nodes as opposed to st->nodes to
> >> +	 * be compatible with write-after-reads such as
> >> +	 * the GROW operation.
> >> +	 */
> >> +	for (i =3D 0; i < __le32_to_cpu(bms->nodes); i++) {
> >> +		/* Only the first bitmap should resync
> >> +		 * the whole device
> >> +		 */
> >> +		if (i)
> >> +			memset(buf, 0x00, 4096);
> >>   		else
> >> +			memset(buf, 0xff, 4096);
> >
> > Why is the first bitmap initialised to 0x00 and the others to 0xff?
> > If there is a good reason it should be documented either in a comment i=
n the
> > code or in the changelog entry.
>=20
>=20
> Rather, it is the reverse. The first one is initialized to 0xff and the=20
> rest are set to 0x00.
>=20
> The reason is only the first node to assemble the device should perform=20
> the resync (if --assume-clean is not provided). The comment is right=20
> above the code. Perhaps I should be more elaborate with the comment.
>=20
>=20

Hmmm... Perhaps I should read code with my eyes open!

Not sure I agree though.  Why should the first node be special?
What if node '0' doesn't get activated?
I guess it always well because of the way numbers are assigned, but I'm not
feeling very comfortable...

Thinking a bit more ... why do we set any bits to '1'?
Why not just set BITMAP_STALE, and let the kernel figure things out.

For the single-node case, BITMAP_STALE is the same as setting all the bits =
to
one.
For the cluster case, we can get BITMAP_STALE to do whatever we want. and we
should make sure we handle it correctly anyway.

So maybe mdadm should set BITMAP_STALE, and leave all the bits as 0.

Thoughts?

NeilBrown

--Sig_/yl05wPhcVz5fmVMR0A3luxj
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVUGYyTnsnt1WYoG5AQKj2w/+KTTImVwDXkCxmt/mzT4fHKP0tah8RJO5
zfQ5rkD7EHm8fLDzqmz7P0ESOxGtB++5Tv0a4e5cIy9QvNA3JCBfuvJ6qU2C7jwZ
yczp23GgSB1vjbvlYxF7EZGnlzJ7JHLTvgOJ7uCaQLpSbYMMmKrPD57oFPdq7NSz
aBO+qViAAvMOam+/LhYzmvl+7/VnUeEbixylSAmZcxtbByT5bb8Pdab5xXortY5t
/x0Q+o9uD6RWQt6sZb4ZdbRVYCfp9XrFM/9nVP1SNFj+mE5W/PtY5ZJoFPVVRfi9
dAYLdM74sDyrhnL5mDrUketfTg+SzFIxWdEdwbJ3G7H6LDDmMtXDO/GkEiJEt3cq
o8aYfOJwwqNqU2U5KRYy6UkO2qskrI1GHp2EceldTM/cwnQgZmSTsIBorPQ7BtPn
HLfo7dGkXJJjnI3DAzsMgYIwdBoYh9xDM+2NNyOF3zlFXyVXvb96cdFAhXgDLxj8
ga0gFi0BgPimqKd7JAQI1cMAU2JTDUgZoCk7oJ3cwGN81akSiMw8I7EdGrPmk9LN
+H9zVnqJwcvsUHZbDweEoP54BaZ1mI3MJdJnG1BOni/GNHZEzq/gVElumbk4+HbR
iborBVW2pOLuhG9Lsq61ZLVKdeVT2AZ8N724aJupMWqDcnHgRudjsvkcqP9r6N9v
id9R45m6hg0=
=5ScF
-----END PGP SIGNATURE-----

--Sig_/yl05wPhcVz5fmVMR0A3luxj--
