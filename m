From: pg@lxra2.for.sabi.co.UK (Peter Grandi)
Subject: Re: RAID-10 explicitly defined drive pairs?
Date: Fri, 6 Jan 2012 16:39:53 +0000
Message-ID: <20231.9177.523012.471046@tree.ty.sabi.co.UK>
References: <20111212115459.GC20730@fi.muni.cz>
	<4EE61EAE.20101@anonymous.org.uk>
	<20120106150823.GX25976@fi.muni.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120106150823.GX25976@fi.muni.cz>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>>> Is there any way how to tell mdadm explicitly how to set up
>>> the pairs of mirrored drives inside a RAID-10 volume?

>> If you're using RAID10,n2 (the default layout) then adjacent
>> pairs of drives in the create command will be mirrors, [ ... ]

I did that once with a pair of MD1000 shelves from Dell and that
worked pretty well (except it was very painful to configure the
shelves with each disk as separate volume).

> half of the disks forming the RAID-10 volume disappeared.
> After removing them using mdadm --remove, and adding them
> back, iostat reports that they are resynced one disk a time,
> not all just-added disks in parallel.

That's very interesting news. Thanks for reporting this though,
it is something to keep in mind.

> [ ... ] Otherwise it would be better for us to discard RAID-10
> altogether, and use several independent RAID-1 volumes joined
> together

I suspect that that MD runs one recovery per array at a time,
and 'raid10' arrays are a single array.

Which would be interesting to know in general, for example how
many drives would be rebuilt at the same time in a 2-drive
failure on a RAID6.

You might try a two layer arrangements, as a 'raid0' of 'raid1'
pairs, instead of a 'raid10'. The two things with MD are not the
same, for example you can do layouts like a 3-drive 'raid10'.

> using LVM (which we will probably use on top of the RAID-10
> volume anyway).

Oh no! LVM is nowhere as nice as MD for RAIDing and is otherwise
largely useless (except regrettably for snapshots) and has some
annoying limitations.
