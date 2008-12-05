From: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: time limited error recovery and md raid
Date: Fri, 5 Dec 2008 16:42:08 -0500 (EST)
Message-ID: <alpine.DEB.1.10.0812051637360.17806@p34.internal.lan>
References: <1228510646.16555.73.camel@localhost>  <alpine.DEB.1.10.0812051600410.17806@p34.internal.lan>  <1228511266.16555.81.camel@localhost>  <alpine.DEB.1.10.0812051609070.17806@p34.internal.lan>  <1228511880.16555.87.camel@localhost>
 <alpine.DEB.1.10.0812051618340.17806@p34.internal.lan> <1228512684.16555.91.camel@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; format=flowed; charset=US-ASCII
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1228512684.16555.91.camel@localhost>
Sender: linux-raid-owner@vger.kernel.org
To: Redeeman <redeeman@metanurb.dk>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On Fri, 5 Dec 2008, Redeeman wrote:

> On Fri, 2008-12-05 at 16:21 -0500, Justin Piszcz wrote:
>>
>> On Fri, 5 Dec 2008, Redeeman wrote:
>>
>>> On Fri, 2008-12-05 at 16:12 -0500, Justin Piszcz wrote:
>>>>
>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>
>>>>> On Fri, 2008-12-05 at 16:01 -0500, Justin Piszcz wrote:
>>>>>>
>>>>>> On Fri, 5 Dec 2008, Redeeman wrote:
>>>>>>
> Okay, you happen to have any knowledge to pass on about current 1tb
> disks?
I am still looking for some good 1TiB drives myself.  I know one user who 
has 12 of these, 11 in a RAID-5 array and 1 as a spare on a 12-port 3ware
PCI-X card:
SAMSUNG Spinpoint F1 HD103UJ 1TB 7200 RPM 32MB Cache SATA 3.0Gb/s Hard Drive

I really would like to find a disk with a working NCQ implementation in 
Linux and 3ware and one that works well.  In a single disk configuration, 
the WD 750G that I have used for ~1 year+ now has been fine, the problem 
is finding good, reliable disks when used in a raid configuration, that is
when everything changes.

> sorry to ask so much, but by "this process", do you mean the drive
> internally doing it rewriting, avoiding the kickout, or do you mean the
> raid system discovering the disk as faulty, and kicking it? :)
The process being check or repair as noted by mikylie who also responded to
this thread, see his response regarding check vs. repair.  There is a
difference, with check/mdraid see mikylie's note, with RAID VERIFY on a 3ware
controller it will remap bad sectors to others parts of the array as it comes
across them both during RAID VERIFY and while the array is running live.

Justin.

