From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid5 to raid6 - reshape very slow
Date: Tue, 29 May 2012 02:21:30 -0500
Message-ID: <4FC478FA.2020100@hardwarefreak.com>
References: <4FC41970.5080009@infinitedepth.com.au> <20120529105619.4dd15511@notabene.brown>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120529105619.4dd15511@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Jonathan Molyneux <jonathan@infinitedepth.com.au>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 5/28/2012 7:56 PM, NeilBrown wrote:
> On Tue, 29 May 2012 10:33:52 +1000 Jonathan Molyneux
> <jonathan@infinitedepth.com.au> wrote:

>> md1 : active raid6 sde1[0] sdb1[6] sdh1[5] sdc1[4] sdg1[3] sdd1[2] sdf1[1]
>>        7325679680 blocks super 0.91 level 6, 64k chunk, algorithm 18 
>> [7/6] [UUUUUU_]
>>        [=========>...........]  reshape = 47.0% (689413888/1465135936) 
>> finish=4126.9min speed=3132K/sec

> The only thing to do is to wait.  This is very much a seek-bound operation
> and there is little room for making it go faster.

With SSDs you'd see the throughput of this operation increase by 2
orders of magnitude (100x) or more, as SSDs have application level seek
latency of ~50-80 microseconds, over 100x lower than rotational drives
which are in the 10-30 millisecond range depending on spindle speed.

Of course, cost/GB for the same total storage is 2 to 10 times higher
with SSD.  Though interestingly the price of SSDs continues to fall,
whereas the rotational drive manufacturers are currently keeping drive
prices artificially high, between 50-100% higher than last year
depending on drive model, in an effort to recoup apparent financial
losses caused by the flooding in Thailand.

-- 
Stan
