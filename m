From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: Raid5 to raid6 reshape or recreate?
Date: Wed, 13 Aug 2014 23:10:16 -0500
Message-ID: <53EC36A8.7090308@gmail.com>
References: <53EAB9F1.5030905@gmail.com> <CABY_QbU4KWwtqp-TfOz13QMO134WA1J7i5jEFDozwy8aQwV1QQ@mail.gmail.com> <53EC2D0E.2070402@fnarfbargle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <53EC2D0E.2070402@fnarfbargle.com>
Sender: linux-raid-owner@vger.kernel.org
To: Brad Campbell <lists2009@fnarfbargle.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 08/13/2014 10:29 PM, Brad Campbell wrote:
> On 14/08/14 01:25, Ram Ramesh wrote:
>
>> On a slightly different topic, will it be faster after a disk
>> fail/replacement as opposed to raid reshaping?
>
> Much.
> I just re-striped a RAID6 changing the chunk size from 128k to 64k. 
> This took 12 days all up. It's the seeking that kills it. To replace a 
> disk or do a resync on the same array takes less than 10 hours.
>
>
>
I am curious. Why do you have to change chunk size? What is the 
benefit/advantage?

This seem to confirm the --layout switch Neil Brown talked about. I need 
to find that switch. I have one more 3disk-raid5 to 4disk-raid6 
reshaping to be done on another machine. I am going to do the --layout 
switch and do it in two steps. I suspect it will take about 10 hours 
with minimal seek.

Ramesh
