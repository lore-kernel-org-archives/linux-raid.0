From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Different sized disks for RAID1+0 or RAID10.
Date: Fri, 12 Oct 2007 12:08:08 -0400
Message-ID: <470F9BE8.1060008@tmr.com>
References: <470E435C.2090703@tmr.com>	<a7536e3a85cf047191dc21e5a11f00f4@memcpy.com> <87ejg11rvw.fsf@informatik.uni-tuebingen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87ejg11rvw.fsf@informatik.uni-tuebingen.de>
Sender: linux-raid-owner@vger.kernel.org
To: Goswin von Brederlow <brederlo@informatik.uni-tuebingen.de>
Cc: kbyrd-linuxraid@memcpy.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Goswin von Brederlow wrote:
> Kelly Byrd <kbyrd-linuxraid@memcpy.com> writes:
>
>   
>> On Thu, 11 Oct 2007 11:38:04 -0400, Bill Davidsen <davidsen@tmr.com> wrote:
>>     
>>> Kelly Byrd wrote:
>>>       
>>>> I've currently got a pair of identical drives in a RAID1 set for
>>>> my data partition. I'll be getting a pair of bigger drives in a
>>>> bit, and I was wondering if I could RAID1 those (of course) and
>>>> then RAID0 the two differently sized mds. Even better, will RAID10
>>>> let me do this?
>>>>
>>>>         
>>> RAID-10 will let you do this, read past threads of this list for
>>> discussion of using the "far" option to gain performance.
>>>       
>
> It will? I don't mean that it will do a raid10 the size of the smaller
> disk.
>   

Unfortunately I did, you have to do some multi-level approach to use all 
the space, the raid-10 is smart enough to handle an odd number of drives 
without hints, but not different size drives or partitions. The obvious 
solution is to make two raid-1 arrays and do raid-0 over them.

If you want to be a bit esoteric in search for a bit of extra read 
performance, consider this:
 hda1 - all of small drive 1
 hdb1 - all of small drive 2
 hdc1 - first part of large drive, same size as hda1
 hdd1 - as hdc1
 hdc2 - rest of 1st large drive
 hdd2 - rest of 2nd large drive

Now, raid-10 hd[abcd]1 and raid-10 hd[cd]2 (both with far), then use 
linear with the four drive array first. My thinking is this, unless the 
filesystem is full, most of the data and head motion will be on the four 
way raid-10, which should be somewhat faster than just raid-1+0. It will 
also put the journal and inodes on the four drives which should help.

The growth path is a tad complex when the small drives are upgraded to 
large, but the new drive can be partitioned like hdc, the first raid-10 
can be recovered, and then the 2nd grown.
> Does raid10 do a 4 disk raid the size of the smaller disks followed by
> 2 disk raid for the remaining space?
>   

Unfortunately not. :-(
>   
>>>> I don't need to grow the current RAID1 into this new beast, I've
>>>> got a place I can copy the existing data so I can start from
>>>> scratch.
>>>>
>>>>         
>> Doesn't the 'far' option trade write performance to gain read
>> performance? This is a desktop, not at all a "mostly read" type
>> workload. 
>>     
>
> My tests with large files show no degradation in write and nearly
> double speed on read. But that might differ for you.
>   

Sounds right, unless you write a ton caching covers any slight slowing, 
which I can measure as ~5% with benchmarks but never see in real life.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

