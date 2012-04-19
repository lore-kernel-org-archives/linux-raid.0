From: Ken Gunderson <kgunders@teamcool.net>
Subject: Re: non fs-data and gpt partitioned md
Date: Wed, 18 Apr 2012 18:18:33 -0600
Message-ID: <20120418181833.0581d8ba.kgunders@teamcool.net>
References: <1334695210.6026.31.camel@hermes>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1334695210.6026.31.camel@hermes>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 17 Apr 2012 14:40:10 -0600
Ken Gunderson <kgunders@teamcool.net> wrote:

Apologies for following my own post but I guess should elaborate...

> Hello:
>=20
> I'm wanting to set up a new md root lvm based configuration and after
> reading various docs am confused about how I should be going about
> this. My intent is to have mirrored /boot and swap partitions and a
> raid10 / partition with LVM.
>=20
> Issue #1: gpt is recommended over mbr based partitioning for new
> installs, even on BIOS based systems (presuming these BIOS will boot
> gpt, wh/mine do). Auto-assemble is not recommended for new
> installations (my understanding is that it is not necessary with
> initramfs) so I presume I should be specifying partition type DA.
> However, while gdisk et.al. allow for selecting type FD, they do not
> offer DA as an option.

Per <http://www.rodsbooks.com/linux-fs-code.html>, Linux ignores
partition type codes.  Yet per man mdadm:

"When creating a partition based array,  using  mdadm  with
version-1.x metadata, the partition type should be set to 0xDA (non
fs-data).  This type selection allows for greater precision since using
any other [RAID auto-detect (0xFD) or a GNU/Linux partition (0x83)],
might create prob=E2=80=90 lems in the event of array recovery through =
a live
cdrom."

So which is it?  Does partition type code matter to md/mdadm or not?
=20
> Issue #2: Is there any reason to prefer 1.0 vs. 1.2 metadata? I can
> use either grub2 or Syslinux boot loaders.  My understanding is that
> Syslinux supports the former while Grub2 supports 1.2. All other
> things being equal, I'd prefer to use Syslinux.  Unless there is some
> technical reason to favor 1.2 metadata and/or Grub2.
>=20
> So what would be best practices recommended way to proceed here?

The reason I ask is that I bring such a configuration online on
Archlinux by following these instructions:

<https://wiki.archlinux.org/index.php/Software_RAID_and_LVM>

But I'll be damned if I can recover from failed drive simulations - at
least reliably, as sometimes it works while others not - so I'm just
trying to rule out potential variables here.

Thanks-- Ken

--=20
Ken Gunderson <kgunders@teamcool.net>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
