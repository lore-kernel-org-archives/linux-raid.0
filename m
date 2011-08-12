From: Asdo <asdo@shiftmail.org>
Subject: Re: single cpu thread performance limit?
Date: Fri, 12 Aug 2011 16:23:58 +0200
Message-ID: <4E45377E.8000206@shiftmail.org>
References: <CAACGR8sSieD1MLCEnY0Wv24pHd9xpcJ=mhduwGMCqo5A5ttZpw@mail.gmail.com>
 <4E44265D.3050809@hardwarefreak.com>
 <CAACGR8v87iw9qmtfsQTiUP8QWQEZPyryBc_zZwuD_DyUxgzN8Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <CAACGR8v87iw9qmtfsQTiUP8QWQEZPyryBc_zZwuD_DyUxgzN8Q@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: mark delfman <markdelfman@googlemail.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Linux RAID Mailing List <linux-raid@vger.kernel.org>, NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

On 08/12/11 15:23, mark delfman wrote:
> Hi
>
> Quick update with the XFS tests suggested (although a FS is still
> probably not a real option at teh moment for me)
>
> This rig only has 4 x Flash (2 MLC and 2 SLC).....  125K IOPS each for
> MLC - 165K each for SLC.
>
> Create linear RAID and XFS with ag=4
>
> Mount as suggested and create 4 test folders.....
>
> If i test individually - we get 99.9% of the IOPS (ie. 125 for first 2
> AG's and 165 for last 2).  which is great news and means that the AG
> does what it should.
>
> But if a run the test over all 4, then we see it peak at aroudn 320K
> IOPS.  Interstingly each AG = 80K IOPS and as we can see above this is
> need not be the case, as the CPU load is not having any issues - i am
> presuming that this could be a simple XFS limit maybe.
>
>
> More testing with many R1's and R0's on top seem to suggest that R0 is
> losing around 20-25% of the IOPS.  (R1 around 5%).  I have tried with
> LVM strip and much the same.
>

So you report a higher speed now:  (25% overhead + 5% overhead = 30% 
overhead = 70% remains)
(125*2+175*2)*0.7 = 420 K
Previously in your first post you were talking about 350K, do you confirm?

Unfortunately I think 20% overhead for R0 or LVM is reasonable, I have 
measured 15% for LVM in other situations.
Your figures with 4 SSDs are not bad I'd say.

But this means that you should obtain 840K IOPS when you have all 8 SSD 
PCIe cards installed (like in your first post).
If possible repeat the test with LVM stripes on the big rig.

Oh and I also wanted to ask: if you run 8 parallel tests on the big rig 
with 8 SSDs, each test on a different SSD but all tests simultaneously, 
without RAIDs or LVMs, are you sure you reach 1 million IOPS overall, or 
do you max out at 600K or similar?  (600K would be the last performance 
you measured but adjusted to remove the overheads of LVM and RAID)


BTW: please note you do NOT have 16 cores, you have 8 cores if you have 
a dual Xeon 5640. The other 8 cores you see are fake, that's 
hyperthreading. If one core CPU occupation goes up, you will see it's 
other twin phantom core to also go up. This makes more difficult to 
understand the benchmarking, so you might disable hyperthreading from 
bios if you want to understand better what's going on. Performances 
should probably change just very little after you disable hyperthreading.
