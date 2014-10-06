From: Phil Turmel <philip@turmel.org>
Subject: Re: UEFI and mdadm questions.
Date: Mon, 06 Oct 2014 11:58:02 -0400
Message-ID: <5432BC0A.1030208@turmel.org>
References: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl> <E82F134B-634B-46B9-A835-846CA89728FB@colorremedies.com> <54318B86.7060506@turmel.org> <F14F7054-A1A1-4381-ADC8-B76952338589@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <F14F7054-A1A1-4381-ADC8-B76952338589@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Linux-RAID Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 10/05/2014 04:22 PM, Chris Murphy wrote:
>=20
> On Oct 5, 2014, at 2:18 PM, Phil Turmel <philip@turmel.org> wrote:

[trim /]

>> If your BIOS can be configured to try multiple boot images, it
>> should be possible to have true raid fallback without using
>> motherboard or hardware raid.  (Set up md raid1 with metadata v1.0
>> of multiple copies of the EFI FAT partition.)  I've been meaning to
>> try this=E2=80=A6.
>=20
> Problems with this: a.) new Windows 8 hardware might require you boot
> Windows to get to the feature enabling the firmware setup, because on
> such hardware USB isn't initialized by default.
> http://mjg59.dreamwidth.org/24869.html
>=20
> I don't know why we don't have free software to initiate this, but I
> haven't come across it so far.

Good to know, but totally immaterial to the boot sequence I'm
recommending.  Boot linux of of an EFI FAT and let linux initialize the
USB hardware in its own good time.

Matthew Garrett's post is really all about how to get linux into the
Win8 box in the first place.  Once there, manipulate the boot sequence
as you please.

> b.) There's no guarantee the firmware won't write to the ESP, thus
> rendering the individual md raid members out of sync and without
> their metadata being updated, i.e. in effect, the logical device they
> become later, is corrupt. Separately they aren't corrupt, merely out
> of sync, but you don't have an obvious way of knowing which one.

This is a very good point.  In fact, I withdraw my recommendation to
raid these partitions.  Simply have one on every disk the BIOS could
possibly boot from, and place an EFI bootable kernel in each one (with
embedded initramfs).

> c.) strictly speaking any partition with mdadm metadata should have
> the linux raid partition type GUID set; not the EFI System partition
> type GUID. Those GUIDs are mutually exclusive.

The former is not true at all--mdadm does not care *at all* what
partition types are set.  Grub might care, but it's moot if you don't
use Grub.  :-)

> This is why I'm still not a fan of using mdadm to raid1 an EFI System
> partition.

One further point:  the failure decision tree is nicer if you boot
directly into a kernel.

1) Bios locates and attempts to boot from 1st configured kernel image
2a) Corrupted image or other disk error blocks complete load of kernel
image--bios moves to next EFI choice (possibly on a different disk).
2b) Successful EFI kernel load, boot encounters missing/corrupt root
=46S--kernel drops to initramfs rescue shell

versus:

1) Bios locates and attempts to boot from 1st configured grub image
2a) Corrupted image or other disk error blocks complete load of
grub--bios moves to next EFI choice (possibly on a different disk).
2b) Successful EFI grub load, grub encounters corrupt config or grub
module--drop to grub shell
2c) Successful EFI grub load, kernel & initramfs load by grub, boot
encounters missing/corrupt root FS--kernel drops to initramfs rescue sh=
ell

I haven't had time to set it up yet, but the clear reduction in points
of failure is compelling.  Faster boot is just icing on the cake.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
