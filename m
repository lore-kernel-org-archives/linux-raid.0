From: NeilBrown <neilb@suse.de>
Subject: Re: mdadm rebuild
Date: Tue, 10 Dec 2013 09:17:29 +1100
Message-ID: <20131210091729.0261e560@notabene.brown>
References: <B49ACD0F-BAD8-4D61-B87C-A06295B58A56@gmail.com>
	<20131209085554.262006d5@notabene.brown>
	<CAJ1=nZcGO_GTUZ9bgrYJJXHoGQnepHyLof21xQ3MFwokfaCvCg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/5pgsGj.W_dIRSaI+.vuUUax"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJ1=nZcGO_GTUZ9bgrYJJXHoGQnepHyLof21xQ3MFwokfaCvCg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: hai wu <haiwu.us@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/5pgsGj.W_dIRSaI+.vuUUax
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Dec 2013 11:16:43 -0600 hai wu <haiwu.us@gmail.com> wrote:

> One more question:
>=20
> How would the failed drive be handled if doing this? Would its traces be
> auto cleaned up and thus it would no longer show up in /proc/mdstat?

When you unplug a device from the system, udev processes a "remove" event.
If you pass this to "mdadm -If" it will fail/remove that device from any
array that it is part of.
The udev scripts distributed with mdadm do this, but only for devices that
were previously detected as raid members.

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


--Sig_/5pgsGj.W_dIRSaI+.vuUUax
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBUqZBeTnsnt1WYoG5AQKpXBAAmQv8IvAv82H42TjFvvOePRt3CUMNkLZQ
ZQdQtoW3peRmm2tosW+hlKjTBWYMGJKvNGFB7Cw8ZIsFKPNitULRelLgW7Y8XXJy
2dqnJFjlH8I2MDeuxmvaS/VOUyGe//pRFLuR5kj827gokPEJgFT663RSmLPxW4k3
OyejdB0hElPsHbTc08wljdBHtGh44Wn6TJ23cYRetzEvqnUjOguR1KzTyWKo3VET
6s58ArCfvxipFqM2mjaTwm2Q/lx1IH6f70PlIcdVaw1O7plh3/woWbDlF/5S9l2P
hrmNclLIjmKwn/AKKXSxMpIn95FAVlulkFZNyij1XULQvm+3zmXWqjy5Z2Rkq7gX
ouj6M/217j0LMASm8RUftyD4GFq5rehzxLPk9xpf09mrHRF1U6eAXOtxYBk7X0A1
TZw7/qonLxF49HHURlpXSACWCDHHkHMIFMDTZJMLwMYbdE83TWprHyMxBbKxn6Ue
pkmCaxiITCXHxsu9wX+vfYkBgporqpDWiNMWupsoWkeBNtaowosRUJIYCl2HpJlM
uDEsz0yDlEu0cD3t3OfNKmOQgIX/v1bxE927Mj5pFNL/HmzIGE+m+TfRapv2mqeq
mK67U8B62ry28tS7gJsYkgoJDeGEEjP3MU30ldkztmH1NTPI3n55HwTW0TxYgXcq
KSnYA56OGsY=
=c0cn
-----END PGP SIGNATURE-----

--Sig_/5pgsGj.W_dIRSaI+.vuUUax--
