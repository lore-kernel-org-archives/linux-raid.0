From: Ken Gunderson <kgunders@teamcool.net>
Subject: Re: non fs-data and gpt partitioned md
Date: Wed, 18 Apr 2012 19:02:21 -0600
Message-ID: <20120418190221.561b0df6.kgunders@teamcool.net>
References: <1334695210.6026.31.camel@hermes>
	<20120418181833.0581d8ba.kgunders@teamcool.net>
	<20120419103823.30ca2834@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120419103823.30ca2834@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, 19 Apr 2012 10:38:23 +1000
NeilBrown <neilb@suse.de> wrote:

> On Wed, 18 Apr 2012 18:18:33 -0600 Ken Gunderson
> <kgunders@teamcool.net> wrote:
>=20
> > On Tue, 17 Apr 2012 14:40:10 -0600
> > Ken Gunderson <kgunders@teamcool.net> wrote:
> >=20
> > Apologies for following my own post but I guess should elaborate...
> >=20
> > > Hello:
> > >=20
> > > I'm wanting to set up a new md root lvm based configuration and
> > > after reading various docs am confused about how I should be
> > > going about this. My intent is to have mirrored /boot and swap
> > > partitions and a raid10 / partition with LVM.
> > >=20
> > > Issue #1: gpt is recommended over mbr based partitioning for new
> > > installs, even on BIOS based systems (presuming these BIOS will
> > > boot gpt, wh/mine do). Auto-assemble is not recommended for new
> > > installations (my understanding is that it is not necessary with
> > > initramfs) so I presume I should be specifying partition type DA.
> > > However, while gdisk et.al. allow for selecting type FD, they do
> > > not offer DA as an option.
> >=20
> > Per <http://www.rodsbooks.com/linux-fs-code.html>, Linux ignores
> > partition type codes.  Yet per man mdadm:
> >=20
> > "When creating a partition based array,  using  mdadm  with
> > version-1.x metadata, the partition type should be set to 0xDA (non
> > fs-data).  This type selection allows for greater precision since
> > using any other [RAID auto-detect (0xFD) or a GNU/Linux partition
> > (0x83)], might create prob=E2=80=90 lems in the event of array reco=
very
> > through a live cdrom."
> >=20
> > So which is it?  Does partition type code matter to md/mdadm or not=
?
>=20
> Both.  Neither.=20
>=20
> md does handle 0xFD partitions a bit differently, but I recommend not
> using that feature.
> Other than that md igores them.  mdadm ingores them completely.
>=20
> But other tools - typically installers - might pay some attention to
> them. Using 0xDA discourages such tools from mishandling them.

Thanks for the clarification. =20
=20
> > > Issue #2: Is there any reason to prefer 1.0 vs. 1.2 metadata? I
> > > can use either grub2 or Syslinux boot loaders.  My understanding
> > > is that Syslinux supports the former while Grub2 supports 1.2.
> > > All other things being equal, I'd prefer to use Syslinux.  Unless
> > > there is some technical reason to favor 1.2 metadata and/or Grub2=
=2E
> > >=20
> > > So what would be best practices recommended way to proceed here?
> >=20
> > The reason I ask is that I bring such a configuration online on
> > Archlinux by following these instructions:
> >=20
> > <https://wiki.archlinux.org/index.php/Software_RAID_and_LVM>
> >=20
> > But I'll be damned if I can recover from failed drive simulations -
> > at least reliably, as sometimes it works while others not - so I'm
> > just trying to rule out potential variables here.
> >=20
> > Thanks-- Ken
> >=20
>=20
> Any reason for preferring one of 1.0 and 1.2 is out side of md.
>=20
> Maybe you want to be able to mount one half of a RAID1
> independently.  You need 1.0 for that.  Maybe you want to ensure that
> never happens.  Then 1.2 is better. Maybe your boot loaded only works
> with one.  Then the choice is clear.

Well, this only pertains to /boot partition, so there's nothing to stop
one from mixing and matching, e.g. Syslinux using 1.0 metadata for
RAID1 /boot and 1.2 metadata for RAID10 swap and root devices, no? Or
is this not advisable?

Thanks-- Ken

--=20
Ken Gunderson <kgunders@teamcool.net>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
