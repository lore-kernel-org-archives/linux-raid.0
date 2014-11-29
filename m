From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: LVM RAID1 syncing component
Date: Sat, 29 Nov 2014 15:26:52 +0000
Message-ID: <21625.58812.321750.229562@tree.ty.sabi.co.uk>
References: <alpine.DEB.2.02.1411242255300.12886@jlaw-desktop.mno.stratus.com>
	<20141127074158.2a3472f3@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20141127074158.2a3472f3@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> During a resync (after an unclean shutdown) the devices are
> indistinguishable. RAID1 reads all drives and if there is a
> difference it chooses one data block to write to the others -
> always the one with the lowest index number.

Uhhhhh "indistinguishable" and "lowest index number"?

Shouldn't that be "lowest index number among those with the
highest event count"?

Put another way, couldn't it happen that in a 5-way RAID1 for
example an unclean shutdown results in 2 drives with the same
highest event count and 3 drives with lower event counts, and
then the data page to write is that from the one of the 2 with
the lowest index number and is written only to the 3 with the
lower event count?

Also, in case of an =ABunclean shutdown=BB resulting in all members
of a RAID1 set having the same event count, is the resync still
done?  Is it necessary? Or is =ABunclean shutdown=BB used here as an
alias for "not all event counts are the same".

I am asking as to what RAID1 actually does mostly, but also
perhaps as to what it ought to be doing.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
