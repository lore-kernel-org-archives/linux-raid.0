From: Shaohua Li <shli@kernel.org>
Subject: Re: Process stuck in md_flush_request (state: D)
Date: Mon, 27 Feb 2017 10:28:06 -0800
Message-ID: <20170227182806.jntxzhyw3nkohl5r@kernel.org>
References: <36A8825E-F387-4ED8-8672-976094B3BEBB@lesstroud.com>
 <99A92F4D-338D-4486-BB1C-C114A8524403@lesstroud.com>
 <20170217200644.amaxgira4nqlbchh@kernel.org>
 <9589FA71-C458-4B44-B2F3-3D42E8B0885D@lesstroud.com>
 <829563C6-A2AF-4E5F-B5AF-D33D2E5A734E@lesstroud.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <829563C6-A2AF-4E5F-B5AF-D33D2E5A734E@lesstroud.com>
Sender: linux-raid-owner@vger.kernel.org
To: Les Stroud <les@lesstroud.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Feb 27, 2017 at 09:49:59AM -0500, Les Stroud wrote:
> After a period of a couple of weeks with one of our test instances having this problem every other day, they were all nice enough to operate without an issue for 9 days.  It finally reoccurred last night on one of the machines.  
> 
> It exhibits the same symptoms and the call traces look as they did previously.  This particular instance is configured with a deadline scheduler.  I was able to capture the inflight you requested:
> 
> $ cat /sys/block/xvd[abcde]/inflight
>        0        0
>        0        0
>        0        0
>        0        0
>        0        0
> 
> I’ve had this happen on instances with the deadline scheduler and the noop scheduler.  At this point, I have not had this happen on an instance that is noop and the raid filesystem (ext4) is mounted with nobarrier.  The instances with noop/nobarrier have not been running long enough for me to make any sort of conclusion that it works around the problem.  Frankly, I’m not sure I understand the interaction between ext4 barriers and raid0 block flushes well enough to theorize whether it should or shouldn’t make a difference.

If nobarrier, ext4 doesn't send flush request.
 
> Does any of this help with identifying the bug?  Is there anymore information I can get that would be useful?  


Unfortunately I can't find anything fishing. Does the xcdx disk correctly
handle flush request? For example, you can do the same test with a single such
disk and check if anything wrong.

Thanks,
Shaohua
