From: Michal Soltys <nozo@ziu.info>
Subject: Re: Partitionable raid array... How to create devices ?
Date: Tue, 16 Oct 2007 11:57:01 +0200
Message-ID: <47148AED.7010104@ziu.info>
References: <471474D6.5090704@systella.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471474D6.5090704@systella.fr>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

BERTRAND Jo=EBl wrote:
>=20
>     Well, /dev/mdp0 is created. But what's about /dev/mdp0p1 ? I beli=
eve=20
> that mdadm has to create required devices. I don't understand where i=
s=20
> my mistake. Any idea ?
>=20

Two things come to my mind:

- udev messing up with what mdadm is doing (but this isn't the moment=20
where the problems should show up). Either way, check them out to avoid=
=20
subtle-looking problems.

- long time ago I noticed, that mdp parameter has problems with creatin=
g=20
nodes for raid partitions on arrays with non-standard names. In my case=
=20
it did work when explicit number of partitions was specified, but maybe=
=20
your case is different. Try --auto=3Dpart4 or --auto=3Dp4 - see if they=
=20
work. For the reference :
http://marc.info/?l=3Dlinux-raid&m=3D118720367217616&w=3D2

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
