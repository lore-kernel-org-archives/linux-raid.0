From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Different sized disks for RAID1+0 or RAID10.
Date: Thu, 11 Oct 2007 11:38:04 -0400
Message-ID: <470E435C.2090703@tmr.com>
References: <2c4919c7d0aa93b6f41a7b2eb1ccd4e5@memcpy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <2c4919c7d0aa93b6f41a7b2eb1ccd4e5@memcpy.com>
Sender: linux-raid-owner@vger.kernel.org
To: kbyrd-linuxraid@memcpy.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kelly Byrd wrote:
> I've currently got a pair of identical drives in a RAID1 set for
> my data partition. I'll be getting a pair of bigger drives in a
> bit, and I was wondering if I could RAID1 those (of course) and
> then RAID0 the two differently sized mds. Even better, will RAID10
> let me do this? 
>   

RAID-10 will let you do this, read past threads of this list for 
discussion of using the "far" option to gain performance.
> I don't need to grow the current RAID1 into this new beast, I've
> got a place I can copy the existing data so I can start from
> scratch.
>
> I imagine the answer is: "sure RAID10 / RAID0 let's you do this,
> but you don't get the striping performance benefit" for some of
> the data", which would be ok with me until the smaller drives go
> bad and I replace them.
>   

Replacing the smaller drives could be an adventure if you plan to go to 
larger replacement drives. I don't recall the issues involved with using 
larger partitions and RAID-10, there's another issue for you to research.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

