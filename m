From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid5 write latency is 10x the drive latency
Date: Mon, 3 Mar 2014 23:29:38 +0000
Message-ID: <21269.4194.236349.136774@tree.ty.sabi.co.uk>
References: <CAGRgLy55eAiam-JJFzUAZH581odHu8o9Pxt6y8jbcj92v+q6CQ@mail.gmail.com>
	<21268.65296.503057.601739@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21268.65296.503057.601739@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> [ ... ] Which tool settings? [ ... ]

As to this, how are the 8KiB writes aligned? To 1KiB? 4KiB?
8KiB? To something else?

Is there any other activity on the same physical disks given
that the RAID members seem to be LVs?

Also what's the size of those LV members of the MD set? It may
be quite small...
