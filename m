From: NeilBrown <neilb@suse.de>
Subject: Re: md-raid paranoia mode?
Date: Thu, 12 Jun 2014 16:45:07 +1000
Message-ID: <20140612164507.3af9fe1d@notabene.brown>
References: <5397FBCE.3060009@bartk.us>
	<53990D44.300@fnarfbargle.com>
	<20140612122814.2db74377@natsu>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/yK5jnZDGvD4S3lAw_7JkC02"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140612122814.2db74377@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>
Cc: Brad Campbell <lists2009@fnarfbargle.com>, Bart Kus <me@bartk.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/yK5jnZDGvD4S3lAw_7JkC02
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jun 2014 12:28:14 +0600 Roman Mamedov <rm@romanrm.net> wrote:

> On Thu, 12 Jun 2014 10:15:32 +0800
> Brad Campbell <lists2009@fnarfbargle.com> wrote:
>=20
> > On 11/06/14 14:48, Bart Kus wrote:
> > > Hello,
> > >
> > > As far as I understand, md-raid relies on the underlying devices to
> > > inform it of IO errors before it'll seek redundant/parity data to
> > > fulfill the read request.  I have, however, seen certain hard drives
> > > report successful reads while returning garbage data.
> >=20
> > If you have drives that return garbage as valid data then you have far=
=20
> > greater problems than what you are suggesting will fix. So much so I=20
> > suggest you document these instances and start banging a drum announcin=
g=20
> > them in a name and shame campaign. That sort of behavior from storage=20
> > devices is never ok, and the manufacturer needs to know that.
>=20
> If your RAM can return garbage, that's not a justification for having ECC=
 RAM.
> ECC RAM is a gimmick invented by weak conformist people. Instead, you sho=
uld go
> and loudly scream at the manufacturer who sold you that RAM! Errors from =
RAM
> are never OK! RAM should always work perfectly! And if it doesn't, you ha=
ve
> greater problems. We shall not tolerate this behavior! So go get a drum a=
nd
> start banging it as loudly as you can! Name and shame the manufacturer who
> sold you that RAM. Fight the power, brother!!!

Your screwdriver is leaking  (*).

Hard drives contain ECC.  It should ensure undetected errors are an
*extremely* rare event (more rare than bugs in the md code).

If your ECC RAM started returning bad data without telling you, would you
build a complex virtual memory system to load every byte from two different
DIMMs into CPU registers and compare them before trusting them?

I know that hard drives can return bad data.  I've seen it happen.  I don't
think that trying to "fix" it in the md/raid layer is appropriate.

File-systems and higher level data management systems (e.g. git) are much
better placed to detect such errors than md/raid is.  Supposedly btrfs will
DTRT with your drives (though TRT is to RMA them, and I don't think btrfs
has an RMA plugin yet).

>=20
> You can probably tell just how sick I am of reasoning like yours. That's =
why
> we can't have nice things (md-side resiliency for the cases when you need=
/want
> it), and sadly Neil is of the same opinion as you.
>=20

In general, if you want nice things you need to pay for them.  If you are
willing to pay I suspect you can find someone who is willing to provide.

NeilBrown

(*)http://www.zazzle.com/a_bad_analogy_is_like_a_leaky_screwdriver_tshirts-=
235102919981826183

--Sig_/yK5jnZDGvD4S3lAw_7JkC02
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)

iQIVAwUBU5lMcznsnt1WYoG5AQJCGg/+KpmgxJfez7PES3Oe8Grj4Rn0Mc+KuZdi
jF4p2Ly6K3eDV0xcLwqAUCRoF5t1zCvuKki9JxmJOyC8YtvlXH9Z87PYZnzyvPy3
l9MtNrmkdVmTE7LNawuHRhevtz/lZyAN2dCRY4gvryKK38KZaUyKk5hVHIy8nU82
qDvNkiyJI56COL52gKv7duR6lfgUufkTRRsUXESU0VZX9/nFoRCqTSlQQDaHgIIh
vGqbBS1jv03umIUvHJSl/Ifbgs+zCzkM1L99wtzuNZ8LWg61l9F7n1fCMHIf15Ie
T/0xO/onq+l+9T7Q2siggwLtvBV+O/pT4l/RbpAQBIq8/OS17+cJtyXNPX791s5G
C2hZkJUPGYiqe/n0zLSgOU+Vr9ITtam7JgMoMbIlwdtiYVBqgEmjqxBkSrGxV1Kk
/omI9gXHztLeCl8Zlu3+IpujfJx+RVWx1lWE78YOCjFa4EVUlBivo/2rzKf/GZWi
b79ymNDsbsYXwdC+iKYUdPW7Rqjpiob2F1yXf+4UQaVFwj+OKUMMcYsUsWzOMyJV
nn+MJY0HPde5Pv7i8RxPLV8xzX8VKmpeO96GEnAXYHnS2ZZ7mx2FAIESucKmA7f8
mGiuZ9SQYfsoHHBHkZNKnC/vtZ35vGVZ5xw4llfZ+2cfpxkHzyTbKaJmbwiv7QjY
/MABMGcaX8s=
=PruA
-----END PGP SIGNATURE-----

--Sig_/yK5jnZDGvD4S3lAw_7JkC02--
