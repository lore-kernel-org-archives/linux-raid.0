From: NeilBrown <neilb@suse.de>
Subject: Re: raid5 Unplug the disk
Date: Thu, 5 Feb 2015 16:03:04 +1100
Message-ID: <20150205160304.1119bb06@notabene.brown>
References: <2c82c493-1fd8-4e59-9f9c-ecd2ab4296e3@aliyun.com>
	<CAEhu1-4krpTbF-0mLdgoTKrkdrWo8J2k80BC0t48rv3WkG3UBA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/JdQm2c9ce7TX=mRP3i.Aaeg"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEhu1-4krpTbF-0mLdgoTKrkdrWo8J2k80BC0t48rv3WkG3UBA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: John Drescher <drescherjm@gmail.com>
Cc: lilofile <lilofile@aliyun.com>, stan <stan@hardwarefreak.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/JdQm2c9ce7TX=mRP3i.Aaeg
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 28 Jan 2015 11:59:30 -0500 John Drescher <drescherjm@gmail.com> wro=
te:

> On Wed, Jan 28, 2015 at 1:44 AM, lilofile <lilofile@aliyun.com> wrote:
> > kernel  linux 3.10, centos
> > when I use 5 disk to create raid5,after sync complete, I unplug a disk,=
and wait a moment, then replug the same disk.
> >
> > the original 4 disk are still a raid5 which is degraded.
> > I find the single disk  become a new raid5,but inactive,what the reason?
>=20
> stop whatever new array that shows up then use
>=20
> mdadm --manage /dev/mymddevice --re-add /dev/disk5
>=20

Also, you probably need a newer version of mdadm. Creating a new inactive
raid5 was a bug.

If you have udev configured to run "mdadm -I" on newly added devices (which=
 I
think most distros do), then adding
  POLICY action=3Dre-add

to /etc/mdadm.conf should  cause the device to automatically be added back =
to
the array when you plug it in.

NeilBrown

--Sig_/JdQm2c9ce7TX=mRP3i.Aaeg
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVNL5iDnsnt1WYoG5AQLKbA/9Eeu/uX5QHj6h7iNfNzdYUVBTv2lO24Qp
QdlCYIVPQwcbOMYcFZ6CDXy51r10etCnkhNBmaRjGmfEYSUG+DF55Rrea6biEtmf
4FbrOMk7359AVHo2vzr7iA8MlgGNhC5jHRUaSM/ei+/vzAm8uQ1BaF1Fv1mWOQ3/
cB3LAis0CDz/wZVZRquVcB994IOCWTkIAz03gxrzHWYlxPCyTRqKmLYNy9KWanS4
/xecqZxkjlDzx8FurSxNlHpKN/Xq0DaTPkJhZY8qKiZALGKdttQovlSuogj2ZXVH
G+3iTfDKGl3yWZH1Mgge72q/kC3tTE7fl7yqvzEWYm+ZjUmefTkF7ok8Zyr4v1o+
f7Zqm7svfQHNRFDxWOLCd4uljGTY1NB/gnV8xm10lVXMMge4b8NqAi84RNtxHpfr
kpdcid9Ip3ruBxW1OvFRNbw5tnQSe1Qyd1kde5Ydwln3evk/x37OU/ybOwb8ktYr
L9YizLC1EdHS3ZeafJ9Z0WzduU0/nXQZInt+kpV4+fxOB5wMUT12/nD4dstMeahP
rnTU91srW8On4ZGJ8bPZfQ1ma6qnGErqKbi3I2BmWlDbdEJO67/8Db0SSkKLmI5N
RFze3I51ym+Q9r/2sxv7xHlOOAJ5/iNlXF3JH/DhtuldB8Lu7sxs1XgS72iTUmP8
xJLKJSLDyek=
=8LlY
-----END PGP SIGNATURE-----

--Sig_/JdQm2c9ce7TX=mRP3i.Aaeg--
