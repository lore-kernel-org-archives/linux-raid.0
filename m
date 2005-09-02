From: Daniel Pittman <daniel@rimspace.net>
Subject: 3ware RAID (was Re: RAID resync stalled at 99.7% ?)
Date: Fri, 02 Sep 2005 20:38:24 +1000
Message-ID: <87vf1jsqjj.fsf@rimspace.net>
References: <1125652202.3454.10.camel@chris.syd.nighthawkrad.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Christopher Smith <csmith@nighthawkrad.net> writes:

[...]

> The components are 12x400GB drives attached to a 3ware 9500s-12
> controller.  They are configured as "single disks" on the controller,
> ie: no hardware RAID is involved.

A quick question for you, because I have a client looking at 3ware RAID
hardware at the moment:

Why are you running this as software RAID, rather than using the
hardware on the 3ware card?

From everything I have heard, 3ware hardware RAID doesn't suck, so if
you have a good reason to avoid it I would love to hear it (and possibly
save my client trouble and/or money...)

     Daniel

