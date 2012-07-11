From: Bar Ziony <bartzy@gmail.com>
Subject: Re: Does mdadm supports TRIM command to SSDs?
Date: Wed, 11 Jul 2012 19:22:38 +0300
Message-ID: <CAF-9JeiKvs+_aXF0gCJxLkGJsVqnqhBvcW7q2UyyDLSFoysxLQ@mail.gmail.com>
References: <CAF-9JegPGmayAO0gAsqY4J3rpRpTq_ciLA5e+nu0PsSjJhwr-A@mail.gmail.com>
	<4FFD632F.3060407@hesbynett.no>
	<4FFDA815.4080006@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FFDA815.4080006@fastmail.fm>
Sender: linux-raid-owner@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: David Brown <david.brown@hesbynett.no>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

If they are connected to a regular LSI controller they won't get TRIM
commands... How do you know they need TRIM?

Thanks,
Bar.

On Wed, Jul 11, 2012 at 7:21 PM, Bernd Schubert
<bernd.schubert@fastmail.fm> wrote:
> On 07/11/2012 01:27 PM, David Brown wrote:
>> On 07/11/2012 12:55 AM, Bar Ziony wrote:
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
>> The big question here is /why/ would you want TRIM support?  In many
>> circumstances it leads to slower operations, and for SSDs from the past
>> couple of years it is almost entirely superseded by the SSD's own
>> garbage collection.
>>
>> So while there certainly has been some work done on TRIM and md raid, it
>> is not a priority as it is of questionable benefit.  You might find some
>> operations are a little faster for older SSDs if you use TRIM, but your
>> metadata operations will be a lot slower.
>>
>> Your best bet is just to make sure you only buy SSDs that are at least
>> half decent, and don't worry about TRIM.
>
>
> Well, we do have not-so-old Intel 510 SSDs on our institute cluster and
> these SSDs really need trim. And it gives us quite some headache for
> some reason (reason is an annoying LSI SAS controller they are connected
> to).
>
>
> Cheers,
> Bernd
