From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm -Db switches array to write-pending?!
Date: Sat, 27 Jul 2013 07:58:10 +1000
Message-ID: <20130727075810.5c6d84d2@notabene.brown>
References: <51DD9FC1.2060200@arcor.de>
	<20130715151809.5fea8c78@notabene.brown>
	<51E6FC4D.6080309@arcor.de>
	<51F2B992.60203@arcor.de>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5xW2oAIPp9R+ytBOTXMwz8e"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <51F2B992.60203@arcor.de>
Sender: linux-raid-owner@vger.kernel.org
To: Martin Wilck <mwilck@arcor.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5xW2oAIPp9R+ytBOTXMwz8e
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Fri, 26 Jul 2013 20:01:54 +0200 Martin Wilck <mwilck@arcor.de> wrote:

> Hi Neil,
>=20
> On 07/17/2013 10:19 PM, Martin Wilck wrote:
> > On 07/15/2013 07:18 AM, NeilBrown wrote:
> >=20
> >> Probably the  best thing to do is:
> >>
> >> diff --git a/drivers/md/md.c b/drivers/md/md.c
> >> index d059af5..b19a1c8 100644
> >> --- a/drivers/md/md.c
> >> +++ b/drivers/md/md.c
> >> @@ -5629,10 +5629,7 @@ static int get_bitmap_file(struct mddev * mddev=
, void __user * arg)
> >>  	char *ptr, *buf =3D NULL;
> >>  	int err =3D -ENOMEM;
> >> =20
> >> -	if (md_allow_write(mddev))
> >> -		file =3D kmalloc(sizeof(*file), GFP_NOIO);
> >> -	else
> >> -		file =3D kmalloc(sizeof(*file), GFP_KERNEL);
> >> +	file =3D kmalloc(sizeof(*file), GFP_NOIO);
> >> =20
> >>  	if (!file)
> >>  		goto out;
> >>
> >>
> >> A failure here is not likely and not catastrophic.
> >>
> >> Does it fix the situation for you?
> >=20
> > Yes it does.
> > Martin
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >=20
>=20
> Any particular reason why you haven't applied this patch in your git
> tree http://git.neil.brown.name/?p=3Dmd.git;a=3Dsummary yet?

Hi Martin,
 you need to look in the for-next branch.
http://git.neil.brown.name/?p=3Dmd.git;a=3Dshortlog;h=3Drefs/heads/for-next

NeilBrown

--Sig_/5xW2oAIPp9R+ytBOTXMwz8e
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUfLw8jnsnt1WYoG5AQKaWhAAnhU817/p23jHXtpeuQK4FtEBHYlb+tf9
CVrAfx8PkMbnkizbinKpxpZ1iWje+DqJmg5kJqk9UuHLvTA6p1WsmAGidNSRz8tq
g7UIbY9lOZV32VqOjJHIyJVyTu4QyJ7oTT+LQYFDV+GfsFZTNjK2nQrUuCu5jQeK
ZEPIUBRzZwtza/32AdYKta88jYCRqe+0XbQkSV3kdzR907nACqB7fwRTh6F7Qbbe
YAVYYmwcmIs0NejZKZsmcsGVRMAUWobDfvi7Eldch4fJAFf/8JNrbTl254/27t9V
HBSYZhQmLAObwWqOCBFNXq384nBCdATuqchKqiMKCN8GxwZgZyBfHTKTl3WUwD9Z
yTcAxXuPvmT5pBio2t4+HWvQK1okDmn/2ohi4lXEn+dz66a4M4Kyyy2FMMFz4H6r
PuHiugzYaP8JmJl3vpNZV7hrC2/8HzMBmmVNdFhwiScyLwMI5tWX56KAoUmqM7oz
JX6O9KptPwlKFQUxPq5EOeutDDwuwFGgyIXZ1ed4nYvr+lSa4mQsP+ZCnxxUufge
g92L7aFPV+38y1YiA+h7Y0qguN0BMBQjAaX3PpQBQ4ouyJVTn23HZuRnX+/m5EIU
Z+T3QcRMGOH9r2fWbhVjsluzV0WmSQdxHIw0R+S6T8aHebk64dhQO2kdPmhB1qN3
jM+mr7x8MR0=
=1caT
-----END PGP SIGNATURE-----

--Sig_/5xW2oAIPp9R+ytBOTXMwz8e--
