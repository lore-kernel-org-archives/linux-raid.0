From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid1 repair does not repair errors?
Date: Sun, 2 Feb 2014 21:51:46 +0000
Message-ID: <21230.48626.53552.600221@tree.ty.sabi.co.uk>
References: <52EE3910.3040205@msgid.tls.msk.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EE3910.3040205@msgid.tls.msk.ru>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] I tried various ways to fix the issue, one of them was
> to removing the bad drive from the array and adding it back.
> This forced all sectors to be re-written, and the problem went
> away.

Lucky,

> [ ... ] Now, the same issue happened again - another drive
> developed a bad sector, and again, md `repair' action does not
> fix it. [ ... ]

Thanks for letting us know things work as expected and MD RAID
has not developed psychic powers yet :-).

Similar reports happen now and then. Some people seem to develop
inflated expectations of what a RAID system can do, and how a
storage stack works. Perhaps some people imagine that "repair"
means "repair disk errors" rather than "repair RAID status".
