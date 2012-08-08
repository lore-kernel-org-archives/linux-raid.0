From: Shaohua Li <shli@kernel.org>
Subject: Re: [RFC v2]raid5: create multiple threads to handle stripes
Date: Wed, 8 Aug 2012 11:08:40 +0800
Message-ID: <CANejiEVQbUuWyBjSN1Z0h=jZg+VSCpZgAtrNK-3OuwNFB=4x6A@mail.gmail.com>
References: <20120801034000.GA25799@kernel.org>
	<CAA9_cmeZtch8cJ8iYU1CcVFLb_YznQx1sFtjW6VWvNDO_YBZQA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAA9_cmeZtch8cJ8iYU1CcVFLb_YznQx1sFtjW6VWvNDO_YBZQA@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: linux-raid@vger.kernel.org, neilb@suse.de
List-Id: linux-raid.ids

2012/8/8 Dan Williams <dan.j.williams@gmail.com>:
> On Tue, Jul 31, 2012 at 8:40 PM, Shaohua Li <shli@kernel.org> wrote:
>> This is a new tempt to make raid5 handle stripes in multiple threads, as
>> suggested by Neil to have maxium flexibility and better numa binding. It
>> basically is a combination of my first and second generation patches. By
>> default, no multiple thread is enabled (all stripes are handled by raid5d).
>>
>> An example to enable multiple threads:
>> #echo 3 > /sys/block/md0/md/auxthread_number
>> This will create 3 auxiliary threads to handle stripes. The threads can run
>> on any cpus and handle stripes produced by any cpus.
>>
>> #echo 1-3 > /sys/block/md0/md/aux0_cpulist
>> This will bind auxiliary thread 0 to cpu 1-3, and this thread will only handle
>> stripes produced by cpu 1-3. User tool can further change the thread's
>> affinity, but the thread can only handle stripes produced by cpu 1-3 till the
>> sysfs entry is changed again.
>>
>> If stripes produced by a CPU aren't handled by any auxiliary thread, such
>> stripes will be handled by raid5d. Otherwise, raid5d doesn't handle any
>> stripes.
>>
>> Please let me know how do you think about it. I'll split the patch to a more
>> reviewable form if no one objects the idea.
>>
>> Signed-off-by: Shaohua Li <shli@fusionio.com>
>
> Looks ok to me.
>
> I think the md_sysfs_entry changes are probably asking for a new
> md_thread kobj_type in the hierarchy rather than sprinkling a
> md_sysfs_entry around.  Similar to what happens for rdevs... and I
> expect the threads may grow more attributes once there.
>
> /sys/block/mdX/md/threadX/mask
> ...active?
> ...idle?
Sure, this makes sense. I'll sort it out in patch submit.
