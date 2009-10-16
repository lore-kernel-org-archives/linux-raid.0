From: mark delfman <markdelfman@googlemail.com>
Subject: Re: MD write performance issue
Date: Fri, 16 Oct 2009 16:46:12 +0100
Message-ID: <66781b10910160846g1ff3e8ccq7c00a05442bb467a@mail.gmail.com>
References: <66781b10910160145r59f3ea0cqc8632dbc3d92f833@mail.gmail.com>
	 <4AD84E08.7020807@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AD84E08.7020807@shiftmail.org>
Sender: linux-raid-owner@vger.kernel.org
To: Asdo <asdo@shiftmail.org>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Quick update on .30.x kernels... which are still showing MD reduced performance:


Linux linux-tlfp 2.6.30-vanilla #1 SMP Fri Oct 16 14:22:54 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAW: 1.1
XFS 870 MB/s



Linux linux-tlfp 2.6.31.3-vanilla #1 SMP Fri Oct 16 14:52:09 BST 2009
x86_64 x86_64 x86_64 GNU/Linux

RAW: 1.1
XFS 920 MB/s


linux-tlfp:/ # uname -a
Linux linux-tlfp 2.6.31.2-vanilla #1 SMP Fri Oct 16 15:44:44 BST 2009
x86_64 x86_64 x86_64 GNU/Linux


RAW: 1.1
XFS: 935 MB/s


On Fri, Oct 16, 2009 at 11:42 AM, Asdo <asdo@shiftmail.org> wrote:
> mark delfman wrote:
>>
>> After further work we are sure that there is a significant write
>> performance issue with either the Kernel+MD or...
>
> Hm!
> Pretty strange repeated ups and downs of the speed with increasing kernel
> versions.
>
> Have you checked:
> that compile options are the same (preferably by taking 2.6.31 compile
> options and porting them down)
> disk schedulers are the same
> the test was long enough to level jitters, like 2-3 minutes
> Also: looking at "iostat -x 1" during the transfer could show something...
>
> Apart from this, I confirm I noticed in my 2.6.31-rc? earlier tests, that
> performances on xfs writes were very inconsistent :
> These were my benchmarks (I wrote them on file at that time):
>
> Stripe_cache_size was 1024, 13 devices raid-5:
>
> bs=1M -> 206MB/s
> bs=256K -> 229MB/s
>
> retrying soon after, identical settings:
>
> bs=1M -> 129MB/s
> bs=256K -> 140MB/s
>
>
> Transfer speed was hence very unreliable, depending on something that is not
> clearly user visible... maybe dirty page cache? I thought that depending on
> the exact amount of data being pushed out by the pdflush at the first round,
> that would cause a sequence of read-modify-write stuff which would cause
> further read-modify-write and further instability later on. But I was doing
> that with raid-5 while you Mark are using raid-0 right? My theory doesn't
> hold on raid-0.
>
>
>
