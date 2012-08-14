From: NeilBrown <neilb@suse.de>
Subject: Re: RAID5 - Disk failed during re-shape
Date: Tue, 14 Aug 2012 12:38:29 +1000
Message-ID: <20120814123829.23126b08@notabene.brown>
References: <BLU153-ds1688A6A36A974526D12FDB94CC0@phx.gbl>
	<50258CEA.10100@turmel.org>
	<BLU401-EAS3343C9BB7296EA68990FF2294B20@phx.gbl>
	<20120813093554.600d46c2@notabene.brown>
	<BLU153-ds10943E39726EDC983C484594B00@phx.gbl>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/IwYdtjDKv_Xbm/3rtN+04ku"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU153-ds10943E39726EDC983C484594B00@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Sam Clark <sclark_77@hotmail.com>
Cc: Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/IwYdtjDKv_Xbm/3rtN+04ku
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Aug 2012 18:14:30 +0200 "Sam Clark" <sclark_77@hotmail.com> wrot=
e:

> Thanks Neil, really appreciate the assistance.
>=20
> Would love to give that a try - at least to catch the data that has chang=
ed=20
> since last backup, however I don't know the chunk size.  I created the ar=
ray=20
> so long ago, and of course didn't document anything.  I would guess they =
are=20
> 64K, but not sure.  Is there any way to check from the disks themselves?
>=20
> I've captured the 128K chunks as follows - hope it's correct:
>=20
> I got the disk size in Bytes from fdisk -l, and subtracted 131072.. then=
=20
> ran:
> sam@nas:~$ sudo dd if=3D/dev/sd[b-f] of=3Dtest.128k bs=3D1 skip=3Dxxx cou=
nt=3D128k,
> The 5 files are attached.
>=20
> The disk sizes are as follows:
> sam@nas:~$ sudo blockdev --getsize /dev/sd[b-f]
> sdb: 2930277168
> sdc: 2930277168
> sdd: 2930277168
> sde: 2930277168
> sdf: 3907029168
>=20

Unfortunately the metadata doesn't contain any trace of the the reshape
position, so we'll make do with 11.4%

The following script will assemble the array read-only.  You can then try
"fsck -n /dev/md_restore" to see if it is credible.  Then try to mount it.

Most of the details I'm confident of.

'chunk' is probably right, but there is no way to know for sure until you
have access to your data.  If you try changing it you'll need to also change
reshape to be an appropriate multiple of it.

'reshape' is approximately 11.4% of the array.  Maybe try other suitable
multiples.

'devs' is probably wrong.  I chose that order because the metadata seems to
suggest that order - yes, with sdf in the middle.  Maybe you know better.
You can try different orders until it seems to work.

Everything else should be correct.  component_size is definitely correct, I
found that in the metadata.  'layout' is the default and is hardly ever
changed.

As it assembles read-only, there is no risk in getting it wrong, changing
some values and trying again.  The script disassembles and old array before
creating the new.

good luck.

NeilBrown



# Script to try to assemble a RAID5 which got it's metadata corrupted
# in the middle of a reshape (ouch).
# We assemble as externally-managed-metadata in read-only mode
# by writing magic values to sysfs.

# devices in correct order.
devs=3D'sdb sdd sdf sde sdc'

# number of devices, both before and after reshape
before=3D4
after=3D5

# reshape position as sectors per array.  It must be a multiple
# of one stripe, so chunk*old_data_disks*new_data_disks
# This number is 0.114 * 2930276992 * 3, rounded up to
# a multiple of 128*3*4.   Other multiples could be tried.
reshape=3D1002155520

# array parameters
level=3Draid5
chunk=3D65536
layout=3D2
component_size=3D2930276992

# always creates /dev/md_restore
mdadm -S /dev/md_restore
echo md_restore >  /sys/module/md_mod/parameters/new_array
cd /sys/class/block/md_restore/md

echo external:readonly > metadata_version
echo $level > level
echo $chunk > chunk_size
echo $component_size > component_size
echo 2 > layout
echo $before > raid_disks

echo $reshape > reshape_position
echo $after > raid_disks

slot=3D0
for i in $devs
do
 cat /sys/class/block/$i/dev > new_dev
 echo 0 > dev-$i/offset
 echo $component_size > dev-$i/size
 echo insync > dev-$i/state
 echo $slot > dev-$i/slot

 slot=3D$[slot+1]
done

echo readonly > array_state=20

grep md_restore /proc/partitions

--Sig_/IwYdtjDKv_Xbm/3rtN+04ku
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUCm6JTnsnt1WYoG5AQKJvQ/7BNyD0wzm6STlhr0iaI5iSO/N39SYYCzC
owqSYPMnESt3aEILEYBt+db2R9Wn2Ylo1ZHUIrgszLCz1qYTFdo4lj6wC8n+op1U
BoKzf/cpB/FAUPCdR6Q8tIsZUh4lXa5GCwfDFjGuJpNtcTbxH2AGL+A+gH+vgzSd
2hrCj86MTPi/9ELpm8y5hnUltAEyodl2+cH+OoY7ziMALVvJIGHHb4aky5Xlaf2V
4tAAYHvbS+HJvjeVYyIMchFZAR5DSCnWtzktNS1yZudJfEahPA1m/Qw708ej1TW6
759d1jvRGDwv/hPA3y/cDl33F0BG8Wun196TyVCiGtwUWPYVVtCgngK5EEFECMC2
3+caKZXpYM2pFI7Y6Es2yI/7s6CXwD8/xBHgvLmLy5ETJ45dFAWR447kU+8vMPWq
Nc+0prd509zuLGwRtAN5i4q62E+jMaDakCzutL1se6cn0VObyYK/7kudfE107Hfw
hOTWfb3UVoob7hAAwjtDTpSSUq8cE4Gpvk8r5atxG7LcsE99DNjpSbOtrwHkDozS
o2+CTJkBrX3eleMqsSftV+JI2EzOfmlSyEuMaLMaVVabNbKwNfcq8Auwiwjbd1AP
mLnMiHlqMBk1wK7z1YrGkAIF9eZs8scf+IS391HRRIuoABywq3AOresV5+fRil8z
H4x8rzQfHdk=
=09Xh
-----END PGP SIGNATURE-----

--Sig_/IwYdtjDKv_Xbm/3rtN+04ku--
