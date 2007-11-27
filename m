From: Mikael Abrahamsson <swmike@swm.pp.se>
Subject: Re: Abysmal write performance on HW RAID5
Date: Tue, 27 Nov 2007 23:18:28 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0711272314561.15659@uplift.swm.pp.se>
References: <13980960.post@talk.nabble.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <13980960.post@talk.nabble.com>
Sender: linux-raid-owner@vger.kernel.org
To: ChristopherD <christopherthe1@yahoo.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, 27 Nov 2007, ChristopherD wrote:

> At this point, I'm all ears...I don't even know where to start.  Is ext2 
> not a good format for volumes of this size?  Then how to explain the 
> block device xfer rate being so bad, too?  Is it that I have one drive 
> in the array that's a different brand?  Or that it has a different cache 
> size?

Well, I have seen 3ware hwraid volumes slow down to 10 megabyte/s when 
writing, so I guess you're seeing a similar problem. It's due to the way 
raid5 works (needing to read before writing parity) and small caches.

If you need to write quickly, you should look into using software raid 
instead, then the raid5 sw raid subsystem has access to the entire ram 
block cache and hopefully don't need to read as much from the drives.

I don't know why you're only getting 4 MB/s, if you would have said 10-15 
MB/s I wouldn't have been surprised at all, but 4 does seem to be on the 
low side. When I tried with 3ware, the type of filesystem chosen made 
very small difference.

-- 
Mikael Abrahamsson    email: swmike@swm.pp.se
