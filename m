From: Antonio Perez <ap23563m@gmx.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Wed, 14 Oct 2009 02:23:36 -0400
Message-ID: <hb3qpa$6ep$1@ger.gmane.org>
References: <hb1udb$6t1$1@ger.gmane.org> <70ed7c3e0910130704l1f1f7f0ar66271d85295c667b@mail.gmail.com> <hb2470$rol$1@ger.gmane.org> <70ed7c3e0910130810r58ab391id2fbfdff6200dcd8@mail.gmail.com>
Reply-To: ap23563m@gmx.com
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Majed B. wrote:

> I think I already answered your question:
> 
>> For desktop usage it's OK to use that setup since you won't be writing
>> to / and the other segments a lot at the same time.
> 
>> If you're running an application which writes a lot of data to / and
>> you require to read/write a lot of data of the rest of the disk, it
>> will conflict and slow things down a lot.
>>
>> Basically, you're partitioning each disk and making each partition
>> belong to an array.
> 
> If you misunderstood part, or I did, let me know :)

Thanks Majeb. I believe I understand you.

This is what I get from your comment:

If the disks are setup with several partitions, and the corresponding 
partitions belong to a md array as this:
	sd[a..d]1 --> md1
	sd[a..d]2 --> md2
	sd[a..d]3 --> md3

If md1 is used as / and md2 is used as /home (or /data) there will be no 
concurrent reads to both places.

While this may be true, depending on the specific application, it is not 
what I am asking.
________________________________________________________________________

The point is:

If md1 is used as /data1 and md2 is used as /data2 will it work?

Will the md system be aware that those are on the same disk (spindle) and 
use the correct queuing on the reads for the best reading speed possible?

Or will md get confused on the correct read sequence causing additional head 
seeks which will degrade overall performance.

Sorry if I confuse you more, this is not an "simple" question.

Please read Robin Hill answer. :-)

-- 
Antonio Perez

