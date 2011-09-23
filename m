From: NeilBrown <neilb@suse.de>
Subject: Re: Lost mdadm RAID6 array and tried everything, hoping for any
 other suggestions you may have
Date: Fri, 23 Sep 2011 14:30:53 +1000
Message-ID: <20110923143053.6a9c5a9e@notabene.brown>
References: <4E7BB186.1010104@pobox.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/TmmCe52.rWm6zP0X92Ohgz4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E7BB186.1010104@pobox.com>
Sender: linux-raid-owner@vger.kernel.org
To: Eduard Rozenberg <eduardr@pobox.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/TmmCe52.rWm6zP0X92Ohgz4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable


Did you keep the "mdadm -E" output from before you started recreating the
array?
If not, you are probably out of luck.

When you create a RAID5 array it will write to all the superblocks, and will
write over everything on the last device listed - basically treating it as a
spare while the rest is a degraded array, and rebuilding the spare.

So the first n-1 drives are probably largely untouched ... unless you chang=
ed
the order of devices when you created.

The superblock will be somewhere on the first drive.  Maybe you can find it.
That will at least tell you the data offset...

Best advice:  As soon as something happens that you don't understand - ask
for help.  Once you don't understand what you are doing, anything you do wi=
ll
probably make it worse.
Also : keep records of everything.

NeilBrown



On Thu, 22 Sep 2011 15:07:02 -0700 Eduard Rozenberg <eduardr@pobox.com> wro=
te:

> Hello,
>=20
> I've had very good luck with mdadm RAID1 over the years and it's really=20
> helped out.
> More recently I got a bit more adventurous and tried out RAID6, but=20
> after my recent
> experience with it I'm considering writing my take on "RAID6 considered=20
> dangerous" :)
>=20
> Quick summary:
>=20
> * Slackware 64 13.37, Linux 2.6.37.6, on Shuttle XPC 4gb ram
>=20
> * RAID6 array, 8 active drives in a chassis connected via 2 esata cables=
=20
> to a shuttle pc,
>     12TB total, worked fine for several months. Esata controller w/port=20
> multiplier support.
>=20
> * Couple of days back, noticed array was down, with second half of the=20
> drives shown as
>     down. Assumption - 1 cable or esata controller port hickuped, taking=
=20
> 4 drives out of the array,
>     or something happened due to the hot temps that day
>=20
> * /proc/mdstat showed (S) next to some (or all, can't remember) of the=20
> drives in the array -
>     I think that means spare, but I had no spares defined for the array=20
> so it seemed weird
>=20
> * Rebooted machine and checked smartctl status, all 8 drives in chassis=20
> showed OK status,
>     and they were all accessible using gdisk and fd00 partitions=20
> appeared fine.
>=20
> * Tried to reassemble normally, then with force, nothing happened - no=20
> errors, array just
>     didn't come up. Did not try --assume-clean (to my regret). Maybe=20
> would have worked,
>     will never know.
>=20
> * Took some internet advice and tried --create to recreate the array,=20
> however I forgot which
>     chunk size I used so I tried several times with different chunk=20
> sizes (some resync took place
>     each time). Could not find any info on Internet about whether the=20
> resyncs blew away my data.
>=20
> * After each mdadm array recreate, tried to mount the array but failed=20
> with missing superblock
>=20
> * dd'd a few gb's from the array and tried to grep text in a failed=20
> attempt to determine chunk size
>=20
> * Tried testdisk utility to attempt to locate file system structures=20
> after recreating array with various
>     chunk sizes, didn't let utility finish but it didn't seem to be=20
> doing anything useful
>=20
> * R-Studio - tried using it, didn't seem it would do anything useful for =
me
>=20
> At this point the key questions I'm aware of:
>=20
> * Did recreating array with various chunk sizes blow away my data/file=20
> system structures
>    (I did not use --assume-clean when recreating array)
>=20
> * If the data is still ok, is there a way to determine the chunk size=20
> that was used? I'm hoping
>     the metadata version and bitmap options used would not affect being=20
> able to recover
>     the array, because I don't remember which metadata and bitmap=20
> options I used if any.
>=20
> * Given the correct chunk size, if I recreate the array, is there some=20
> way to convince mount to
>     mount the array, or some way of fixing the ext4 structure, or any=20
> other way to get the data of
>     the array other than the file carving utilities that dump everything=
=20
> in a bunch of random
>     directories.
>=20
> I'm well aware RAID !=3D backups and I had a backup but it was a few=20
> months old unfortunately.
> I didn't expect at all this failure mode of having half the disks=20
> disappear and having the array
> be so hard to recover. Most of the Internet information is focused on=20
> array creation and mgmt,
> and I found precious little information on recovery, some of which was=20
> wrong and dangerous.
> At this point I do consider RAID6 to be dangerous and will avoid it =20
> where possible. It just makes
> recovery so much harder when the file system and data is broken up into=20
> little pieces.
>=20
> Thanks in advance for any tips.
>=20
> Regards,
> --Ed
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/TmmCe52.rWm6zP0X92Ohgz4
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iD8DBQFOfAt9G5fc6gV+Wb0RAqHcAJ9zLgOET876qkjuLfKthrrwdUTCDgCguGXd
pT2c58Wg8uFmICr8X7z0sZ4=
=ptNX
-----END PGP SIGNATURE-----

--Sig_/TmmCe52.rWm6zP0X92Ohgz4--
