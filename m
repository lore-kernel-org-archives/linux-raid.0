From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Confusion with setting up new RAID6 with mdadm
Date: Fri, 22 Jul 2011 07:17:25 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1107220716060.20159@uplift.swm.pp.se>
References: <4CE00206.4000301@geograph.co.za> <20101114195036.GA23982@maude.comedia.it> <loom.20110722T025156-876@post.gmane.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <loom.20110722T025156-876@post.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: Tanguy Herrmann <dolanor@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Jul 2011, Tanguy Herrmann wrote:

> I've read somewhere (sorry I can't remind it) that the raid still could be
> unaligned by using the whole disk, and so we had to create a partition aligned
> (by using fdisk -u, then creating a partition beginning at LBA 64 at least, and
> that would span on a length multiple of 8.
>
> Was it totally wrong ?

No, but I don't see how using the whole disk can end up to be not 4k 
aligned when doing your way would. Only way this would end up unaligned 
would be if the offset jumper on the WDxxEARS drives was set, and then 
you'd be misaligned regardless of method.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
