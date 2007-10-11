From: Neil Brown <neilb@suse.de>
Subject: Re: Different sized disks for RAID1+0 or RAID10.
Date: Fri, 12 Oct 2007 08:25:22 +1000
Message-ID: <18190.41682.966138.35268@notabene.brown>
References: <2c4919c7d0aa93b6f41a7b2eb1ccd4e5@memcpy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: message from Kelly Byrd on Wednesday October 10
Sender: linux-raid-owner@vger.kernel.org
To: kbyrd-linuxraid@memcpy.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday October 10, kbyrd-linuxraid@memcpy.com wrote:
> 
> I've currently got a pair of identical drives in a RAID1 set for
> my data partition. I'll be getting a pair of bigger drives in a
> bit, and I was wondering if I could RAID1 those (of course) and
> then RAID0 the two differently sized mds. Even better, will RAID10
> let me do this? 
> 
> I don't need to grow the current RAID1 into this new beast, I've
> got a place I can copy the existing data so I can start from
> scratch.
> 
> I imagine the answer is: "sure RAID10 / RAID0 let's you do this,
> but you don't get the striping performance benefit" for some of
> the data", which would be ok with me until the smaller drives go
> bad and I replace them.

RAID0 happily handles devices of different sizes and uses all the
available space.
RAID10 will only use as much space off each device as the smallest
device allows.

So you should have 2 RAID1 arrays of different sizes, and use RAID0 to
combine them.
Don't use RAID10.

NeilBrown
