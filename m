From: Andre Majorel <aym-xunil@teaser.fr>
Subject: Re: RAID1 root and swap and initrd
Date: Sat, 16 Dec 2006 22:05:17 +0100
Message-ID: <20061216210517.GB11400@aym.net2.nerim.net>
References: <20061215175630.GA11400@aym.net2.nerim.net> <Pine.LNX.4.64.0612151909210.27298@lion.drogon.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0612151909210.27298@lion.drogon.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2006-12-15 19:14 +0000, Gordon Henderson wrote:
> On Fri, 15 Dec 2006, Andre Majorel wrote:
>
> >Can you use RAID1 devices for your root and swap with a "straight"
> >kernel ? (i.e. without the need for initrd/initramfs.)
>=20
> Yes - but you need the md (and ide/scsi/sata) drivers compiled
> into your kernel, and make sure the parition types are 0xFD and
> trust the kernel auto-detection.
[...]
> >If that matters, the boot manager would be LILO and each MD device
> >would be assembled from "parallel" logical partitions.
>=20
> Lilo is fine. Even kernel auto-detection is fine for me.

Thanks Jurriaan and Gordon. I think I may still be f*cked,
however. The Lilo doc says you can't use raid-extra-boot=3Dmbr-only
if boot=3D does not point to a raid device. Which it doesn't because
in my setup, boot=3D/dev/sda.

Using boot=3D/dev/md5 would solve the raid-extra-boot issue but the
components of /dev/md5 are not primary partitions (/dev/sda5,
/dev/sdb5) so I don't think that would work.

I *could* run lilo once for each disk after tweaking boot=3D in
lilo.conf, or just supply a different -M option but I'm not sure.
The Lilo doc is not terribly enlightening. Not for me, anyway. :-)

> A nice little tip I learned from someone else on the list is to
> have your md devices named after the partition numbers. So:
>=20
> md1 is /dev/hda1 and /dev/hdc1
> md2 is /dev/hda2 and /dev/hdc2

That's an improvement on what I was doing. Just "renumbered" my
devices that way (mdadm --assemble /dev/md8 -U super-minor
/dev/sda8 /dev/sdb8 ...). Thanks.

--=20
Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
