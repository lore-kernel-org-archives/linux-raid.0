From: Francis Moreau <francis.moro@gmail.com>
Subject: Re: UEFI and mdadm questions.
Date: Mon, 06 Oct 2014 10:43:57 +0200
Message-ID: <5432564D.8010806@gmail.com>
References: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl> <E82F134B-634B-46B9-A835-846CA89728FB@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <E82F134B-634B-46B9-A835-846CA89728FB@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Murphy <lists@colorremedies.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Hello Chris,

On 10/03/2014 07:04 AM, Chris Murphy wrote:
>=20
> On Oct 1, 2014, at 12:33 PM, "Wilson, Jonathan" <piercing_male@hotmai=
l.com> wrote:
>=20
>> From what I can tell with UEFI I need to set up a UEFI partition wit=
h a
>> FAT format.
>=20
> It's a particular kind of FAT, that's defined as EFI FAT, the idea be=
ing that if the originating FAT ever changes, EFI FAT won't.
>=20
>>
>> On my current BIOS system I have a Biosboot 1M, /boot Raid1 200M and=
 /
>> Raid 1 40G.
>>
>> Obviously Grub installs to the mbr, and then installs a bit into
>> Biosboot which can read raids, hence it can read and boot from /boot=
=2E
>=20
> BIOSboot applies to GPT disks on BIOS computers, not MBR. On MBR disk=
s, the GRUB stage1 code jumps to stage2 code in the MBR gap which is th=
e region between the MBR and the first partition's starting LBA.
>=20
>>
>> Further, from what I can tell, into the UEFI partition can go either=
 a
>> kernel & initramfs with UEFI support, or a "loader" that then loads =
the
>> kernel.
>=20
> No. An OSLoader is required, it's an EFI application. Its job is to l=
oad a kernel and initramfs. The kernel and initramfs could be on the ES=
P (EFI System partition) but this is fraught with limitations. The expe=
ctation is that the kernel and initramfs are on some other partition of=
 the same disk. Of course if you're using GRUB it doesn't care and will=
 find a kernel/initramfs off another disk also, or even off md raid.
>=20

I think the kernel can be compiled as an EFI application, therefore
OSLoader is not always required. The advantage of this is that you can
get rid of grub entirely (cool !). But the downside is that you can't
customize/edit the kernel command line at boot time.

> In the case of GRUB, it directly understands pretty much every filesy=
stem used on linux, so it can read kernel+initramfs from ext4, or ext4 =
on mdraid, or on LVM, or on Btrfs (including multiple devices).
>=20
>>
>> What I am unsure about are...=20
>>
>> 1)  Can the loader/kernel understand md raid? so the / can be in a b=
og
>> standard raid1 v1.2?
>=20
> If the EFI OSLoader is GRUB2, then yes.
>=20
>=20
>>
>> 2) I'm guessing I would no longer need the /boot as that would be
>> replaced by what ever was in the UEFI partition?
>=20
> The ESP isn't a replacement for /boot. But you can have a unified /bo=
ot and / on a single file system, and GRUB2 can boot from it, including=
 if that volume is on an md device. GRUB2 even boots off md raid6 (it's=
 sorta crazy and badass at the same time, but in my testing it does wor=
k with the BIOS being the limiting factor as to how many drives are rec=
ognized at this stage).
>=20
>=20
>=20
>>
>> 3) as my "/boot" is currently in a raid 1 my life is simple, should =
any
>> changes occur they are replicated to the drives I have set up as /bo=
ot
>> raid 1, and I installed the mbr portion of boot loader manually on e=
ach
>> disk and tested pulling one, and then booting from another.. it
>> worked :-)
>> So I would like to keep things, if not simple, at least less likely =
to
>> have problems because I forgot to install duplicates of the UEFI on =
all
>> the disks=85 so can I use a .90v raid1 on the UEFI partition,
>=20
> That solution isn't that simple because it requires too many things t=
hat aren't supported by any distribution. And also it increases the cha=
nces of corruption because of course the EFI firmware only sees these p=
artition/volumes as single devices, not as md devices that need to be a=
ssembled first into a logical device. Some EFI firmwares do reportedly =
write to the ESP, so if they write to one and not the other, while also=
 not changing the metadata on either partition, there's no way to know =
which one is valid now. So that's just a mess. And even if your firmwar=
e doesn't write to the ESP ever, what about dual boot? That too would b=
e proscribed because the ESP is shared among multiple OS's. So the idea=
 is just way off the rails of anything standardized or widely supported=
=2E Will it work? Yes. But do you want to support something this non-st=
andard?
>=20
> An alternative is a single static grub.cfg on the EFI System partitio=
n that points to the real grub.cfg on an mdraid1 / or /boot. Since the =
ESP's are identical, and never need updating again, this is much safer.=
 You can also dispense with this ridiculously bad idea most all linux d=
istros have right now of persistently mounting the ESP at /boot/efi (an=
d persistently mount it rw as well! really bad!).
>=20
> The way to do this is with the grub configfile command. The most stra=
ightforward way to do it is let grub-mkconfig create a grub.cfg for you=
, and then copy past the parts that tell GRUB how to find /. For exampl=
e it needs to know the mduuid so it knows there's an mdraid volume to a=
ssembled, and also the volume uuid so it knows what filesystem volume i=
t should find the file one, and then "configfile /boot/grub/grub.cfg" a=
nd it'll load that grub.cfg. And it's that grub.cfg that your system sh=
ould update - of course you have to figure out how your system knows to=
 update the grub.cfg so that it does it correctly without stepping on y=
our ESP grub.cfg (for one comment out the /boot/efi line in fstab and t=
hen unmount the ESP). This is distribution specific.
>=20
> Either way it's a bit complicated to figure out initially.
>=20

After thinking about it for a while, I'm not sure about the point of
having ESP mirrored or at least I'm not sure it really worths the
trouble: ESP and /boot are very static partitions and should be written
mostly during kernel upgrade. So even if something bad happens in those
partitions, the system should be able to run without any issues.

The annoying part is that if you decide/have to reboot and ESP is
damaged you won't be able to boot your system again. But that said if
you created initially a copy of /boot on each disk, you should be able
to boot again even though those copies are not uptodate.

Thanks.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
