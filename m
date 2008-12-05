From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: time limited error recovery and md raid
Date: Fri, 5 Dec 2008 16:21:22 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812051618340.17806@p34.internal.lan>
References: <1228510646.16555.73.camel@localhost>  <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan>  <1228511266.16555.81.camel@localhost>  <alpine.DEB.1.10.0812051609070.17806@p34.internal.lan> <1228511880.16555.87.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228511880.16555.87.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 5 Dec 2008, Redeeman wrote:

> On Fri, 2008-12-05 at 16:12 -0500, Justin Piszcz wrote:
>>
>> On Fri, 5 Dec 2008, Redeeman wrote:
>>
>>> On Fri, 2008-12-05 at 16:01 -0500, Justin Piszcz wrote:
>>>>
>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>
> I thought disks had this internally, and could be prompted to do it by
> writing to the sector?
Yes-- and that is what I did over and over again, dd if=/dev/zero of=/dev/dsk
it ran OK for 1-2 days but then it started erroring again with Velociraptors. 
With some old 400GiB Seagates, I did the same thing and their pending sector 
list rose but the drives still remained working for 1-2 years after.  The 
problems I mention are only applicable to my latest experience with 
velociraptor hdds.

>> typically, (having run md/linux) for a number of years is not
>> super-necessary if you run checks on your disks once a week *AND* you have
>> good drives that don't have problems.
> Obviously i intent to replace broken disks as i detect them, but as i
> understand it, its fairly common case that disks will get bad sectors
> over time, and remap them internally?
Yes, and with 'check' I believe it helps to ensure this process (it is like
'scrubbing') using RAID VERIFY in the 3ware controller.

Justin.

