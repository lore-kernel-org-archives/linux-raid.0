From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: raid5 to utilize upto 8 cores
Date: Thu, 16 Aug 2012 03:55:39 -0500
Message-ID: <502CB58B.4040509@hardwarefreak.com>
References: <CAEyJA_sSzmgcK6miWfxC4jgvbH7WJ_hgZhnmFABaK9r7X=SLDQ@mail.gmail.com> <502C8C18.5070501@hardwarefreak.com> <CAEyJA_ungvS_o6dpKL+eghpavRwtY9eaDNCRJF0eUULoC0P6BA@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEyJA_ungvS_o6dpKL+eghpavRwtY9eaDNCRJF0eUULoC0P6BA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: vincent Ferrer <vincentchicago1@gmail.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 8/16/2012 2:08 AM, vincent Ferrer wrote:
>> No it is not normal practice.  I 'preach' against it regularly when I
>> see OPs doing it.  It's quite insane.  The glaring maintenance problem
>> is that when one SSD fails, and at least one will, you'll have 8 arrays
>> to rebuild vs one.  This may be acceptable to you, but not to the
>> general population.  With rust drives, and real workloads, it tends to
>> hammer the drive heads prodigiously, increasing latency and killing
>> performance, and decreasing drive life.  That's not an issue with SSD,
>> but multiple rebuilds is.  That and simply keeping track of 80 partitions.

> Suppose If I  don't do the partitioning  and get more SSDs  to  be able to create  more  raid5 thread - does my setup now sane ?

No, because you're not addressing an actual workload problem, but merely
playing with what-ifs.

> Only reason i partitioned insanely  was because I dont have enough SSDs yet.
> 
>  suppose if  I get  32 SSDs .  Then What is normal practice :
>     1)  Have one raid5  drives out of  32 SSDs
>               or
>     2)  Have  8 raid5 drives each with 4 SSDs
> 
> My partitioning was only a proof-of-concept  test to prove that buying
> more SSDs and launching several raid5 will increase  write throughput
> in kernel I  am using (2.6.32)

You didn't need to perform a proof of concept in order to confirm
anything.  All you had to do is google "md raid ssd".  This issue has
been well documented for quite some time, as well as workarounds, some
of which I mentioned.

"Normal practice" would be to explain your target workload, and then
discuss storage options that meet the needs of that workload.

If you had a workload that actually requires the performance equivalent
of 32 SATA SSDs, you'd already be looking at a high end SAN controller
or a handful of LSI's WarpDrive devices, and not wasting time playing
what-ifs with md/RAID's parity personality limitations.

-- 
Stan

