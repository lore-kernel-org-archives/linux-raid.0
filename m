From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 - Disk failed during re-shape
Date: Wed, 15 Aug 2012 07:05:33 +1000
Message-ID: <20120815070533.5f7eb1e5@notabene.brown>
References: <BLU153-ds1688A6A36A974526D12FDB94CC0@phx.gbl>
	<50258CEA.10100@turmel.org>
	<BLU401-EAS3343C9BB7296EA68990FF2294B20@phx.gbl>
	<20120813093554.600d46c2@notabene.brown>
	<BLU153-ds10943E39726EDC983C484594B00@phx.gbl>
	<20120814123829.23126b08@notabene.brown>
	<BLU153-ds7438ACF3B689B6D7DA9E294B70@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/XBpw2UNFpCBcgq_6jd93Vr0"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU153-ds7438ACF3B689B6D7DA9E294B70@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Clark <sclark_77@hotmail.com>
Cc: 'Phil Turmel' <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/XBpw2UNFpCBcgq_6jd93Vr0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Aug 2012 15:40:50 +0200 Sam Clark <sclark_77@hotmail.com> wrote:

> Thanks Neil,=20
>=20
> Tried that and failed on the first attempt, so I tried shuffling around t=
he
> dev order.. unfortunately I don't know what they were previously, but I do
> recall being surprised that sdd was first on the list when I was looking =
at
> it previously, so perhaps a starting point.  Since there are some 120
> different permutations of device order (assuming all 5 could be anywhere)=
, I
> modified the script to accept parameters and automated it a little furthe=
r.=20
>=20
> I ended up with a few 'possible successes' but none that would mount (i.e.
> fsck actually ran and found problems with the superblocks, group descript=
or
> checksums and Inode details, instead of failing with errorlevel 8).  The
> most successful so far was the ones with SDD as device 1 and SDE as device
> 2.. one particular combination (sdd sde sdb sdc sdf) seems to report every
> time "/dev/md_restore has been mounted 35 times without being checked, ch=
eck
> forced.".. does this mean we're on the right combination?=20

Certainly encouraging.  However it might just mean that the first device is
correct.  I think you only need to find the filesystem superblock to be able
to report that.

>=20
> In any case, that one produces a lot of output (some 54MB when fsck is pi=
ped
> to a file) that looks bad and still fails to mount.  (I assume that "mount
> -r /dev/md_restore /mnt/restore" I all I need to mount with?  I also tried
> with "-t ext4", but that didn't seem to help either).

54MB certainly seems like more that we were hoping for.
Yes, that mount command should be sufficient.  You could try adding "-o
noload".  I'm not sure what it does but from the code it looks like it tried
to be more forgiving of some stuff.


>=20
> This is a summary of the errors that appear:=20
> Pass 1: Checking inodes, blocks, and sizes
> (51 of these)
> Inode 198574650 has an invalid extent node (blk 38369280, lblk 0)
> Clear? no
>=20
> (47 of these)
> Inode 223871986, i_blocks is 2737216, should be 0.  Fix? no
>=20
> Pass 2: Checking directory structure
> Pass 3: Checking directory connectivity
> /lost+found not found.  Create? no
>=20
> Pass 4: Checking reference counts
> Pass 5: Checking group summary information
> Block bitmap differences:  +(36700161--36700162) +36700164 +36700166
> +(36700168--36700170) (this goes on like this for many pages.. in fact, m=
ost
> of the 54 MB is here)
>=20
> (and 492 of these)=20
> Free blocks count wrong for group #3760 (24544, counted=3D16439).
> Fix? no
>=20
> Free blocks count wrong for group #3761 (0, counted=3D16584).
> Fix? no
>=20
> /dev/md_restore: ********** WARNING: Filesystem still has errors ********=
**
> /dev/md_restore: 107033/274718720 files (5.6% non-contiguous),
> 976413581/1098853872 blocks
>=20
>=20
> I also tried setting the reshape number to 1002152448 , 1002153984,
> 1002157056 , 1002158592 and 1002160128 (+/ - a couple of multiples) but
> output didn't seem to change much in any case.. Not sure if there are many
> different values worth testing there.

Probably not.

>=20
> So, unless there's something else worth trying based on the above, it loo=
ks
> to me that it's time to raise the white flag and start again... it's not =
too
> bad, I'll recover most of the data.
>=20
> Many thanks for your help so far, but if I may... 1 more question...
> Hopefully I won't lose a disk during re-shape in the future, but just in
> case I do, or for other unforeseen issues, what are good things to backup=
 on
> a system?  Is it enough to backup the /etc/mdadm/mdadm.conf and /proc/mds=
tat
> on a regular basis?  Or should I also backup the device superblocks?  Or
> something else? =20

There isn't really any need to backup anything.  Just don't use a buggy
kernel (which unfortunately I let out into the wild and got into Ubuntu).
The most useful thing if things do go wrong is the "mdadm --examine" output
of all devices.


>=20
> Ok, so that's actually 4 questions  ... sorry :-)
>=20
> Thanks again for all your efforts.=20
> Sam

Sorry we couldn't get your data back.

NeilBrown

--Sig_/XBpw2UNFpCBcgq_6jd93Vr0
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCq9nTnsnt1WYoG5AQLDng//dnQICckmsLq4M74f3pWjYhDnub1cc6I0
lX42yRppGiYYTIW0ocuSzLo+4oMYYIqDOOFpisce1QlCI+1YhC3KqIqtxpn5+MmW
RPbIU4U1ntYiqD2651cj7jpVgtJ/aQTFadDTBITRiYmlrApHb59rBFtdJT/WXKp7
QGF62aV6UXSxjPidSEazxN1w7j34acTOdTWqnGxa7Vuj+hyplF6QY0Gd/IWptDvL
zN+R9AbfCem5ULONG7DaoWVFog6t9J861upPvAJR7YXmgWF3zcpet/eqbl8nzmQE
Q2sWUObuZqA6u4ti8HsgW1wrY1CjIfZm9jW4QrFoVhwCbH7J5F+k5LgDuYv4i9xU
xhjUGKEI5W55+BAHQr+GE72LlcO6hfcd5MFMpUFIkVxWxMEIGxegMVS3BZw9F+dT
fwA9lbocYdgD16iLG0rBcicjzUu+sf0VxHnDJNTIzxg+8l0G2MhCJEKdsryeeaxA
W1a6MvFVSJYxDk43oWHieLLn+6ZwydOVua91efqFUWcFxq/R7H2hMTH5RuyG0AwA
gavy7L2fjtjj5RoevX6H6pLxK12Kq1SaTrhgooQVcQ4G5dhD+fyDC2T/rKG6uU9w
hCdbO2ASzGwDkFplXZ1iR9W67vhV3wn9B1TzrAC/e+ffaiy1pLOpi1m0Zif2uEkG
lKq15mPUBVk=
=Srar
-----END PGP SIGNATURE-----

--Sig_/XBpw2UNFpCBcgq_6jd93Vr0--
