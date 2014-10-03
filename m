From: Chris Murphy <lists@colorremedies.com>
Subject: Re: UEFI and mdadm questions.
Date: Fri, 3 Oct 2014 01:04:05 -0400
Message-ID: <E82F134B-634B-46B9-A835-846CA89728FB@colorremedies.com>
References: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl>
Mime-Version: 1.0 (Mac OS X Mail 6.6 \(1510\))
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BLU436-SMTP10330CBEBC0CA1E27853BE498B80@phx.gbl>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


On Oct 1, 2014, at 12:33 PM, "Wilson, Jonathan" <piercing_male@hotmail.=
com> wrote:

> From what I can tell with UEFI I need to set up a UEFI partition with=
 a
> FAT format.

It's a particular kind of FAT, that's defined as EFI FAT, the idea bein=
g that if the originating FAT ever changes, EFI FAT won't.

>=20
> On my current BIOS system I have a Biosboot 1M, /boot Raid1 200M and =
/
> Raid 1 40G.
>=20
> Obviously Grub installs to the mbr, and then installs a bit into
> Biosboot which can read raids, hence it can read and boot from /boot.

BIOSboot applies to GPT disks on BIOS computers, not MBR. On MBR disks,=
 the GRUB stage1 code jumps to stage2 code in the MBR gap which is the =
region between the MBR and the first partition's starting LBA.

>=20
> Further, from what I can tell, into the UEFI partition can go either =
a
> kernel & initramfs with UEFI support, or a "loader" that then loads t=
he
> kernel.

No. An OSLoader is required, it's an EFI application. Its job is to loa=
d a kernel and initramfs. The kernel and initramfs could be on the ESP =
(EFI System partition) but this is fraught with limitations. The expect=
ation is that the kernel and initramfs are on some other partition of t=
he same disk. Of course if you're using GRUB it doesn't care and will f=
ind a kernel/initramfs off another disk also, or even off md raid.

In the case of GRUB, it directly understands pretty much every filesyst=
em used on linux, so it can read kernel+initramfs from ext4, or ext4 on=
 mdraid, or on LVM, or on Btrfs (including multiple devices).

>=20
> What I am unsure about are...=20
>=20
> 1)  Can the loader/kernel understand md raid? so the / can be in a bo=
g
> standard raid1 v1.2?

If the EFI OSLoader is GRUB2, then yes.


>=20
> 2) I'm guessing I would no longer need the /boot as that would be
> replaced by what ever was in the UEFI partition?

The ESP isn't a replacement for /boot. But you can have a unified /boot=
 and / on a single file system, and GRUB2 can boot from it, including i=
f that volume is on an md device. GRUB2 even boots off md raid6 (it's s=
orta crazy and badass at the same time, but in my testing it does work =
with the BIOS being the limiting factor as to how many drives are recog=
nized at this stage).



>=20
> 3) as my "/boot" is currently in a raid 1 my life is simple, should a=
ny
> changes occur they are replicated to the drives I have set up as /boo=
t
> raid 1, and I installed the mbr portion of boot loader manually on ea=
ch
> disk and tested pulling one, and then booting from another.. it
> worked :-)
> So I would like to keep things, if not simple, at least less likely t=
o
> have problems because I forgot to install duplicates of the UEFI on a=
ll
> the disks=85 so can I use a .90v raid1 on the UEFI partition,

That solution isn't that simple because it requires too many things tha=
t aren't supported by any distribution. And also it increases the chanc=
es of corruption because of course the EFI firmware only sees these par=
tition/volumes as single devices, not as md devices that need to be ass=
embled first into a logical device. Some EFI firmwares do reportedly wr=
ite to the ESP, so if they write to one and not the other, while also n=
ot changing the metadata on either partition, there's no way to know wh=
ich one is valid now. So that's just a mess. And even if your firmware =
doesn't write to the ESP ever, what about dual boot? That too would be =
proscribed because the ESP is shared among multiple OS's. So the idea i=
s just way off the rails of anything standardized or widely supported. =
Will it work? Yes. But do you want to support something this non-standa=
rd?

An alternative is a single static grub.cfg on the EFI System partition =
that points to the real grub.cfg on an mdraid1 / or /boot. Since the ES=
P's are identical, and never need updating again, this is much safer. Y=
ou can also dispense with this ridiculously bad idea most all linux dis=
tros have right now of persistently mounting the ESP at /boot/efi (and =
persistently mount it rw as well! really bad!).

The way to do this is with the grub configfile command. The most straig=
htforward way to do it is let grub-mkconfig create a grub.cfg for you, =
and then copy past the parts that tell GRUB how to find /. For example =
it needs to know the mduuid so it knows there's an mdraid volume to ass=
embled, and also the volume uuid so it knows what filesystem volume it =
should find the file one, and then "configfile /boot/grub/grub.cfg" and=
 it'll load that grub.cfg. And it's that grub.cfg that your system shou=
ld update - of course you have to figure out how your system knows to u=
pdate the grub.cfg so that it does it correctly without stepping on you=
r ESP grub.cfg (for one comment out the /boot/efi line in fstab and the=
n unmount the ESP). This is distribution specific.

Either way it's a bit complicated to figure out initially.


Chris Murphy

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
