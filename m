From: Learner Study <learner.study@gmail.com>
Subject: Re: Linux Raid performance
Date: Fri, 2 Apr 2010 10:58:30 -0700
Message-ID: <w2i7efa8a7d1004021058yadbda1bavb1e96a3f6f3bbd70@mail.gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
	<20100331201539.GA19395@rap.rap.dk> <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
	<4BB5BFB3.2030400@abcpages.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BB5BFB3.2030400@abcpages.com>
Sender: linux-raid-owner@vger.kernel.org
To: Nicolae Mihalache <mache@abcpages.com>
Cc: linux-raid@vger.kernel.org, learner.study@gmail.com
List-Id: linux-raid.ids

Hi Nicolae:

Can you please let me know:
- what HDDs (rpm etc.) of your system?
- which linux kernel are you using?

Thanks!

On Fri, Apr 2, 2010 at 2:58 AM, Nicolae Mihalache <mache@abcpages.com> =
wrote:
> I see some benchmarks performed at boot time on my Xeon E5410 2.33GHz
> that shows
> ...
> [ =A0 37.935702] raid6: sse2x1 =A0 =A03562 MB/s
> [ =A0 38.003702] raid6: sse2x2 =A0 =A06422 MB/s
> [ =A0 38.003702] raid6: using algorithm sse2x2 (6422 MB/s)
>
> This =A0speed is higher that the DDR2 667 theoretical speed of
> 5333MBs/sec. So I expect the limiting factor will never be the CPU, s=
o
> it would not make sense to use multi-core.
>
> Am I completely off?
>
>
> nicolae
>
>
> Learner Study wrote:
>> Hi Keld:
>>
>> Do we have raid5/6 numbers for linux on any multi-core CPU? Most of
>> the benchmarks I have seen on wiki show raid5 perf to be ~150MB/s wi=
th
>> single core CPUs. How does that scale with multiple cores? Something
>> like intel's jasper forest???
>>
>> If available, can u pls point me to numbers with multi-core CPU?
>>
>> Thanks!
>>
>> On Wed, Mar 31, 2010 at 1:15 PM, Keld Simonsen <keld@keldix.com> wro=
te:
>>
>>> On Wed, Mar 31, 2010 at 12:42:57PM -0700, Learner Study wrote:
>>>
>>>> Hi Linux Raid Experts:
>>>>
>>>> I was looking at following wiki on raid perf on linux:
>>>>
>>>> https://raid.wiki.kernel.org/index.php/Performance
>>>>
>>>> and notice that the performance numbers are with 2.6.12 kernel.
>>>>
>>>> Do we perf numbers for:
>>>> - latest kernel (something like 2.6.27 / 2.6.31)
>>>> - raid 5 and 6
>>>>
>>>> Can someone please point me to appropriate link?
>>>>
>>> The link mentioned above has a number of other performance reports,=
 for other levels of the kernel.
>>> Anyway you should be able to get comparable results for newer kerne=
ls, the kernel has not become
>>> slower since 2.6.12 on RAID.
>>>
>>> best regards
>>> Keld
>>>
>>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
