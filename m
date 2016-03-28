From: Phil Turmel <philip@turmel.org>
Subject: Re: Probable bug in md with rdev->new_data_offset
Date: Mon, 28 Mar 2016 08:19:12 -0400
Message-ID: <56F92140.6080801@turmel.org>
References: <20160328103123.GC8633@rcKGHUlyQfVFW>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160328103123.GC8633@rcKGHUlyQfVFW>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?Q?=c3=89tienne_Buira?= <etienne.buira@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 03/28/2016 06:31 AM, =C3=89tienne Buira wrote:
> Hi all,
>=20
> Please apologise if i hit the wrong list.

This is the right list. :-)

> I searched a bit, but could not find bug report or commits that seeme=
d
> related, please apologise if i'm wrong here.
>=20
> I was going to grow a raid6 array (that contained a spare), using thi=
s
> command:
> # mdadm --grow -n 7 /dev/mdx
>=20
> But when doing so, i got a PAX message saying that a size overflow wa=
s
> detected in super_1_sync on the decl new_offset. The array was then i=
n
> unusable state (presumably because some locks were held).
>=20
> After printking the values for rdev->new_data_offset and
> rdev->data_offset in the
> if (rdev->new_data_offset !=3D rdev->data_offset) { ...
> block of super_1_sync, i found that new_data_offset (252928 in my cas=
e)
> where smaller than data_offset (258048), thus, the substraction to
> compute sb->new_data_offset yielded an insanely high value.

Modern mdadm and kernels avoid the use of backup files by adjusting the
data offset.  The lowered offset you see is normal.

I suspect the grsecurity kernels haven't kept up with this.  If you can
reproduce a problem with a vanilla kernel, please report back here.
Otherwise you'll have to report to your kernel provider.

Phil
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
