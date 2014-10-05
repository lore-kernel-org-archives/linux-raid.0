From: Chris Murphy <lists@colorremedies.com>
Subject: Re: UEFI and mdadm questions.
Date: Sun, 5 Oct 2014 16:22:59 -0400
Message-ID: <F14F7054-A1A1-4381-ADC8-B76952338589@colorremedies.com>
References: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl> <E82F134B-634B-46B9-A835-846CA89728FB@colorremedies.com> <54318B86.7060506@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54318B86.7060506@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 5, 2014, at 2:18 PM, Phil Turmel <philip@turmel.org> wrote:

> On 10/03/2014 01:04 AM, Chris Murphy wrote:
>>=20
>> No. An OSLoader is required, it's an EFI application. Its job is to
>> load a kernel and initramfs. The kernel and initramfs could be on th=
e
>> ESP (EFI System partition) but this is fraught with limitations. The
>> expectation is that the kernel and initramfs are on some other
>> partition of the same disk. Of course if you're using GRUB it doesn'=
t
>> care and will find a kernel/initramfs off another disk also, or even
>> off md raid.
>=20
> An option to consider is to compile a kernel using the EFI stub optio=
n,
> a pre-set command line, and an embedded initramfs.  Then the kernel c=
an
> boot directly from the EFI FAT partition with *no bootloader*.  The
> embedded initramfs can support any raid/lvm/partitioning scheme
> what-so-ever.

Sure but then it means the kernel+initramfs is on FAT32. Ick. And there=
's no advantage if using maintstream storage options like md raid, lvm,=
 btrfs, xfs, ext234, reiserfs, ufs, zfs, hfs+, ntfs and more, because G=
RUB2 already understands these things so the kernel can be located on t=
hem.

=46or appliances, there could be some advantage since there'd only be o=
ne kernel present at a time, no fallback necessary. My Android phone, f=
or example, has 35 partitions.

>=20
> If your BIOS can be configured to try multiple boot images, it should=
 be
> possible to have true raid fallback without using motherboard or
> hardware raid.  (Set up md raid1 with metadata v1.0 of multiple copie=
s
> of the EFI FAT partition.)  I've been meaning to try this=85.

Problems with this: a.) new Windows 8 hardware might require you boot W=
indows to get to the feature enabling the firmware setup, because on su=
ch hardware USB isn't initialized by default.
http://mjg59.dreamwidth.org/24869.html

I don't know why we don't have free software to initiate this, but I ha=
ven't come across it so far.

b.) There's no guarantee the firmware won't write to the ESP, thus rend=
ering the individual md raid members out of sync and without their meta=
data being updated, i.e. in effect, the logical device they become late=
r, is corrupt. Separately they aren't corrupt, merely out of sync, but =
you don't have an obvious way of knowing which one.

c.) strictly speaking any partition with mdadm metadata should have the=
 linux raid partition type GUID set; not the EFI System partition type =
GUID. Those GUIDs are mutually exclusive.

This is why I'm still not a fan of using mdadm to raid1 an EFI System p=
artition.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
