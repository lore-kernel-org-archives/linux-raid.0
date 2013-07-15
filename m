From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm -Db switches array to write-pending?!
Date: Mon, 15 Jul 2013 15:18:09 +1000
Message-ID: <20130715151809.5fea8c78@notabene.brown>
References: <51DD9FC1.2060200@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/bJ9=Y6D27e=POOkLTF+9Ikz"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51DD9FC1.2060200@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/bJ9=Y6D27e=POOkLTF+9Ikz
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 10 Jul 2013 19:54:09 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil, hi all,
>=20
> I discovered a weird behavior of mdadm -Db - it will switch a RAID array
> from read-auto state to write-pending. For DDF (and possibly other
> formats) this will cause metadata writes.
>=20
> If I read the code correctly, the reason is that mdadm -Db will use the
> GET_BITMAP_FILE ioctl, which calls md_allow_write(). I saw this on a
> CentOS 6.3 kernel but comparing the code I didn't see a difference in
> recent kernels.
>=20
> I am wondering if this is intentional, and if no, if anything could be
> done about it. It is certainly surprising behavior.
>=20
> Regards
> Martin

I hadn't thought of that consequence.
Probably the  best thing to do is:

diff --git a/drivers/md/md.c b/drivers/md/md.c
index d059af5..b19a1c8 100644
--- a/drivers/md/md.c
+++ b/drivers/md/md.c
@@ -5629,10 +5629,7 @@ static int get_bitmap_file(struct mddev * mddev, voi=
d __user * arg)
 	char *ptr, *buf =3D NULL;
 	int err =3D -ENOMEM;
=20
-	if (md_allow_write(mddev))
-		file =3D kmalloc(sizeof(*file), GFP_NOIO);
-	else
-		file =3D kmalloc(sizeof(*file), GFP_KERNEL);
+	file =3D kmalloc(sizeof(*file), GFP_NOIO);
=20
 	if (!file)
 		goto out;


A failure here is not likely and not catastrophic.

Does it fix the situation for you?

NeilBrown

--Sig_/bJ9=Y6D27e=POOkLTF+9Ikz
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUeOGETnsnt1WYoG5AQI0qBAAjaok38PDtIloNJ3UsXBypfU5iD/bLLqV
B1SDbyku+0Jr/tix30+ff6TC/V1XIQzlvLs0ob/MLj7VsOoHoOBaXoxvevwcpQ3l
z7MR3+qxEsffWFrZsXIDP25MOvVwi5NNUdpCTnzFm8VovX4YqaN92j5thzPXGYU6
oNsnuRV9mJOROr3Uz3ior7RRviU5GSl3plZ4WdK88SqGz3F3nXReUrbfGNplY4j+
dnFE9rc0j2ds5yuzU0XRT2lIlN38R7RQci5vZga5IfAbrGsKNfrUszaSBd/3a0Y3
MnIRepvW2xyc15o7v/6eMPneuukivyGru/W8/4RrBhIcTLk+CECks6WDFIPLhdQP
Afvu3mXO7f6nE4cFzw+lfyxDpzgJzbiMsRrB55TDXWJ2+Ln0vCB3IOmWGXHTekhL
TPCRBtuAF5kPrkpOOZl3fwkHP3GUTOQlbG2NvRMedIXIuw7yyF8e6PK4rA6Sm2Kw
/af5QuTQeobNoNldJxfhWCE7XpOssRQHbP1cqVf6SAFyoTquyYcwhUS8c0x/oCaV
Lt7FkNvBK4W5+5se7p4MqWI54Ug3QoUVYwglyAXlgJo4ITYNh0JxzYiwC0RU5oaK
qWYBCmof0TskSxdaA9FAviOzMFUqSV8mrwuEoVc86jDnPk1ErF1X82W0XuSBqOoU
XqD1bMonBzI=
=HH2q
-----END PGP SIGNATURE-----

--Sig_/bJ9=Y6D27e=POOkLTF+9Ikz--
