From: Roman Mamedov <rm@romanrm.ru>
Subject: Re: vess raid stripes disappear
Date: Thu, 9 May 2013 21:10:16 +0600
Message-ID: <20130509211016.718dff41@natsu>
References: <CANSWD74J9HZCbE4ba1Y5UMRQjjDDZiof21-tUJOKdJmHBvuyXw@mail.gmail.com>
	<t7qs5axa4b.ln2@goaway.wombat.san-francisco.ca.us>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/Rjs6DRFpp9j1y3CBiSV9hqL"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <t7qs5axa4b.ln2@goaway.wombat.san-francisco.ca.us>
Sender: linux-raid-owner@vger.kernel.org
To: Keith Keller <kkeller@wombat.san-francisco.ca.us>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/Rjs6DRFpp9j1y3CBiSV9hqL
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Thu, 09 May 2013 07:59:41 -0700
Keith Keller <kkeller@wombat.san-francisco.ca.us> wrote:

> On 2013-05-09, mashtin.bakir@gmail.com <mashtin.bakir@gmail.com> wrote:
> > I have an interesting problem with a Vessraid 1830s.
>=20
> Is this a hardware RAID controller?  If so, you are probably looking for
> a different group.  This mailing list is specific to linux md software
> RAID.  You can try the comp.os.linux.misc newsgroup instead.

I (also) was under impression that linux-raid is not just for md, but for a=
ll
kinds of RAID in GNU/Linux. It's just that historically it's mostly about m=
d.

However the poster is highly unlikely to find anyone experienced with an
obscure h/w RAID controller here (I am almost willing to bet that majority =
of
the readers see the name "Vess RAID" for the first time in that very post).

My advice to them would be to switch the controller into a dumb SATA HBA mo=
de
if possible, and use the Linux Software RAID (indeed, md). Here are some
reasons why: http://linux.yyz.us/why-software-raid.html

--=20
With respect,
Roman

--Sig_/Rjs6DRFpp9j1y3CBiSV9hqL
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.12 (GNU/Linux)

iEYEARECAAYFAlGLvFgACgkQTLKSvz+PZwh9RgCgi2l2vaSO7aum7wB76wWyzMRc
5R8Ani1TVyRiPpCAJQCaIxSYwJq+eQ6K
=YcIG
-----END PGP SIGNATURE-----

--Sig_/Rjs6DRFpp9j1y3CBiSV9hqL--
