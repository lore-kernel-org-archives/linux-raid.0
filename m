From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH 0/4] add --initrd argument to mdadm/mdmon
Date: Sun, 22 Jan 2012 22:25:33 +1100
Message-ID: <20120122222533.42ba46b2@notabene.brown>
References: <1326797330-4488-1-git-send-email-Jes.Sorensen@redhat.com>
	<4F15D29C.7070504@redhat.com>
	<4F15D710.7080104@redhat.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/mwoNHyHnoV_W3neZVQ7dqq6"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F15D710.7080104@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Jes Sorensen <Jes.Sorensen@redhat.com>
Cc: Doug Ledford <dledford@redhat.com>, linux-raid@vger.kernel.org, kay@redhat.com, harald@redhat.com, lpoetter@redhat.com, mschmidt@redhat.com
List-Id: linux-raid.ids

--Sig_/mwoNHyHnoV_W3neZVQ7dqq6
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2012 21:16:16 +0100 Jes Sorensen <Jes.Sorensen@redhat.com>
wrote:

> On 01/17/12 20:57, Doug Ledford wrote:
> > Patch set looks reasonable to me, although you missed adding the new
> > option to the mdadm man page.
> >=20
> > Do we have a specific systemd version for which we know that --initrd is
> > needed, or a version before which it is the wrong thing to do?
> >=20
> > Ditto for dracut, do we know what the minimum version of dracut is
> > before it will use the --initrd parameter on its mdadm calls?
>=20
> I actually did this on purpose - or rather I left it out of the help
> message on purpose. The option is really only meant to be used by
> dracut/systemd, it doesn't make much sense for normal users/admins to
> play with it directly.

You left it out of the help message for mdmon, but included it in the help
message for mdadm!

>=20
> If you think it makes sense, I can add documentation for it.

I think it should be in the help messages and definitely should be in the m=
an
page.

If you fix that up and the other little things I've identified, then I'll
apply it .... providing we have a name that I can live with.

Thanks,
NeilBrown


>=20
> Right now I believe dracut isn't ready to call mdadm with --initrd,
> however systemd in rawhide is aware of the '@' hack. I am not sure of
> the specific version, but we should document the final minimum versions
> once it's all sorted so all distros know which versions to pick.
>=20
> Cheers,
> Jes


--Sig_/mwoNHyHnoV_W3neZVQ7dqq6
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTxvyLTnsnt1WYoG5AQJAIBAAll0cFCNLJX/RgsmklW+60zYKhQWKWwno
BR2KdYj6q8cEk3UonBY33bllpC2xcWYnKe36n77F5L4eMt4SPDIhB8z1EG6/QJjA
tt7uWbWjENqh0R/ufOu9HCYDXxxNFlWKAFsSekU/bgTaVlXTjsPKzTRhAGNY5xRZ
W6MP262qpNMDxNGNbDlWHeYDLxp/wgQzDQBv0L/iqMFKPZaHU1g5pyt4VlBshIML
bVkPysLGMYyNcppsqr6aZt8Kd3KIK/GDYcB26NOx4VEn0EphT9mv4Eta0G6trWO9
IthQnEIAzcMNlhb485AB4WuPuifSzFJtQ1VEn+HIW7m717D0QPbCNfWmhxBuSt4H
w54lWBHFRvXpu+EbFOxo+32g4Joe3IyHpGquPMZFeGwNdclJrzlMXbE5vlOmjc/s
gZzSFrB1XddJn3FqGzeSvPJI62zotulwCwUgZtdXzWX6jcyBWz1W/WryQsnJiTIr
Bc+FyZi8PfchzAwNwhvX7ePGJCSs9J+WScWVY+Im37Bxb6TNn6KOcbuTRCNu30yz
UKt6+0tE21wcL1hsjKeBi7j/5KPxJc4dzjMNaajVXXWCwdf9C1Rnx7vv6kqne6EZ
2IpXNde64BUntix7K6qErkXcK1nnuDXeWzP9zh17Qd1K3ur76BE4pgAqIMaCmFjy
U5L7sT9OIwk=
=w2TE
-----END PGP SIGNATURE-----

--Sig_/mwoNHyHnoV_W3neZVQ7dqq6--
