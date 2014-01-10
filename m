From: Wilson Jonathan <piercing_male@hotmail.com>
Subject: Re: MD on raw device, use unallocated space anyway?
Date: Fri, 10 Jan 2014 21:59:09 +0000
Message-ID: <BLU0-SMTP48F19D88B7C51A81C8620398B30@phx.gbl>
References: <CADNH=7H2E5J3MPyGt4YHHK8wLzhizJLmdos0G60OE1qEwvBOKg@mail.gmail.com>
	 <BLU0-SMTP3004D13A23660A4859D816298B30@phx.gbl>
	 <CADNH=7FRJwC+N8dTfOgbXRxcVa0Drcrptv=tmXY33mz25zdgYg@mail.gmail.com>
	 <BLU0-SMTP163A53F7E505381E9CB2F2598B30@phx.gbl>
	 <CADNH=7E3X7nbNC333==kN4X51=jAGJ4gF+qC_OX1uJ=GyUmR=g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CADNH=7E3X7nbNC333==kN4X51=jAGJ4gF+qC_OX1uJ=GyUmR=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mathias =?ISO-8859-1?Q?Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Fri, 2014-01-10 at 20:38 +0000, Mathias Bur=C3=A9n wrote:
> On 10 January 2014 20:10, Wilson Jonathan <piercing_male@hotmail.com>=
 wrote:
> >
> > In that case the answer would be no. However if fail/remove the 3TB
> > drive, then partitioned the drive as 2TB and 1TB and then added the=
 2TB
> > partition back into the array then you can use the 1TB on its own..=
=2E
> > just as long the "2TB" partition is the same size as the 2TB drives=
 (or
> > slightly bigger) then it should all work nicely.
> >
> >
>=20
> Thanks, that confirms my suspicions. I wanted to avoid this (as a
> rebuild would be required) but it's the only way, I suppose. Unless I
> upgrade to 3TB all around and gain some storage.
>=20

The only re-build would be onto the now partitioned disk (a re-sync) so
any existing data would be un-changed.

If you replaced the other drives then you would either need to
fail/remove a drive, then add in the new 3tb drive and allow it to
re-sync, then replicate 1 by 1 till all replaced then perform a grow...
or build a new array from scratch.

Having done a similar 1/1 replacement over a number of drives reciently=
,
not without incident, I personally would go for a from scratch new buil=
d
if I did it again saving both time and potential mistakes.

> Cheers,
> Mathias
>=20


--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
