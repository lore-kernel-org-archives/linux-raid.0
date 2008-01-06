From: Nagilum <nagilum@nagilum.org>
Subject: Re: PROBLEM: RAID5 reshape data corruption
Date: Sun, 06 Jan 2008 22:35:46 +0100
Message-ID: <20080106223546.lf8zvaxyiog4sokc@cakebox.homeunix.net>
References: <20080106003146.y9ccz1ra4ggg84wo@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_gu57pfcofl";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080106003146.y9ccz1ra4ggg84wo@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Nagilum <nagilum@nagilum.org>
Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_gu57pfcofl
Content-Type: multipart/mixed;
	boundary="=_6e6p8kxvms08"
Content-Transfer-Encoding: 7bit

This message is in MIME format.

--=_6e6p8kxvms08
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from nagilum@nagilum.org ---------
     Date: Sun, 06 Jan 2008 00:31:46 +0100
     From: Nagilum <nagilum@nagilum.org>

> At the moment I'm thinking about writing a small perl program that
> will generate me a shell script or makefile containing dd commands
> that will copy the chunks from the drive to /dev/md0. I don't care if
> that will be dog slow as long as I get most of my data back. (I'd
> probably go forward instead of backward to take advantage of the
> readahead, after I've determined the exact start chunk.)
> For that I need to know one more thing.
> Used Dev Size is 488308672k for md0 as well as the disk, 16k chunk size.
> 488308672/16 =3D 30519292.00
> so the first dd would look like:
>  dd if=3D/dev/sdg of=3D/dev/md0 bs=3D16k count=3D1 skip=3D30519291 seek=3D=
X
>
> The big question now being how to calculate X.
> Since I have a working testcase I can do a lot of testing before
> touching the real thing. The formula to get X will probably contain a
> 5 for the 5(+1) devices the raid spans now, a 4 for the 4(+1) devices
> the raid spanned before the reshape, a 3 for the device number of the
> disk that failed and of course the skip/current chunk number.
> Can you help me come up with it?
> Thanks again for looking into the whole issue.
----- End message from nagilum@nagilum.org -----

Ok, the spare time over the weekend allowed me to make some headway.
I'm not sure if the attachment will make it through to the ML so I =20
uploaded the perl script to: http://www.nagilum.de/md/rdrep.pl
First tests show already promising results although I seem to miss the =20
start of the error corruption. Anyway unlike with the testcase at the =20
real array I have to start after the area that is unreadable. I have =20
already determined that last Friday.
Anyway I would appreciate it if someone could have a look over the script.
I'll probably change it a little bit and make every other dd run via =20
exec instead of system to use some parallelism. (I guess the overhead =20
for runnung dd will take about as much time as the transfer itself)
Thanks again,
Alex

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
#    _  __          _ __     http://www.nagilum.org/ \n icq://69646724 #
#   / |/ /__ ____ _(_) /_ ____ _  nagilum@nagilum.org \n +491776461165 #
#  /    / _ `/ _ `/ / / // /  ' \  Amiga (68k/PPC): AOS/NetBSD/Linux   #
# /_/|_/\_,_/\_, /_/_/\_,_/_/_/_/   Mac (PPC): MacOS-X / NetBSD /Linux #
#           /___/     x86: FreeBSD/Linux/Solaris/Win2k  ARM9: EPOC EV6 #
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


----------------------------------------------------------------
cakebox.homeunix.net - all the machine one needs..


--=_6e6p8kxvms08
Content-Type: application/x-perl;
	name="rdrep.pl"
Content-Disposition: attachment;
	filename="rdrep.pl"
Content-Transfer-Encoding: 7bit

#!/usr/bin/perl
#
# array before reshape:
#
# n: 0  1  2  3  4  5  6  7  8
# 0: 0, 5,10,15, X,20,25,30,35,
# 1: 1, 6,11, X,16,21,26,31, X,
# 2: 2, 7, X,12,17,22,27, X,32,
# 3: 3, X, 8,13,18,23, X,28,33,
# 4: X, 4, 9,14,19, X,24,29,34,
#
# after a reshape it might look:
#
# 0: 0, 6,12,18,24, X,30
# 1: 1, 7,13,19, X,25,31
# 2: 2, 8,14, X,20,26,32
# 3: 3, 9, X,15,21,27,33
# 4: 4, X,10,16,22,28,34
# 5: X, 5,11,17,23,29, X

use strict;
use English;

my $begin=152;		# ( Reshape pos / $rd_dev_a ) / chunk size
my $end=1276;		# Used Dev size / chunk size
my $rd_dev_a=5;		# of devs including redundant dev
my $failed_dev=3;	# of the bad dev in array
my ($cb,$db,$command);	# current block from source, dest block

for($cb=$begin;$cb<$end;$cb++){
	next unless (($cb+1+$failed_dev)%($rd_dev_a));	#skip X
	$db=$cb*($rd_dev_a-1)+(($cb+$failed_dev)%$rd_dev_a);
	$command="dd if=/dev/loop7 of=/dev/md0 bs=16k count=1 skip=$cb seek=$db\n";
	print ($command);
	system ($command);
}

--=_6e6p8kxvms08--

--=_gu57pfcofl
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHgUmwAKWN2UY+sLwRArqFAJ48bEGTHB9IODGgE464vgNtx2BNwwCgskci
N7IiKk+uRszpKhzzyMSKC1M=
=x4MP
-----END PGP SIGNATURE-----

--=_gu57pfcofl--
