From: Simon Valiquette <v.simon@ieee.org>
Subject: Re: nested raid possible?
Date: Fri, 06 Jul 2007 01:49:58 -0400
Message-ID: <468DD806.6070608@ieee.org>
References: <8585506.1183693119573.JavaMail.root@wombat.diezmil.com>
Reply-To: linux-raid@vger.kernel.org
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <8585506.1183693119573.JavaMail.root@wombat.diezmil.com>
Sender: linux-raid-owner@vger.kernel.org
To: turbo@weasel.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

turbo@weasel.com un jour =C3=A9crivit:
> I have a raid-5 array of six 250gb hard drives.
> I just bought four 500gb hard drives.
>=20
> I know I can take the six drives and make three raid-1 arrays of 500g=
b.

   Here, you probably means three RAID-0 arrays of 500GB, otherwise you=
=20
would get three RAID-1 of 250GB.

> After doing that, can I make a raid-5 array consisting of the three=20
> raid-0 arrays, and the four 500gb hard drives?

   Yes, It would works, because all you need is to get a block device.=20
Software Raid takes many block devices to generate one block device, so=
 It=20
is transparent.

   That said, I don't say that It is a good idea to do It as you are=20
suggesting.  You realize that It would be less reliable than a RAID-5=20
array made of seven 500GB drive.

   If you really want to do than, I would feel more confident using=20
RAID-6.   Another option is to use RAID-10 with 4x250GB with 2 hot spar=
e,=20
and connect everything in a RAID-5 array for a total of also 2.5TB of=20
usable space.  Personnaly, considering the price of the hard drives, I=20
won't ever bother and use only 500GB drive.

   That said, It is your data.  It is you that know if It is better to=20
have the full 3TB, at the cost of somewhat more risk to loose your data=
=2E=20
Maybe the additional risk is low enough for your needs, I don't know.

   But in a business environment, I would normaly not do It.

Simon Valiquette

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
