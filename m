From: Martin T <m4rtntns@gmail.com>
Subject: Re: calculating optimal chunk size for Linux software-RAID
Date: Wed, 12 Mar 2014 17:21:46 +0200
Message-ID: <CAJx5YvFHnQDCF5DiRjdyxj4AK226sCk=oF-o5NbbLispOO=Y=g@mail.gmail.com>
References: <CAJx5YvHVrWgcOCOh2q95RLcDcq5bkev0uqyStj=Op3DCjNhTGw@mail.gmail.com>
	<531A5D2F.3010002@hardwarefreak.com>
	<CAJx5YvH1GE0KUcsSnVwbtUz6qP4zMv3N2qt3HhrjdF69NT2vLQ@mail.gmail.com>
	<531AACA1.6000606@hardwarefreak.com>
	<531B93A4.7010708@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <531B93A4.7010708@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: davidsen@tmr.com, stan@hardwarefreak.com
Cc: Linux Raid List <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Stan,

you said that "In flight IO size has no correlation to stripe and
chunk size.  What you
need to know is how your application(s) write to the filesystem and how
your filesystem issues write IOs.". Could you please explain this? I
would think that it's possible to measure how applications read/write
to file system, isn't it?



regards,
Martin


On 3/9/14, Bill Davidsen <davidsen@tmr.com> wrote:
> Stan Hoeppner wrote:
>> On 3/7/2014 9:15 PM, Martin T wrote:
>>> Stan,
>>>
>>> ok, I see. However, are there utilities out there which help one to
>>> analyze how applications on a server use the file-system over the time
>>> and help to make an educated decision regarding the chunk size?
>>
>> My apologies.  You're a complete novice and I'm leading you down the
>> textbook storage architectural design path.  Let's short circuit that as
>> I don't have the time.
>>
>> As you're starting from zero, let me give you what works best with 99%
>> of workloads.  Use a chunk size of 32KB or 64KB.  Such a chunk will work
>> extremely well with any singular or mixed workloads, on parity and
>> non-parity RAID.  The only workload that should have a significantly
>> larger chunk than this is a purely streaming allocation workload of
>> large files.
>>
>> If you want a more technical explanation, you can read all of my
>> relevant posts in the linux-raid or XFS archives, as I've explained this
>> hundreds of times in great detail.  Or you can wait a few months to read
>> the kernel documentation I'm working on, which will teach the reader the
>> formal storage stack design process, soup to nuts.  I wish it was
>> already finished, as I could simply paste the link for you, which,
>> coincidentally, is the exact reason I'm writing it. :)
>>
>>
> Thank you Stan, hopefully you cover typical mixed use cases. I split my
> physical
> drives with partitions and built large chunk arrays on on set and small on
> the
> other, to cover my use cases of editing large video files and compiling
> kernels
> and large apps.
>
> The ext4 extended options stride= and stripe-width= can produce improvements
> in
> performance, particularly when writing a large file on an array with a small
>
> chunk size. My limited tests showed this helped more with raid6 than raid5.
>
> Since you're writing a document you can include that or not as it pleases
> you.
>
> --
> Bill Davidsen <davidsen@tmr.com>
>    "We have more to fear from the bungling of the incompetent than from
> the machinations of the wicked."  - from Slashdot
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
