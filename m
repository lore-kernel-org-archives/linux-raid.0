From: Roman Mamedov <rm@romanrm.net>
Subject: Re: Is a raid0 512 byte chunk size possible? Or is it just too
 small?
Date: Sat, 31 Aug 2013 13:10:09 +0600
Message-ID: <20130831131009.4a1dfaad@natsu>
References: <CANb3qHcczcKrCOPWy7MfY2aP_0V2c5KkQa6zzm5f1J7Qx20W8w@mail.gmail.com>
	<52210FAB.7060606@hardwarefreak.com>
	<CALFpzo7sZgjrZbfT=1uT3UMWwA7TG6pBXsj4f+oxRAfwuvWZ9w@mail.gmail.com>
	<CANb3qHfJ=5T6Oa0NgPdLsDhdjj4wMPorRtkZjwDjdh14oKjcsw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/y7FMn+7DjbV48TrR=PlzMzA"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CANb3qHfJ=5T6Oa0NgPdLsDhdjj4wMPorRtkZjwDjdh14oKjcsw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Veedar Hokstadt <veedar@gmail.com>
Cc: Marcus Sorensen <shadowsor@gmail.com>, stan@hardwarefreak.com, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/y7FMn+7DjbV48TrR=PlzMzA
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sat, 31 Aug 2013 01:05:44 -0400
Veedar Hokstadt <veedar@gmail.com> wrote:

> I am totally aware of the complications involved but if I can somehow
> build a raid0 / chunk 512B array with mdadm using the raw Lacie dives
> then I can take it from there to recover the data.

You can write a simple program to read in chunks of 512 bytes from one driv=
e,
then from the other, piece this together and write to some third file. Here=
 is
something quick that I modified from a tool I already had. Even though it's
doing the tight loop in PHP, it seems to do about 100 MB/sec reading from t=
wo
SATA drives and writing to a file on a RAID6 in my system.

--- merge.php ---

#!/usr/bin/php
<?php
  $f =3D array();
  array_shift($argv);
  foreach($argv as $arg) {
    if(($f[] =3D @fopen($arg, "rb"))=3D=3D=3Dfalse) die("Unable to open fil=
e $arg.\n");
  }
  while(@$feof_cnt<2) {
    $feof_cnt=3D0;
    foreach($f as $file) {
      print(fread($file, 512));
      if(feof($file))$feof_cnt++;
    }
  } =20
?>

---

Usage: ./merge.php /dev/sda /dev/sdb > image.img

And you will need somewhere to store this image.img that's has the free spa=
ce
to fit the size of sda+sdb. Also check that you specify the drives in the
proper order (only 2 tries, really).

--=20
With respect,
Roman

--Sig_/y7FMn+7DjbV48TrR=PlzMzA
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlIhltEACgkQTLKSvz+PZwiwGACcCbshOcGW7FBofyPuz+6xkgwd
m1QAn2CW7bkIjyiJr0pdK8UNIyOKZgRO
=8A6f
-----END PGP SIGNATURE-----

--Sig_/y7FMn+7DjbV48TrR=PlzMzA--
