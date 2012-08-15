From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 - Disk failed during re-shape
Date: Thu, 16 Aug 2012 08:38:36 +1000
Message-ID: <20120816083836.70c2c8a8@notabene.brown>
References: <BLU153-ds1688A6A36A974526D12FDB94CC0@phx.gbl>
	<50258CEA.10100@turmel.org>
	<BLU401-EAS3343C9BB7296EA68990FF2294B20@phx.gbl>
	<20120813093554.600d46c2@notabene.brown>
	<BLU153-ds10943E39726EDC983C484594B00@phx.gbl>
	<20120814123829.23126b08@notabene.brown>
	<BLU153-ds7438ACF3B689B6D7DA9E294B70@phx.gbl>
	<20120815070533.5f7eb1e5@notabene.brown>
	<BLU153-ds19E110068A838779FF3C294B60@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/shsi+kpQV9p+VTs0Z98YJPQ"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU153-ds19E110068A838779FF3C294B60@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Clark <sclark_77@hotmail.com>
Cc: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/shsi+kpQV9p+VTs0Z98YJPQ
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 15 Aug 2012 18:32:43 +0200 Sam Clark <sclark_77@hotmail.com> wrote:

> Unbelievable!  It mounted!=20
>=20
> With the -o noload, my array is mounted, and files are readable!
>=20
> I've tested a few, and they look fine, but it's obviously hard to be sure=
 on
> a larger scale.
>=20
> In any case, I'll certainly be able to recover more data now!

.. and that's what makes it all worthwhile!

Thanks for hanging in there and letting us know the result.

NeilBrown

>=20
> Thanks again Neil!
> Sam
>=20
> -----Original Message-----
> From: linux-raid-owner@vger.kernel.org
> [mailto:linux-raid-owner@vger.kernel.org] On Behalf Of NeilBrown
> Sent: 14 August 2012 23:06
> To: Sam Clark
> Cc: 'Phil Turmel'; linux-raid@vger.kernel.org
> Subject: Re: RAID5 - Disk failed during re-shape
>=20
> On Tue, 14 Aug 2012 15:40:50 +0200 Sam Clark <sclark_77@hotmail.com> wrot=
e:
>=20
> > Thanks Neil,
> >=20
> > Tried that and failed on the first attempt, so I tried shuffling=20
> > around the dev order.. unfortunately I don't know what they were=20
> > previously, but I do recall being surprised that sdd was first on the=20
> > list when I was looking at it previously, so perhaps a starting point. =
=20
> > Since there are some 120 different permutations of device order=20
> > (assuming all 5 could be anywhere), I modified the script to accept
> parameters and automated it a little further.
> >=20
> > I ended up with a few 'possible successes' but none that would mount (i=
.e.
> > fsck actually ran and found problems with the superblocks, group=20
> > descriptor checksums and Inode details, instead of failing with=20
> > errorlevel 8).  The most successful so far was the ones with SDD as=20
> > device 1 and SDE as device 2.. one particular combination (sdd sde sdb=
=20
> > sdc sdf) seems to report every time "/dev/md_restore has been mounted=20
> > 35 times without being checked, check forced.".. does this mean we're on
> the right combination?
>=20
> Certainly encouraging.  However it might just mean that the first device =
is
> correct.  I think you only need to find the filesystem superblock to be a=
ble
> to report that.
>=20
> >=20
> > In any case, that one produces a lot of output (some 54MB when fsck is=
=20
> > piped to a file) that looks bad and still fails to mount.  (I assume=20
> > that "mount -r /dev/md_restore /mnt/restore" I all I need to mount=20
> > with?  I also tried with "-t ext4", but that didn't seem to help either=
).
>=20
> 54MB certainly seems like more that we were hoping for.
> Yes, that mount command should be sufficient.  You could try adding "-o
> noload".  I'm not sure what it does but from the code it looks like it tr=
ied
> to be more forgiving of some stuff.
>=20
>=20
> >=20
> > This is a summary of the errors that appear:=20
> > Pass 1: Checking inodes, blocks, and sizes
> > (51 of these)
> > Inode 198574650 has an invalid extent node (blk 38369280, lblk 0)=20
> > Clear? no
> >=20
> > (47 of these)
> > Inode 223871986, i_blocks is 2737216, should be 0.  Fix? no
> >=20
> > Pass 2: Checking directory structure
> > Pass 3: Checking directory connectivity /lost+found not found. =20
> > Create? no
> >=20
> > Pass 4: Checking reference counts
> > Pass 5: Checking group summary information Block bitmap differences: =20
> > +(36700161--36700162) +36700164 +36700166
> > +(36700168--36700170) (this goes on like this for many pages.. in=20
> > +fact, most
> > of the 54 MB is here)
> >=20
> > (and 492 of these)
> > Free blocks count wrong for group #3760 (24544, counted=3D16439).
> > Fix? no
> >=20
> > Free blocks count wrong for group #3761 (0, counted=3D16584).
> > Fix? no
> >=20
> > /dev/md_restore: ********** WARNING: Filesystem still has errors=20
> > **********
> > /dev/md_restore: 107033/274718720 files (5.6% non-contiguous),
> > 976413581/1098853872 blocks
> >=20
> >=20
> > I also tried setting the reshape number to 1002152448 , 1002153984,
> > 1002157056 , 1002158592 and 1002160128 (+/ - a couple of multiples)=20
> > but output didn't seem to change much in any case.. Not sure if there=20
> > are many different values worth testing there.
>=20
> Probably not.
>=20
> >=20
> > So, unless there's something else worth trying based on the above, it=20
> > looks to me that it's time to raise the white flag and start again...=20
> > it's not too bad, I'll recover most of the data.
> >=20
> > Many thanks for your help so far, but if I may... 1 more question...
> > Hopefully I won't lose a disk during re-shape in the future, but just=20
> > in case I do, or for other unforeseen issues, what are good things to=20
> > backup on a system?  Is it enough to backup the /etc/mdadm/mdadm.conf=20
> > and /proc/mdstat on a regular basis?  Or should I also backup the=20
> > device superblocks?  Or something else?
>=20
> There isn't really any need to backup anything.  Just don't use a buggy
> kernel (which unfortunately I let out into the wild and got into Ubuntu).
> The most useful thing if things do go wrong is the "mdadm --examine" outp=
ut
> of all devices.
>=20
>=20
> >=20
> > Ok, so that's actually 4 questions  ... sorry :-)
> >=20
> > Thanks again for all your efforts.=20
> > Sam
>=20
> Sorry we couldn't get your data back.
>=20
> NeilBrown


