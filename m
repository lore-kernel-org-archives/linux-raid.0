From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: time limited error recovery and md raid
Date: Fri, 5 Dec 2008 18:52:26 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812051852110.4906@p34.internal.lan>
References: <1228510646.16555.73.camel@localhost>  <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan>  <1228511266.16555.81.camel@localhost>  <alpine.DEB.1.10.0812051609070.17806@p34.internal.lan>  <1228511880.16555.87.camel@localhost>
 <alpine.DEB.1.10.0812051618340.17806@p34.internal.lan>  <1228512684.16555.91.camel@localhost>  <alpine.DEB.1.10.0812051637360.17806@p34.internal.lan> <1228514942.16555.95.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228514942.16555.95.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 5 Dec 2008, Redeeman wrote:

> On Fri, 2008-12-05 at 16:42 -0500, Justin Piszcz wrote:
>>
>> On Fri, 5 Dec 2008, Redeeman wrote:
>>
>>> On Fri, 2008-12-05 at 16:21 -0500, Justin Piszcz wrote:
>>>>
>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>
>>>>> On Fri, 2008-12-05 at 16:12 -0500, Justin Piszcz wrote:
>>>>>>
>>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>>>
>>>>>>> On Fri, 2008-12-05 at 16:01 -0500, Justin Piszcz wrote:
>>>>>>>>
>>>>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>>>>>
>>> Okay, you happen to have any knowledge to pass on about current 1tb
>>> disks?
>> I am still looking for some good 1TiB drives myself.  I know one user who
>> has 12 of these, 11 in a RAID-5 array and 1 as a spare on a 12-port 3ware
>> PCI-X card:
>> SAMSUNG Spinpoint F1 HD103UJ 1TB 7200 RPM 32MB Cache SATA 3.0Gb/s Hard Drive
> I guess those look pretty good.
>
> i personally am running WD RE2 and Seagate ES.2 in raids without issues
> at all, raid1, but hmm..

Can you show the smartctl -a output for each of the disks in your raids?

