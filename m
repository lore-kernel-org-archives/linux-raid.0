From: Tobias Oberstein <tobias.oberstein@gmail.com>
Subject: Re: performance collapse: 9 mio IOPS to 1.5 mio with MD RAID0
Date: Thu, 26 Jan 2017 09:35:17 +0100
Message-ID: <686aaca3-e79e-ee7b-06e8-fbd6d2d196e1@gmail.com>
References: <ebf6cf62-b877-251f-5704-c5c6238a4b91@gmail.com>
 <1d766141-465b-34f2-dbd6-b7f71ecc344c@hardwarefreak.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1d766141-465b-34f2-dbd6-b7f71ecc344c@hardwarefreak.org>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Am 26.01.2017 um 00:01 schrieb Stan Hoeppner:
> On 01/25/2017 05:45 AM, Tobias Oberstein wrote:
>> Hi,
>>
>> I have a storage consisting of 8 NVMe drives (16 logical drives) that
>> I verified (FIO) is able to do >9 million 4kB random read IOPS if I
>> run FIO on the set of individual NVMes.
>>
>> However, when I create a MD (RAID-0) over the 16 NVMes and run the
>> same tests, performance collapses:
>>
>> ioengine=sync, invidual NVMes: IOPS=9191k
>> ioengine=sync, MD (RAID-0) over NVMes: IOPS=1562k
>>
>> Using ioengine=psync, the performance collapse isn't as dramatic, but
>> still very signifcant:
>>
>> ioengine=sync, invidual NVMes: IOPS=9395k
>> ioengine=sync, MD (RAID-0) over NVMes: IOPS=4117k
>>
>> --
>>
>> All detail results (including runs under Linux perf) and FIO control
>> files are here
>>
>> https://github.com/oberstet/scratchbox/tree/master/cruncher/sync-engines-perf
>>
>>
>
> You don't need 1024 jobs to fill the request queues.  Just out of

Here is scaling of measured IOPS depending on concurrency for sync engines

https://github.com/oberstet/scratchbox/raw/master/cruncher/Performance%20Results%20-%20NVMe%20Scaling%20with%20IO%20Concurrency.pdf

Note: the top numbers are lower than in what I posted above, because 
these measurements were still done with 512 bytes sectors (not with 4k 
as above).

> curiosity, what are the fio results when using fewer jobs and a greater
> queue depth, say one job per core, 88 total, with a queue depth of 32?

iodeapth doesn't apply to synchronous io engines (ioengine=sync/psync/..)

>
> osq_lock appears to be a per cpu opportunistic spinlock.  Might be of
> benefit to try even fewer jobs for fewer active cores.

with reduced concurrency, I am not able to saturate the storage anymore

in essence, 1 Xeon core is needed per 120k IOPS with ioengine=sync even 
on the set of raw NVMe devices (no MD RAID).

for comparison: libaio achieves 600k IOPS / core

SPDK claims (I haven't measured that myself .. Intel claim):
1.8 mio IOPS / core

Cheers,
/Tobias
