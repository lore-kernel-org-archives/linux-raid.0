From: Kelly Byrd <kbyrd-linuxraid@memcpy.com>
Subject: Re: Different sized disks for RAID1+0 or RAID10.
Date: Thu, 11 Oct 2007 09:15:12 -0700
Message-ID: <a7536e3a85cf047191dc21e5a11f00f4@memcpy.com>
References: <470E435C.2090703@tmr.com>
Reply-To: kbyrd-linuxraid@memcpy.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <470E435C.2090703@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids




On Thu, 11 Oct 2007 11:38:04 -0400, Bill Davidsen <davidsen@tmr.com> wrote:
> Kelly Byrd wrote:
>> I've currently got a pair of identical drives in a RAID1 set for
>> my data partition. I'll be getting a pair of bigger drives in a
>> bit, and I was wondering if I could RAID1 those (of course) and
>> then RAID0 the two differently sized mds. Even better, will RAID10
>> let me do this?
>>
> 
> RAID-10 will let you do this, read past threads of this list for
> discussion of using the "far" option to gain performance.
>> I don't need to grow the current RAID1 into this new beast, I've
>> got a place I can copy the existing data so I can start from
>> scratch.
>>

Doesn't the 'far' option trade write performance to gain read
performance? This is a desktop, not at all a "mostly read" type
workload. 


>> I imagine the answer is: "sure RAID10 / RAID0 let's you do this,
>> but you don't get the striping performance benefit" for some of
>> the data", which would be ok with me until the smaller drives go
>> bad and I replace them.
>>
> 
> Replacing the smaller drives could be an adventure if you plan to go to
> larger replacement drives. I don't recall the issues involved with using
> larger partitions and RAID-10, there's another issue for you to research.
> 

Will do.


