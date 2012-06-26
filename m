From: NeilBrown <neilb@suse.de>
Subject: Re: Hi! Strange issue with LSR -- bitmaps hadn't been used during 2
 of 3 RAIDs resync
Date: Tue, 26 Jun 2012 16:18:46 +1000
Message-ID: <20120626161846.08489b0a@notabene.brown>
References: <CA+sTkh74rDvV05pjhVAD5wa4fxXsZE5MLN4y4fMd=Js7_BoTDQ@mail.gmail.com>
	<20120527220007.64fb230b@notabene.brown>
	<CA+sTkh67PwRkuYyXMRHUFmJUmC==9KFJNnpK+SsAhCTB-48UOg@mail.gmail.com>
	<20120528114550.417ae379@notabene.brown>
	<CA+sTkh6D8b38Bx+Xbd7iKo8j29YqYqtRr6tqgFx-j2zAGjMyJQ@mail.gmail.com>
	<20120528125436.69e847ca@notabene.brown>
	<CA+sTkh5wn0UaUb51+tcNegCooi5cUdVi08qQ5Z2RTk4j5Wk2qA@mail.gmail.com>
	<CA+sTkh7=QrRyq23g=NDjOPLBfJRw8NFaQCPJc1JoDRa893_9oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/PYNsS6fEgqNVHPs+zQ7RVEW"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CA+sTkh7=QrRyq23g=NDjOPLBfJRw8NFaQCPJc1JoDRa893_9oA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Igor M Podlesny <for.poige+lsr@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PYNsS6fEgqNVHPs+zQ7RVEW
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Jun 2012 10:49:32 +0800 Igor M Podlesny <for.poige+lsr@gmail.com>
wrote:

> On 28 May 2012 12:03, Igor M Podlesny <for.poige+lsr@gmail.com> wrote:
> > On 28 May 2012 10:54, NeilBrown <neilb@suse.de> wrote:
> > [...]
> >> The best indicator is total time that it takes (which can probably be
> >> extracted from logs as start and end are logged). =C2=A0Divide that in=
to size of a
> >> device to get average MB/sec. =C2=A0If the bitmap was used, that will =
normally be
> >> much less the best throughput of the device.
> >
> > =C2=A0 That's exactly why I am stating it didn't use WIBs 2 times of 3.=
 It
> > went resyncing from beginning till the end -- I had my finger on its
> > pulse. :)
> >
> > =C2=A0 I can't promise (due to popular "lack of time" disease, yeah), b=
ut
> > if I'll get on it using VirtualBox or real environment [Lord forbid
> > :)] once again, I'll let you know, sure.
>=20
>    Here it is: http://pastie.org/4118133

This doesn't appear to show the "start to end" that I suggested, just 10% to
30%, but it does suggest that the bitmap isn't speeding things up at all, at
least for that part of the array... That is assuming you are talking about
md124.  I note that md125 doesn't have a bitmap.  Is that what you are
referring to?

The next thing to do would be to look at the bitmap immediately after reboot
to see how many bits are set.  Maybe lots are set for some reason.

>=20
>    =E2=80=94 3.4.2-rt10 went suspend ok for 2 times, the 3rd it didn't.
> Reboot, resync, no bitmaps use.
>=20
>    And, BTW, it's rather slow in despite of having max. stripe_cache_size=
 set.
>=20

A larger stripe cache isn't going to affect resync speed much (I think).
50MB/sec on each drive seems fairly good to me.  What were you expecting?

NeilBrown



--Sig_/PYNsS6fEgqNVHPs+zQ7RVEW
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT+lURjnsnt1WYoG5AQJHQA/8DjGtrjCM24WxHhmGOR4bQFODZFkEpKfE
BHyotRi/roY8sEDfVl5vKcKK7jpDGVB6xCeGq9xN3eGidF1euYr+hzAZBDisYv5M
bI8soKbNzcAr+Y/GdpDT9mc13wudTBOKyfsOvv5pTvSW5woYzn40msnCeoc47D1T
gZys9LEPJSa7y3n/vMHY3Z7O5ZyQIxhY0gzMFYy0snfef6ps/W0TCqZYdoSjrJPu
eUTtwCLYx8X//nY7wJD1GQZm/BPpfhSHfXpUiTCWgNu12NUog+lfWiboYamb+eLA
4JdRxdd7mLz2+z9iAMZU0FJlQI3yovdYz0BXQAGl01BOJfTrXWvhY0wMXcBJ01AM
xohL09flyGKWlJtHpZReiPA4k7pzJofmXLw0YF4rd1Vsf6zk+Sn/E6epamjCblz1
M9NVLc75+YqNK7vT8jIaNhLnTGkH9yYqY6op4C2pQgM6DiBLd1QwsqdWV9FN5SPi
IsrXHM2Im7ek5AOmqgFsMoS0k1JdnWAw6lkOtXdgLAD/pHU6N47EnkrjVO3vowM7
IHkJLao8y/keFcWnCVDLg4StyuUBhi3YVaNRg8IOef5pSmVMOt8MDuk5DVtsVNlE
yYvkIA+jhs1bQFOlZ8+8gwr1uqqA2QFQxguFeIO5q2d/ofqQ3VEX9Ngc4MTX98pa
B6mZ5bXL/hE=
=zox/
-----END PGP SIGNATURE-----

--Sig_/PYNsS6fEgqNVHPs+zQ7RVEW--
