From: =?ISO-8859-1?Q?Ralf_M=FCller?= <ralf@bj-ig.de>
Subject: Re: Replace drive in RAID5 without losing redundancy?
Date: Tue, 6 Mar 2007 10:18:13 +0100
Message-ID: <A7E5669B-057D-493A-BF5C-F2324AD80136@bj-ig.de>
Mime-Version: 1.0 (Apple Message framework v752.3)
Content-Type: text/plain; charset=US-ASCII; delsp=yes; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids


Am 05.03.2007 um 23:29 schrieb Neil Brown:

> On Monday March 5, ralf@bj-ig.de wrote:
>>
>> Is it possible to mark a disk as "to be replaced by an existing  
>> spare",
>> then migrate to the spare disk and kick the old disk _after_  
>> migration
>> has been done? Or not even kick - but mark as new spare.
>
> No, this is not possible yet.

It's a pity - this would be a cool feature. It would take a lot of
worrying out of RAID5 maintenance. Even when you have a backup it takes
hours over hours to rebuild data from it when you crash a big RAID.  
Do you
know if such a thing is on a ToDo list somewhere?

> You can get nearly all the way there by:
>
>   - add an internal bitmap.
> [ ... ]
>   - disassemble the raid1
>   - re-add the new drive to the raid5
> However that won't work as the superblock will be in the wrong place
> on the new drive.
> It wouldn't be hard to relocate the superblock, but there currently is
> no code to do this.

There has been an idea in PM to initially create the RAID5 out of  
RAID1's
with only one disk. For migration one could add a disk to one of the  
RAID1's,
let it sync and fail out the old disk. The question left had been if  
a RAID1
with only one disk would propagate read errors to the RAID5 above -  
so that
the RAID5 is be able to rewrite this sector - or simply fail the single
drive left.

Best regards
Ralf Mueller

-- 
Van Roy's Law: -------------------------------------------------------
        An unbreakable toy is useful for breaking other toys.


