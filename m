From: Asdo <asdo@shiftmail.org>
Subject: Re: MD write performance issue
Date: Fri, 16 Oct 2009 12:42:16 +0200
Message-ID: <4AD84E08.7020807@shiftmail.org>
References: <66781b10910160145r59f3ea0cqc8632dbc3d92f833@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <66781b10910160145r59f3ea0cqc8632dbc3d92f833@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

mark delfman wrote:
> After further work we are sure that there is a significant write
> performance issue with either the Kernel+MD or...

Hm!
Pretty strange repeated ups and downs of the speed with increasing 
kernel versions.

Have you checked:
that compile options are the same (preferably by taking 2.6.31 compile 
options and porting them down)
disk schedulers are the same
the test was long enough to level jitters, like 2-3 minutes
Also: looking at "iostat -x 1" during the transfer could show something...

Apart from this, I confirm I noticed in my 2.6.31-rc? earlier tests, 
that performances on xfs writes were very inconsistent :
These were my benchmarks (I wrote them on file at that time):

Stripe_cache_size was 1024, 13 devices raid-5:

bs=1M -> 206MB/s
bs=256K -> 229MB/s

retrying soon after, identical settings:

bs=1M -> 129MB/s
bs=256K -> 140MB/s


Transfer speed was hence very unreliable, depending on something that is 
not clearly user visible... maybe dirty page cache? I thought that 
depending on the exact amount of data being pushed out by the pdflush at 
the first round, that would cause a sequence of read-modify-write stuff 
which would cause further read-modify-write and further instability 
later on. But I was doing that with raid-5 while you Mark are using 
raid-0 right? My theory doesn't hold on raid-0.


