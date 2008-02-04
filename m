From: Michael Tokarev <mjt@tls.msk.ru>
Subject: Re: In this partition scheme, grub does not find md information?
Date: Mon, 04 Feb 2008 20:26:38 +0300
Message-ID: <47A74ACE.6020802@msgid.tls.msk.ru>
References: <479EAF42.6010604@pobox.com>	<18334.46306.611615.493031@notabene.brown>	<479F07E1.7060408@pobox.com>	<479F0AAB.3090702@rabbit.us>	<479F331F.7080902@msgid.tls.msk.ru>	<479F3C74.1050605@rabbit.us>	<479F4CFC.5060305@pobox.com>	<47A05971.1020507@dgreaves.com> <18343.16913.671817.87174@stoffel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <18343.16913.671817.87174@stoffel.org>
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: David Greaves <david@dgreaves.com>, Moshe Yudkowsky <moshe@pobox.com>, Peter Rabbitson <rabbit+list@rabbit.us>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

John Stoffel wrote:
[]
> C'mon, how many of you are programmed to believe that 1.2 is better
> than 1.0?  But when they're not different, just just different
> placements, then it's confusing.

Speaking of "more is better" thing...

There were quite a few bugs fixed in recent months wrt version 1
superblocks - both in kernel and in mdadm.  While 0.90 format is
stable for a very long time, and unless you're hitting its limits
(namely, max 26 drives in an array, no "homehost" field), there's
nothing which makes v1 superblocks better than 0.90 ones.

In my view, "better" = stable first, faster/easier/whatever second.

/mjt
