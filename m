From: Richard Scobie <richard@sauce.co.nz>
Subject: Re: raid5 grow reshaping speed is unchangeable
Date: Sat, 29 Dec 2007 17:38:12 +1300
Message-ID: <4775CF34.7030400@sauce.co.nz>
References: <380-2200712528192139967@mochamail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <380-2200712528192139967@mochamail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Cody Yellan wrote:

> You are right, Richard.  RHEL5 had a stripe_cache_size of 256 when
> the reshape began.  I increased it to 1024 and the reshape speed
> doubled to 4500K/s.  I did not see any increase in memory usage.  I
> tried 2048 and then 4096 but saw no difference in speed.

Sorry, I did not make myself clear.

Back when I was seeing the slow resync speeds, it was due to larger than 
default stripe_cache_size - I had increased to 16384.

When this was reduced back to the default, which I suspect is 256, 
speeds were back up to more normal levels - much faster than the 4.5MB/s 
you are seeing.

At some point, this issue was fixed and currently on 2.6.22, with a 
stripe_cache_size of 16384 and a 4 x 500GB SATA II md RAID 5, resync 
speed is 162MB/s.

Perhaps somthing different occurs on a reshape, (which I have only now 
realised you were doing).

Regards,

Richard
