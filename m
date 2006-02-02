From: Gordon Henderson <gordon@drogon.net>
Subject: Re: RAID 16?
Date: Thu, 2 Feb 2006 08:34:08 +0000 (GMT)
Message-ID: <Pine.LNX.4.56.0602020748250.31455@lion.drogon.net>
References: <43E19FAB.4000603@cogweb.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43E19FAB.4000603@cogweb.net>
Sender: linux-raid-owner@vger.kernel.org
To: David Liontooth <liontooth@cogweb.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 1 Feb 2006, David Liontooth wrote:

> We're wondering if it's possible to run the following --
>
>   * define 4 pairs of RAID 1 with an 8-port 3ware 9500S card
>   * the OS will see these are four normal drives
>   * use md to configure them into a RAID 6 array
>
> Would this work? Would it be better than RAID 15? We're looking for a
> very high redundancy system.

So you have 8 disks and would end up with 2 disks worth of data... (3 if
you used RAID-5)

It'll work, but I'm not convinced that you'll gain anything in real terms.
Maybe if this machine was going to be locked in a bunker with absolutely
zero access for its lifetime? Or live on a space shuttle?

I'd be tempted to turn off RAID on the 3ware and run RAID-6 over all 8
drives myself, but I like to keep things simple - to the extent that I'd
not even bother with EVMS. Keep as few software layers as possible between
the application & the platters... But your application may demand it,
so... :)

Gordon
