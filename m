From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: raid1 or raid10 for /boot
Date: Wed, 6 Feb 2008 23:43:03 +0100
Message-ID: <20080206224303.GG15772@rap.rap.dk>
References: <20080204063454.GA31046@rap.rap.dk> <47AA01DB.8080706@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <47AA01DB.8080706@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Feb 06, 2008 at 01:52:11PM -0500, Bill Davidsen wrote:
> Keld J=F8rn Simonsen wrote:
> >I understand that lilo and grub only can boot partitions that look l=
ike
> >a normal single-drive partition. And then I understand that a plain
> >raid10 has a layout which is equivalent to raid1. Can such a raid10
> >partition be used with grub or lilo for booting?
> >And would there be any advantages in this, for example better disk
> >utilization in the raid10 driver compared with raid?
> > =20
>=20
> I don't know about you, but my /boot goes with zero use between boots=
,=20
> efficiency and performance improvements strike as a distinction witho=
ut=20
> a difference, while adding complexity without benefit is always a bad=
 idea.
>=20
> I suggest that you avoid having a "learning experience" and stick wit=
h=20
> raid1.

I agree with you, it was only a theoretical question.

Best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
