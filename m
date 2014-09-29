From: NeilBrown <neilb@suse.de>
Subject: Re: /sys/block/md126 still exists even after stopping the array
Date: Mon, 29 Sep 2014 14:47:07 +1000
Message-ID: <20140929144707.39fc5ec0@notabene.brown>
References: <53A99B76.3020603@gmail.com>
	<20140625110348.48ab2d7a@notabene.brown>
	<54243ED7.6090904@gmail.com>
	<20140926103348.5f5ea568@notabene.brown>
	<54253E9F.4070505@gmail.com>
	<20140926204445.1ec830b9@notabene.brown>
	<54255A30.9010406@gmail.com>
	<54256100.3090507@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/stDl8EyCgutIBNCEQsVBu0Z"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54256100.3090507@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Francis Moreau <francis.moro@gmail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>, sebastian.riemer@profitbricks.com
List-Id: linux-raid.ids

--Sig_/stDl8EyCgutIBNCEQsVBu0Z
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Sep 2014 14:50:08 +0200 Francis Moreau <francis.moro@gmail.com>
wrote:

> On 09/26/2014 02:21 PM, Francis Moreau wrote:
> [...]
>=20
> >=20
> >>>> mdadm --stop --scan <<<
> >=20
> > [   89.975162] md_open(): md125 opened by mdadm [930]
> > [   89.975305] md_release(): md125 released by mdadm [930]
> > [   89.977434] md_open(): md125 opened by mdadm [932]
> > [   89.978813] md_open(): md125 opened by mdadm [930]
> > [   89.979365] md_release(): md125 released by mdadm [932]
> > [   89.979693] md_open(): md125 opened by systemd-udevd [931]
> > [   89.985790] md_release(): md125 released by systemd-udevd [931]
> > [   90.179911] md_release(): md125 released by mdadm [930]
> > [   90.180168] md_open(): md127 opened by mdadm [459]
> > [   90.180187] md_release(): md127 released by mdadm [459]
> > [   90.180199] md_open(): md126 opened by mdadm [459]
> > [   90.180205] md_release(): md126 released by mdadm [459]
> > [   90.180556] md_open(): md126 opened by mdadm [930]
> > [   90.180653] md_release(): md126 released by mdadm [930]
> > [   90.180690] md_open(): md126 opened by mdadm [930]
> > [   90.180758] md_open(): mdX opened by mdadm [459]
>=20
> What is this 'mdX' device that mdadm operates on ?
>=20
> It also doesn't have a counterpart release() call.

'mdX' is the name used if mddev->gendisk is NULL.
In that case, md_open() will return an error (ERESTARTSYS).
As the 'open' failed, we wouldn't expect a matching close/release.

NeilBrown


>=20
>=20
> > [   90.180995] md_open(): md125 opened by mdadm [459]
> > [   90.181056] md_release(): md125 released by mdadm [459]
> > [   90.182717] md_open(): md127 opened by mdadm [459]
> > [   90.182725] md_release(): md127 released by mdadm [459]
> > [   90.182732] md_open(): md126 opened by mdadm [459]
> > [   90.182761] md_release(): md126 released by mdadm [459]
> > [   90.182770] md_open(): md125 opened by mdadm [459]
> > [   90.182775] md_release(): md125 released by mdadm [459]
> > [   90.182940] md_release(): md126 released by mdadm [930]
> > [   90.183167] md_open(): md127 opened by mdadm [930]
> > [   90.183257] md_release(): md127 released by mdadm [930]
> > [   90.183288] md_open(): md127 opened by mdadm [930]
> > [   90.183461] md_open(): md127 opened by mdadm [459]
> > [   90.183488] md_release(): md127 released by mdadm [459]
> > [   90.183499] md_open(): md125 opened by mdadm [459]
> > [   90.183505] md_release(): md125 released by mdadm [459]
> > [   90.183686] md_release(): md127 released by mdadm [930]
> >=20
> >=20
> >> Probably there is a 'change' event happening just before the 'remove' =
event,
> >> and udev runs "mdadm" on the 'change' event, and that ends up happenin=
g after
> >> the device has been removed.
> >>
> >> Is this really a problem?  Can't you just ignore it and pretend it isn=
't
> >> there?
> >=20
> > Well, if you list the block devices that the kernel detected in order to
> > operate on them, it could. I don't know exactly what would be the result
> > to use it but it could confuse some tools.
> >=20
> > Is there a way to check that the 'ghost' device has been removed by
> > poking sysfs ?
> >=20
> > Thanks
> >=20
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


--Sig_/stDl8EyCgutIBNCEQsVBu0Z
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBVCjkSznsnt1WYoG5AQL+sxAAhU/BF27meg+y8HwHPNbok6d/2IGH0h3I
kleBIfgmhyHWJINJgIo/f3xTQhS04IgtkXMN/PTJPYcAo9do+PNI4jrmIjDKYaIz
t6+gfzQL0xADS2R0IeFR8X7v90dZxi/5qtxxMBtsgh8cohSVrcYRpC3b1TarzVyy
0IM/Nbx0weddL1joIjlbG6oYqyraNKMfOuDk/yF4kCxRQyFDK7Bf0+xV9RxIZkhg
6XAWjumIqb/p6RyhaZnO3fgX8lSNFqunMllge1X/VYUXx944lej3tGB/7k+XsFdv
oBa4awrUWsmdvRg8aZp/Myvw6HYhVbMRYMQS61BwD0pWzHtkTo5cNikmtEvRRUL+
dyp9yYXTKyYNRX5EoNBstA4s5JGDazrIDAaxXmLx/70YpG8/3XDW0p2PeGRLsK7j
88XrqBvjdQN+GiiD9+geRvBsI/oaMh3ElMnIqm24a18iOeBs8LDUafS59r0FH381
gXgBLAswpTvFXkhLl4iVmAtx26jFUT+RkqBchuFmYW5qT0idZuokC0hw66zxPeXY
fIh5xU2paACZ4SYnapub5D/x1pdgJB8tCcvkXoGxMgw8Ni3VK+NJkNfMy7jkgIp3
3mJfq+S9aMyNcdIoi8KhQFAo7wGT+QQvwuzIflzdYYuAucyuLst40Of4qm+0QF38
Qp215KcVCF8=
=DO1h
-----END PGP SIGNATURE-----

--Sig_/stDl8EyCgutIBNCEQsVBu0Z--
