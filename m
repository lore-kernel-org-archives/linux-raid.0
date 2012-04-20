From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Removing a failing drive from multiple arrays
Date: Fri, 20 Apr 2012 10:30:06 -0400
Message-ID: <4F9172EE.4000503@tmr.com>
References: <4F905F66.6070803@tmr.com> <20120420075212.4574111a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120420075212.4574111a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>
Cc: NeilBrown <neilb@suse.de>
List-Id: linux-raid.ids

NeilBrown wrote:
> On Thu, 19 Apr 2012 14:54:30 -0400 Bill Davidsen<davidsen@tmr.com>  wrote:
>
>> I have a failing drive, and partitions are in multiple arrays. I'm
>> looking for the least painful and most reliable way to replace it. It's
>> internal, I have a twin in an external box, and can create all the parts
>> now and then swap the drive physically. The layout is complex, here's
>> what blkdevtra tells me about this device, the full trace is attached.
>>
>> Block device sdd, logical device 8:48
>> Model Family:     Seagate Barracuda 7200.10
>> Device Model:     ST3750640AS
>> Serial Number:    5QD330ZW
>>       Device size   732.575 GB
>>              sdd1     0.201 GB
>>              sdd2     3.912 GB
>>              sdd3    24.419 GB
>>              sdd4     0.000 GB
>>              sdd5    48.838 GB [md123] /mnt/workspace
>>              sdd6     0.498 GB
>>              sdd7    19.543 GB [md125]
>>              sdd8    29.303 GB [md126]
>>              sdd9   605.859 GB [md127] /exports/common
>>     Unpartitioned     0.003 GB
>>
>> I think what I want to do is to partition the new drive, then one array
>> at a time fail and remove the partition on the bad drive, and add a
>> partition on the new good drive. Then repeat for each array until all
>> are complete and on a new drive. Then I should be able to power off,
>> remove the failed drive, put the good drive in the case, and the arrays
>> should reassemble by UUID.
>>
>> Does that sound right? Is there an easier way?
>>
>
> I would add the new partition before failing the old but that isn't a big
> issues.
>
> If you were running a really new kernel, used 1.x metadata, and were happy to
> try out code that that hasn't had a lot of real-life testing you could (after
> adding the new partition) do
>     echo want_replacement>  /sys/block/md123/md/dev-sdd5/state
> (for example).
>
> Then it would build the spare before failing the original.
> You need linux 3.3 for this to have any chance of working.
>
Seems I got this a day late, but I will happily do some testing in real 
world conditions when I get another replacement drive, since I noted 
some issues in another drive.

Kernel is 3.3.1-5 in Fedora 16, should have mentioned that, I guess.

Thanks for the input, wonder why multiple drives are dying, coincidence 
or some other problem? I did check the p/s, voltages are all good, 
minimal ripple, no spikes, surge protection and UPS on the power, etc.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
