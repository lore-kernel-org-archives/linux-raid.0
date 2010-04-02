From: Learner Study <learner.study@gmail.com>
Subject: Re: Linux Raid performance
Date: Thu, 1 Apr 2010 20:07:25 -0700
Message-ID: <g2s7efa8a7d1004012007ibe8b42b6k28a6d2a531fb6103@mail.gmail.com>
References: <r2v7efa8a7d1003311242vfa92024ar93ad2123a7b49806@mail.gmail.com>
	<20100331201539.GA19395@rap.rap.dk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20100331201539.GA19395@rap.rap.dk>
Sender: linux-raid-owner@vger.kernel.org
To: Keld Simonsen <keld@keldix.com>
Cc: linux-raid@vger.kernel.org, keld@dkuug.dk, learner.study@gmail.com
List-Id: linux-raid.ids

Hi Keld:

Do we have raid5/6 numbers for linux on any multi-core CPU? Most of
the benchmarks I have seen on wiki show raid5 perf to be ~150MB/s with
single core CPUs. How does that scale with multiple cores? Something
like intel's jasper forest???

If available, can u pls point me to numbers with multi-core CPU?

Thanks!

On Wed, Mar 31, 2010 at 1:15 PM, Keld Simonsen <keld@keldix.com> wrote:
> On Wed, Mar 31, 2010 at 12:42:57PM -0700, Learner Study wrote:
>> Hi Linux Raid Experts:
>>
>> I was looking at following wiki on raid perf on linux:
>>
>> https://raid.wiki.kernel.org/index.php/Performance
>>
>> and notice that the performance numbers are with 2.6.12 kernel.
>>
>> Do we perf numbers for:
>> - latest kernel (something like 2.6.27 / 2.6.31)
>> - raid 5 and 6
>>
>> Can someone please point me to appropriate link?
>
> The link mentioned above has a number of other performance reports, for other levels of the kernel.
> Anyway you should be able to get comparable results for newer kernels, the kernel has not become
> slower since 2.6.12 on RAID.
>
> best regards
> Keld
>
