From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: Promise TX2-plus and kernel 2.6
Date: Thu, 22 Jan 2004 18:02:54 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040122170254.GA26148@rap.rap.dk>
References: <20040122004820.GA2515@rap.rap.dk> <400FF229.6000507@pobox.com> <20040122161929.GA26026@rap.rap.dk> <400FF986.2090509@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <400FF986.2090509@pobox.com>
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Thu, Jan 22, 2004 at 11:25:42AM -0500, Jeff Garzik wrote:
> Keld J=F8rn Simonsen wrote:
> >I am running linux kernel 2.4.22-26mdk and it supports PATA right ou=
t of
> >the box, on a Promise TX2-plus controller. I have one disk on the PA=
TA
> >port (and one disk on one of the SATA ports). I would probably like =
to
> >run kernel 2.6, mostly because I think of implementing some striping
> >RAID-1 on it and try that new module out, but if kernel 2.6 does not
> >support PATA on the TX2-plus then I am at a loss.
>=20
>=20
> It sounds like Mandrake added a non-standard Promise driver...  Consu=
lt=20
> your vendor in this case.

I don't get this. Promise themselves say that TX2-plus is supported in
Redhat 7.3/8.0 and SuSE 7.3/8.0 in their data sheet:
http://www.promise.com/marketing/datasheet/file/SATA150_DS_101703.pdf
I read that to be that support is included in the standard kernel, and
has been for a long time, so it is a very stable driver, and standard.
But of cause I may be mistaken.

But you say that the standard 2.4 and 2.6 driver is not implementing PA=
TA.
I am courious about the status of this.  Are we talking the same
controller?

Best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
