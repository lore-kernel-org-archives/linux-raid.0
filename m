From: Iordan Iordanov <iordan@cdf.toronto.edu>
Subject: Re: debian software raid1
Date: Tue, 19 Apr 2011 12:03:27 -0400
Message-ID: <4DADB24F.2030300@cdf.toronto.edu>
References: <1303215166.2809.8.camel@valio> <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTik7iVaUH2bn9spW2gtV-TkjLH2Qag@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?UTF-8?B?TWF0aGlhcyBCdXLDqW4=?= <mathias.buren@gmail.com>
Cc: b2 <b2@playtime.bg>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hey guys,

On 04/19/11 08:25, Mathias Bur=C3=A9n wrote:
> http://www.debian-administration.org/articles/238
>
> Plenty of articles on the net on how to do that.

There is a lot of information, but also, I suspect there is a lot of=20
disagreement. One thing that I could not find a definitive answer on wa=
s=20
the question of whether or not to mirror swap.

There are articles that propose mirroring partitions independently=20
(rather than the entire disk), and not mirroring swap, but adding two=20
swap partitions with equal priority. On the other hand, there are peopl=
e=20
who point out that in the event where one of the disks in the mirror=20
dies, the machine may cease to function, because a part of its "memory"=
=20
will have disappeared. However, making swap part of the mirror opens a=20
whole new can of worms. For instance, could there be a deadlock=20
possibility (for example after a suspend/resume cycle) where mdadm is=20
waiting for something which is swapped out onto swap which is mirrored?

It would be nice to have a discussion among people who have experience=20
with all of this.

Cheers,
Iordan
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