--Sig_/shsi+kpQV9p+VTs0Z98YJPQ
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCwk7Tnsnt1WYoG5AQIchQ/9EJbU3JO0WFI9C0SkLHVltxBoL768IKcd
b9TudBebmUhskDZGuu0WWWQghOHEYerC45eCIvACu6LAhLy+O3M3JEihzg9Us0KS
pByFYUtlHfUupRm64csDFZKjZHlyawHrgsItNBBmz0/QY7ypdAXmibviF30L7Qes
USuOL1v5nCz2QMWzoTs4t9AlMP+kPVQ55KJj/za/YChJ433FyhBj6IjeozJCbfpw
ZbYJb3oltG0+IvZXyUlbP0ukgl7LwX5WSX/cBknJs5L0qX+Hu0xS0EnHP8G+x8hX
DInWZ865+cSAtw1ur3gDpU0IMFFY6wExvv+JScJSWsxT1iaXNZ+pi+InhMzLVuW1
ev0s3fEKWNfdE/XO1iXO9CVCdPJLyoRqzTgxZ7p3Rq0x1YbytBS1XfnYlY33PhLp
G2aGnLZXgpr6KhclVBg7Mo3WUg6x3xjD5XyG+ynfxyGPJVs6AifhOje+tcgBCuA7
wd+g5OJufuwYzs+iUA6zk0s33GgwkIaeL/Jn6fgwOE4L1D/7lsnc29BsRh8ICFMo
MocpaL6gnZJpGH0T2z5jmCqO8srcYj6Y2c+mAJAa4+Etl+TaMpJnZ7pkXMgwSJM3
SNHxdh8Iw/Cd+dL+8R/SAti3utZpCQQTsLHHRFp7s4NNTujJ9MPf3E/GHSeYwBo1
qyn5NeSKxkE=
=cGdv
-----END PGP SIGNATURE-----

--Sig_/shsi+kpQV9p+VTs0Z98YJPQ--
