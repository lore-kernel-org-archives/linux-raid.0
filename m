From: Philip Molter <philip@corp.texas.net>
Subject: Re: Software RAID & Filesystem Cache
Date: Thu, 05 Aug 2004 13:54:51 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4112827B.2030402@corp.texas.net>
References: <4112731A.5030000@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4112731A.5030000@h3c.com>
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> I'm honestly not trying to be a smart-ass by posting this since I
> haven't played with these *a single bit* - however, this was what I found:
> 
> <berlin>/sys % find . | grep ahead
> ./block/hdf/queue/read_ahead_kb
> ./block/hdg/queue/read_ahead_kb
> ./block/hdc/queue/read_ahead_kb
> ./block/hda/queue/read_ahead_kb
> 
> Maybe those are the appropriate knobs to twiddle? If so, it appears
> they've gone per-device, and they've moved to sysfs...

Thanks!  Maybe that's why I couldn't find it.  I was looking through 
sysctl settings, which only run through /proc (I guess).  I keep 
forgetting /sys exists now.

Philip
