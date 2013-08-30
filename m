From: Albert Pauw <albert.pauw@gmail.com>
Subject: Re: RAID 10 on Fusion IO cards problems
Date: Fri, 30 Aug 2013 10:09:23 +0200
Message-ID: <CAGkViCFKnQQSbbtsb8uHLojzAhwWjNE0hkwaWPagKmQ4cM2Tig@mail.gmail.com>
References: <CAGkViCEJqcGHZQgn0moxFbhHr_XJ0uswy1C4L_nrURR6VKCwSw@mail.gmail.com>
	<521FD62C.9070800@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <521FD62C.9070800@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: stan@hardwarefreak.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Stan,

thanks for your thorough explanation. Since the testing is out of our
scope (it's done by another group) I don't have anymore details then
they will give me,
and yes that's very annoying. But your explanation is very interesting
read, thanks for that.

As for the choice of RHEL 5.9, that was also their choice, not ours.
Also very frustrating, but that's what we have to deal with.

Thanks again, and we'll investigate further (latest claim from them is
that they also have problems on a single device, so I am a bit
clueless what they are actually doing).

Albert

On 30 August 2013 01:15, Stan Hoeppner <stan@hardwarefreak.com> wrote:
> On 8/29/2013 4:20 AM, Albert Pauw wrote:
> ...
>> OS: Oracle Linux 5.9 (effectively RHEL 5.9), kernel  2.6.32-400.29.2.el5uek.
>> All utilities updates, mdadm (2.6.9 latest through updates).
> ...
>> Two Fusion IO Duo cards, each Fusion IO device 640 GB, so four in total.
> ...
>> mdadm --create --verbose /dev/md0 --level=10 --metadata=1.2
>> --chunk=512 --raid-devices=4 /dev/fioa /dev/fioc /dev/fiob /dev/fiod
>> --assume-clean -N md0
>>
>> When the performance turned out bad, after about 20 minutes, the
>> process was stopped. I broke the mirror, so the md0 device is only
>> striped, but the performance hit after 20 minutes happened again.
>>
>> The status of all cards are fine, no problems there. Then I created a
>> fs on only one device and have it run again. This time it worked fine.
>> The fs was in all cases ext3, no TRIM.
>
> You've presented insufficient information to allow a definitive answer.
>  That said, it's very likely that you're hitting the same wall many
> folks do with SSDs.  All md/RAID personalities are limited to a single
> write thread which limits you to one CPU of IO throughput.  When writing
> to a single device without md/RAID, block IOs can be processed by all
> CPUs in parallel.  The Fusion IO device is likely sufficiently fast that
> a single md/RAID10 thread can't saturate the device, so you run out of
> CPU before IOPS.  This is very common with SSD and md/RAID.  Shaohua Li
> has been busily working on patches for quite some time now to eliminate
> this CPU bottleneck in md.
>
> The fact that a single Fusion IO device with EXT3 on it is faster than
> md/RAID10 strongly suggests this may be the cause.  If you have multiple
> application threads or processes writing to a single device the IOs will
> be processed on the same CPU (core) as the thread, so you can have IOs
> in flight from all CPUs in parallel.  When using md/RAID all of that IO
> must be shuttled to the md driver which can only execute on a single CPU
> (core).  To verify this, simply run your tests again and monitor CPU
> burn of the md/RAID10 thread.  If that CPU is 100% at any time then this
> is the problem.
>
> If this is true, you can immediately mitigate it by using a layered
> md/RAID0 over md/RAID1 setup.  Doing this will give you two md/RAID1
> write threads, doubling the number of CPU cores you can put into play.
> To do this and maintain the card<->card mirror layout you described, you
> will create an md/RAID1 with fioa and fioc, and another md/RAID1 with
> fiob and fiod.  Then you'll create an md/RAID0 across these two md/RAID1
> devices.  The md/RAID0 and linear personalities don't use write threads
> and are thus not limited to a single CPU core.
>
> One final suggestion.  Use XFS instead of EXT3/4.  You should get
> significantly better performance with a parallel database workload.  But
> I'd strongly suggest moving up to a RHEL 6.2+ clone if you do.  5.9 is
> ancient, and there are tons of performance and stability enhancements in
> newer kernels, specifically related to XFS.
>
> --
> Stan
>
