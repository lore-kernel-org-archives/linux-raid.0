From: Andre Noll <maan@systemlinux.org>
Subject: Re: Raid6 array crashed-- 4-disk failure...(?)
Date: Tue, 16 Sep 2008 10:25:10 +0200
Message-ID: <20080916082509.GA17300@skl-net.de>
References: <48CE250C.8000603@ultratux.net> <20080915125951.GA17966@skl-net.de> <48CE9811.60307@ultratux.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="sdtB3X0nJg68CQEu"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <48CE9811.60307@ultratux.net>
Sender: linux-raid-owner@vger.kernel.org
To: Maarten <maarten@ultratux.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

On 19:14, Maarten wrote:
> >Are you also using an Intel-based SATA chip (please send the output
> >of lspci -v)?  Also, which kernel version are you using?
>=20
> No, my chipset is a VIA one. Because the VIA SATA chips/drivers are=20
> terrible, I use only SATA PCI cards with Sil chipsets.  Believe it or=20
> not I have good/excellent experiences with these. The driver is quite=20
> stable, better than everything else I tried.
>=20
> apoc log # lspci
> 00:00.0 Host bridge: VIA Technologies, Inc. VT8377 [KT400/KT600 AGP]=20
> Host Bridge (rev 80)
> 00:01.0 PCI bridge: VIA Technologies, Inc. VT8237 PCI Bridge
> 00:07.0 RAID bus controller: Silicon Image, Inc. SiI 3114=20
> [SATALink/SATARaid] Serial ATA Controller (rev 02)
> 00:08.0 RAID bus controller: Silicon Image, Inc. SiI 3114=20
> [SATALink/SATARaid] Serial ATA Controller (rev 02)
> 00:09.0 RAID bus controller: Silicon Image, Inc. SiI 3114=20
> [SATALink/SATARaid] Serial ATA Controller (rev 02)
> 00:0a.0 RAID bus controller: Silicon Image, Inc. SiI 3124 PCI-X Serial=20
> ATA Controller (rev 02)
> 00:0b.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL-8169=20
> Gigabit Ethernet (rev 10)
> 00:0f.0 IDE interface: VIA Technologies, Inc.=20
> VT82C586A/B/VT82C686/A/B/VT823x/A/C PIPC Bus Master IDE (rev 06)
> 00:11.0 ISA bridge: VIA Technologies, Inc. VT8237 ISA bridge=20
> [KT600/K8T800/K8T890 South]
> 01:00.0 VGA compatible controller: ATI Technologies Inc Rage XL AGP 2X=20
> (rev 65)
>=20
> Linux apoc 2.6.23-gentoo-r3 #2 Fri Apr 25 11:09:37 CEST 2008 i686 AMD=20
> Sempron(tm) 2200+ AuthenticAMD GNU/Linux

My machine is running vanilla 2.6.25.4, i.e. we're using different
SATA drivers and different kernels.

While looking at the logs I found a plenty of those:

	set_rtc_mmss: can't update from 150 to 43

And indeed this machine started to have serious problems with its
clock since last weekend. I found it off by 12 hours yesterday and it
is still runing much too fast so that ntp is not working any more. I'm
currently setting the time with a script in 10min intervals...

Were you also seeing such messages during/after the hard disk failures?

> I'm considering a 8/12/16 port Areca controller but a few practicalities=
=20
> hold me back: the price, and the fact I would need a PCI-X slot unless I=
=20
> want to kill performance by a factor of 10. Also, the fact that I then=20
> cannot use software raid anymore tends to scare me a little: You never=20
> know how firmware reacts in the more 'interesting' circumstances, and=20
> you lose control over it...

You could use jbod mode (or create single-disk "raid arrays") with
Areca or 3ware controllers and use software raid on top of that.

Andre
--=20
The only person who always got his work done by Friday was Robinson Crusoe

--sdtB3X0nJg68CQEu
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.1 (GNU/Linux)

iD8DBQFIz21lWto1QDEAkw8RAsIrAJ9VMUN6DkTMvIgUH0Elo1+8MtjLGgCbB2ON
kUuIH8IwWU2gQ1RFu4ZH+YE=
=nJ4z
-----END PGP SIGNATURE-----

--sdtB3X0nJg68CQEu--
