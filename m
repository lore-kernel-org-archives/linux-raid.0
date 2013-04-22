From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] DM RAID: Add ability to restore transiently failed
 devices on resume
Date: Mon, 22 Apr 2013 10:43:26 +1000
Message-ID: <20130422104326.217ef2f8@notabene.brown>
References: <1365712023.9799.1.camel@f16>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/REDHpfAjuTkhkmIr.ust_K0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1365712023.9799.1.camel@f16>
Sender: linux-raid-owner@vger.kernel.org
To: Jonathan Brassow <jbrassow@redhat.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/REDHpfAjuTkhkmIr.ust_K0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 11 Apr 2013 15:27:03 -0500 Jonathan Brassow <jbrassow@redhat.com>
wrote:

> DM RAID: Add ability to restore transiently failed devices on resume
>=20
> This patch adds code to the resume function to check over the devices
> in the RAID array.  If any are found to be marked as failed and their
> superblocks can be read, an attempt is made to reintegrate them into
> the array.  This allows the user to refresh the array with a simple
> suspend and resume of the array - rather than having to load a
> completely new table, allocate and initialize all the structures and
> throw away the old instantiation.
>=20
> Signed-off-by: Jonathan Brassow <jbrassow@redhat.com>

Is this really a good idea? =20
Just because you can read the superblock, that doesn't mean you can read any
other block in the array.

If the auto-recovery were optional I might consider it, but having it be
enforced on every suspend/resume just doesn't seem safe to me.

Have I misunderstood?

Is this that hard to achieve in user-space?


> +			if (test_bit(Faulty, &r->flags) && r->sb_page &&
> +			    !read_disk_sb(r, r->sb_size)) {

I know it is fairly widely used, especially for 'strcmp', but I absolutely
despise this construct.
  !read_disk_sb()
sound like
  "not read_disk_sb" or "could not read the disk's superblock" but it
actually means "did not fail to read the disk's superblock" - the exact
reverse.
If 0 means success, I like to see an explicit test for 0:
   read_disk_sb() =3D=3D 0

NeilBrown


--Sig_/REDHpfAjuTkhkmIr.ust_K0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXSHrjnsnt1WYoG5AQLZDg/+N4bj3VC7NMEhMIStXHheFWRkTEuD+Q/x
zezzE5QLIIXJWqd4bnkjIqUx/lNpCnQGHjAD+bidySBwmuLOtEitt1kH05tnnmlE
qTu8o+UF4A4uajWkpGqObQq4Pi3g+SJb1L5OriVKOGYxBvABT/owEh59l9qjNMo1
01E5JyhuO8nsu57vBFaX7wF8sAlxYtygOS7lEHJuDvkvSK0qbk8pvSH52fhaHCyS
uETgpBmO6PZ7BCrKqEJNwfpxW8GG9MRnh9UEX8cRtreSQYnCy+euk14cryIC934j
0SOEUdBuRGkPZ4a0XEaTY7/xWLV55HQKUIz1V2QXfz654wQnIOMg8WCb2Mvm+2VN
J+tb8OsqqS7qW2tXA7Adih36GCdLzwIGFdIcNr2UyaqCDMYnkdiMlYPCDAZI/xkD
upLb2hAduVhfKzcGgR+GMMCe7NyHMplNj2QTthXwDqiBadwZ3ixx8UO4Q/f74/Mu
pcqPnu4GAmZPT/PyzaiGnxKldkQfrO4MuUCWDJ3SxvNw8YLZy/lqLXFKs4kf/n4T
zGBz1x9HoPTiCzjlP9aU80wVxPBUQwN7OKcrjgwFi6/qgjkhG6FbpneZST1qTKpg
rwU63DVIsSNMLgeQGd3DJsJs8rkvH8dRYgbY0eTjvL+Yum+MxviYVJ51LfOlDwZB
kYxTGbzmoS0=
=udcb
-----END PGP SIGNATURE-----

--Sig_/REDHpfAjuTkhkmIr.ust_K0--
