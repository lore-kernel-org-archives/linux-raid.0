From: Ming Lin <mlin@kernel.org>
Subject: Re: write performance of HW RAID VS MD RAID
Date: Fri, 12 Jun 2015 10:20:24 -0700
Message-ID: <CAF1ivSb60pmdrVD1V7-c+Zs0dPf=1zxrgJC+RpDoOszW0TCjfw@mail.gmail.com>
References: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com>
	<20150611052729.258dddfa@natsu>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735FCBEA69@EXCHANGE.collogia.de>
	<CAF1ivSZYjwwWeVnhPL=njT=e_kympgWCT_kvrpGR0fU6crCC7w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF1ivSZYjwwWeVnhPL=njT=e_kympgWCT_kvrpGR0fU6crCC7w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: Markus Stockhausen <stockhausen@collogia.de>, Roman Mamedov <rm@romanrm.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On Wed, Jun 10, 2015 at 11:02 PM, Ming Lin <mlin@kernel.org> wrote:
> On Wed, Jun 10, 2015 at 10:39 PM, Markus Stockhausen
> <stockhausen@collogia.de> wrote:
>>> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&quot; im Auftrag von &quot;Roman Mamedov [rm@romanrm.net]
>>> Gesendet: Donnerstag, 11. Juni 2015 02:27
>>> An: Ming Lin
>>> Cc: linux-raid@vger.kernel.org; Neil Brown
>>> Betreff: Re: write performance of HW RAID VS MD RAID
>>>
>>> On Wed, 10 Jun 2015 15:27:07 -0700
>>> Ming Lin <mlin@kernel.org> wrote:
>>>
>>> > Hi NeilBrown,
>>> >
>>> > As you may already see, I run a lot of tests with 10 HDDs for the patchset
>>> > "simplify block layer based on immutable biovecs"
>>> >
>>> > Here is the summary.
>>> > http://minggr.net/pub/20150608/fio_results/summary.log
>>> >
>>> > MD RAID6 read performance is OK.
>>> > But write performance is much lower than HW RAID6.
>>> >
>>> > Is it a known issue?
>>>
>>> Did you tune the stripe_cache_size for the array? Try 32768.
>>> https://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write-transfer/
>>
>> +1 for giving an increased cache size a try.
>
> Will try it.
>
>>
>> From the numbers I anticipate that you are doing sequential
>> read/write tests. Otherwise I would expect a write penalty for
>> the HW RAID setup too.
>
> Yes,
>
> [global]
> ioengine=libaio
> iodepth=64
> direct=1
> runtime=1800
> time_based
> group_reporting
> numjobs=48
> gtod_reduce=0
> norandommap
> write_iops_log=fs
>
> [job1]
> bs=640K
> directory=/mnt
> size=5G
> rw=write

I tested xfs write for RAID6 stripe size 64k with different stripe_cache_size.

stripe_cache_size       throughput(MB/s)
--------------------------       --------------------------
256                            181.7
512                            185.1
768                            178.3
1024                          194.4
2048                           227
4096                           247
8192                           300.3
16834                         312.4
32768                          304

While xfs write for HW RAID6 throughput is 753.16 MB/s
