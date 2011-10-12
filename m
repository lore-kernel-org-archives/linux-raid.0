From: NeilBrown <neilb@suse.de>
Subject: Re: MD devnode still present after 'remove' udev event, and mdadm
 reports 'does not appear to be active'
Date: Wed, 12 Oct 2011 14:45:31 +1100
Message-ID: <20111012144531.7479596a@notabene.brown>
References: <CAGRgLy4K-sFpeHhu_f+7-F8Fa_L1OP7ki0X-_9858BbBQrnWOA@mail.gmail.com>
	<20110830072557.428fab35@notabene.brown>
	<CAGRgLy5D+yZJArP9Y=x6N5NnozckQnyF7eaLFo8hgbBxPwzn4w@mail.gmail.com>
	<20110921150323.0ef402c9@notabene.brown>
	<CAGRgLy7fKegKw6j-36o0uchTF35F4hT8NvujW4ghb5av-onCGQ@mail.gmail.com>
	<20110925201510.24e0f468@notabene.brown>
	<CAGRgLy6Ew-mDK-u+Gz9Ae8gKzjC+qJBxM_=Xm6x=VBJBPeOaeg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/n7+YAKePBPA6ejKerGcj6=h"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRgLy6Ew-mDK-u+Gz9Ae8gKzjC+qJBxM_=Xm6x=VBJBPeOaeg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alexander Lyakas <alex.bolshoy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/n7+YAKePBPA6ejKerGcj6=h
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 11 Oct 2011 15:11:47 +0200 Alexander Lyakas <alex.bolshoy@gmail.com>
wrote:

> Hello Neil,
> can you please confirm for me something?
> In case the array is FAILED (when your enough() function returns 0) -
> for example, after simultaneous failure of all drives - then the only
> option to try to recover such array is to do:
> mdadm --stop
> and then attempt
> mdadm --assemble
>=20
> correct?

Yes, though you will probably want a --force as well.

>=20
> I did not see any other option to recover such array Incremental
> assemble doesn't work in that case, it simply adds back the drives as
> spares.

In recent version of mdadm it shouldn't add them as spare.  It should say
that it cannot add it and give up.

NeilBrown



--Sig_/n7+YAKePBPA6ejKerGcj6=h
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTpUNWznsnt1WYoG5AQJAaw/+Mcyi4BXkhBUeLQwl7ddTplLOImk5xJyS
RxR1KYUVH4UMHqQbO7HohkAb3ZOE+3IPf+w13OYGpHsK7VZMl3YDQr0We3p73hyw
ntDy2Sj038DYmdABvFeAmxUlyWxI8k7wxJjKRh6RU45F5Y1SlETfNCkS60KYw8/F
L6r3TGyNstuVGo/hC9YIVJmCNGo/yRmpPAHmGG/8n4vYPoeP8yP9RUTFo8MB7eyY
XlLma/+k5T/dD1gvimpNslNcpyhGWDawbpImwT1TVKNfBkzcmXMU+jrVh13RTy5H
bjx7qclCiG1hp0on94S3XLoBBzdNG+JmFSLmNFJlsc6HeKyFVqxc2iqgO5p14EW6
VLL2IdQhoxsdKwZ8+kSOOVef7zeKv+p2eqKzSoeT535DSsRj9gF0Z0/sLGNcUyX2
WL8iJfdOK6OUkCSrZrTAKlzngnOdSsBV8319MAPnTFRWF4DQndHiJoRShYjkvw3I
g0p9v37t8Sez9vTJR/0z6OFaH8yrlvlGLzL9Ns4Jl4QMeEieQ042TqgANNE8f3vR
7g2/6lZecQ8goBoLpRa34EInGcwRKH5GQPpmJ/0UQ9awzLrY7GN+TUEXVvgSsaYS
mT7hN2MuW7NhX4nU+mgbDlpy1cScHMBm6l5hnKGs2XdtsJK6ikE9I+SSG0YuQUYX
EAvLGVcu3x4=
=jFJC
-----END PGP SIGNATURE-----

--Sig_/n7+YAKePBPA6ejKerGcj6=h--
