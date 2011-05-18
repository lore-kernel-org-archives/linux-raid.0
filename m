From: Gavin Flower <gavinflower@yahoo.com>
Subject: Re: Best way to create RAID-6 for swap partition - existing one failed
Date: Wed, 18 May 2011 15:55:18 -0700 (PDT)
Message-ID: <584815.1435.qm@web65107.mail.ac2.yahoo.com>
References: <4DD4477B.3000704@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4DD4477B.3000704@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
List-Id: linux-raid.ids


--- On Thu, 19/5/11, Stan Hoeppner <stan@hardwarefreak.com> wrote:

> From: Stan Hoeppner <stan@hardwarefreak.com>
> Subject: Re: Best way to create RAID-6 for swap partition - existing =
one failed
> To: "Gavin Flower" <gavinflower@yahoo.com>
> Cc: linux-raid@vger.kernel.org, neilb@suse.de, mb@gem.win.co.nz
> Date: Thursday, 19 May, 2011, 10:26
> On 5/18/2011 3:42 PM, Gavin Flower
> wrote:
>=20
> > I just checked the man page for mkswap, it still
> recommends using a partition.
>=20
> Gavin, you know who Andrew Morton is, yes?=A0 His
> opinion on the subject:
>=20
> http://lkml.org/lkml/2005/7/7/326
>=20
> Don't know about you, but I think I'll trust Morton's
> opinion on this
> more than the writer of the mkswap man page.=A0 BTW, the
> similarities
> between what I wrote earlier and Morton's comments in the
> lkml thread
> above are not coincidental. ;)
>=20
> --=20
> Stan
>=20

Andrew Morton is God's 2nd in command.  :-)
He took over from Alan Cox.

Seeing how all too frequently I have problems recovering from hibernati=
on due to the video driver crashing, and my system can at least start w=
ithout swap (I have 8GB) - I think will implement the file idea next ti=
me I do a major O/S upgrade.

Currently my options seems to be to either continue with my RAID-6 swap=
 partition (which I have done) or to use a file within another RAID-6 p=
artition.

I now have a policy of trying to spend more time understanding why I sh=
ould do things a particular way, rather than simply following recipes b=
lindly. partly because I am a geek, and partly it might be useful profe=
ssionally.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
