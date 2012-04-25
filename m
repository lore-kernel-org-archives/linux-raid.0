From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Removing a failing drive from multiple arrays
Date: Tue, 24 Apr 2012 20:07:18 -0400
Message-ID: <4F974036.60000@tmr.com>
References: <4F905F66.6070803@tmr.com> <20120420075212.4574111a@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120420075212.4574111a@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: Linux RAID <linux-raid@vger.kernel.org>
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
Well, it does occur, has on the first bunch of partitions, is now doing 
the big ~TB one. And because I'm nervous about power cycling sick disks 
(been there, done that) I am doing the whole rebuild onto drives 
attached by USB and eSATA connections. On the last one now.

I did them all live and running, although I did "swapoff" the one for 
swap, it isn't really needed and just seems like a bad thing to be 
diddling while the system is using it.

Good news, it has worked perfectly, bad news it doesn't do what I 
thought it did. For RAID-[56] it does what I expected and pulls data off 
the partition marked for replacement, but with RAID-10 2f layout the 
"take the best copy" logic seems to take over and data comes from all 
active drives. I would have expected it to come from the failing drive 
first and be taken elsewhere only if the failing drive didn't provide 
the data. I have seen cases where migration failed due to a bad sector 
on another drive, so that's unexpected. I don't claim it wrong, just 
"not what I expected."

I think in a perfect world (where you have infinite time to diddle 
stuff), it would be useful to have three options:
  - favor the failing drive, recover what you must
  - reconstruct all data possible, don't use the failing drive
  - build the new copy fastest way possible, get it where it's available.

In any case this feature worked just fine, and I put my thoughts on the 
method out for comment. By morning the last rebuild will be done, and I 
can actually pull the bad drives by serial number, hope the UUID means 
the new drive can go anywhere, add another eSATA card and Blu-Ray 
burner, and be up solid.


-- 
Bill Davidsen <davidsen@tmr.com>
   "We have more to fear from the bungling of the incompetent than from
the machinations of the wicked."  - from Slashdot
