From: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Subject: Re: Different sized disks for RAID1+0 or RAID10.
Date: Thu, 11 Oct 2007 19:29:55 +0200
Message-ID: <87ejg11rvw.fsf@informatik.uni-tuebingen.de>
References: <470E435C.2090703@tmr.com>
	<a7536e3a85cf047191dc21e5a11f00f4@memcpy.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <a7536e3a85cf047191dc21e5a11f00f4@memcpy.com> (Kelly Byrd's
	message of "Thu, 11 Oct 2007 09:15:12 -0700")
Sender: linux-raid-owner@vger.kernel.org
To: kbyrd-linuxraid@memcpy.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Kelly Byrd <kbyrd-linuxraid@memcpy.com> writes:

> On Thu, 11 Oct 2007 11:38:04 -0400, Bill Davidsen <davidsen@tmr.com> wrote:
>> Kelly Byrd wrote:
>>> I've currently got a pair of identical drives in a RAID1 set for
>>> my data partition. I'll be getting a pair of bigger drives in a
>>> bit, and I was wondering if I could RAID1 those (of course) and
>>> then RAID0 the two differently sized mds. Even better, will RAID10
>>> let me do this?
>>>
>> 
>> RAID-10 will let you do this, read past threads of this list for
>> discussion of using the "far" option to gain performance.

It will? I don't mean that it will do a raid10 the size of the smaller
disk.

Does raid10 do a 4 disk raid the size of the smaller disks followed by
2 disk raid for the remaining space?

>>> I don't need to grow the current RAID1 into this new beast, I've
>>> got a place I can copy the existing data so I can start from
>>> scratch.
>>>
>
> Doesn't the 'far' option trade write performance to gain read
> performance? This is a desktop, not at all a "mostly read" type
> workload. 

My tests with large files show no degradation in write and nearly
double speed on read. But that might differ for you.

MfG
        Goswin
