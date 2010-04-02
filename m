From: Nicolae Mihalache <mache@abcpages.com>
Subject: Re: Linux Raid performance
Date: Fri, 02 Apr 2010 11:58:11 +0200
Message-ID: <4BB5BFB3.2030400@abcpages.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com> 	<20100331201539.GA19395@rap.rap.dk> <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Learner Study <learner.study@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

I see some benchmarks performed at boot time on my Xeon E5410 2.33GHz
that shows
...
[   37.935702] raid6: sse2x1    3562 MB/s
[   38.003702] raid6: sse2x2    6422 MB/s
[   38.003702] raid6: using algorithm sse2x2 (6422 MB/s)

This  speed is higher that the DDR2 667 theoretical speed of
5333MBs/sec. So I expect the limiting factor will never be the CPU, so
it would not make sense to use multi-core.

Am I completely off?


nicolae


Learner Study wrote:
> Hi Keld:
>
> Do we have raid5/6 numbers for linux on any multi-core CPU? Most of
> the benchmarks I have seen on wiki show raid5 perf to be ~150MB/s with
> single core CPUs. How does that scale with multiple cores? Something
> like intel's jasper forest???
>
> If available, can u pls point me to numbers with multi-core CPU?
>
> Thanks!
>
> On Wed, Mar 31, 2010 at 1:15 PM, Keld Simonsen <keld@keldix.com> wrote:
>   
>> On Wed, Mar 31, 2010 at 12:42:57PM -0700, Learner Study wrote:
>>     
>>> Hi Linux Raid Experts:
>>>
>>> I was looking at following wiki on raid perf on linux:
>>>
>>> https://raid.wiki.kernel.org/index.php/Performance
>>>
>>> and notice that the performance numbers are with 2.6.12 kernel.
>>>
>>> Do we perf numbers for:
>>> - latest kernel (something like 2.6.27 / 2.6.31)
>>> - raid 5 and 6
>>>
>>> Can someone please point me to appropriate link?
>>>       
>> The link mentioned above has a number of other performance reports, for other levels of the kernel.
>> Anyway you should be able to get comparable results for newer kernels, the kernel has not become
>> slower since 2.6.12 on RAID.
>>
>> best regards
>> Keld
>>
>>     
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>   

