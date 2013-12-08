From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm rebuild
Date: Mon, 9 Dec 2013 09:53:28 +1100
Message-ID: <20131209095328.0d39e6ad@notabene.brown>
References: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
	<20131209085554.262006d5@notabene.brown>
	<CAJ1=nZfUBQ0_T1s3deG+HOU7BQeayibWcW8y5h5bEjFt2tvhnA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/CFC.qQW/7tcJY7EAp9cHvmD"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ1=nZfUBQ0_T1s3deG+HOU7BQeayibWcW8y5h5bEjFt2tvhnA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hai wu <haiwu.us@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/CFC.qQW/7tcJY7EAp9cHvmD
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 8 Dec 2013 16:45:08 -0600 hai wu <haiwu.us@gmail.com> wrote:

> Thanks Neil. I am not sure if I understand mdadm 'spare' correctly. If
> doing as you mentioned above, the new driver will show up in output of
> "mdadm --detail /dev/md0" as 'spare' status, while I would like the new
> drive to automatically show up as "acitve, sync", and it will automatical=
ly
> be synced up with the one remaining good drive upon running the udev rule.
> I don't see an option like "force-include" in this case. Please let me kn=
ow
> if I miss something.

Whenever md notices that an array has a spare device and a missing device it
will start rebuilding the spare and will then make it an active device.

So if a new device is added to the system, you really do want to give it to
md as a 'spare'.  md will do the rest - it always has done.

NeilBrown


>=20
>=20
> On Sun, Dec 8, 2013 at 3:55 PM, NeilBrown <neilb@suse.de> wrote:
>=20
> > On Sun, 8 Dec 2013 11:53:00 -0600 Hai Wu <haiwu.us@gmail.com> wrote:
> >
> > > I am wondering whether it is possible for mdadm to auto-rebuild a fai=
led
> > > raid1 driver upon its replacement with a new drive? The following lin=
es
> > > from some RedHat website URL seems to indicate vaguely that it might =
be
> > possible:
> > >
> >
> > Yes and no.
> > "yes" because it is certainly possible to arrange this,
> > "no" because it isn't just mdadm which does it.
> >
> > When a drive is plugged in, udev notices and can run various commands t=
o do
> > things with that device.  You need to get udev to run "mdadm -I $devnam=
e"
> > when a new device is plugged in.
> > The udev scripts which come with mdadm will only do that for new drives
> > which
> > appear to be part of an array already.  You presumably want it to do th=
at
> > for
> > any new drive.  The change should be quite easy.
> >
> > Secondly, you need to tell mdadm that it is OK to add a new device as a
> > spare
> > to an array.  To see how to do this you need to read the documentation =
for
> > the "POLICY" command in mdadm.conf.5.
> >
> > A line like:
> >     POLICY action=3Dforce-spare
> > tells mdadm that any device passed to "mdadm -I" can be added to any ar=
ray
> > as
> > a spare.  You might not want that, but you can restrict it in various w=
ays.
> >
> >     POLICY path=3Dpci-0000:00:1f.2-scsi* action=3Dspare
> >
> > says that any device attached to a particular controller can be added to
> > any
> > array as long as it is already a member of the array, or appears to be
> > blank.
> >
> > There are various other directives which should allow you to describe
> > whatever you want.
> >
> > NeilBrown
> >
> >
> > > Previously, mdadm was not able to rebuild newly-connected drives
> > > automatically. This update adds the array auto-rebuild feature and
> > allows a
> > > RAID stack to automatically rebuild newly-connected drives.
> > >
> > > The goal is to get mdadm software raid1 to behave the same as hardware
> > > raid1, when replacing failed hard drive. It should automatically dete=
ct
> > new
> > > drive and rebuild the new drive into part of raid1 ..--
> > > To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> > > the body of a message to majordomo@vger.kernel.org
> > > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
> >


--Sig_/CFC.qQW/7tcJY7EAp9cHvmD
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqT4aDnsnt1WYoG5AQJBYhAAjf3bidvf4vJDRgTjjFMpdYWq1hXHHrNS
jH8v9udaxMfKXiJPvWiJTYc2DXxNMnO7ANmBhXkBBizh+XDGYuJhndP9JaKrIFDO
adMq7bk4hFSqpuy+zn5YN3PsAlenw0RwJAbvNaag+KnbpcjH1TgUuzSPZ5nmq5sh
Fg+k9ZqUJA2DlYDKttiZimMSHJ7ZpU4bdJmciaLQdn+sdSNjyqc1StwADBLlJ4kw
Mnx7X/TTHlq2vKUQU+BREVCM33h/I+ajD0aryGzOS3HzlapCYF4VhZy+CdPGP//A
PWIGdHjfOcAMDRL7EeOdm8ldr4awRunNThDvvk05SSfGFNWyTxJyzBGUR94K5GeW
7v1W6XsK+0KYzJm0friT00pYYkWHdJBogN/4fMmZV2mPFBVVXaVpSRMOfjyh/PXQ
ynbvj6eHZ4cV4UnA8C9D5nkRCs/hjf0US5cyHVy0Et3i9LX+sabUIGgaA5z9O2Ps
5p8q+FDswtucCuzzRrzWWkJs8Q+O9YMzcYAGkbq/f4iDMUmKSqB2+psDjcj2mWZa
bUs8q9h38h7FbT7AbEL2ANODr5bmph3W2Fk6c9UyqNUulkuo6OT/V0HMHzqfrVzp
dWKxI8twAh9klnikvlX01AxKTeBlKAhuGbKk6At+ToZcqKnzRYU3hJ3JQfjXj8Y3
7PXb7IMaN0c=
=WmNM
-----END PGP SIGNATURE-----

--Sig_/CFC.qQW/7tcJY7EAp9cHvmD--
