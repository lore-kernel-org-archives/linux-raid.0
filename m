From: Brad Campbell <lists2009@fnarfbargle.com>
Subject: Re: Raid5 to raid6 reshape or recreate?
Date: Thu, 14 Aug 2014 14:06:11 +0800
Message-ID: <53EC51D3.9020204@fnarfbargle.com>
References: <53EAB9F1.5030905@gmail.com> <CABY_QbU4KWwtqp-TfOz13QMO134WA1J7i5jEFDozwy8aQwV1QQ@mail.gmail.com> <53EC2D0E.2070402@fnarfbargle.com> <53EC36A8.7090308@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53EC36A8.7090308@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ram Ramesh <rramesh2400@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 14/08/14 12:10, Ram Ramesh wrote:
> On 08/13/2014 10:29 PM, Brad Campbell wrote:
>> On 14/08/14 01:25, Ram Ramesh wrote:
>>
>>> On a slightly different topic, will it be faster after a disk
>>> fail/replacement as opposed to raid reshaping?
>>
>> Much.
>> I just re-striped a RAID6 changing the chunk size from 128k to 64k.
>> This took 12 days all up. It's the seeking that kills it. To replace a
>> disk or do a resync on the same array takes less than 10 hours.
>>
>>
>>
> I am curious. Why do you have to change chunk size? What is the
> benefit/advantage?

When I initially selected 128k it was for a stripe of 8 chunks (10 
disks) and for a workload that contained lots of fairly big streaming 
writes and reads.  The array has since grown to 12 chunks (14 disks) and 
the workload turned out to be a lot more random than I initially had 
profiled, so I re-striped to attempt to reduce the amount of RMW 
happening on the disks.

It may well be academic, but it's a lot easier to find 768k to write in 
one action than 1.5M.

... and probably because I could.

