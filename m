From: NeilBrown <neilb@suse.com>
Subject: Re: doubt about raid1 and writemostly
Date: Fri, 3 Jul 2015 11:32:41 +1000
Message-ID: <20150703113241.13e24704@noble>
References: <CAH3kUhEdDY2DeAQ1FYaEvsRRdia9kn6V+9VQETxVdh9j-R3TTA@mail.gmail.com>
	<20150625085954.57b485ab@noble>
	<CAH3kUhHH+uNM92QGEocLJ3HmYYL-28ax1LuC2cvypAHkMYou0Q@mail.gmail.com>
	<CAH3kUhHV=RC-Q1bGG_OXPk=mUZ_Mc2T6h7KAQAv0GP-DMY-ihg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHV=RC-Q1bGG_OXPk=mUZ_Mc2T6h7KAQAv0GP-DMY-ihg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Wed, 1 Jul 2015 11:53:07 -0300 Roberto Spadim
<roberto@spadim.com.br> wrote:

> i could do write-behind in a already up md device?
> i'm trying echo writebehind > /sys/block/md0/md/dev-sdc1 and it retur=
n error
>=20
> /sys/block/md0/md/dev-sdc1# echo write_behind >state
> -bash: echo: write error: Invalid argument

You really should be using mdadm, not trying to poke directly at sysfs.

The "Write behind" functionality involves two separate configurations.

1/ the write-intent bitmap must enable write behind - it records a
   maximum number of outstanding "behind" requests".  To arrange this
   you remove any bitmap that you have and add a correctly configured
   one.

2/ individual devices can be marked as "write mostly", in which case th=
e
   writes to those devices are "behind" writes.  you can enable this
   by writing "writemostly" to the 'state' file.


NeilBrown

>=20
> 2015-06-25 0:28 GMT-03:00 Roberto Spadim <roberto@spadim.com.br>:
> > nice :)  i read about it some years ago and i was trying to remembe=
r, i will
> > test, thanks neil!
> >
> > 2015-06-24 19:59 GMT-03:00 NeilBrown <neilb@suse.com>:
> >>
> >> On Tue, 23 Jun 2015 12:01:33 -0300 Roberto Spadim
> >> <roberto@spadim.com.br> wrote:
> >>
> >> > hi guys, i'm with a doubt
> >> > when i use witemostly, how the md handle the slower drive
> >> > (writemostly) for example i have 2 ssd that support 500mb/s writ=
e
> >> > running raid1, i included a hdd with +- 100mb/s write with write=
mostly
> >> > flag
> >> > when i execute a dd if=3D/dev/zero of=3D./test , i get near to 2=
00mb/s
> >> > with dd, and using iostat -d 1 -k, i get +- 100mb/s
> >> > there's some kind of configuration to writemostly drive? somethi=
ng
> >> > like 'buffer size' or someting like it?
> >> >
> >>
> >> You need to also enable --write-behind if you want md/raid1 to not=
 be
> >> slowed down so much by a slower device.
> >> However this only really helps hide latency.  There is nothing tha=
t can
> >> be done to help over-all throughput.
> >>
> >> When you set --write-behind you can provide a number which is the
> >> number of outstanding requests that can be in flight to the
> >> write-mostly device.
> >>
> >> If your writes are "bursty" in nature - so lots of writes together=
,
> >> then longer pauses with no writes, then this write-behind buffer c=
an
> >> hide the delay caused by the slower device.  If you write continuo=
usly,
> >> then there is no way that the slower device can keep up and the
> >> over-all throughput will be reduced to match the slowest device.
> >>
> >> This functionality was originally written for cases where both dev=
ices
> >> had the same throughput, but one was higher latency, due to being
> >> several kilometres away on the other end of an optical fibre.
> >>
> >> NeilBrown
> >
> >
> >
> >
> > --
> > Roberto Spadim
> > SPAEmpresarial - Software ERP
> > Eng. Automa=C3=A7=C3=A3o e Controle
>=20
>=20
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
