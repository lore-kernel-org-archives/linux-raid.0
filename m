From: Mikael Johansson <mpjohans@pcu.helsinki.fi>
Subject: Re: Perhaps this has been answered before...
Date: Wed, 21 Aug 2002 20:31:36 +0300 (EET DST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.OSF.4.30.0208212024340.15250-100000@soul.helsinki.fi>
References: <1029946722.31116.64.camel@zimmerman>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1029946722.31116.64.camel@zimmerman>
To: Chris Zimmerman <czimmer@mclaneco.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


Hello Chris and All!

On 21 Aug 2002, Chris Zimmerman wrote:

> I have a Slack system running a patched 2.2.17 kernel with raidtools
> 0.90 that is running RAID 1 on 2 internal 20 GB IDE drives (one on each
> bus).  Periodically, and now happening more frequently, the machine will
> partially freeze.  I cannot login into the machine, but the IP address
> still answers.

> /dev/md0       swap        swap        defaults   0   0

> raiddev /dev/md0
>         raid-level              1

Having your swap space as RAID-1 is redundant indeed :-) You will be
better off changing it to RAID-0.

I however do not see why this should freeze your machine. Does "freeze"
here only mean that the console freezes? You say the IP address answers,
can you login from another machine? If it is the console you might want to
check for culprits elsewhere. We had similar problems on some new machines
here last year. If I remember correctly, it turned out to be some conflict
between PS/2-mice and X. Or maybe it was the graphics cards...

Have a nice day,
    Mikael J.
    http://www.helsinki.fi/~mpjohans/


