From: Chris Murphy <lists@colorremedies.com>
Subject: Re: UEFI and mdadm questions.
Date: Tue, 7 Oct 2014 18:59:51 -0400
Message-ID: <6AC2A70C-5777-4CE1-8187-5B3D069AE79B@colorremedies.com>
References: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl> <E82F134B-634B-46B9-A835-846CA89728FB@colorremedies.com> <54318B86.7060506@turmel.org> <F14F7054-A1A1-4381-ADC8-B76952338589@colorremedies.com> <5432BC0A.1030208@turmel.org>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5432BC0A.1030208@turmel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 6, 2014, at 11:58 AM, Phil Turmel <philip@turmel.org> wrote:

> On 10/05/2014 04:22 PM, Chris Murphy wrote:
>>=20
>> On Oct 5, 2014, at 2:18 PM, Phil Turmel <philip@turmel.org> wrote:
>=20
> [trim /]
>=20
>>> If your BIOS can be configured to try multiple boot images, it
>>> should be possible to have true raid fallback without using
>>> motherboard or hardware raid.  (Set up md raid1 with metadata v1.0
>>> of multiple copies of the EFI FAT partition.)  I've been meaning to
>>> try this=85.
>>=20
>> Problems with this: a.) new Windows 8 hardware might require you boo=
t
>> Windows to get to the feature enabling the firmware setup, because o=
n
>> such hardware USB isn't initialized by default.
>> http://mjg59.dreamwidth.org/24869.html
>>=20
>> I don't know why we don't have free software to initiate this, but I
>> haven't come across it so far.
>=20
> Good to know, but totally immaterial to the boot sequence I'm
> recommending.  Boot linux of of an EFI FAT and let linux initialize t=
he
> USB hardware in its own good time.

Sure but it means that you can't use the firmware's boot manager to cho=
ose anything else. Any other kernel (or copy) only happens in the cours=
e of the firmware's fallback mechanisms.

>=20
> Matthew Garrett's post is really all about how to get linux into the
> Win8 box in the first place.  Once there, manipulate the boot sequenc=
e
> as you please.
>=20
>> b.) There's no guarantee the firmware won't write to the ESP, thus
>> rendering the individual md raid members out of sync and without
>> their metadata being updated, i.e. in effect, the logical device the=
y
>> become later, is corrupt. Separately they aren't corrupt, merely out
>> of sync, but you don't have an obvious way of knowing which one.
>=20
> This is a very good point.  In fact, I withdraw my recommendation to
> raid these partitions.  Simply have one on every disk the BIOS could
> possibly boot from, and place an EFI bootable kernel in each one (wit=
h
> embedded initramfs).

Well, to me that seems more esoteric than just having kernel+initramfs =
on a conventional md raid1 /boot volume, and having a static (never upg=
raded or modified) GRUB2 or syslinux point to the modifiable configurat=
ion file (basically load a 2nd config file) in the usual location also =
on /boot. So now kernel upgrades are normal, and the user gets to regre=
ss to older kernels on demand should it be necessary and they also get =
resilient boot.

>=20
>> c.) strictly speaking any partition with mdadm metadata should have
>> the linux raid partition type GUID set; not the EFI System partition
>> type GUID. Those GUIDs are mutually exclusive.
>=20
> The former is not true at all--mdadm does not care *at all* what
> partition types are set.  Grub might care, but it's moot if you don't
> use Grub.  :-)

The partition type isn't for mdadm, it's for other things that might ot=
herwise modify the partition if it's misidentified as an EFI System par=
tition. And it would be a misidentification to set the partition type G=
UID to EFI System partition, because first this example partition is an=
 md member, and only after assembly is it an EFI system partition. So I=
 still consider them mutually exclusive.

>=20
>> This is why I'm still not a fan of using mdadm to raid1 an EFI Syste=
m
>> partition.
>=20
> One further point:  the failure decision tree is nicer if you boot
> directly into a kernel.
>=20
> 1) Bios locates and attempts to boot from 1st configured kernel image
> 2a) Corrupted image or other disk error blocks complete load of kerne=
l
> image--bios moves to next EFI choice (possibly on a different disk).
> 2b) Successful EFI kernel load, boot encounters missing/corrupt root
> FS--kernel drops to initramfs rescue shell
>=20
> versus:
>=20
> 1) Bios locates and attempts to boot from 1st configured grub image
> 2a) Corrupted image or other disk error blocks complete load of
> grub--bios moves to next EFI choice (possibly on a different disk).
> 2b) Successful EFI grub load, grub encounters corrupt config or grub
> module--drop to grub shell
> 2c) Successful EFI grub load, kernel & initramfs load by grub, boot
> encounters missing/corrupt root FS--kernel drops to initramfs rescue =
shell
>=20
> I haven't had time to set it up yet, but the clear reduction in point=
s
> of failure is compelling.  Faster boot is just icing on the cake.

But we have a lot of experience with the latter, as that's how it's alw=
ays been on BIOS systems. In a way it's more complicated because BIOS i=
tself didn't really have a meaningful (or complicated) fallback mechani=
sm, that was just up to the boot manager which we (FOSS) control. But w=
ith UEFI we don't control this, so exactly how the firmware behaves in =
failure cases actually needs to be tested on a firmware by firmware bas=
is.

The other thing is this arrangement isn't supported by any distro curre=
ntly. So setting it up and maintaining is pretty cumbersome.


Chris Murphy--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
