From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: RAID1 and load-balancing during read
Date: Tue, 11 Sep 2007 15:20:33 +0200
Message-ID: <877imxibj2.fsf@informatik.uni-tuebingen.de>
References: <200709102229.30655.jimis@gmx.net>
	<20070910193530.GB2597@teal.hq.k1024.org>
	<200709102251.37976.jimis@gmx.net>
	<20070911034417.GA20596@teal.hq.k1024.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070911034417.GA20596@teal.hq.k1024.org> (Iustin Pop's message
	of "Tue, 11 Sep 2007 05:44:17 +0200")
Sender: linux-raid-owner@vger.kernel.org
To: Dimitrios Apostolou <jimis@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Iustin Pop <iusty@k1024.org> writes:

> On Mon, Sep 10, 2007 at 10:51:37PM +0300, Dimitrios Apostolou wrote:
>> On Monday 10 September 2007 22:35:30 Iustin Pop wrote:
>> > On Mon, Sep 10, 2007 at 10:29:30PM +0300, Dimitrios Apostolou wrote:
>> > > Hello list,
>> > >
>> > > I just created a RAID1 array consisting of two disks. After experiments
>> > > with processes *reading* from the device (badblocks, dd) and the iostat
>> > > program, I can see that only one disk is being utilised for reading. To
>> > > be exact, every time I execute the command one of the two disks is being
>> > > randomly used, but the other one has absolutely no activity.
>> > >
>> > > My question is: why isn't load balancing happening? Is there an option
>> > > I'm missing? Until now I though it was the default for all RAID1
>> > > implementations.
>> >
>> > Did you read the archives of this list? This question has been answered,
>> > like, 4 times already in the last months.
>> >
>> > And yes, the driver does do load balancing. Just not as RAID0 does,
>> > since it's not RAID0.
>> 
>> Of course I did a quick search in the archives but couldn't find anything. 
> Hmm, it's true that searching does not point out an easy to find
> response.
>
>> I'll search better, thanks anyway. Moreover, I think I found the answer in 
>> the code after posting. There is a comment somewhere in read_balance() 
>> saying "Don't change to another disk for sequential reads". I have to study 
>> it a bit to figure out *why* you chose that way. 
> Well, from what I understand, you cannot make a mirror behave like a
> stripe, plain and simple. There is no simple algorithm that makes
> sequential raid behave better.

As I understand it the problem is the hardware. Reading a chunk of
data from a disk means that the head has to seek to the right track
and the disk has to spin to the right position. After that you can
read a full revolution of the disk worth of data sequentially.

Now consider what happens if you read 4K per disk in stripes. The disk
seeks to the right track, spins to the right position and reads
4k. Then it waits for 4k to rotate below the head, read 4k, waits 4k,
read 4k, waits 4k, .... That way both disks are busy without any gain.

What you would need to do is read one track from one disk, the next
track from the other and so on. But how should the kernel know where
tracks start and end. That is highly device dependent and differs
between the outside and inside of the platter. The geometry values
reported by the disk is purely fictional so the CHS values are no
help.

> OTOH, random I/O or multiple threads are being sped up by raid1. And
> people have said on the list that using the raid10 module with only two
> disks and (IIRC) in offset or far mode will give better read
> performance, albeit it reduces write performance.

I found that near copies behave like raid1, offset copies are slower
in both reading and writing (beats me why) and far copies are slightly
faster than near copies in write and twice as fast in read. All for
sequential read/write. For random writes far copies should be slower
to write.

> Hmmm, I think a patch is needed to md.4 in order to explain this right
> at the source of the confusion.
>
> thanks,
> iustin

MfG
        Goswin
