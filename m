From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid1 or raid10 for /boot
Date: Mon, 4 Feb 2008 12:21:40 +0100
Message-ID: <20080204112140.GB20876@rap.rap.dk>
References: <20080204063454.GA31046@rap.rap.dk> <20080204091735.GA30156@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20080204091735.GA30156@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 04, 2008 at 09:17:35AM +0000, Robin Hill wrote:
> On Mon Feb 04, 2008 at 07:34:54AM +0100, Keld J=F8rn Simonsen wrote:
>=20
> > I understand that lilo and grub only can boot partitions that look =
like
> > a normal single-drive partition. And then I understand that a plain
> > raid10 has a layout which is equivalent to raid1. Can such a raid10
> > partition be used with grub or lilo for booting?
> > And would there be any advantages in this, for example better disk
> > utilization in the raid10 driver compared with raid?
> >=20
> A plain RAID-10 does _not_ have a layout equivalent to RAID-1 and
> _cannot_ be used for booting (well, possibly a 2-disk RAID-10 could -
> I'm not sure how that'd be layed out).  RAID-10 uses striping as well=
 as
> mirroring, and the striping breaks both grub and lilo (and, AFAIK, ev=
ery
> other boot manager currently out there).

Yes, it is understood that raid10,f2 uses striping, but a raid10,near=3D=
2,
far=3D1 does not use striping, anfd this is what you get if you just ma=
ke
a    mdadm --create /dev/md0 -l 10 -n 2 /dev/sda1 /dev/sdb1

best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
