From: Manish Awasthi <manish.awasthi@caviumnetworks.com>
Subject: Re: md raid performance with 3-18-rc3
Date: Tue, 9 Dec 2014 13:54:34 +0530
Message-ID: <5486B1C2.1000508@caviumnetworks.com>
References: <5472E7DE.5070702@caviumnetworks.com> <20141125133742.0154a4d4@notabene.brown> <54758B3B.5080907@caviumnetworks.com> <20141203172101.17859aee@notabene.brown> <5486B15C.8060109@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5486B15C.8060109@caviumnetworks.com>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

resending:

  dirty_ratio same for both the kernels.
>
> vm.dirty_background_bytes = 0
> vm.dirty_background_ratio = 10
> vm.dirty_bytes = 0
> vm.dirty_expire_centisecs = 3000
> vm.dirty_ratio = 20
> vm.dirty_writeback_centisecs = 500
>
>
> I re-ran the tests with the same set of kernel without enabling 
> multithread support on 3.18 and measured a few things with perf.
>
> perf-stat-<kernel>.txt: test ran for some time and measured various 
> parameters.
>
> Meanwhile I'm also running complete test under perf record. I'll share 
> the results soon.
>
> Manish
>
> On 12/03/2014 11:51 AM, NeilBrown wrote:
>> On Wed, 26 Nov 2014 13:41:39 +0530 Manish Awasthi
>> <manish.awasthi@caviumnetworks.com>  wrote:
>>
>>> Whatever data I have on comparison is attached, I have consolidated this
>>> from log files to excel. See if this helps.
>> raid_3_18_performance.xls shows read throughput to be consistently 20% down
>> on 3.18 compared to 3.6.11.
>>
>> Writes are a few percent better for 4G/8G files, 20% better for 16G/32G files.
>> unchanged above that.
>> Given that you have 8G of RAM, that seems like it could be some change in
>> caching behaviour, and not necessarily a change in RAID behaviour.
>>
>> The CPU utilization roughly follows the throughput: 40% higher when write
>> throughput is 20% better.
>> Could you check if the value of /proc/sys/vm/dirty_ratio is the same for both
>> tests.  That number has changed occasionally and could affect these tests.
>>
>>
>> The second file, 3SSDs-perf-2-Cores-3.18-rc1 has the "change" numbers
>> negative where I expected positive.. i.e. negative mean an increase.
>>
>> Writes consistently have higher CPU utilisation.
>> Reads consistently have much lower CPU utilization.
>>
>> I don't know what that means ... it might not mean anything.
>>
>> Could you please run the tests between the two kernels *with* RAID.  i.e.
>> directly on an SSD.  That will give us a baseline for what changes are caused
>> by other parts of the kernel (filesystem, block layer, MM, etc).  Then we can
>> see how much change RAID5 is contributing.
>>
>> The third file, 3SSDs-perf-4Core.xls seems to show significantly reduced
>> throughput across the board.
>> CPU utilization is less (better) for writes, but worse for reads.  That is
>> the reverse of what the second file shows.
>>
>> I might try running some tests across a set of kernel versions and see what I
>> can come up with.
>>
>> NeilBrown
>

