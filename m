From: =?ISO-8859-1?Q?G=FCnther_J=2E?= Niederwimmer <gjn@gjn.priv.at>
Subject: Re: GPT Table broken on a Raid1
Date: Thu, 20 Sep 2012 13:05:54 +0200
Message-ID: <2627519.Y2VdWh5VBI@techz>
References: <4961154.0TR9MeFlIq@techz> <7577D4C6-344F-4AE6-BB6A-3B4F29D4CAA0@colorremedies.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7577D4C6-344F-4AE6-BB6A-3B4F29D4CAA0@colorremedies.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Am Mittwoch, 19. September 2012, 20:39:55 schrieb Chris Murphy:
> On Sep 19, 2012, at 5:03 AM, G=FCnther J. Niederwimmer wrote:
> > Hello,
> >=20
> > can any tell me, why the GPT Table is broken by a linux installatio=
n
>=20
> What format superblock? I will guess it's 1.0 which stores the superb=
lock at
> the end of the disk and may be stepping on the secondary GPT header. =
And
> then when you repair the GPT, you're wiping out part of the md superb=
lock
> so it breaks your RAID.
>=20
> It's confusing that the GPT table is created with diskpart, instead o=
f
> parted.

this is "normal" I install "windows 7" first ;). but the problem with t=
he=20
wrong GPT Table Message I have also on a Raid10 with "Intel Matrix Stor=
age"=20
and dmraid installation.

The Question is, work parted correct with Raid GPT Table?
--=20
mit freundlichen Gr=FC=DFen / best Regards.

  G=FCnther J. Niederwimmer
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
