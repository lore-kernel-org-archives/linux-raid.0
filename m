From: Dan Stromberg <strombrg@dcs.nac.uci.edu>
Subject: Re: big fault :-)
Date: Wed, 12 Oct 2005 07:39:11 -0700
Message-ID: <1129127952.4282.123.camel@seki.nac.uci.edu>
References: <434BE7CA.4040707@gmx.de>
	 <Pine.LNX.4.61.0510121136250.27472@desktop.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0510121136250.27472@desktop.agenda.si>
Sender: linux-raid-owner@vger.kernel.org
To: danci@agenda.si
Cc: Karsten =?ISO-8859-1?Q?R=F6mke?= <k.roemke@gmx.de>, linux-raid@vger.kernel.org, strombrg@dcs.nac.uci.edu
List-Id: linux-raid.ids

On Wed, 2005-10-12 at 11:41 +0200, danci@agenda.si wrote:
> On Tue, 11 Oct 2005, Karsten R=F6mke wrote:
>=20
> > Oct 11 18:15:44 hhbgate kernel: end_request: I/O error, dev hda, se=
ctor
> > 97562304
> > Oct 11 18:15:44 hhbgate kernel: raid1: hda: unrecoverable I/O read =
error for
> > block 94440448
> >=20
> > the recovering prozess starts again and again.
> >=20
> > Any hints what to do?
>=20
> Try to save as much data as possible to a new, known good disk - as s=
oon=20
> as possible. You might be lucky and the data is not spread over those=
 bad=20
> sectors...
>=20
> Syncing the array will *always* hit bad sectors and thus will *always=
*=20
> fail.
>=20
>  D.

An overview of various data recovery methods:

http://dcs.nac.uci.edu/~strombrg/data-recovery.html


-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
