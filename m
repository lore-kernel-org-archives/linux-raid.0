From: NeilBrown <neilb@suse.de>
Subject: Re: Preparing for mdadm-3.3
Date: Tue, 25 Jun 2013 09:38:24 +1000
Message-ID: <20130625093824.1723e2e3@notabene.brown>
References: <20130624171818.71a9688a@notabene.brown>
	<CAK2H+ef9Zs0rQsGtB5BTOV6bYGXQ_n=Ld_9Lq63x9gBbDnFPog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/hT.WmDvFtfpnP3YK=PP/=IM"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAK2H+ef9Zs0rQsGtB5BTOV6bYGXQ_n=Ld_9Lq63x9gBbDnFPog@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mark Knecht <markknecht@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/hT.WmDvFtfpnP3YK=PP/=IM
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Jun 2013 06:44:25 -0700 Mark Knecht <markknecht@gmail.com> wrote:

> On Mon, Jun 24, 2013 at 12:18 AM, NeilBrown <neilb@suse.de> wrote:
> <SNIP>
> >
> > I somehow got unsubscribed from linux-raid (again) a few weeks back, so=
 if
> > anything was sent to the list and not me that I should know about, now =
might
> > be a good time to resend that too.
> >
> > Thanks,
> > NeilBrown
>=20
> Neil,
>    Welcome back. :-)
>=20
>    I currently run mdadm-3.1.4 which is Gentoo stable. It seems that I
> cannot change chunk size if the new chunk size doesn't divide evenly
> into the number of sectors on the partition, or at least that's the
> way I understand the message. Is that anything you've either worked on
> or considered for mdadm?
>=20

In my mind, it should "obviously" work the way it does.  As you seem to thi=
nk
differently, at least one of us must be missing something.

Each device (in a striped array) must contribute an integer number of chunks
to the array, otherwise you will get holes in the data.
So if you set the chunk size to something that doesn't divide into the size
of the device, then you will end up using less of the device.  And that mea=
ns
that they array will become smaller.

Making the array smaller will mostly likely cause you to lose data.

If you really want to do that, you can.  Just set the size to something
appropriate and then change the chunk size.
  mdadm -G /dev/mdXX --size=3Dsmaller
  mdadm -G /dev/mdXX --chunk=3Ddifferent

Of course the "something appropriate" must be a multiple of both the old and
the new chunk sizes.  As chunk sizes are mostly powers of 2, that shouldn't=
 be
a problem.

Maybe when mdadm reports that the chunk size doesn't divide the device size,
it could suggest a "--grow --size=3D" command to reduce the array size so t=
hat
it will.

Obviously you would need to resize any file system before resizing the arra=
y.

Does that address your issue?  Is there something that you are thinking that
I am missing?

Thanks,
NeilBrown

--Sig_/hT.WmDvFtfpnP3YK=PP/=IM
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUcjYcDnsnt1WYoG5AQLvhxAAtGkuaddNyL2JdTsqNPxTAEcSJZtn7loa
6k39PeXsaXRMitT5exuso8L0ddJScLG4gM2lUmf2EoV+rEOn+mfDi6QpUEgeIhGs
PyApJGyV1oAsvF/IJv0gbhpKHW87VqcV8YgOBBEedIFECNhagpe8lk0QJINqeGmZ
t03JT/wC3gtnF/n+cFryMoAt1yEZbHdwI3Zmr/hXDmztPtVbWxdMIlDkTeWhqbeY
pcwoUKt79k6ERhWVG/gtpT4GkOwUHsNiN9MoeANczG9/7ub+rd3GXZCmat4Nb4Ag
U6k0EmGC+JzGa5gcZ3feRBREhB/MKD7z5T6ancb2kHGnviGDWTuLp4TBtc3T701A
L2e9HgXom0D2aZs5IFR8jE/sxqW2a/MWiRCaYQYatSR6vAmwQiwkEo2Wp+r5pDHp
jan8aJBbqxIxNgfxnnHWKtyyMFvRZsfk7rSpEgMpA5rEYi2klPFvYJ8Yh6drNGHK
p0yKIMkKIot3Nf2UWH7v9Sk/EttfX+u29cMGcw7z/TRS6S3gNSjwho4eXr8HXQdT
7e/3wIeBJOdTZi3VG7GWecBmG+P3VM4MLrAroi/rjAKya09b4wNmSc3SMDUQo2O5
NRITWfG53zD2/u+6K7HPmZT9YqepKprMJODt9Blbwukckb6MuZZ8dRwZOwKUzSVK
nqrTMupbInM=
=RgBG
-----END PGP SIGNATURE-----

--Sig_/hT.WmDvFtfpnP3YK=PP/=IM--
