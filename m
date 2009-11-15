From: Doug Ledford <dledford@redhat.com>
Subject: Re: Bitmap did not survive reboot
Date: Sun, 15 Nov 2009 06:01:39 -0500
Message-ID: <4AFFDF93.9010303@redhat.com>
References: <20091114214824046.GOED3390@cdptpa-omta03.mail.rr.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 protocol="application/pgp-signature";
 boundary="------------enigC252984C6DE438DCFF90DD24"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20091114214824046.GOED3390@cdptpa-omta03.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Leslie Rhorer <lrhorer@satx.rr.com>
Cc: 'Linux RAID Mailing List' <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

This is an OpenPGP/MIME signed message (RFC 2440 and 3156)
--------------enigC252984C6DE438DCFF90DD24
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable

On 11/14/2009 04:48 PM, Leslie Rhorer wrote:
>> dbench -t 300 -D $mpoint --clients-per-process=3D4 16 | tail -19 >>
>> $log_file
>> mkdir $mpoint/bonnie
>> chown nobody.nobody $mpoint/bonnie
>> bonnie++ -u nobody:nobody -d $mpoint/bonnie -f -m
>> RAID${lvl}-${num}Disk-${chunk}k -n 64:65536:1024:16 >>$log_file
>> 2>/dev/null
>> tiotest -f 1024 -t 6 -r 1000 -d $mpoint -b 4096 >> $log_file
>> tiotest -f 1024 -t 6 -r 1000 -d $mpoint -b 16384 >> $log_file
>>
>> Obviously, I pulled these tests out of a script I use where all these
>> various variables are defined.  Just replace the variables with
>> something sensible for accessing your array, run them, save off the
>> results, run again with a different chunk size, then please post the
>> results back here as I imagine they would be very informative.
>> Especially the dbench results as I think they are likely to benefit th=
e
>> most from the change.  Note: dbench, bonnie++, and tiotest should all =
be
>> available in the debian repos.
>=20
> 	I could not find tiotest.  Also, the version dbench in the distro
> does not support the --clients-per-process switch.  I'll post the resul=
ts
> from the backup system here, and from the primary system in the next po=
st.
>=20
> Backup with bitmap-chunk 65M:
>=20
>   16    363285   109.22 MB/sec  execute 286 sec
>   16    364067   109.05 MB/sec  execute 287 sec
>   16    365960   109.26 MB/sec  execute 288 sec
>   16    366880   109.13 MB/sec  execute 289 sec
>   16    368850   109.35 MB/sec  execute 290 sec
>   16    370444   109.45 MB/sec  execute 291 sec
>   16    372360   109.64 MB/sec  execute 292 sec
>   16    373973   109.74 MB/sec  execute 293 sec
>   16    374821   109.61 MB/sec  execute 294 sec
>   16    376967   109.88 MB/sec  execute 295 sec
>   16    377813   109.77 MB/sec  execute 296 sec
>   16    379422   109.87 MB/sec  execute 297 sec
>   16    381197   110.05 MB/sec  execute 298 sec
>   16    382029   109.92 MB/sec  execute 299 sec
>   16    383868   110.10 MB/sec  cleanup 300 sec
>   16    383868   109.74 MB/sec  cleanup 301 sec
>   16    383868   109.37 MB/sec  cleanup 302 sec


Hmmm...interesting.  This is not the output I expected.  This is the
second by second update from the app, not the final results.  The tail
-19 should have grabbed the final results and looked something like this:=


 Operation      Count    AvgLat    MaxLat
 ----------------------------------------

 NTCreateX    3712699     0.186   297.432
 Close        2726300     0.013   168.654
 Rename        157340     0.149   161.108
 Unlink        750442     0.317   274.044
 Qpathinfo    3367128     0.054   297.590
 Qfileinfo     586968     0.011   148.788
 Qfsinfo       617376     0.921   373.536
 Sfileinfo     302636     0.028   151.030
 Find         1301556     0.121   309.603
 WriteX       1834128     0.125   341.075
 ReadX        5825192     0.047   239.368
 LockX          12088     0.006    24.543
 UnlockX        12088     0.006    23.540
 Flush         260391     7.149   520.703

