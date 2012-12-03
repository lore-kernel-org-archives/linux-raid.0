From: Pasi =?iso-8859-1?Q?K=E4rkk=E4inen?= <pasik@iki.fi>
Subject: Re: Checksumming RAID? / SCSI SAS T10 PI and DIF/DIX / T13 SATA EPP
Date: Mon, 3 Dec 2012 16:09:46 +0200
Message-ID: <20121203140946.GW8912@reaktio.net>
References: <14319197.21.1353936449959.JavaMail.root@zimbra>
 <20121203122444.GV8912@reaktio.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121203122444.GV8912@reaktio.net>
Sender: linux-raid-owner@vger.kernel.org
To: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Cc: Linux Raid <linux-raid@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-raid.ids

On Mon, Dec 03, 2012 at 02:24:45PM +0200, Pasi K=E4rkk=E4inen wrote:
> On Mon, Nov 26, 2012 at 02:27:30PM +0100, Roy Sigurd Karlsbakk wrote:
> > Hi all
> >=20
> > I see from an article at http://pages.cs.wisc.edu/~bpkroth/cs736/md=
-checksums/md-checksums-paper.pdf that an implementation has been made =
to allow for ZFS-like checksumming inside Linux MD. However, this code =
doesn't seem to exist in any kernel trees. Does anyone know the current=
 status for data checksumming in MD?
> >=20
>=20
> Afaik Linux md-raid raid0 and raid1 already supports T10 PI (Protecti=
on Information) and DIF (Data Integrity Fields) / DIX (Data Integrity E=
xtensions).
>=20
> I wonder if it'd be possible to utilize this mdadm code with normal d=
isks that don't have T10 PI support? ie. implement custom checksums in =
the "backend" with normal non-PI disks..
>=20
> T10 PI and DIF/DIX is a SCSI/SAS feature, so it's mostly available in=
 new(ish) enterprise SAS disks and it's not available in SATA.. but I t=
hink there are plans to implement something similar in SATA aswell in t=
he future.
>=20

Now I remember.. it's the SATA T13 "External Path Protection" (EPP).

(Added CC to Martin in the case he has some thoughts about generic Linu=
x checksumming RAID without T10 PI disks..)


-- Pasi


> A couple of SAS HBAs (mpt2sas, for example) and some FC HBAs support =
DIF/DIX in Linux.
>=20
> The purpose of DIF/DIX is to allow passing and verifying end-to-end c=
hecksums from all the way from the applications to the disks.. and prob=
ably in more common case that'd be checksums all the way from filesyste=
ms to the disks.
>=20
> Some more links about T10 PI and DIF/DIX:
> http://git.kernel.org/?p=3Dlinux/kernel/git/torvalds/linux.git;a=3Dbl=
ob_plain;f=3DDocumentation/block/data-integrity.txt;hb=3DHEAD
> https://oss.oracle.com/~mkp/docs/dix.pdf
> https://oss.oracle.com/~mkp/docs/osd2008-data-integrity.pdf
> https://oss.oracle.com/~mkp/docs/ols2008-petersen.pdf
> https://oss.oracle.com/~mkp/docs/ppdc.pdf
>=20
>=20
> -- Pasi
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
