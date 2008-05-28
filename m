From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: Performance Characteristics of All Linux RAIDs
 (mdadm/bonnie++)
Date: Wed, 28 May 2008 15:27:58 -0400 (EDT)
Message-ID: <alpine.DEB.1.10.0805281523560.29755@p34.internal.lan>
References: <alpine.DEB.1.10.0805280442330.4527@p34.internal.lan> <483D7CE8.4000600@redhat.com> <alpine.DEB.1.10.0805281329450.29755@p34.internal.lan> <483DB0EC.3090403@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <483DB0EC.3090403@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Chris Snook <csnook@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, xfs@oss.sgi.com
List-Id: linux-raid.ids



On Wed, 28 May 2008, Chris Snook wrote:

> Justin Piszcz wrote:
>> 
>> 
>> On Wed, 28 May 2008, Chris Snook wrote:
>> 
>>> Justin Piszcz wrote:
>>>> Hardware:
>>>> 
>>> Given that one of the greatest benefits of NCQ/TCQ is with parity RAID, 
>>> I'd be fascinated to see how enabling NCQ changes your results.  Of 
>>> course, you'd want to use a single SATA controller with a known good NCQ 
>>> implementation, and hard drives known to not do stupid things like disable 
>>> readahead when NCQ is enabled.
>> Only/usually on multi-threaded jobs/tasks, yes?
>
> Generally, yes, but there's caching and readahead at various layers in 
> software that can expose the benefit on certain single-threaded workloads as 
> well.
>
>> Also, I turn off NCQ on all of my hosts that has it enabled by default 
>> because
>> there are many bugs that occur when NCQ is on, they are working on it in 
>> the
>> libata layer but IMO it is not safe at all for running SATA disks w/NCQ as
>> with it on I have seen drives drop out of the array (with it off, no 
>> problems).
>> 
>
> Are you using SATA drives with RAID-optimized firmware?  Most SATA 
> manufacturers have variants of their drives for a few dollars more that have 
> firmware that provides bounded latency for error recovery operations, for 
> precisely this reason.
I see--however, as I understood it there were bugs utilizing NCQ in libata?

But FYI--
In this test, they were regular SATA drives, not special raid-ones (RE2,etc).

Thanks for the info!

Justin.

