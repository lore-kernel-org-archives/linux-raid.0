From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm --grow Hard Drive Size Puzzle
Date: Mon, 1 Oct 2012 15:40:23 +1000
Message-ID: <20121001154023.4d3b14d7@notabene.brown>
References: <67FBE301-6EF3-4B0D-87FC-8A3C66473416@thinkcomputer.com>
	<20121001125510.6cc0c2be@notabene.brown>
	<8C2056A6-5E2E-4E02-AF9A-1C07158776CB@thinkcomputer.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/SaPFMTknMYOtJQffDzyCTFn"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8C2056A6-5E2E-4E02-AF9A-1C07158776CB@thinkcomputer.com>
Sender: linux-raid-owner@vger.kernel.org
To: Aaron Greenspan <aarong@thinkcomputer.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/SaPFMTknMYOtJQffDzyCTFn
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 30 Sep 2012 21:55:27 -0700 Aaron Greenspan <aarong@thinkcomputer.co=
m>
wrote:

> Neil,
>=20
> The kernel I'm using is...
>=20
> [root@kermit plainsite]# uname -a
> Linux kermit.thinkcomputer.com 2.6.32-71.el6.i686 #1 SMP Fri Nov 12 04:17=
:17 GMT 2010 i686 i686 i386 GNU/Linux
>=20
> However, I have downloaded an update that I can install and hopefully tha=
t will fix the issue.

You don't actually need to install a new kernel - though it certainly won't
hurt.

Just reboot and you will be able to resize the array.

>=20
> One other question: why do df, /proc/mdstat, and other utilities always l=
ist the RAID arrays in random order? I'm always expecting md0 to show up fi=
rst, followed by md1, md2, etc. but this is rarely actually the way that th=
e arrays are ordered. It makes it kind of confusing when different utilitie=
s do things differently.

I think the correct word is "arbitrary", not "random".

Just adjust your expectations.  Don't expect any particular order, and then
it won't look wrong.

Things tends to be listed in the order they are created, or the reverse of
that.  Though in some cases it might be the ordering of some hash of some
value.

If you want something sorted, use "sort" :-)

NeilBrown



>=20
> Thanks for your help,
>=20
> Aaron
> =09
> Aaron Greenspan
> President & CEO
> Think Computer Corporation
>=20
> telephone +1 415 670 9350
> toll free +1 888 815 8599
> fax +1 415 373 3959
> e-mail aarong@thinkcomputer.com
> web http://www.thinkcomputer.com


--Sig_/SaPFMTknMYOtJQffDzyCTFn
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGksyDnsnt1WYoG5AQIySxAApWe20VsU3fQ6YRphtm0pjERDYm0B44Wt
PoKHQoIxBOxFHG/qsWgIAQsyVOYTDP/OvBYFAWEbpiAwn2v2aNGGbOv1lu7Jg23m
0Y3dSB/sPdlz+JLTAN7iURwRZPZHxdrpf8MWPXLNchgLxIDOgrU24fIPMnh9zX+n
W138e6Sm2CLMOXR05SDIA31kzmnkIOZqkOPdlYtmrp/nquqNgn6iriJsveMoVi5N
GWjO+9nezyRghkx+vGCy7sjsBsRGrTDAvEur+7TVBquvWeHr7SfZV2KdhlPccb+y
F3kmxRRnPcPY4THxkavigune31K14jORRkY3BAuIqmvwwVAdiAsuiFsZE4KU5NCj
SqDfoVrjUkAMFIyr7AZM11bjI8ZSimWTKWA2n9ycBWmlfbfhqVbgV+3cjCuz3hb4
BpZyNp/2/wEp07MIhHsDNGHvN4cP5KNhzXFTrAzzHX+FwEUPln+xSwxwc1kn/SPS
kIFzciSoQKUwTMT9vH4Gk4QkWYYbQ4FSANIP7bbIFGWfdb3xwl5w34H+x1hG3JVw
4qn9HC59Fw2bdPPIaKWMDoiPVIPCw6D/F/yFQr39JQK+Phqj3lvAvhtgM2H0SUqz
lm0CTGugMQ/mS90Qkb0W2CcVsymaPyb8R1b8wrMZCRPsGnXpMJ2IZp9hYF0lchsT
4L128JHw6oo=
=MP9+
-----END PGP SIGNATURE-----

--Sig_/SaPFMTknMYOtJQffDzyCTFn--
