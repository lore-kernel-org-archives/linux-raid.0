From: Stan Hoeppner <stan@hardwarefreak.com>
Subject: Re: calculating optimal chunk size for Linux software-RAID
Date: Thu, 13 Mar 2014 05:15:01 -0500
Message-ID: <53218525.7050000@hardwarefreak.com>
References: <CAJx5YvHVrWgcOCOh2q95RLcDcq5bkev0uqyStj=Op3DCjNhTGw@mail.gmail.com>	<531A5D2F.3010002@hardwarefreak.com>	<CAJx5YvH1GE0KUcsSnVwbtUz6qP4zMv3N2qt3HhrjdF69NT2vLQ@mail.gmail.com>	<531AACA1.6000606@hardwarefreak.com>	<531B93A4.7010708@tmr.com> <CAJx5YvFHnQDCF5DiRjdyxj4AK226sCk=oF-o5NbbLispOO=Y=g@mail.gmail.com>
Reply-To: stan@hardwarefreak.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJx5YvFHnQDCF5DiRjdyxj4AK226sCk=oF-o5NbbLispOO=Y=g@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Martin T <m4rtntns@gmail.com>, davidsen@tmr.com
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 3/12/2014 10:21 AM, Martin T wrote:
> Stan,
> 
> you said that "In flight IO size has no correlation to stripe and
> chunk size.  What you

In flight IO is defined as that between DRAM and the HBA ASIC using DMA
scatter/gather, and that between the HBA and individual disk devices.

The DMA IO size varies widely between HBAs.  The largest I've seen is
~320KB.  One can determine this using blktrace, though that isn't
required for this discussion.

The in flight IO size between the HBA and a disk device is variable
depending on the technology, whether SAS, ATA, fiber channel, iSCSI,
etc.  Fiber channel frames are 2112 bytes.

The point is that the in flight IO size is significantly smaller than a
full stripe width, and smaller than the current default md chunk size of
512KB, or any conceivable chunk size.  These IOs are performed by
hardware, are transparent to the OS and applications.  It should be
obvious that you'd never try to align chunks to in flight IO size.  This
hardware doesn't care.  It's the RAID layer, which sites well avoe the
hardware, that cares.

WRT in flight IO I believe I was responding to someone talking about
optimizing the md chunk size to the in flight IO size or similar.  It's
not quoted in the context and it's not worth my time to track it down.

> need to know is how your application(s) write to the filesystem and how
> your filesystem issues write IOs.".  Could you please explain this?

App creates a file with open(2) and writes 4KB every    15 seconds.
App creates a file with open(2) and writes 4KB every   1.5 seconds.
App creates a file with open(2) and writes 4KB every   0.5 seconds.
App creates a file with open(2) and writes 4KB every  0.01 seconds.
App creates a file with open(2) and writes 4KB every 0.001 seconds.

Assume a stripe width of 8x512KB=4MB.  Depending on the filesystem
driver, whether EXT3/4, JFS, XFS, the amount of time it will wait to
assemble a full aligned stripe from incoming writes will dictate whether
it writes a full stripe to the block layer.

In the first three cases the filesystem won't align a full stripe
because the timer will expire first.  Thus you'll get RMW in the RAID
layer with parity RAID.  In the 2nd to last case, 400KB/s, you'll get
full stripe alignment if the FS timer is 10s or more.  At 4MB/s you'll
always get full stripe aligned writeout.

All of this assumes the app is performing only buffered IO.  If it
issues fsync() or fdatasync, or uses O_DIRECT, depending on when and how
it does so, you may get partial stripe writes where you got full stripe
writes with buffered IO.

> I would think that it's possible to measure how applications read/write
> to file system, isn't it?

Sure.  If it's an allocation workload you simply look at iotop which
will tell you the data rate.  If it's an append workload, in the case of
XFS anyway, this is irrelevant as XFS doesn't do write alignment for non
allocation writes.  Here full stripe assembly of append data is up the
the RAID layer and it's timer.  If the application is doing random
writes you already know that of this is irrelevant.

If you need further information or instruction on application IO
profiling you'll need to read one of the books written on the topic, or
enroll in one of the many courses offered at various colleges
universities.  It is simply way beyond the scope of an email discussion.

Cheers,

Stan


> 
> 
> regards,
> Martin
> 
> 
> On 3/9/14, Bill Davidsen <davidsen@tmr.com> wrote:
>> Stan Hoeppner wrote:
>>> On 3/7/2014 9:15 PM, Martin T wrote:
>>>> Stan,
>>>>
>>>> ok, I see. However, are there utilities out there which help one to
>>>> analyze how applications on a server use the file-system over the time
>>>> and help to make an educated decision regarding the chunk size?
>>>
>>> My apologies.  You're a complete novice and I'm leading you down the
>>> textbook storage architectural design path.  Let's short circuit that as
>>> I don't have the time.
>>>
>>> As you're starting from zero, let me give you what works best with 99%
>>> of workloads.  Use a chunk size of 32KB or 64KB.  Such a chunk will work
>>> extremely well with any singular or mixed workloads, on parity and
>>> non-parity RAID.  The only workload that should have a significantly
>>> larger chunk than this is a purely streaming allocation workload of
>>> large files.
>>>
>>> If you want a more technical explanation, you can read all of my
>>> relevant posts in the linux-raid or XFS archives, as I've explained this
>>> hundreds of times in great detail.  Or you can wait a few months to read
>>> the kernel documentation I'm working on, which will teach the reader the
>>> formal storage stack design process, soup to nuts.  I wish it was
>>> already finished, as I could simply paste the link for you, which,
>>> coincidentally, is the exact reason I'm writing it. :)
>>>
>>>
>> Thank you Stan, hopefully you cover typical mixed use cases. I split my
>> physical
>> drives with partitions and built large chunk arrays on on set and small on
>> the
>> other, to cover my use cases of editing large video files and compiling
>> kernels
>> and large apps.
>>
>> The ext4 extended options stride= and stripe-width= can produce improvements
>> in
>> performance, particularly when writing a large file on an array with a small
>>
>> chunk size. My limited tests showed this helped more with raid6 than raid5.
>>
>> Since you're writing a document you can include that or not as it pleases
>> you.
>>
>> --
>> Bill Davidsen <davidsen@tmr.com>
>>    "We have more to fear from the bungling of the incompetent than from
>> the machinations of the wicked."  - from Slashdot
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
