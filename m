From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: Very long raid5 init/rebuild times
Date: Sat, 01 Feb 2014 16:39:31 -0600
Message-ID: <52ED77A3.6020509@hardwarefreak.com>
References: <21217.9977.5869.747472@quad.stoffel.home> <20140121073540.GF10140@merlins.org> <20140121163755.GG10140@merlins.org> <52DF7976.6070808@hardwarefreak.com> <20140122174854.GF26014@merlins.org> <52E0807D.2030608@hardwarefreak.com> <20140123091319.GB2306@merlins.org> <52E10A07.3070302@hardwarefreak.com> <20140123210155.GJ10046@merlins.org> <52E1F685.3050300@hardwarefreak.com> <20140125083630.GA7555@merlins.org> <52E76054.5090900@hardwarefreak.com> <52EABA63.2060701@ubuntu.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <52EABA63.2060701@ubuntu.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>, Marc MERLIN <marc@merlins.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 1/30/2014 2:47 PM, Phillip Susi wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 1/28/2014 2:46 AM, Stan Hoeppner wrote:
>> You usually must submit asynchronously or in parallel to reach 
>> maximum throughput. Being limited by a PMP it may not matter. But 
>> with your direct connected drives of your production array you
>> should see a substantial increase in throughput with parallel
>> submission.
> 
> Not for streaming IO; you just need to make sure your cache is big
> enough so the drive is never waiting for the app.
> 
>> To significantly increase single streaming throughput you need AIO.
>> A faster CPU won't make any difference.  Neither will a better SATA
>> card, unless your current one is defective, or limits port
>> throughput will more than one port active--I've heard of couple
>> that do so.
> 
> What AIO gets you is the ability to use O_DIRECT to avoid a memory
> copy to/from the kernel page cache.  That saves you some cpu time, but
> doesn't make *that* much difference unless you have a crazy fast
> storage array, or crazy slow ram.  And since almost nobody uses it,
> it's a bit of an unrealistic benchmark.

Phillip, you seem to be arguing application performance.  For an
application/data type that doesn't need fsync you'd be correct.

However, the purpose of this exchange has been to determine the maximum
hardware throughput of the OP's array.  It's not possible to accurately
measure IO throughput doing buffered writes.  Thus O_DIRECT is needed.

But, as I already stated, because O_DIRECT is synchronous with
significant completion latency, regardless of CPU/RAM speed, a single
write stream typically won't saturate the storage.  Thus, one needs to
use either use AIO or parallel submission, or possibly both, to saturate
the storage.

-- 
Stan

