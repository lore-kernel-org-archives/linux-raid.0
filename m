From: =?iso-8859-1?q?M=E5ns_Rullg=E5rd?= <mru@inprovide.com>
Subject: Re: linux pci raid card recommendations?
Date: Sat, 22 Jan 2005 23:56:46 +0100
Message-ID: <yw1xr7kdkr81.fsf@ford.inprovide.com>
References: <20050122224005.GA5906@xmission.xmission.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050122224005.GA5906@xmission.xmission.com> (lf@xmission.com's
 message of "Sat, 22 Jan 2005 15:40:05 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
Cc: lf <lf@xmission.com>
List-Id: linux-raid.ids

lf <lf@xmission.com> writes:

> I've been looking at the highpoint and adaptec 8port SATA cards.  The
> adaptec card costs twice as much.  Is it worth it?

The highpoint card is fakeraid, so I'd consider it overpriced if it
costs half as much as an Adaptec card.

> Is there some other card I haven't found that works better under
> linux than either one?

3ware cards have a good reputation, and from what I've seen they work
pretty well.

When using a hardware raid controller, always remember that you are
completely at the mercy of the vendor, since the on-disk format is
generally proprietary.

--=20
M=E5ns Rullg=E5rd
mru@inprovide.com
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
