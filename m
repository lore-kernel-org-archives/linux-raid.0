From: NeilBrown <neilb@suse.de>
Subject: Re: [PATCH] mdadm: autodetect being run in an initramfs
Date: Fri, 28 Sep 2012 09:18:11 +1000
Message-ID: <20120928091811.7b7871e6@notabene.brown>
References: <1348756863-21081-1-git-send-email-dreisner@archlinux.org>
	<20120928083518.12d53ea8@notabene.brown>
	<20120927225302.GY474@rampage>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/rT3L+YFYcKKToE8jCiMAYW_"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120927225302.GY474@rampage>
Sender: linux-raid-owner@vger.kernel.org
To: Dave Reisner <d@falconindy.com>
Cc: Dave Reisner <dreisner@archlinux.org>, linux-raid@vger.kernel.org, teg@jklm.no
List-Id: linux-raid.ids

--Sig_/rT3L+YFYcKKToE8jCiMAYW_
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Sep 2012 18:53:02 -0400 Dave Reisner <d@falconindy.com> wrote:

> On Fri, Sep 28, 2012 at 08:35:18AM +1000, NeilBrown wrote:
> > On Thu, 27 Sep 2012 10:41:03 -0400 Dave Reisner <dreisner@archlinux.org>
> > wrote:
> >=20
> > > Key off of the existance of /etc/initrd-release as an indicator that
> > > mdadm is running in early userspace and set the __offroot flag. This
> > > allows the same udev-based assembly rules to be valid both off and on
> > > root and, moreover, will propagate to mdmon, should it need to be
> > > started.
> > >=20
> > > Signed-off-by: Dave Reisner <dreisner@archlinux.org>
> > > ---
> > >  mdadm.c | 5 +++++
> > >  1 file changed, 5 insertions(+)
> > >=20
> > > diff --git a/mdadm.c b/mdadm.c
> > > index 4c7c5ea..557e00b 100644
> > > --- a/mdadm.c
> > > +++ b/mdadm.c
> > > @@ -1106,6 +1106,11 @@ int main(int argc, char *argv[])
> > >  		exit(0);
> > >  	}
> > > =20
> > > +	/* auto-detect being on an initramfs
> > > +	 * http://www.freedesktop.org/wiki/Software/systemd/InitrdInterface=
 */
> > > +	if (access("/etc/initrd-release", F_OK) =3D=3D 0)
> > > +		__offroot =3D 1;
> > > +
> > >  	if (!mode && devs_found) {
> > >  		mode =3D MISC;
> > >  		devmode =3D 'Q';
> >=20
> > What is the problem with adding the --offroot flag to every place in the
> > initrd that starts mdadm?
>=20
> The assumption is that mdadm is being called via udev for assembly, so
> we'd need to maintain a separate udev rule explicitly for the initramfs.
> I'd rather not do that.

Then use --offroot for the 'standard' udev rules too.

>=20
> > (Actually I'm contemplating making --offroot the default so this might =
become
> > a non-issue)
>=20
> That'd be great!

Your support is noted - thanks :-)

NeilBrown

--Sig_/rT3L+YFYcKKToE8jCiMAYW_
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBUGTesznsnt1WYoG5AQI5fQ//d9wVuKNpSqRrld/iqSe7dtWe1r5EJQLf
/z3GK4f1NI+nbvPDJy/itzl3N8sSfwqWJCVynmFsIEuADdHwWVCuE1QxZHVuP62z
4+VR+7FHlb8M7rBxaqXpzsWoXSHSKbHNp52Mp3m6b9Jkgo2by2cp9+x2YXcvXwF+
nTrXBESD214LHxXcfYn0ppsQGXuOlK4LQ409lj8IfwfXKZZm6lVC6KgLoUxZOX5N
o2R3+H5tTm1paBWnyM7mcyX+DrdmbE3XR4DUEE3JPxf4DkHVhqJvzVCJXYnm6hBY
Y4rPby43ZjDC1WRlagKdVGQO0zlKYMIjLeXxtiyHs/ywRC4OSgW4wcG9X09dumPd
wwCyvDL/BYVVCYO8/scD/5XK98wjsDhRKr8C5rq5QmWIyYEyDU7kYb8hhOb4qb7Q
kE6LlizUdOC8Sz/H2ky8KzQTd+/F1nzdjoA+5LAx5+tE9UrUV9DUFmv7Qk5fAY5R
R7TaBlgUIeCk7aFd1rbUb+xV/4kZzEYuxPeyHa+T6z8cZ0GJq+wd7n8JBzJWfLbI
yuME/FsnPNOnL4dri41lqHFYAKaE953eGMPvsRIyY2uh9p11TGQdSrofU6mLySeJ
iSZs1GFIKz4ZNrHqRnXCz1jpwwmLau/ccuO5JbX/h0xuUuuqlz6ysyuHvVmuQNrC
KOwBwRBGJwg=
=iaq7
-----END PGP SIGNATURE-----

--Sig_/rT3L+YFYcKKToE8jCiMAYW_--
