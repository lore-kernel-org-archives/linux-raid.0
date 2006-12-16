From: Andre Majorel <aym-xunil@teaser.fr>
Subject: Re: RAID1 root and swap and initrd
Date: Sun, 17 Dec 2006 00:01:16 +0100
Message-ID: <20061216230116.GC11400@aym.net2.nerim.net>
References: <20061215175630.GA11400@aym.net2.nerim.net> <Pine.LNX.4.64.0612151909210.27298@lion.drogon.net> <20061216210517.GB11400@aym.net2.nerim.net> <45846A43.8070207@tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <45846A43.8070207@tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Michael Tokarev <mjt@tls.msk.ru>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2006-12-17 00:50 +0300, Michael Tokarev wrote:
> Andre Majorel wrote:
> []
> > Thanks Jurriaan and Gordon. I think I may still be f*cked,
> > however. The Lilo doc says you can't use raid-extra-boot=3Dmbr-only
> > if boot=3D does not point to a raid device. Which it doesn't becaus=
e
> > in my setup, boot=3D/dev/sda.
> >=20
> > Using boot=3D/dev/md5 would solve the raid-extra-boot issue but the
> > components of /dev/md5 are not primary partitions (/dev/sda5,
> > /dev/sdb5) so I don't think that would work.
>=20
> So just move it to sda1 (or sda2, sda3) from sda5

Problem is, the disks are entirely used by an extended partition.
There's nowhere to move sd?5 to.

I think it's possible to turn the first logical partition into a
primary partition by modifying the partition table on the MBR but
I'm not sure I'm up for that.

--=20
Andr=E9 Majorel <URL:http://www.teaser.fr/~amajorel/>
Do not use this account for regular correspondence.
See the URL above for contact information.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
