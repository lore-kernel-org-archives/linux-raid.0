From: Andreas Haumer <andreas@xss.co.at>
Subject: mdadm 2.1: command line option parsing bug?
Date: Fri, 18 Nov 2005 20:34:14 +0100
Message-ID: <437E2CB6.2030903@xss.co.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Hi!

I just upgraded to mdadm-2.1 from mdadm-1.12.0 and noticed
that the following command (which is even mentioned in the
manual page) doesn't work anymore:

root@tolstoi:~ {838} $ mdadm -Ebsc partitions
mdadm: cannot open partitions: No such file or directory


(I always use this command to create my mdadm.conf file,
so I found the problem very quickly after upgrading ;-)

After playing a little bit with the available commandline
options I found that the following commands do work:

root@tolstoi:~ {839} $ mdadm -Eb -sc partitions
ARRAY /dev/md/1 level=raid1 num-devices=3 UUID=c2c22b31:909b7973:0e4224bb:19cf529d

ARRAY /dev/md/0 level=raid5 num-devices=3 UUID=7abbd703:643ffe8e:d6ae4d0e:1b0908aa

as well as the following variations:

root@tolstoi:~ {840} $ mdadm -Eb -s -c partitions
ARRAY /dev/md/1 level=raid1 num-devices=3 UUID=c2c22b31:909b7973:0e4224bb:19cf529d

ARRAY /dev/md/0 level=raid5 num-devices=3 UUID=7abbd703:643ffe8e:d6ae4d0e:1b0908aa


root@tolstoi:~ {841} $ mdadm --examine --brief --scan --config=partitions
ARRAY /dev/md/1 level=raid1 num-devices=3 UUID=c2c22b31:909b7973:0e4224bb:19cf529d

ARRAY /dev/md/0 level=raid5 num-devices=3 UUID=7abbd703:643ffe8e:d6ae4d0e:1b0908aa


So it looks like the commandline option parsing algorithm
in mdadm.c (which is way too complicated for me to find out
quickly what is going wrong here... ;-) has some problem with
the "-Ebsc partitions" variant.

Seems to be a bug?

I also noticed that there is now an additional newline between
the "ARRAY" lines. Is that intentional? IMHO there should only
by one newline after each line here.

HTH

- - andreas

- --
Andreas Haumer                     | mailto:andreas@xss.co.at
*x Software + Systeme              | http://www.xss.co.at/
Karmarschgasse 51/2/20             | Tel: +43-1-6060114-0
A-1100 Vienna, Austria             | Fax: +43-1-6060114-71
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.2 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://enigmail.mozdev.org

iD8DBQFDfiy0xJmyeGcXPhERAp9KAKCfQru5tViXFM3I+MGwEfTfSS7zwACgxD0C
ExjRVCIUb3ik5x1zCFYslFo=
=Rc7n
-----END PGP SIGNATURE-----
