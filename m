From: Nagilum <nagilum@nagilum.org>
Subject: Re: Help RAID5 reshape Oops / backup-file
Date: Wed, 17 Oct 2007 15:13:40 +0200
Message-ID: <20071017151340.20v6rrd1a8oww888@cakebox.homeunix.net>
References: <20071011142518.igm1jud7ms408ggg@cakebox.homeunix.net>
	<18190.46828.156191.300754@notabene.brown>
	<20071012084328.2f6vk4cdw80kscw0@cakebox.homeunix.net>
	<20071014185550.d6hbv2bk00kkwkgc@cakebox.homeunix.net>
	<18194.42699.193194.986448@notabene.brown>
	<20071015135522.xjds82zo08cgc08c@cakebox.homeunix.net>
	<18196.4323.854776.966812@notabene.brown>
	<20071016145009.qu5kpigu1c8owkc4@cakebox.homeunix.net>
Mime-Version: 1.0
Content-Type: multipart/signed;
	boundary="=_zq3iakwvkpw";
	protocol="application/pgp-signature";
	micalg="pgp-sha1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20071016145009.qu5kpigu1c8owkc4@cakebox.homeunix.net>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

This message is in MIME format and has been PGP signed.

--=_zq3iakwvkpw
Content-Type: text/plain;
	charset=UTF-8;
	DelSp="Yes";
	format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

----- Message from nagilum@nagilum.org ---------
     Date: Tue, 16 Oct 2007 14:50:09 +0200
     From: Nagilum <nagilum@nagilum.org>
Reply-To: Nagilum <nagilum@nagilum.org>
  Subject: Re: Help RAID5 reshape Oops / backup-file
       To: Neil Brown <neilb@suse.de>
       Cc: linux-raid@vger.kernel.org


> ----- Message from neilb@suse.de ---------
>     Date: Tue, 16 Oct 2007 11:16:19 +1000
>     From: Neil Brown <neilb@suse.de>
> Reply-To: Neil Brown <neilb@suse.de>
>  Subject: Re: Help RAID5 reshape Oops / backup-file
>       To: Nagilum <nagilum@nagilum.org>
>       Cc: linux-raid@vger.kernel.org
>
>> Please let me know how it goes.
>>
>> Also, if you could show me "mdadm.conf" and "mdrun.conf" from the
>> initrd, that might help.
>>
>> Thanks,
>> NeilBrown
>>
>
>
> ----- End message from neilb@suse.de -----

Ok, the array reshaped successfully and is back in production. :)
Here the content of the (old) initrd /etc/mdadm/mdadm.conf:

DEVICE partitions
ARRAY /dev/md0 level=3Draid5 num-devices=3D3 =20
UUID=3D25da80a6:d56eb9d6:c7780c0e:bc15422d

That needed updating of course. I don't have a "mdrun.conf" on my =20
system or on the initrd.
I'll try to replicate the issue using a different machine and plain =20
files (lets see if that works) at the weekend and let you know if I =20
succeed.
Again, thank you so much for the patch!
Alex.

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


--=_zq3iakwvkpw
Content-Type: application/pgp-signature
Content-Description: PGP Digital Signature
Content-Disposition: inline
Content-Transfer-Encoding: 7bit

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.7 (FreeBSD)

iD8DBQBHFgqDAKWN2UY+sLwRAiKYAJ9o127wwWViQVEsaC4yeLXEHbLKzwCfSA5j
r2h0zENHwWSmSQFtcfmk8jo=
=8TOm
-----END PGP SIGNATURE-----

--=_zq3iakwvkpw--
