From: Gordon Henderson <gordon@drogon.net>
Subject: Weird Interrupt Problem..
Date: Wed, 1 Oct 2003 14:34:21 +0100 (BST)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0310011423560.17966@unicorn.drogon.net>
References: <20030917160504.95107.qmail@web14505.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030917160504.95107.qmail@web14505.mail.yahoo.com>
To: Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Hi,

I doubt this is RAID releated, but maybe some of you fine fellows might
have an insight to a small problem I seem to have...

I've built many servers using Linux RAID and all are working fine, but I
have one wich uses 2 x Promise PCI IDE cards which is giving me some
intersting problems. Kernels from 2.4.20+ac1 to 2.4.22 support the cards:

    Unknown mass storage controller: Promise Technology, Inc. 20269 (rev 2).

and the motherboards boot off it OK. I have 2 cards with 4 IDE drives (one
per master on each controller). Only using the on-board controller for
CD-ROM.

In general, it works, but ... When its heavilly loaded I see processes
hanging in a "D" state - presumably waiting on the hardware somehow.
Sometimes for up to 10 seconds before the appear to resume again. Under
extreme loads up to a dozen processes get stuck - from nfsd to cvs to
mysql to just about anything thats doing a disk access (including the
kernel processes to keep the journal going - it's ext3, but prior to ext3,
it was xfs) The hanging processes seem to come alive again, but it makes
the machine appear very clunky and slow.

I've tried different motherboard, and kernel combinations (from a dual
Xeon PII/500 to dual Athlon XP2200+) and nothing seems to have made any
difference.

Is anyone else using these PCI cards, or can recommend another to use
instead?

Thanks for any advice anyone has - I'm clutching at straws now I think!

Gordon
