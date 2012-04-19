From: NeilBrown <neilb@suse.de>
Subject: Re: non fs-data and gpt partitioned md
Date: Thu, 19 Apr 2012 10:38:23 +1000
Message-ID: <20120419103823.30ca2834@notabene.brown>
References: <1334695210.6026.31.camel@hermes>
	<20120418181833.0581d8ba.kgunders@teamcool.net>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/_j+s=VelxY/z4Lr0iuCmvFj"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120418181833.0581d8ba.kgunders@teamcool.net>
Sender: linux-raid-owner@vger.kernel.org
To: Ken Gunderson <kgunders@teamcool.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

--Sig_/_j+s=VelxY/z4Lr0iuCmvFj
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Wed, 18 Apr 2012 18:18:33 -0600 Ken Gunderson <kgunders@teamcool.net>
wrote:

> On Tue, 17 Apr 2012 14:40:10 -0600
> Ken Gunderson <kgunders@teamcool.net> wrote:
>=20
> Apologies for following my own post but I guess should elaborate...
>=20
> > Hello:
> >=20
> > I'm wanting to set up a new md root lvm based configuration and after
> > reading various docs am confused about how I should be going about
> > this. My intent is to have mirrored /boot and swap partitions and a
> > raid10 / partition with LVM.
> >=20
> > Issue #1: gpt is recommended over mbr based partitioning for new
> > installs, even on BIOS based systems (presuming these BIOS will boot
> > gpt, wh/mine do). Auto-assemble is not recommended for new
> > installations (my understanding is that it is not necessary with
> > initramfs) so I presume I should be specifying partition type DA.
> > However, while gdisk et.al. allow for selecting type FD, they do not
> > offer DA as an option.
>=20
> Per <http://www.rodsbooks.com/linux-fs-code.html>, Linux ignores
> partition type codes.  Yet per man mdadm:
>=20
> "When creating a partition based array,  using  mdadm  with
> version-1.x metadata, the partition type should be set to 0xDA (non
> fs-data).  This type selection allows for greater precision since using
> any other [RAID auto-detect (0xFD) or a GNU/Linux partition (0x83)],
> might create prob=E2=80=90 lems in the event of array recovery through a =
live
> cdrom."
>=20
> So which is it?  Does partition type code matter to md/mdadm or not?

Both.  Neither.=20

md does handle 0xFD partitions a bit differently, but I recommend not using
that feature.
Other than that md igores them.  mdadm ingores them completely.

But other tools - typically installers - might pay some attention to them.
Using 0xDA discourages such tools from mishandling them.

> =20
> > Issue #2: Is there any reason to prefer 1.0 vs. 1.2 metadata? I can
> > use either grub2 or Syslinux boot loaders.  My understanding is that
> > Syslinux supports the former while Grub2 supports 1.2. All other
> > things being equal, I'd prefer to use Syslinux.  Unless there is some
> > technical reason to favor 1.2 metadata and/or Grub2.
> >=20
> > So what would be best practices recommended way to proceed here?
>=20
> The reason I ask is that I bring such a configuration online on
> Archlinux by following these instructions:
>=20
> <https://wiki.archlinux.org/index.php/Software_RAID_and_LVM>
>=20
> But I'll be damned if I can recover from failed drive simulations - at
> least reliably, as sometimes it works while others not - so I'm just
> trying to rule out potential variables here.
>=20
> Thanks-- Ken
>=20

Any reason for preferring one of 1.0 and 1.2 is out side of md.

Maybe you want to be able to mount one half of a RAID1 independently.  You
need 1.0 for that.  Maybe you want to ensure that never happens.  Then 1.2 =
is
better. Maybe your boot loaded only works with one.  Then the choice is cle=
ar.

NeilBrown


--Sig_/_j+s=VelxY/z4Lr0iuCmvFj
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.18 (GNU/Linux)

iQIVAwUBT49efznsnt1WYoG5AQLZRRAAoXke0BICV9BdtqUxjyWbehfrY+R7latS
KWIVG3ItYPWFbNEiNsEmB/jcvTXaOqB01Vg4DDw0JJVMGh8EmF/XKA50ggs+K4AF
g1bfmj/Kd7Vh+gV8+emS80EOCesON7hJG1jb7hCwMbFN20JNbhk8vSG8/tGqjl1W
oYq8jEgm66kuTIEe/mTseE7qw7w1N3ke1dpzFbvmCL99NfAxXD/K1Op2CFNUq2Bi
cOeAl2LKVh5Ri2v0NPsDkLnm4BvZxErqgcYqcUj3VCIzAxL1/emxFFi2EcPe2Q8y
KJO1ORDGzSUIeNI7SylsHY9ITQODmOaO/GQbvfIR2X/pFJTLxTETHBHe4wdwfHne
L8dWS4eImxidk+SUqsoYih4BdSeekM1b/cZaKMsLBWcnFc54c/z78Lg4/hQCd6cJ
Z/rqYC9LVmtlR9dpppDaCrooOgzbKkWssm5bnjo9W4qENnZrjz3OZhciXHEIS0Hn
iz7UMJBc5qNiRoBPJ7VoWb2adtTrwDa8eoUWXU0ZSHHf/QWIrcaqnbp5WJVzzP9+
XWZFi1cTSPfGBosZWxVJGtojXRuUoajZhWOqOyVV7nnNv8N7IVP2u4XjO+6xR4fM
igmrZOiV0qYn1LaoHnZo2u15NTNNFBcPOd3hkkytfJxQv5wMzBNpZj71WY6nWrl5
i6L3omNgMj4=
=uWEx
-----END PGP SIGNATURE-----

--Sig_/_j+s=VelxY/z4Lr0iuCmvFj--
