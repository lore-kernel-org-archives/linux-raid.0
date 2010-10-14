From: Arkadiusz Miskiewicz <a.miskiewicz@gmail.com>
Subject: Re: bitmap questions
Date: Thu, 14 Oct 2010 08:00:38 +0200
Message-ID: <201010140800.38419.a.miskiewicz@gmail.com>
References: <201010131824.53363.a.miskiewicz@gmail.com> <AANLkTikBAi=NO-uzkvtzwYsgLSf44KuA1VmvXj3d708_@mail.gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikBAi=NO-uzkvtzwYsgLSf44KuA1VmvXj3d708_@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Paul Clements <paul.clements@us.sios.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thursday 14 of October 2010, Paul Clements wrote:
> On Wed, Oct 13, 2010 at 12:24 PM, Arkadiusz Miskiewicz
>=20
> <a.miskiewicz@gmail.com> wrote:
> > I have a question on how bitmap works and what's shown in /proc/mds=
tat,
> > for example:
> >=20
> > md2 : active raid10 sdc3[0] sdd3[3] sdb3[2] sda3[1]
> >      60002560 blocks 64K chunks 2 near-copies [4/4] [UUUU]
> >      bitmap: 1/1 pages [4KB], 65536KB chunk
> >=20
> > - 1 bitmap for 4096 chunks
> >=20
> > - if it shows 0/1 pages [0KB] what does it actually mean?
>=20
> If it's 0 pages then no resync.
> I assume you mean 1/1 ?

Ok, I thought differently since it's bitmap->pages - bitmap->missing_pa=
ges=20
(thought that missing_pages =3D=3D dirty one).

> > Does that mean that
> > in case of resync it will resync _all_ 4096  chunks in that page or=
 only
> > chunks that require that (for example 7 chunks) ?
>=20
> It only resyncs what is dirty. A page dirty in the in-memory bitmap
> does not mean ALL bits are dirty, just that the page is allocated.

So there is no way to know in advance how much is going to be resynced =
when=20
sudden reset would happen in that moment?

Anyway good to know that 1 page setup also makes sense :)

> --
> Paul

--=20
Arkadiusz Mi=C5=9Bkiewicz        PLD/Linux Team
arekm / maven.pl            http://ftp.pld-linux.org/
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
