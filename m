From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bitmap did not survive reboot
Date: Thu, 12 Nov 2009 00:22:26 -0500
Message-ID: <4AFB9B92.505@redhat.com>
References: <20091112045600054.OQVX5263@cdptpa-omta04.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigAFD3488DA924A114A93D23BC"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091112045600054.OQVX5263@cdptpa-omta04.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigAFD3488DA924A114A93D23BC
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/11/2009 11:55 PM, Leslie Rhorer wrote:
>>>     Data Offset : 272 sectors
>>>    Super Offset : 8 sectors
>>
>> The above two items are what you need for both version 1.1 and 1.2
>> superblocks in order to figure things out.  The data, aka the filesyst=
em
>> itself, starts at the Data Offset which is 272 sectors.  The superbloc=
k
>> itself is 8 sectors in from the front of the disk because you have
>> version 1.2 superblocks.  So, 272 - 8 - size of the superblock, which =
is
>> only a sector or two, is how much internal space you have.  So, in you=
r
>> case, you have about 132k of space for the bitmap.
>=20
> 	OK.  The 10 drive system shows:
>=20
> bitmap: 0/466 pages [0KB], 1024KB chunk
>=20
> 	The 7 drive system shows:
>=20
> bitmap: 0/350 pages [0KB], 2048KB chunk
>=20
> So you think I should remove both and replace them with=20
>=20
> mdadm -G /dev/md0 --bitmap=3Dinternal --bitmap-chunk=3D65536
>=20
> ?
>=20
> 	While most of the files are large video files, there are a fair
> number which are smaller data files such as those of the IMAP server an=
d
> Quicken.  I don't want performance to be too terrible for them, either.=


Oh yeah, those chunk sizes are waaayyyy too small.  Definitely replace
them.  If it will make you feel better, you can do some performance
testing before and after to see why I say so ;-)  I would recommend
running these tests to check the performance change for yourself:

dbench -t 300 -D $mpoint --clients-per-process=3D4 16 | tail -19 >> $log_=
file
mkdir $mpoint/bonnie
chown nobody.nobody $mpoint/bonnie
bonnie++ -u nobody:nobody -d $mpoint/bonnie -f -m
RAID${lvl}-${num}Disk-${chunk}k -n 64:65536:1024:16 >>$log_file 2>/dev/nu=
ll
tiotest -f 1024 -t 6 -r 1000 -d $mpoint -b 4096 >> $log_file
tiotest -f 1024 -t 6 -r 1000 -d $mpoint -b 16384 >> $log_file

Obviously, I pulled these tests out of a script I use where all these
various variables are defined.  Just replace the variables with
something sensible for accessing your array, run them, save off the
results, run again with a different chunk size, then please post the
results back here as I imagine they would be very informative.
Especially the dbench results as I think they are likely to benefit the
most from the change.  Note: dbench, bonnie++, and tiotest should all be
available in the debian repos.

--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigAFD3488DA924A114A93D23BC
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr7m5IACgkQg6WylM+/8ZQiBgCbBwh+K3/7l5KIsbB8AgeNEOag
/T0AoKHVB0I+EwGtrdVyton/+MeF/N/W
=3Md7
-----END PGP SIGNATURE-----

--------------enigAFD3488DA924A114A93D23BC--
