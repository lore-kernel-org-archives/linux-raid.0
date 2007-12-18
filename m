From: Nagilum <nagilum@nagilum.org>
Subject: Re: raid5 reshape/resync
Date: Tue, 18 Dec 2007 11:09:38 +0100
Message-ID: <20071218110938.0gh9rkr2xc84cscs@cakebox.homeunix.net>
References: <20071124120209.0t70rfkfswkcww0g@cakebox.homeunix.net>
	<20071125200431.2wbk051yoso4owsk@cakebox.homeunix.net>
	<18254.21183.807123.642613@notabene.brown>
	<20071201154817.5uwtck6ask0ksw8s@cakebox.homeunix.net>
	<20071211225613.5tybri2ickcgk0s4@cakebox.homeunix.net>
	<20071216141645.6a766a85@absurd>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_ni8ykhj3mn4";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071216141645.6a766a85@absurd>
Sender: linux-raid-owner@vger.kernel.org
To: Janek Kozicki <janek_listy@wp.pl>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_ni8ykhj3mn4
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from janek_listy@wp.pl ---------
     Date: Sun, 16 Dec 2007 14:16:45 +0100
     From: Janek Kozicki <janek_listy@wp.pl>
Reply-To: Janek Kozicki <janek_listy@wp.pl>
  Subject: Re: raid5 reshape/resync
       To: Nagilum <nagilum@nagilum.org>
       Cc: linux-raid@vger.kernel.org


> Nagilum said:     (by the date of Tue, 11 Dec 2007 22:56:13 +0100)
>
>> Ok, I've recreated the problem in form of a semiautomatic testcase.
>> All necessary files (plus the old xfs_repair output) are at:
>>   http://www.nagilum.de/md/
>
>> After running the test.sh the created xfs filesystem on the raid
>> device is broken and (at last in my case) cannot be mounted anymore.
>
> I think that you should file a bugreport, and provide there the
> explanations you have put in there. An automated test case that leads
> to xfs corruption is a neat snack for bug squashers ;-)
>
> I wonder however where to report this - the xfs or raid ? Eventually
> cross report to both places and write in the bugreport that you are
> not sure on which side there is a bug.
>
----- End message from janek_listy@wp.pl -----

This is a md/mdadm problem. xfs is merely used as a vehicle to show =20
the problem also amplified bei luks.
Where would I file this bug report? I thought this is the place?
I could also really use a way to fix that corruption. :(
Thanks,
Alex.

PS: yesterday I verified this bug on 2.6.23.9, will do 2.6.23.11 today.

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


--=_ni8ykhj3mn4
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHZ5xhAKWN2UY+sLwRAtm6AJ9IfQWV7513FOzRmfdgEuhnXXHEUwCeK+1U
wa1Bbd/sKunVs7z5QqZIgic=
=YNSF
-----END PGP SIGNATURE-----

--=_ni8ykhj3mn4--
