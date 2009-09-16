From: Linux Raid Study <linuxraid.study@gmail.com>
Subject: Re: Raid5 Read Perf drop in 2.6.27
Date: Wed, 16 Sep 2009 00:57:40 -0700
Message-ID: <f5d1f90a0909160057s5846df48i12c1026deb666d90@mail.gmail.com>
References: <f5d1f90a0909091554u6d40b402ga7e9f58cabf21b57@mail.gmail.com>
	 <70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <70ed7c3e0909091652m60b0ea9cp7000db919a639c35@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Majed B." <majedb@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Majed, All:

I'm using the default scheduler with 2.6.21 and 2.6.27...do you know
if there is any difference?

I rechecked the perf today - everything (i.e. disks, disk controller
etc) remaining the same, I see around 45MB/s difference in performance
when I change kernel from 2.6.21 to 2.6.27. I issue following cmd to
see performance:
hdparm -t /dev/md0

FYI...I'm using Seagate HDDs (7200 RPM) with RocketRaid 2310 controller.

Any ideas...I have tried blockdev readahead option and it helps but
still not enough...

Thanks a lot!

On Wed, Sep 9, 2009 at 4:52 PM, Majed B. <majedb@gmail.com> wrote:
> Are you sure you're using the same Kernel Scheduler on both kernels?
>
> Have you checked and verified that the same drivers are being loaded?
> (IDE vs. AHCI -- proprietary drivers vs. open source)
>
> This is interesting!
>
> On Thu, Sep 10, 2009 at 1:54 AM, Linux Raid
> Study<linuxraid.study@gmail.com> wrote:
>> Hello:
>>
>> I'm benchmarking RAID5 Read performance with 4 disks and notice perf
>> drop when using kernel 2.6.27.
>> The perf with 2.6.27 is 150MB/s whereas with kernel 2.6.21 (and same
>> setup), the perf is 180MB/s/
>>
>>
>>
>> Some of the tests I have done:
>> 1. I ran  experiments using iozone also but notice that READ perf with
>> RAID5 in 2.6.27 is ~30% less as compared to 2.6.21.
>> Write perf is similar but Read is an issue.
>>
>> 2. On 2.6.27, I played around with chunk size and blocksize parameters
>> and got ~5% improvement but not much. I used following cmds:
>>
>> #mdadm --create /dev/md0 --level=5 --assume-clean --raid-devices=4
>> /dev/sda /dev/sdb /dev/sdc /dev/sdd --chunk=32
>> #mke2fs -b 4096 -E stride=8 /dev/md0
>>
>> #time dd if=/dev/md0 of=/dev/null bs=94208 count=1024
>>
>>
>> Is this perf drop a known issue? Can someone please recommend some
>> performance tuning tips?
>>
>> Thanks a lot for your time and help!
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
>       Majed B.
>
