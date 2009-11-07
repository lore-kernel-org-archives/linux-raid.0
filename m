From: Doug Ledford <dledford@redhat.com>
Subject: Re: Successful RAID 6 setup
Date: Sat, 07 Nov 2009 13:35:31 -0500
Message-ID: <4AF5BDF3.8020907@redhat.com>
References: <20091104184049356.ZIDJ2725@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigFB0EF021F80A5D3D5EC9BF78"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091104184049356.ZIDJ2725@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigFB0EF021F80A5D3D5EC9BF78
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/04/2009 01:40 PM, Leslie Rhorer wrote:
>> I will preface this by saying I only need about 100MB/s out of my arra=
y
>> because I access it via a gigabit crossover cable.
>=20
> 	That's certainly within the capabilities of a good setup.
>=20
>> I am backing up all of my information right now (~4TB) with the
>> intention of re-creating this array with a larger chunk size and
>> possibly tweaking the file system a little bit.
>>
>> My original array was a raid6 of 9 WD caviar black drives, the chunk
>> size was 64k. I use USAS-AOC-L8i controllers to address all of my driv=
es
>> and the TLER setting on the drives is enabled for 7 seconds.
>=20
> 	I would recommend a larger chunk size.  I'm using 256K, and even
> 512K or 1024K probably would not be excessive.

OK, I've got some data that I'm not quite ready to send out yet, but it
maps out the relationship between max_sectors_kb (largest request size a
disk can process, which varies based upon scsi host adapter in question,
but for SATA adapters is capped at and defaults to 512KB max per
request) and chunk size for a raid0 array across 4 disks or 5 disks (I
could run other array sizes too, and that's part of what I'm waiting on
before sending the data out).  The point here being that a raid0 array
will show up more of the md/lower layer block device interactions where
as raid5/6 would muddy the waters with other stuff.  The results of the
tests I ran were pretty conclusive that the sweet spot for chunk size is
when chunk size is =3D=3D max_sectors_kb, and since SATA is the predomina=
nt
thing today and it defaults to 512K, that gives a 512K chunk as the
sweet spot.  Given that the chunk size is generally about optimizing
block device operations at the command/queue level, it should transfer
directly to raid5/6 as well.

>> storrgie@ALEXANDRIA:~$ sudo mdadm -D /dev/md0
>> /dev/md0:
>>         Version : 00.90
>=20
> 	I definitely recommend something other than 0.9, especially if this
> array is to grow a lot.
>=20
>> I have noticed slow rebuilding time when I first created the array and=

>> intermittent lockups while writing large data sets.
>=20
> 	Lock-ups are not good.  Investigate your kernel log.  A write-intent
> bitmap is recommended to reduce rebuild time.
>=20
>> Is ext4 the ideal file system for my purposes?
>=20
> 	I'm using xfs.  YMMV.
>=20
>> Should I be investigating into the file system stripe size and chunk
>> size or let mkfs choose these for me? If I need to, please be kind to
>> point me in a good direction as I am new to this lower level file syst=
em
>> stuff.
>=20
> 	I don/'t know specifically about ext4, but xfs did a fine job of
> assigning stripe and chunk size.

xfs pulls this out all on it's own, ext2/3/4 need to be told (and you
need very recent ext utils to tell it both stripe and stride sizes).

>> Can I change the properties of my file system in place (ext4 or other)=

>> so that I can tweak the stripe size when I add more drives and grow th=
e
>> array?
>=20
> 	One can with xfs.  I expect ext4 may be the same.

Actually, this needs clarified somewhat.  You can tweak xfs in terms of
the sunit and swidth settings.  This will effect new allocations *only*!
 All of your existing data will still be wherever it was and if that
happens to be not so well laid out for the new array, too bad.  For the
ext filesystems, they use this information at filesystem creation time
to lay out their block groups, inode tables, etc. in such a fashion that
they are aligned to individual chunks and also so that they are *not*
exactly stripe width apart from each other (which forces the metadata to
reside on different disks and avoids the possible pathological case
where you could accidentally end up with the metadata blocks always
falling on the same disk in the array making that one disk a huge
bottleneck to the rest of the array).  Once an ext filesystem is
created, I don't think it uses the data much any longer, but I could be
wrong.  However, I know that it won't be rearranged for your new layout,
so you get what you get after you grow the fs.


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigFB0EF021F80A5D3D5EC9BF78
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr1vfgACgkQg6WylM+/8ZRZQgCgqG5m+V6ZIDuzlNzMmBVOjpgv
CNoAn2wpWno+g9kTzjRVanzH+Rbn0phf
=w3cN
-----END PGP SIGNATURE-----

--------------enigFB0EF021F80A5D3D5EC9BF78--
