From: David Brown <david.brown@hesbynett.no>
Subject: Re: Does mdadm supports TRIM command to SSDs?
Date: Wed, 11 Jul 2012 13:27:43 +0200
Message-ID: <4FFD632F.3060407@hesbynett.no>
References: <CAF-9JegPGmayAO0gAsqY4J3rpRpTq_ciLA5e+nu0PsSjJhwr-A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAF-9JegPGmayAO0gAsqY4J3rpRpTq_ciLA5e+nu0PsSjJhwr-A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bar Ziony <bartzy@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 07/11/2012 12:55 AM, Bar Ziony wrote:
> Hi,
>
> I wasn't able to find any information about it after searching for
> hours - Does mdadm supports sending the TRIM command to SSDs, if using
> the right filesystem with the 'discard' flag?
> If it does support it, from what kernel version it is?
>
> Thank you,
> Bar.

The big question here is /why/ would you want TRIM support?  In many 
circumstances it leads to slower operations, and for SSDs from the past 
couple of years it is almost entirely superseded by the SSD's own 
garbage collection.

So while there certainly has been some work done on TRIM and md raid, it 
is not a priority as it is of questionable benefit.  You might find some 
operations are a little faster for older SSDs if you use TRIM, but your 
metadata operations will be a lot slower.

Your best bet is just to make sure you only buy SSDs that are at least 
half decent, and don't worry about TRIM.

