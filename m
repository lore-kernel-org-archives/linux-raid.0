From: Mathias Mueller <raidfail@gmx.de>
Subject: Re: broken raid level 5 array caused by user error
Date: Fri, 22 Jan 2016 10:30:53 +0100
Message-ID: <34ad7f74bc9fdc37aab022054d8d856e@pingofdeath.de>
References: <3c05d813e42324cdf95989784f6d7b17@pingofdeath.de>
 <56426499.8000205@turmel.org>
 <ceee2de5aba3ca77efc1146e19896b90@pingofdeath.de>
 <564284F5.9080409@turmel.org>
 <b0cdddd4394bbc1356980bb61ac199c3@pingofdeath.de>
 <56429326.5030405@turmel.org>
 <a7d58e8e4c319c320bc531b8d2bf11e7@pingofdeath.de>
 <44d28ec402622b25c4d4d7a32a8888d9@pingofdeath.de>
 <569D384F.6070208@turmel.org>
 <bb6cce6b0d5bb6c653ef94e4a58388cf@pingofdeath.de>
 <569E77AF.6040906@turmel.org> <569E905D.9010606@turmel.org>
 <15c75ec959427ae31d36912854b6debd@pingofdeath.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <15c75ec959427ae31d36912854b6debd@pingofdeath.de>
Sender: linux-raid-owner@vger.kernel.org
To: Phil Turmel <philip@turmel.org>
Cc: Linux raid <linux-raid@vger.kernel.org>, linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Hi Phil,

it's done:

658 Unique hashes in picture.jpg

Searching for pieces of picture.jpg in /dev/sdc1:...
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdc1 @=
 005400d00000:005400d7ffff ~=3D 00156000:001d5fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdc1 @=
 0087b4f29000:0087b4f7ffff ~=3D 00000000:00056fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdc1 @=
 0087b4f80000:0087b4ffffff ~=3D 001d7000:00256fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdc1 @=
 00cb2d980000:00cb2d9fffff ~=3D 0012a000:001a9fff
End of /dev/sdc1 at 01d1c1016000

Searching for pieces of picture.jpg in /dev/sdd1:...
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdd1 @=
 005400c80000:005400cfffff ~=3D 000d6000:00155fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdd1 @=
 0087b4f80000:0087b4ffffff ~=3D 00157000:001d6fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdd1 @=
 00cb2d980000:00cb2d9fffff ~=3D 000aa000:00129fff
End of /dev/sdd1 at 01d1c1016000

Searching for pieces of picture.jpg in /dev/sde1:...
  =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sde1 @ 005=
400b90000:005400c0ffff ~=3D 00056000:000d5fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sde1 @=
 005400c10000:005400c4bfff ~=3D 00256000:00291fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sde1 @=
 0087b4e10000:0087b4e8ffff ~=3D 000d7000:00156fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sde1 @=
 00cb2d810000:00cb2d88ffff ~=3D 0002a000:000a9fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sde1 @=
 00cb2d910000:00cb2d977fff ~=3D 0022a000:00291fff
End of /dev/sde1 at 01d1c0e90000

Searching for pieces of picture.jpg in /dev/sdf1:...
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdf1 @=
 005400caa000:005400cfffff ~=3D 00000000:00055fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdf1 @=
 005400d00000:005400d7ffff ~=3D 001d6000:00255fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdf1 @=
 0087b4f00000:0087b4f7ffff ~=3D 00057000:000d6fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdf1 @=
 0087b4f80000:0087b4fbafff ~=3D 00257000:00291fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdf1 @=
 00cb2d956000:00cb2d97ffff ~=3D 00000000:00029fff
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0/dev/sdf1 @=
 00cb2d980000:00cb2d9fffff ~=3D 001aa000:00229fff
End of /dev/sdf1 at 01d1c110e000


Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
