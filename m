From: NeilBrown <neilb@suse.de>
Subject: Re: MD does not wait for drives on start-up with kernels 3.8+
Date: Wed, 24 Apr 2013 17:12:48 +1000
Message-ID: <20130424171248.235667a7@notabene.brown>
References: <20130330190538.4e3c1771@natsu>
	<CAGqmV7qmPHYpm1rinfsh5W-mgqo+Va2RvQtZoy-5AazYFAHYdg@mail.gmail.com>
	<20130415144530.183d7b31@natsu>
	<20130415203449.4d121b32@notabene.brown>
	<20130415191157.72b630c3@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/vwpc9DQo=O.O//N41hoUbC2"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20130415191157.72b630c3@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: CoolCold <coolthecold@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/vwpc9DQo=O.O//N41hoUbC2
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 15 Apr 2013 19:11:57 +0600 Roman Mamedov <rm@romanrm.ru> wrote:

> On Mon, 15 Apr 2013 20:34:49 +1000
> NeilBrown <neilb@suse.de> wrote:
>=20
> > > This was NOT required on any of the previous kernels, so I wonder why=
 all of
> > > sudden with the 3.8+ kernels my system needs an extra "crutch" just t=
o keep
> > > starting up properly.
> >=20
> > This is almost certainly not directly related to the kernel.  It seems =
clear
> > that some change in the kernel has resulted in the difference, but it is
> > probably indirect and really a bug elsewhere.
> >=20
> > What distro are you using?  Is systemd in use?
>=20
> Debian Testing, no systemd.
>=20

Can you try something for me?

Edit   /usr/share/initramfs-tools/scripts/local-top/mdadm

and just before the line:

  verbose && log_begin_msg "Assembling all MD arrays"

insert

  /sbin/udevadm settle

Then try booting without the 'rootdelay=3D10'.

If it doesn't (and the odds are at least even) then we have an awkward
situation.  The kernel is discovering devices asynchronously but it isn't
clear that there is any way to wait for it to "finish".

NeilBrown

--Sig_/vwpc9DQo=O.O//N41hoUbC2
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.19 (GNU/Linux)

iQIVAwUBUXeF8Dnsnt1WYoG5AQKFfRAAs+bjG2QI8L/xnkryWxQDSMwNlrqO4f4A
4/CC9NRYIteeOWcqyJ5e+e7HkJSoiK5LsprqkIFEdo0xAV9U05MLXQC32ayn6wtc
MMoV4wU/U3VqMasA9gTS+R+VCtvYt8oqW/H3TwvTNLt7nHDt2dljxZN4LIMQOJ3o
3iLQ1h0sogl6Po9bzF+to80S98+5ALI32wX1K1yAVHEcd2KO8uA2ZkpSqPRHYWI+
BaNTYsysfhW7k6f0EOVBtjjItuluc9/mRlVaJ3Up++YpCqttWiDJRtpqXoIFmw08
1rr9qyiR5JNp0O96Es3JZTMC5xuIqVcypXcijDgYrVHVpJ0Pe6Zn6bY4V2MrJBgD
NkocKb9tXlDPfHLGcGSBNPwCYrDxN0GZajiWeCgHyy9Z6O26muVYG21IH8csICaK
/yzjyHBLAJFK0G7gltG0/CEBTt/JTkOs3VCz/4ug4W0Mjl5uyOKUSbCgu83Aa1D7
9ZNw6q1YJ4H0ncjd5DjOBBhSIr/bYTyYSqx2bz93Bn0EN+CB5TQ3mTAVxzggEW1y
6JZZnsAH/kOB53/k8dMR1Vg9RxvwIXDU1QZc/E5JUea/ZGgyg3RRzKS5vGhvhH4V
NXLTvorVVQOJfzrocuwEEUAX4ky2+EDTb1+Q+18F1XygMLN65Dtu3++j/qfD8yvq
YcLvQDMrOto=
=hg4x
-----END PGP SIGNATURE-----

--Sig_/vwpc9DQo=O.O//N41hoUbC2--
