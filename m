From: mjstumpf <mjstumpf@cotse.net>
Subject: bug with resync in specific config
Date: Mon, 28 Jul 2003 09:12:19 -0400 (EDT)
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <bWpzdHVtcGY=.f9ad4b23e7168dc967940347ea06ba08@1059397939.cotse.net>
Reply-To: mjstumpf@pobox.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-raid-owner@vger.kernel.org>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi,

I have a production server that I can't really experiment with, but I
thought I'd warn / ask if this has been seen before.  (Running stock
2.4.20 kernel, 2 raid-5 IDE (via external promise card) arrays LVM'd
together).

I had issues before where multiple drives kicked out simultaneously, so I
added a hot spare that was large enough to contain a hot spare volume for
each of my raid-5 arrays.  Everything seemed great until I had a lockup
that required an unclean poweroff/reboot, at which time I witnessed this:

Both raid-5s needed to be resynced.  Because a volume was shared between
RAID-5s, the resync on one was delayed.  However, after the first RAID
resynced, one time the machine locked up... the other, the second resync
froze at 4% for about 8-12 hours.  In both cases I had to hard-power-off.

I disconnected the hot spare drive, fired it up, and everything resynced
nicely.

Has this been seen?  Is there a fix?  I can't really provide much more
info because I'm not willing to risk the data by experimenting..

Regards,
Michael Stumpf


