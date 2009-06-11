From: Michael Ole Olsen <gnu@gmx.net>
Subject: Re: slow mdadm reshape, normal?
Date: Thu, 11 Jun 2009 18:07:41 +0200
Message-ID: <20090611160741.GG30825@rlogin.dk>
References: <4A303C06.9080409@anonymous.org.uk> <20090610233659.GD30825@rlogin.dk> <20090611081909.GA16250@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
	protocol="application/pgp-signature"; boundary="Zd8I2GZVcdxtyaG/"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20090611081909.GA16250@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


--Zd8I2GZVcdxtyaG/
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Thanks

I was just hoping for something like 127MB/s divided by 3 =3D 42MB/s which=
=20
is the practical limit of the pci bus assuming each disk gets its equal
share.

6MB/s is only 14% of that, so I wonder where the lost bandwidth goes :)

The reshape takes only 10-15% cpu or so on my 3ghz cpu so dont think that is
the bottleneck.

Might be interesting to test a pci network controller at the same time had I
installed one before the build, that way i could see if the pci bus really =
got
congested.


On Thu, 11 Jun 2009, Robin Hill wrote:

> On Thu Jun 11, 2009 at 01:36:59AM +0200, Michael Ole Olsen wrote:
>=20
> > the slow disks (them with 85MB/s) in the posting are the one on the pci=
 4x sata controller
> >=20
> > the 32bit pci sata (sata_sil) controller has 3 disks connected
> >=20
> > the onboard sata2 6x sata connectors have 6 disks connected=20
> > (p5n32-e sli motherboard), i believe all these are sata2 and not shared=
 with
> > an ide controller.
> >=20
> > so only the pci controller should have bus limitations, but i wonder wh=
y it is
> > that slow on reshape compared to build.
> >=20
> The build was reading (sequentially) from all drives and writing
> (sequentially) only to one, whereas a reshape is reading from and
> writing to all the drives (including seeking between reads & writes).
> This means it is inevitably a lot slower.  In addition, you're now using
> 3 rather than 2 drives on the PCI bus, which will increase the
> congestion.
>=20
> Cheers,
>     Robin
> --=20
>      ___       =20
>     ( ' }     |       Robin Hill        <robin@robinhill.me.uk> |
>    / / )      | Little Jim says ....                            |
>   // !!       |      "He fallen in de water !!"                 |



--Zd8I2GZVcdxtyaG/
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: Digital signature
Content-Disposition: inline

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.9 (GNU/Linux)

iQIcBAEBAgAGBQJKMSvMAAoJECXlragqp/ZI+scP/1gwjj7d08R1ckgo2tsPGlEV
8CWXG969+4yLjTsDge3oi9zyAAgvVEvpBpAqBO6RCE5HjPynkiM/EwqhJn8nZCdi
sYPslaaIn/IL9QLpHMOMdlnooMijEG5paNdTborR/QOyzoZdYFcaHpbFbtIz5ny1
mJyo8yWM2foFWiKsi+Lb0WAhTXmjqTYb1KesFduJ8cEZLil+L0yq32MtpaxaNyMW
reDxtC0CNhFQ2H1AHrm3h8BqG1Bv2gGIciBHHWnTABMBPkx1xb5oocG68UtakjJb
Y6yEpiPiwRGgZrlzUIv6Kn0stGyRHbK66wbwlgMUM+/3+6ZB94bV6gjjwChTgjnX
VGFfP9IVI5UbpPksizm/VSlu5uoYczTXJM81SjFheL8uUuO1VkAe9kEfJVclKEbk
8kfkMI/tWLQe3Y3O1ivnsNJKb0CWHIFDWgzFGwyyaSCh0RX28QGNPYG/GXux3RzO
MEVToe4eaFsVEm4TnRUKr0jhrpdpiZABuLXxqACNn6fpxxPOZkv+fY/3wepaHJAM
CIcC/+cQ5pF0P3cajzBc4zsHv2jG3FT/8RnoAMxxyjGwKhwSzXZzYhgO0PF6i6aJ
enKyXgfQmuHRDoSxROTREk8+Z1q3mOvzZg2XMOcWe+rozd7Tx87SJacOzJ7awyJJ
HnTiCRfO8DF0uJZ/V1Mb
=LsAL
-----END PGP SIGNATURE-----

--Zd8I2GZVcdxtyaG/--
