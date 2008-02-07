From: Neil Brown <neilb@suse.de>
Subject: Re: recommendations for stripe/chunk size
Date: Thu, 7 Feb 2008 16:31:11 +1100
Message-ID: <18346.38815.503023.991827@notabene.brown>
References: <20080205182421.GA32250@rap.rap.dk>
	<47AA08E7.5000801@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Bill Davidsen on Wednesday February 6
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Keld Jorn Simonsen <keld@dkuug.dk>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday February 6, davidsen@tmr.com wrote:
> Keld J=F8rn Simonsen wrote:
> > Hi
> >
> > I am looking at revising our howto. I see a number of places where =
a
> > chunk size of 32 kiB is recommended, and even recommendations on
> > maybe using sizes of 4 kiB.=20
> >
> >  =20
> Depending on the raid level, a write smaller than the chunk size caus=
es=20
> the chunk to be read, altered, and rewritten, vs. just written if the=
=20
> write is a multiple of chunk size. Many filesystems by default use a =
4k=20
> page size and writes. I believe this is the reasoning behind the=20
> suggestion of small chunk sizes. Sequential vs. random and raid level=
=20
> are important here, there's no one size to work best in all cases.

Not in md/raid.

RAID4/5/6 will do a read-modify-write if you are writing less than one
*page*, but then they often to read-modify-write anyway for parity
updates.

No level will every read a whole chunk just because it is a chunk.

To answer the original question:  The only way to be sure is to test
your hardware with your workload with different chunk sizes.
But I suspect that around 256K is good on current hardware.

NeilBrown
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
