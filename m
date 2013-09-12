From: NeilBrown <neilb@suse.de>
Subject: Re: Implementing --detail-platform for DDF
Date: Thu, 12 Sep 2013 16:00:43 +1000
Message-ID: <20130912160043.54d73613@notabene.brown>
References: <5230D9D6.7030005@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/g.wpw_77=PqS3lbbVGp7dAB"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5230D9D6.7030005@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/g.wpw_77=PqS3lbbVGp7dAB
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sep 2013 23:00:06 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> I thought I might come up with an implementation of mdadm
> --detail-platform for DDF, but I encountered a problem I'd like to discus=
s.
>=20
> For DDF, we can't scan PCI devices like IMSM does, because we don't know
> all controllers supporting DDF. Thus I considered scanning block devices
> instead and looking at "foreign" vendor strings in the meta data;
> possibly also filtering by device names or types. It occured to me that
> it might be elegant to simply call conf_get_devs() for a list of devices
> to be scanned. But if I do that, config.o and its dependencies must be
> linked with mdmon, blowing up its size considerably. I figure that
> that's a no-go. But I'm also reluctant to write my own DDF-specific
> block device scanning code while there is conf_get_devs() already.
>=20
> Perhaps I am misunderstanding the purpose of --detail-platform?
> I wouldn't bother with it if YaST2/libstorage didn't call it in order to
> check if a "fake RAID" platform is present.
>=20
> Regards
> Martin

I think it would be wrong for --detail-platform to look at the contents of
disk drives.  If anything, it must look at the 'platform' - the controller.

If YaST2 uses --detail-platform for anything other than IMSM it is doing it
wrong.
I'm currently building a virtual machine running openSUSE 13.1-M4 with DDF
devices.  I'll see what yast thinks of it...

NeilBrown

--Sig_/g.wpw_77=PqS3lbbVGp7dAB
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUjFYiznsnt1WYoG5AQIDcA//TKNebWLU8k6m65TZgCa+GcMa31Cowlwn
rVwSXwKCBpNxfD0dKs51W2QhHbwr9ihKfSWThmSHwu3D71VqVLAjP7336V/bhgw6
pGHwyq7bCNrVXY3Ef5+cQ+VZ3ZdY2I1+sI18C0HFG62AiDymclNp/kH1RTZHwlGR
Fu1TSIYwWpkRC59w5D9ftjm2pU72Wfdt4x99mE9zB3JifNQXnGB8OrZMkjx3A83r
MpLS1J6RrShfRBVHiXXtWZ6xCFeV749ibDb55Peet7Jlc6IJBlVSMfZiJvZhoAOC
mt8iI9e8MDpsXucviAoBX1NFP/OAcgN+0YY5VZPo9euPYc2sU90+mkUwrJ4BvxBl
AahNzHyDEJIzWK6DiPWUYdqXe2Bis+5yask/pUGN0aHrES93rUx0qfRGY0RbEHXG
qkL3VeBF/ISHgFOMpc6/0w/AFBhnWvYbKzvLPZCVRzQ6Pi7m74lbYfHhW7NH+Tj5
i8UZm1deG8p6qaHt0u7eMj9FkhBMwOtQ/GXmiGxdvZLMS7c0/SqUBgSV731TRF6Q
PcLI3Xt8KxBeNjuzIqsfoM23hNYVjgyYKn6fvBiAblbF0jwBhluhjKXZ4ybvVO4N
VD70jvZHvZxwny/UoouuK5Ec1r+igBtVE9tGyVnxS79uHt/4Ea2Y9RpZXgX3x3xb
dup3VK1l8LI=
=LmVl
-----END PGP SIGNATURE-----

--Sig_/g.wpw_77=PqS3lbbVGp7dAB--
