From: daobang wang <wangdb1981@gmail.com>
Subject: Re: RAID5 created by 8 disks works with xfs
Date: Thu, 5 Apr 2012 08:48:01 +0800
Message-ID: <CACwgYDPsZSEhuqNP8YgAksEq9BB6YOS1Q8jGx2J7DCrrOh_JQw@mail.gmail.com>
References: <CACwgYDPQBNa7z7WcyUjV2Rx8Qf47r7eaRCowNKxjLBz+fYcfvQ@mail.gmail.com>
	<CADNH=7H_rgiY4fkB0SHo0yPhSBib7Gq-E_fu18yuJx=enn-eGg@mail.gmail.com>
	<4F776492.4070600@hardwarefreak.com>
	<CACwgYDOSrEYUps2VLpFSZ-irH7Mn_-BWrOYYDgXS=ULrmVuEPw@mail.gmail.com>
	<4F77D0B2.8000809@hardwarefreak.com>
	<CACwgYDMx6nQF-OwYj-BA+sZivUK=kmv2tPukgf5JGwA1vMTGrA@mail.gmail.com>
	<4F77EA55.6090004@hardwarefreak.com>
	<CACwgYDMVHT5DFjJztX9JvsVQJ+uOjPrfcs4+0aGXotDvf6tymQ@mail.gmail.com>
	<CACwgYDMXF9WEgzW9vL_0=GdRc_t+67WAkRTKNoKOMEMCvjujVw@mail.gmail.com>
	<CALFpzo5aKM2y_stDR14PNYMHEcq5CEptuFiXrvcCpXTzSQmAxw@mail.gmail.com>
	<4F792154.5020006@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F792154.5020006@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: Marcus Sorensen <shadowsor@gmail.com>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Thanks to all. Because the end-user is adhere to use RAID5, I need to
test how many video streams could be run on it really, and give the
suggestion to them. Thanks again.

Best Wishes,
Daobang Wang.

On 4/2/12, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 4/1/2012 2:08 AM, Marcus Sorensen wrote:
>> Streaming workloads don't benefit much from writeback cache.
>> Writeback can absorb spikes, but if you have a constant load that goes
>> beyond what your disks can handle, you'll have good performance
>> exactly to the point where your writeback is full. Once you hit
>> dirty_bytes, dirty_ratio, or the timeout, your system will be crushed
>> with I/O beyond recovery. It's best to limit your writeback cache to a
>> relatively small number with such a constant IO load.
>
> My comments WRT battery or flash backed write cache, whether write back
> or write through, were strictly related to running with XFS barriers
> disabled.  The only scenaio where you can safely disable XFS barriers is
> when you have a properly functioning BBWC RAID controller, whether an
> HBA, or a host independent external array such as a SAN controller.
>
> Of course, I agree 100% that write cache yields little benefit with high
> throughput workloads, and especially those generating high seek rates to
> boot.  The workload described is many parallel streaming writes of .25
> MB/s each.  If we use 96 streams, that's "only" 24 MB/s aggregate.  But
> as each of the 16 drives will likely be hitting its seek ceiling of
> ~150/s using XFS on striped RAID, the aggregate throughput of the 15
> RAID5 spindles will probably be less than 10 MB/s.
>
> Using the linear array with XFS instead of RAID5 will eliminate much of
> the head seeking, increasing throughput.  The increase may not be a
> huge, but it will be enough to handle many more parallel write streams
> than RAID5 before the drives hit their seek ceiling.
>
> --
> Stan
>
