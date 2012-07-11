From: David Brown <david.brown@hesbynett.no>
Subject: Re: Does mdadm supports TRIM command to SSDs?
Date: Wed, 11 Jul 2012 16:54:08 +0200
Message-ID: <4FFD9390.5010109@hesbynett.no>
References: <CAF-9JegPGmayAO0gAsqY4J3rpRpTq_ciLA5e+nu0PsSjJhwr-A@mail.gmail.com> <4FFD632F.3060407@hesbynett.no> <CAF-9JeiJQVrFjt1fszpvMik7mgz-CgvNxgBAxSxKTUE5Gfch5w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-9JeiJQVrFjt1fszpvMik7mgz-CgvNxgBAxSxKTUE5Gfch5w@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bar Ziony <bartzy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2012 01:49 PM, Bar Ziony wrote:
> Hi David,
>
> Thanks for the info, it's very assuring to know that TRIM is not needed.

There are some benchmarks that indicate improvement with TRIM, but I 
think it is overrated, and there are many cases where it makes things 
worse.  If TRIM had been implemented properly (such as being 
asynchronous and working with the command queue) it would have been much 
more useful - but unfortunately it was made as a rush job to minimise 
the ageing effects seen with early SSDs.

>
> We bought Samsung 830 256GB SSDs, and as I understood, they're very
> good, but their GC is only when the device is idling, and they will be
> installed on a DB server. I don't know if they'll be idle for long
> periods.

There is always some idle time, even on a busy database server.  If not, 
then you probably need more ram in the server!

>
> Do you perhaps know if we need to over-provision modern SSDs like the
> Samsung 830's ?

There is a fair amount of variation in the over-provisioning SSDs have - 
you'd have to read the specs for the drives in question.  And if the 
drives have compressing controllers, they will effectively have more 
over-provisioning if your data is easily compressible.  However, if you 
don't need all the space on the disks, then it's easy to add more 
over-provisioning - you simply leave part of the disk out of the 
partitioning (but make sure you do that before the disk is used, or 
after a complete wipe).

>
> Thanks!
> Bar.
>
> On Wed, Jul 11, 2012 at 2:27 PM, David Brown <david.brown@hesbynett.no> wrote:
>> On 07/11/2012 12:55 AM, Bar Ziony wrote:
>>>
>>> Hi,
>>>
>>> I wasn't able to find any information about it after searching for
>>> hours - Does mdadm supports sending the TRIM command to SSDs, if using
>>> the right filesystem with the 'discard' flag?
>>> If it does support it, from what kernel version it is?
>>>
>>> Thank you,
>>> Bar.
>>
>>
>> The big question here is /why/ would you want TRIM support?  In many
>> circumstances it leads to slower operations, and for SSDs from the past
>> couple of years it is almost entirely superseded by the SSD's own garbage
>> collection.
>>
>> So while there certainly has been some work done on TRIM and md raid, it is
>> not a priority as it is of questionable benefit.  You might find some
>> operations are a little faster for older SSDs if you use TRIM, but your
>> metadata operations will be a lot slower.
>>
>> Your best bet is just to make sure you only buy SSDs that are at least half
>> decent, and don't worry about TRIM.
>>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>


