From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: raid1 or raid10 for /boot
Date: Wed, 06 Feb 2008 13:52:11 -0500
Message-ID: <47AA01DB.8080706@tmr.com>
References: <20080204063454.GA31046@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20080204063454.GA31046@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Keld_J=F8rn_Simonsen?= <keld@dkuug.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Keld J=F8rn Simonsen wrote:
> I understand that lilo and grub only can boot partitions that look li=
ke
> a normal single-drive partition. And then I understand that a plain
> raid10 has a layout which is equivalent to raid1. Can such a raid10
> partition be used with grub or lilo for booting?
> And would there be any advantages in this, for example better disk
> utilization in the raid10 driver compared with raid?
>  =20

I don't know about you, but my /boot goes with zero use between boots,=20
efficiency and performance improvements strike as a distinction without=
=20
a difference, while adding complexity without benefit is always a bad i=
dea.

I suggest that you avoid having a "learning experience" and stick with=20
raid1.

--=20
Bill Davidsen <davidsen@tmr.com>
  "Woe unto the statesman who makes war without a reason that will stil=
l
  be valid when the war is over..." Otto von Bismark=20



-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
