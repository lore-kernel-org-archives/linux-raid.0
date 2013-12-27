From: pg@lxraid2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID 10 far and offset on-disk layouts
Date: Fri, 27 Dec 2013 14:46:06 +0000
Message-ID: <21181.37550.85602.993895@tree.ty.sabi.co.uk>
References: <52BD8EDD.10809@assyoma.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52BD8EDD.10809@assyoma.it>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]
> The "on different drives" part let me wonder _how_ are chunks
> distributed. [ ... ] Question 1: as the two schema have
> different reliability characteristics, which is really used?

It does not matter (except to people writing MD-specific tools).
There is nothing special as to the ordering of drives or chunks
on drives. Also reliability is a *statistical* property not a
geometric one...

> [ ... ] However, this is susceptible to any consecutive
> two-disk failures. A schema like [... ] would not suffer from
> this problem (eg: disk 2 & 3 can fail and the array is still
> working).

That "consecutive two-disk failures" is really funny!

If two-paired-disk failure in RAID10 bother you, try RAID14:

  http://www.sabi.co.uk/blog/13-two.html#131213

Warning: that does not come at no cost :-).
