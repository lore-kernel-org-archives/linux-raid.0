From: NeilBrown <neilb@suse.de>
Subject: Re: Metadata > 0.90 and auto-assemble
Date: Mon, 23 Feb 2015 11:17:18 +1100
Message-ID: <20150223111718.34cd5d30@notabene.brown>
References: <54EA25D3.8020300@gentoo.org>
	<CAJCQCtSPPm3ipb49SCeNFvgQ21y4HseqovBPg28LKXzvP5PY8Q@mail.gmail.com>
	<54EA5004.3090104@gentoo.org>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/PnSut_QeW3ozNHetCjuPTue"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54EA5004.3090104@gentoo.org>
Sender: linux-raid-owner@vger.kernel.org
To: Joshua Kinard <kumba@gentoo.org>
Cc: Chris Murphy <lists@colorremedies.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/PnSut_QeW3ozNHetCjuPTue
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Sun, 22 Feb 2015 16:54:12 -0500 Joshua Kinard <kumba@gentoo.org> wrote:

> On 02/22/2015 16:29, Chris Murphy wrote:
> > On Sun, Feb 22, 2015 at 11:54 AM, Joshua Kinard <kumba@gentoo.org> wrot=
e:
> >> I'd like to
> >> avoid this if possible, as I haven't had to use an initramfs for norma=
l booting
> >> in the past, as long as I stay on metadata 0.90.  So I thought I'd ask=
 what the
> >> official stance is on this.
> >=20
> > https://raid.wiki.kernel.org/index.php/Autodetect
> >=20
> > Official stance is that it's deprecated, but people still use it.
>=20
> Yeah, but it's a pretty useful feature.  I can't see why autodetect for s=
imple
> setups (several disks or partitions and building a basic array out of the=
m) is
> maintained, while userspace autodetect is required for the more complex s=
etups.

The in-kernel autodetect is only maintained because tearing it out and
throwing it away (my preferred option) would be a user-visible regression,
and those are not permitted.

The user-space version is more general and more flexible.  If the
kernel-space version works for you, you can keep using it.  But if you want
features added to it, you are out of luck.

As others have said, creating a simple initrd is really not that hard.  Once
you spend the time to make it work, you will find that it "just works" and
wonder why you ever cared before.

There is even a README.initramfs in the mdadm source.  It was written 10
years ago so I cannot promise it is 100% correct, but it is a reasonably go=
od
and very simple starting point.

NeilBrown


>=20
> But I suppose this has been discussed before in detail, though I cannot f=
ind
> said discussion.  The RAID Boot page has this one example only:
>=20
> "This approach can cause problems in several situations (imagine moving p=
art of
> an old array onto another machine before wiping and repurposing it: reboo=
t and
> watch in horror as the piece of dead array gets assembled as part of the
> running RAID array, ruining it); kernel autodetect is correspondingly dep=
recated."
>=20
> Which I find to be rather unconvincing.  The cited example is a fault of =
the
> user not torching the superblock before moving the disks or trying to use
> them...and I've done this to myself on several occasions.  mdadm --misc
> --zero-superblock and 'dd' saved the day in less than ~30s.
>=20
> Are there any other discussions that might be more convincing, or offer up
> other points of view?  Perhaps there's a point I've yet to consider that =
might
> be enlightening.
>=20
> Thanks!,
>=20


--Sig_/PnSut_QeW3ozNHetCjuPTue
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVOpxjjnsnt1WYoG5AQIXFA/5AZ4C9HPrITmpD0TEjZCVWQ5eCaWqCPix
cVM11h97KF+ncVAhP9hstH/07J+dOW8KerzmRutdmeOz3DEy/5dhx+e5dnjuyRBj
8lX2xduVXqGVEUy62Pdbl99fcgR5CDM9qsjGEkkZpGmR6fvXov4zBfJgEx9rYoa2
DJJN2nReM9qBBES3fdL2xwU7owTCq58QSk9KBwj3opm6kPW1pTom6x+L6Na4RzYB
dh0d37ouVE9zDgtxfyooY9iFZ4PpDoawu6Y0H40I3COxQD0Bx/gmPYaz93kZ76UZ
6q3wq+EJOaYTCxUTK1JTlqMV2egm/8+JVOgymoj/kMsck1C1AFjETGK9OuAVsBQj
fZseDVbC8gvAtJqr3jQut2t6vVIokBfMhtjsv0ogvjbMnO60wLSVeCNc8/eHUuCl
q7N5Q+3GJEBxqh2qBwjJChv3Yb6qS4+pIbNABxhAzj5uLYDfwch5NDipJzYwebfU
V54051nrk5IFEVPtm6jP95XhrnP+d7aYq/I0TSYcuAqOSC21f/Aom63qiQrSVnk0
dugh/SrYJvR5OsKdZV+UrGduefDeBhUHPrY5OuxJ4S4dl+060aqyJ4k0uI5Ij+Qp
R6ZDHm4JHJNX15CHgYBNBBs3nwjuUToAOY+3NG4+hoR4+vG76WgE5HFgbJdnEkDL
DxjCBJuPoVQ=
=l4HY
-----END PGP SIGNATURE-----

--Sig_/PnSut_QeW3ozNHetCjuPTue--
