From: Nagilum <nagilum@nagilum.org>
Subject: Re: PROBLEM: RAID5 reshape data corruption
Date: Fri, 11 Jan 2008 10:04:15 +0100
Message-ID: <20080111100415.a89hg1l3k0wsg8gc@cakebox.homeunix.net>
References: <20080106003146.y9ccz1ra4ggg84wo@cakebox.homeunix.net>
	<20080106223546.lf8zvaxyiog4sokc@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_3bw3za67s6yo";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080106223546.lf8zvaxyiog4sokc@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: Neil Brown <neilb@suse.de>, Dan Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_3bw3za67s6yo
Content-Type: text/plain;
	charset=ISO-8859-2;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from nagilum@nagilum.org ---------
     Date: Sun, 06 Jan 2008 22:35:46 +0100
     From: Nagilum <nagilum@nagilum.org>
Reply-To: Nagilum <nagilum@nagilum.org>
  Subject: Re: PROBLEM: RAID5 reshape data corruption
       To: Nagilum <nagilum@nagilum.org>
       Cc: Neil Brown <neilb@suse.de>, linux-raid@vger.kernel.org, Dan =20
Williams <dan.j.williams@intel.com>, "H. Peter Anvin" <hpa@zytor.com>


> ----- Message from nagilum@nagilum.org ---------
>     Date: Sun, 06 Jan 2008 00:31:46 +0100
>     From: Nagilum <nagilum@nagilum.org>
>
>> At the moment I'm thinking about writing a small perl program that
>> will generate me a shell script or makefile containing dd commands
>> that will copy the chunks from the drive to /dev/md0. I don't care if
>> that will be dog slow as long as I get most of my data back. (I'd
>> probably go forward instead of backward to take advantage of the
>> readahead, after I've determined the exact start chunk.)
>> For that I need to know one more thing.
>> Used Dev Size is 488308672k for md0 as well as the disk, 16k chunk size.
>> 488308672/16 =3D 30519292.00
>> so the first dd would look like:
>> dd if=3D/dev/sdg of=3D/dev/md0 bs=3D16k count=3D1 skip=3D30519291 seek=3D=
X
>>
>> The big question now being how to calculate X.
>> Since I have a working testcase I can do a lot of testing before
>> touching the real thing. The formula to get X will probably contain a
>> 5 for the 5(+1) devices the raid spans now, a 4 for the 4(+1) devices
>> the raid spanned before the reshape, a 3 for the device number of the
>> disk that failed and of course the skip/current chunk number.
>> Can you help me come up with it?
>> Thanks again for looking into the whole issue.
> ----- End message from nagilum@nagilum.org -----
>
> Ok, the spare time over the weekend allowed me to make some headway.
> I'm not sure if the attachment will make it through to the ML so I
> uploaded the perl script to: http://www.nagilum.de/md/rdrep.pl
> First tests show already promising results although I seem to miss the
> start of the error corruption. Anyway unlike with the testcase at the
> real array I have to start after the area that is unreadable. I have
> already determined that last Friday.
> Anyway I would appreciate it if someone could have a look over the script.
> I'll probably change it a little bit and make every other dd run via
> exec instead of system to use some parallelism. (I guess the overhead
> for runnung dd will take about as much time as the transfer itself)
----- End message from nagilum@nagilum.org -----

I just want to give a quick update.
The program run for about one and a half day and it looks good, the =20
directories and files appear ok. I'll do some work on it this evening, =20
see if I can restore some more blocks before running xfs_repair.
Kind regards,

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


--=_3bw3za67s6yo
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHhzEOAKWN2UY+sLwRAuVaAJ42GImrLTXlwL21fi3u1x9CO9qz2QCcDn2F
pvWakCyJHn4P1GdGcNhLaYg=
=W51v
-----END PGP SIGNATURE-----

--=_3bw3za67s6yo--
