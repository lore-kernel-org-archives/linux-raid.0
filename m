From: Bar Ziony <bartzy@gmail.com>
Subject: Re: Does mdadm supports TRIM command to SSDs?
Date: Wed, 11 Jul 2012 14:49:01 +0300
Message-ID: <CAF-9JeiJQVrFjt1fszpvMik7mgz-CgvNxgBAxSxKTUE5Gfch5w@mail.gmail.com>
References: <CAF-9JegPGmayAO0gAsqY4J3rpRpTq_ciLA5e+nu0PsSjJhwr-A@mail.gmail.com>
	<4FFD632F.3060407@hesbynett.no>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4FFD632F.3060407@hesbynett.no>
Sender: linux-raid-owner@vger.kernel.org
To: David Brown <david.brown@hesbynett.no>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi David,

Thanks for the info, it's very assuring to know that TRIM is not needed.

We bought Samsung 830 256GB SSDs, and as I understood, they're very
good, but their GC is only when the device is idling, and they will be
installed on a DB server. I don't know if they'll be idle for long
periods.

Do you perhaps know if we need to over-provision modern SSDs like the
Samsung 830's ?

Thanks!
Bar.

On Wed, Jul 11, 2012 at 2:27 PM, David Brown <david.brown@hesbynett.no> wrote:
> On 07/11/2012 12:55 AM, Bar Ziony wrote:
>>
>> Hi,
>>
>> I wasn't able to find any information about it after searching for
>> hours - Does mdadm supports sending the TRIM command to SSDs, if using
>> the right filesystem with the 'discard' flag?
>> If it does support it, from what kernel version it is?
>>
>> Thank you,
>> Bar.
>
>
> The big question here is /why/ would you want TRIM support?  In many
> circumstances it leads to slower operations, and for SSDs from the past
> couple of years it is almost entirely superseded by the SSD's own garbage
> collection.
>
> So while there certainly has been some work done on TRIM and md raid, it is
> not a priority as it is of questionable benefit.  You might find some
> operations are a little faster for older SSDs if you use TRIM, but your
> metadata operations will be a lot slower.
>
> Your best bet is just to make sure you only buy SSDs that are at least half
> decent, and don't worry about TRIM.
>
