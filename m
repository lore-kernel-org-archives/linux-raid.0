From: Philip Molter <philip@corp.texas.net>
Subject: Re: Software RAID & Filesystem Cache
Date: Thu, 05 Aug 2004 12:34:00 -0500
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <41126F88.7040006@corp.texas.net>
References: <411260FB.4080604@corp.texas.net> <411268C7.9070804@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <411268C7.9070804@h3c.com>
To: Mike Hardy <mhardy@h3c.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Hardy wrote:

> 
> I was just researching a similar problem. I turned up a few things that 
> pointed at the filesystem readahead values/strategies, apparently those 
> things changed quite a bit between 2.4 and 2.6. You might try twiddling 
> those knobs, and you can find some linux-kernel threads where various 
> values were tested
> 
> Also, for my specific case, I found that the default I/O scheduler in 
> Fedora Core 2, the "Complete Fair Queueing" scheduler ('cfq') wasn't as 
> good as the 'deadline' scheduler, and neither was good as the 
> 'anticipatory' scheduler. So now I boot with the kernel command line 
> parameter 'scheduler=as' and things are faster. That's extremely 
> workload specific though - so you might run your own scheduler derby and 
> see what works.
> 
> The readahead is the first place I'd look though. All in all, it appears 
> that 2.6 kernels need a great deal more I/O tuning before they can be 
> put in production. While I like the flexibility that's available, the 
> default settings seem to be a major negative change from 2.4. This sort 
> of thing is just now being quantified and hopefully it gets sorted out 
> in the next couple of releases

Hi Mike,

Thanks for the response.  I run the system under the anticipatory 
scheduler, too, but I tried all of this under the default, deadline and 
as schedulers with no difference between the two.

My first suspicion was readahead as well, but I couldn't find any of the 
sysctl options to control readahead in the kernel (as there were under 
2.4).  I did mess around with readahead directly on the drives, but as 
expected, that had no effect.  I tried other reading options, but none 
seemed to have any effect.  The RAID seemed very insistent on reading 
all of that data.

I was flummoxed.

Philip