Throughput 385.585 MB/sec  64 clients  16 procs  max_latency=3D661.232 ms=


This allows comparison of not just the final throughput but also the
various activities.  Regardless though, 109 average versus 92 average is
a very telling story.  That's an 18% performance difference and amounts
to a *HUGE* factor.

> Throughput 110.101 MB/sec 16 procs
> Version 1.03d       ------Sequential Output------ --Sequential Input-
> --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  =
/sec
> %CP
> RAID5-7Disk-6 3520M           66779  23 46588  22           127821  29 =
334.7
> 2
>                     ------Sequential Create------ --------Random
> Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read---
> -Delete--
> files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  =
/sec
> %CP
>    64:65536:1024/16    35   1   113   2   404   9    36   1    54   1  =
 193
> 5


Ditto with these bonnie++ numbers, *HUGE* difference.  66MB/s versus
38MB/s, 46MB/s versus 31MB/s, and 127MB/s versus 114MB/s on the
sequential stuff.  The random numbers are all low enough that I'm not
sure I trust them (the random numbers in my test setup are in the
thousands, not the hundreds).

>=20
> Backup with default (2048K) bitmap-chunk
>=20
>=20
>   16    306080    91.68 MB/sec  execute 286 sec
>   16    307214    91.69 MB/sec  execute 287 sec
>   16    307922    91.61 MB/sec  execute 288 sec
>   16    308828    91.53 MB/sec  execute 289 sec
>   16    310653    91.78 MB/sec  execute 290 sec
>   16    311926    91.82 MB/sec  execute 291 sec
>   16    313569    92.01 MB/sec  execute 292 sec
>   16    314478    91.96 MB/sec  execute 293 sec
>   16    315578    91.99 MB/sec  execute 294 sec
>   16    317416    92.18 MB/sec  execute 295 sec
>   16    318576    92.25 MB/sec  execute 296 sec
>   16    320391    92.39 MB/sec  execute 297 sec
>   16    321309    92.40 MB/sec  execute 298 sec
>   16    322461    92.42 MB/sec  execute 299 sec
>   16    324486    92.70 MB/sec  cleanup 300 sec
>   16    324486    92.39 MB/sec  cleanup 301 sec
>   16    324486    92.17 MB/sec  cleanup 302 sec
>=20
> Throughput 92.6969 MB/sec 16 procs
> Version 1.03d       ------Sequential Output------ --Sequential Input-
> --Random-
>                     -Per Chr- --Block-- -Rewrite- -Per Chr- --Block--
> --Seeks--
> Machine        Size K/sec %CP K/sec %CP K/sec %CP K/sec %CP K/sec %CP  =
/sec
> %CP
> RAID5-7Disk-2 3520M           38751  14 31738  15           114481  28 =
279.0
> 1
>                     ------Sequential Create------ --------Random
> Create--------
>                     -Create-- --Read--- -Delete-- -Create-- --Read---
> -Delete--
> files:max:min        /sec %CP  /sec %CP  /sec %CP  /sec %CP  /sec %CP  =
/sec
> %CP
>    64:65536:1024/16    30   1   104   2   340   8    30   1    64   1  =
 160
> 4


--=20
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

Infiniband specific RPMs available at
	      http://people.redhat.com/dledford/Infiniband


--------------enigC252984C6DE438DCFF90DD24
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iEYEARECAAYFAkr/35kACgkQg6WylM+/8ZSVEgCcClU5AdPdQAPzc//loDrpAss6
UvkAoITUJHZ7G8l9CEziXEOtmS6f81kx
=7q9f
-----END PGP SIGNATURE-----

--------------enigC252984C6DE438DCFF90DD24--
