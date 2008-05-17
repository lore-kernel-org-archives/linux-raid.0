From: David Greaves <david@dgreaves.com>
Subject: Re: Regression- XFS won't mount on partitioned md array
Date: Sat, 17 May 2008 15:48:06 +0100
Message-ID: <482EF026.9000206@dgreaves.com>
References: <482DC043.5000307@dgreaves.com>	 <alpine.DEB.1.10.0805161316100.3118@p34.internal.lan>	 <482DCCCD.8020503@dgreaves.com> <6101e8c40805161135w7470123uaac93ca59caee026@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <6101e8c40805161135w7470123uaac93ca59caee026@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Pinter <oliver.pntr@gmail.com>
Cc: Justin Piszcz <jpiszcz@lucidpixels.com>, David Chinner <dgc@sgi.com>, LinuxRaid <linux-raid@vger.kernel.org>, xfs@oss.sgi.com, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Eric Sandeen <sandeen@sandeen.net>
List-Id: linux-raid.ids

Oliver Pinter wrote:
> this[1] patch fixed?
>
> 1:
http://git.kernel.org/?p=linux/kernel/git/stable/stable-queue.git;a=blob;f=queue-2.6.25/block-do_mounts-accept-root-non-existant-partition.patch;h=097cda9928b434994dbb157065b2ca38e7cec3a1;hb=8cc4c3b370d59deb16c2e92165a466c82e914020


Looks like a possible candidate - thanks.

I think this patch is for mounting root on an md device when the partitions
aren't yet initialised.

However:
* When I run cfdisk I can read the partition table.
* Subsequent attempts to mount the xfs when /proc/partitions is clearly present
still fail.

> this patch is for 2.6.25.5 kernel
? there isn't a 2.6.25.5
It doesn't apply to 2.6.25.4

I'll see if I can make it apply...

David

