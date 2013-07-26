From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Help creating filesystem (xfs) and partitioning
Date: Thu, 25 Jul 2013 20:30:23 -0500
Message-ID: <51F1D12F.8030507@hardwarefreak.com>
References: <CAH3kUhFqX5fB0=eYbECxrR_52Yv3_v5oodG=6Z-8L_gcTwiC4Q@mail.gmail.com> <51F19E0F.5000400@tmr.com> <CAH3kUhEMtauLoymUL7k8s==4NtvX=CRzOJhhtfL2EdJzYygd+A@mail.gmail.com> <51F1B478.4050901@hardwarefreak.com> <CAH3kUhHzZ3DoA-mJiQG+27gai1=MZEu6t8JTMtmMvQ7q0ipEoQ@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAH3kUhHzZ3DoA-mJiQG+27gai1=MZEu6t8JTMtmMvQ7q0ipEoQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <rspadim@gmail.com>
Cc: Bill Davidsen <davidsen@tmr.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 7/25/2013 7:36 PM, Roberto Spadim wrote:
> ok =] in other words no problem about performace loss, just use one
> xfs per disk, right?
> the second doubt... i was thinking about /boot /home and /, in the
> same partition, should i consider other design? a /boot with ext2 or
> ext3 and a / with xfs?

What I would do:

	swap	1GB partition on each disk

md RAID1

/boot	ext2	100MB
rootfs	XFS	remainder of disk
home
...

> i'm considering only one partition with swap and one partition with
> raid1+xfs, what you think?

I wouldn't do it.  See above.

> in a crash (power failure) i will have better rescure with only one
> partition? or many partitions?

Having a separate /boot is always a good idea.

And truthfully, for a system of this caliber, you don't really gain
anything by using XFS, certainly not from a performance standpoint.  If
you were already an XFS user on large systems and it was simply your "go
to" filesystem, then using it on this system may make sense.  And if you
don't have a working UPS, you should definitely stay away from XFS.
Power failure shouldn't cause filesystem corruption, but it may well
corrupt or zero out files that are open for write but not written.  XFS
journals metadata, not data.

-- 
Stan

