From: "Donghui Wen" <dhwen@protegonetworks.com>
Subject: Re: badblock handling
Date: Thu, 5 Feb 2004 20:43:47 -0800
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <006001c3ec6b$cf529ee0$df01010a@moon>
References: <20040204122317.K27780@forte.austin.ibm.com> <Pine.LNX.4.44.0402041726350.20232-100000@coffee.psychology.mcmaster.ca> <20040204164946.P27780@forte.austin.ibm.com> <16417.31540.78193.699721@notabene.cse.unsw.edu.au> <001601c3eba2$e6110410$df01010a@moon> <676854718.1075970126@[172.30.250.225]>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
To: Martin Dohmen <md@tripnet.se>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I read some posts before says 3ware's hardware raid is doing bad block
remapping, which is transparent to file system. I was wondering if md i=
s
doing
the same way.

I am trying hardware raid 1+0 now, even it will lost half of the disk s=
pace,
but if it is stable and fast, I will go for it.

Donghui

----- Original Message -----=20
=46rom: "Martin Dohmen" <md@tripnet.se>
To: "'Donghui Wen'" <dhwen@protegonetworks.com>;
<linux-raid@vger.kernel.org>
Sent: Wednesday, February 04, 2004 11:35 PM
Subject: Re: badblock handling


I have seen the same problem, but I have also noticed that if I use the
3ware cards own raid5 instead of md things work diffrently, the only th=
ing
that seems to happen when a disk develops a bad block is this in the lo=
g:

3w-xxxx: scsi0: AEN: ERROR: Drive error: Port #6.
3w-xxxx: scsi0: AEN: WARNING: Sector repair occurred: Port #6.

I do not now if 3ware sets some block asside when the raid is created f=
or
use when errors occure or if they justs writes the block agan and the d=
isk
does the realocation by it self.

The downside of using 3ware raid5 is that performance is quite much low=
er
than with md, with 8 disks I get 90MB/s with md and 40MB/s with 3ware i=
n
writespeed.


--On den 4 februari 2004 20:45 -0800 Donghui Wen
<dhwen@protegonetworks.com> wrote:

> Hi,
>      I am running a server with Linux software-raid (3ware controller=
).
> But from time to time,
> a disk is kicked out by md. This will happen when 3ware card reports =
a
> unrecovered read error
> for a sector. But when I run raidhotadd, the disk can added back to r=
aid
> with no problem.
>      So my questions are:
>         (1) Will md  kick out one disk if it find out ONE bad block?
>         (2) Is it possible to set up a threshold, only the amount of =
bad
> blocks pass this threshold,
>             the disk will be kicked out.
>         (3) Is it possible to remap the bad blocks to some spare bloc=
ks
> automatically on the fly?
>
> Thanks!
>
> Donghui
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>



Med v=E4nlig h=E4lsning
TRIPNET AB

Martin Dohmen
_______________________________________________________________________=
_
Tripnet AB                Bes=F6ksadress:      Telefon:  031-725 25 00
Box 5071                  =C5v=E4gen 42          Telefax:  031-725 25 0=
1
402 22  G=D6TEBORG          G=D6TEBORG           Direkt:   031-725 25 1=
1
http://www.tripnet.se     dohmen@tripnet.se  Mobil:    0733-58 25 11

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
