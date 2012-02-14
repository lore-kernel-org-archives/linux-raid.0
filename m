From: NeilBrown <neilb@suse.de>
Subject: Re: SES Enclosure Management.
Date: Wed, 15 Feb 2012 08:16:11 +1100
Message-ID: <20120215081611.3cc31578@notabene.brown>
References: <CAB9NSeUBZXdGRkNNzYjC-KmJjv_AUp4bD_dJH2XyzkuO7PUPcw@mail.gmail.com>
	<20120215073130.792d4fae@notabene.brown>
	<4F3AC828.5000202@gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Bp/AAilNl+U4c4_Y=7Yhumy"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F3AC828.5000202@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Woodworth <robertjwoodworth@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Bp/AAilNl+U4c4_Y=7Yhumy
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Tue, 14 Feb 2012 13:46:32 -0700 Robert Woodworth
<robertjwoodworth@gmail.com> wrote:

> On 02/14/2012 01:31 PM, NeilBrown wrote:
> > On Tue, 14 Feb 2012 10:30:37 -0700 Robert Woodworth
> > <robertjwoodworth@gmail.com>  wrote:
> >
> >> Has anyone ever thought of integrating SES managed enclosures into the
> >> kernel RAID system?  I briefly looked through the archives and have
> >> not found anything on the topic.
> >>
> >> Some HW based RAID controllers do this flawlessly now, there is no
> >> reason why the kernel RAID cannot also.  (LSI MegaRAID)
> >>
> >> 1) When a drive is part if a managed enclosure, the RAID system should
> >> address it by location instead of by enumerated device node.  The SES
> >> device in the enclosure can map the physical slot to a physical drive.
> >>   The RAID admin (mdamd) should be able to add/fail/identify devices
> >> based on slot.
> > Does this just mean that the admin should using names in /dev/disk/by-p=
ath/
> > rather than /dev/sdXX to address devices?  What can md or mdadm do to h=
elp?
> I don't like the /by-path/ too well, it is not human readable.  I would=20
> propose that the SES module that is already in the base kernel be=20
> expanded to provide a /dev/disk/by-location/<enclosureID>/<slot> ->=20
> /dev/sdXY

It isn't the kernel that provides these links, it is udev.
If there is some tool that can extract the enclosureID and slot values, then
one or 2 lines in a udev 'rules' file should be able to create the links.

> >
> The one piece that could be included in the kernel level is the display=20
> of /proc/mdstat to show the enclosureID and slot number

I'm finding /proc/mdstat increasingly distasteful.  It is very convenient b=
ut
hard to extend usefully.
I' rather create something like
   mdadm --status

which reported the status of all (or some) arrays with similar usability to
/proc/mdstat, but more room to extend it.


Thanks,
NeilBrown


--Sig_/Bp/AAilNl+U4c4_Y=7Yhumy
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBTzrPGznsnt1WYoG5AQIXdRAAvCNSDSwSNRDYQzL8l68qWqp7efXc1aTt
6BIeQBgioPcp6oiyXoiKF/GYGieWcORJCdv+bv8nrvUHbL+OU4NCfgoWFOmkXtFd
NHdGUxqQgBY05g8fB8hqDhYPDX5FfYSNiVwi7fbK1g55fXuLNXQKGdzBwNgbN/iT
LFegE+wPtMiXGwVaU6AUEhsEXPCHYo1+/5d6Zh0Tp1C6BiizaTPIoguVVw9H1jUu
8cZcOhKac5AVK7QCPcMBLNL1ucj/xSE287fAWNCmp7kTM4lUQZ+4Gq8pfnS2oR3b
82sUx87+VCO3yMs4NQQGhSD7/YLA09uMRwkS/FSgEHOXxCrAelo8a9tTXv/EOQZI
rlxb+DsHNv5OYEl8PNpKKbCfFZrG6Wad6Wi9Y8t0YNiYF9+372wIn5PArtUqHYLj
aKkpa07BzajZdIwu/p5I2VTSQibFDGTyXu46+ZQeI5Lvjdkf2kn21cFl8e1dCM+F
hiYXAVRj6dhb5IZ3bQMutgVtZrAdc3FyMp00v02uAXAkgOqFRbq89VvHYl3ogYSb
EwB7bqsJ3KA/Iqr6iXalC27lJxXyBrzHqo5BxD8ed1ksxhTJt4yNlej5NrviL0SX
nyQbQ/wvmpBkZTO74msZxqkxAounBxkFqtUOxZH8jLu5i6uEL2xk3ku2Q9E57DNR
CoQ8z/8tyXA=
=Nqbb
-----END PGP SIGNATURE-----

--Sig_/Bp/AAilNl+U4c4_Y=7Yhumy--
