From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: SuSE Linux cluster using MC/ServiceGuard --- shared storage
Date: Tue, 21 Sep 2004 17:32:08 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <20040921153208.GE4118@marowsky-bree.de>
References: <20040920132846.29970.qmail@web61108.mail.yahoo.com> <20040920135549.GA8201@percy.comedia.it> <20040920183318.GP3592@marowsky-bree.de> <20040921063411.GA23543@percy.comedia.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20040921063411.GA23543@percy.comedia.it>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 2004-09-21T08:34:12,
   Luca Berra <bluca@comedia.it> said:

> >>>Do I still need to use the Driver Patch for EVA
> >>>Controller Failover?=20
> >>i believe using the qlogic driver failover is a viable solutio,
> >The DM multipath in 2.6 should handle the EVA just fine.
> you mean multipath-tools (http://christophe.varoqui.free.fr/multipath=
=2Ehtml)?
> i suppose so, using the "group_by_tur" spreading policy. fortunately =
i
> don't have any spare EVA to test, plenty of XP tough :)

You could always ask HP to give you one as a loaner while you make the
code work ;-)

> >The qlogic internal failover is being depreciated and AFAIK isn't
> >included in 2.6 mainline even...
> excuse me, are you shipping (or at least supporting) a 2.6 kernel on
> your SLES 8.0 product?

Not sure how it relates to this comment, but no, SLES8 is 2.4 only.
However, we do support 2.6 on our SLES9 platform, which has been out
since something like 1-2 months. (In R&D, project release dates become =
a
blur.)


Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
High Availability & Clustering
SUSE Labs, Research and Development
SUSE LINUX AG - A Novell company

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
