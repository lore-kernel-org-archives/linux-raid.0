From: Roy Sigurd Karlsbakk <roy@karlsbakk.net>
Subject: Re: SV: RAID-6 support in kernel?
Date: Mon, 3 Jun 2002 11:59:33 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200206030959.g539xXb31139@mail.pronto.tv>
References: <A2C65A3296DA4A4FB30DB57A9A464A16436851@exchange.lan.vanadis.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <A2C65A3296DA4A4FB30DB57A9A464A16436851@exchange.lan.vanadis.no>
To: Christian Vik <cvik@vanadis.no>
Cc: linux-kernel@vger.kernel.org, Kasper Dupont <kasperd@daimi.au.dk>, linux-raid@vger.kernel.org, dstephenson@snapserver.com
List-Id: linux-raid.ids

> > > > > RAID-6 layout: http://www.acnc.com/04_01_06.html
> >=A0>
>  >=A0> If it is supposed to survive two arbitrary disk failures somet=
hing is
> >=A0> wrong with that figure. They store 12 logical sectors in 20 phy=
sical
>=A0> > sectors across 4 drives. With two lost disks there are 10 physi=
cal
>=A0> > sectors left from which we want to reconstruct 12 logical secto=
rs.
>=A0> > That is impossible.
> >
> > Might be the diagram is wrong.

> Could be the case, so until I find another description I will
> still not know how RAID-6 works.

Below is a (patented?) version that works. This is from the linux-raid =
list

>  A1   A2  (P1) (PA)
> (P2) (PB)  B2   B1
>  C4   C3  (PC) (P3)
> (PD) (P4)  D3   D4
>
> Disclaimer: I took that from Patent 6,353,895.  If you look it up you=
'll see
> a lot of different schemes and discussion of XOR-based RAID 6, in lan=
guage
> disguised as English.  You'll also see that I'm listed as the invento=
r.
> That's four companies back for me, but my current employer unknowingl=
y
> has some rights to it, so I hope it will see the light of day sometim=
e.
>
> Dale Stephenson
> steph@snapserver.com

--=20
Roy Sigurd Karlsbakk, Datavaktmester

Computers are like air conditioners.
They stop working when you open Windows.
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
