From: pg_lxra@lxra.for.sabi.co.UK (Peter Grandi)
Subject: Re: md RAID 10 on Linux 2.6.20?
Date: Fri, 23 Nov 2007 22:04:47 +0000
Message-ID: <18247.20095.161899.423846@base.ty.sabi.co.UK>
References: <8C9FB9564550DC0-464-E73@FWM-D05.sysops.aol.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <8C9FB9564550DC0-464-E73@FWM-D05.sysops.aol.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> On Thu, 22 Nov 2007 22:09:27 -0500, thomas62186218@aol.com
>>> said:

> [ ... ] a RAID 10 "personality" defined in md that can be
> implemented using mdadm. If so, is it available in 2.6.20.11,
> [ ... ]

Very good choice about 'raid10' in general. For a single layer
just use '-l raid10'. Run 'man mdadm', the '-l' option and also
the '-p' option for the more exotic variants. Also 'man 4 md'
the "RAID10" section.

The pairs are formed naturally out of the block device list
(first with second listed, and so on).

> 8 drive RAID 10 would actually consist of 5 md devices (four
> RAID 1's and one RAID 0). [ ... ] one RAID 10, that would of
> course be better both in terms of management and probably
> performance I would guess. [ ... ]

Indeed easier in terms of management and there are some
interesting options for layout. Not sure about performance, as
sometimes I have seen strange interactions with the page cache
either way, but usually '-l raid10' is the way to go as you say.
