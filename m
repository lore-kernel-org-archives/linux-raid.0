From: Mike Hardy <mhardy@h3c.com>
Subject: Re: Software RAID & Filesystem Cache
Date: Thu, 05 Aug 2004 10:49:14 -0700
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4112731A.5030000@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
To: "'linux-raid@vger.kernel.org'" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


Philip Molter wrote:
> Mike Hardy wrote:
>        [ ... snip ... ]
>> The readahead is the first place I'd look though. All in all, it 
>> appears that 2.6 kernels need a great deal more I/O tuning before they 
>> can be put in production. While I like the flexibility that's 
>> available, the default settings seem to be a major negative change 
>> from 2.4. This sort of thing is just now being quantified and 
>> hopefully it gets sorted out in the next couple of releases
> 
> 
> [ .. snip ... ]
> 
> My first suspicion was readahead as well, but I couldn't find any of the 
> sysctl options to control readahead in the kernel (as there were under 

I'm honestly not trying to be a smart-ass by posting this since I
haven't played with these *a single bit* - however, this was what I found:

<berlin>/sys % find . | grep ahead
./block/hdf/queue/read_ahead_kb
./block/hdg/queue/read_ahead_kb
./block/hdc/queue/read_ahead_kb
./block/hda/queue/read_ahead_kb

Maybe those are the appropriate knobs to twiddle? If so, it appears
they've gone per-device, and they've moved to sysfs...

-Mike
