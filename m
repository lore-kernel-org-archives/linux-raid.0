From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Mustn't be RAID 1 and 0 read-performance be similar?
Date: Thu, 09 Aug 2007 17:37:36 -0400
Message-ID: <46BB8920.9090105@tmr.com>
References: <735D322AED9CD711BE53000476917CD00281A96B@NT-SERVER-5>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <735D322AED9CD711BE53000476917CD00281A96B@NT-SERVER-5>
Sender: linux-raid-owner@vger.kernel.org
To: "Rustedt, Florian" <florian.rustedt@smartnet.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Rustedt, Florian wrote:
> Hello List,
>
> If the speed on RAID 0 is based on reading out in parallel, then it must be
> the same on RAID 1, mustn't it?
>
> On RAID 1, it is possible, to read two blocks in parallel to speed up, too.
>
> I tried to measure this some weeks ago, but i couldn't get over the
> read-performance of a single disk on my raid 1, so that means, that the
> software-raid does not use this easy possibility to speed up?
>   

We've had this discussion before, and the RAID code does not take 
advantage of running reads in parallel to satisfy readahead or anything 
else. I seen it said that this is on a per-thread basis, but a simple 
test suggests that it's on a process basis, setting two threads to read 
alternating 10k blocks as fast as possible ran no faster than a single 
thread. However, running against RAID-10, even a single thread seemed to 
run far faster than the speed of a single drive.

Lightly tested, don't take this as the last word.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

