From: "Mark Klarzynski" <mark.k@computer-design.co.uk>
Subject: RE: Good news / bad news - The joys of RAID
Date: Sat, 20 Nov 2004 20:03:42 -0000
Message-ID: <037501c4cf3c$11c8dba0$030a0a0a@musicroom>
References: <200411201937.iAKJbwN17977@www.watkins-home.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200411201937.iAKJbwN17977@www.watkins-home.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

MTBF is statistic based upon the expected 'use' of the drive and the
replacement of the drive after its end of life (3-5 years)...

It's extremely complex and boring but the figure is only relative if the
drive is being used within an environment that matches those of the
calculations.

SATA / IDE drives have an MTBF similar to that of SCSI / Fibre. But this
is based upon their expected use... i.e. SCSI used to be [power on hours
= 24hr] [use = 8 hours].. whilst SATA used to be [power on = 8 hours]
and [use = 20 mins].

Regardless of what some people clam (usually those that only sell sata
based raids), the drives are not constructed the same in any way.

SATA's fail more within a raid environment (probably around 10:1)
because of the heavy use and also because they are not as intelligent...
therefore when they do not respond we have no way of interrogating them
or resetting them, whilst with scsi we do both. This means that a raid
controller / driver has no option to but simply fail the drive.

Maxtor lead the way in capacity and also reliability... I personal had
to recall countless earlier IBMs and replace them with maxtor.  But the
new generation of IBM's (Hitachi) have got it together.

So - I guess you are all right :) 



