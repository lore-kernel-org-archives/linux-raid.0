From: Peter Rabbitson <rabbit+list@rabbit.us>
Subject: Re: How do people deal with disk size variations?
Date: Wed, 13 May 2009 11:09:52 +0200
Message-ID: <4A0A8E60.8030702@rabbit.us>
References: <4A0A89DE.4070502@eyal.emu.id.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4A0A89DE.4070502@eyal.emu.id.au>
Sender: linux-raid-owner@vger.kernel.org
To: Eyal Lebedinsky <eyal@eyal.emu.id.au>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Eyal Lebedinsky wrote:
> I have a 5-disk raid5. I notice that the five identical disks, which also
> list identical LBA numbers on the label, do not show the same size when
> queried. One is reporting (smart - it should tell the truth from the disk
> pov) a smaller size.
> 
> One disk reports
>     User Capacity: 1,000,203,804,160 bytes
> and the other four
>     User Capacity: 1,000,204,886,016 bytes
> 
> Luckily I always build a raid on partitions so this difference is
> irrelevant being in the slack past the partition end.
> 
> However, if I managed to use the whole disk, the raid will be as large as
> the smallest disk. What happens when I replace a disk and get an even
> smaller replacement one?
> 
> Do people always leave unused space at the end? Do you expect disks from
> the same exact model to have exactly the same usable size?

I always leave about 2gb off a disk, regardless of if I use a full disk
or partitions. Considering you are dealing with terabyte drives here,
your question seems rather strange...

Cheers
