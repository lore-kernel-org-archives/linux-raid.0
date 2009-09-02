From: "me at tmr.com" <tmrbill@tmr.com>
Subject: (unknown)
Date: Wed, 2 Sep 2009 14:46:50 -0400
Message-ID: <200909021846.n82Iko5v020720@firewall2.tmr.com>
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
List-Id: linux-raid.ids

Clinton Lee Taylor wrote:
> Greetings ...
>
> 2009/9/2 Bill Davidsen <davidsen@tmr.com>:
>   
>> Clinton Lee Taylor wrote:
>>     
>>> http://www.issociate.de/board/post/498227/Ext3_convert_to_RAID1_....html
>>>
>>> Wanting to convert an already created and populated ext3 filesystem.
>>>
>>> I unmounted the filesystem, ran e2fsck -f /dev/sdb1 to check that the
>>> current filesystem had no errors.
>>> Then ran mdadm --create /dev/md0 --level=1 -n 1 /dev/sdb1 --force to
>>> create the RAID1 device, answered yes to the question.
>>>
>>>       
>> Right here is where you invite problems.
>>     
>  This just a warning or have you had problems doing this?
>
>
> If you don't remember to shrink the filesystem you lose data. The list
> has had tales of woe from people who have done it. I personally
> haven't. Oh, and shrinking a filesystem is not totally without
> possibility of having problems due to hardware or power issues or even
> just a crash.
>
>
> Doing it the other way avoids this, all failures keep the original data safe.
>
> - create an array using the NEW partition
> - make the filesystem on the new array
> - mount the new filesystem
> - copy the data to the new array and verify
> - umount the old partition
> - mount the array on the OLD mount point
> - add the OLD partition to the array and let the system refresh it
>> You want to create the array using
>> the new device or partition, and put a new filesystem on it.
>>     
>  No, I want to convert an existing ext3 to RAID1 partition ...
>   

See above, you want to wind up with the data on an array, preferably 
without modifying the old data until the old data has been moved and 
verified.
>   
>> Read and
>> understand the man page for mke2fs in the stride= and stripe-width=
>> parameters, it shouldn't matter for raid-1 but would if you use raid-[56].
>>     
>  How would striding effect RAID growing or shrinking? Does not the
> striding just effect performance or is it a big problem? Would a RAID
> defragger help?
>
>   
On raid-[456] it can improve performance. I mentioned it because people 
overlook it. And if I were doing this I would use raid-10 to get better 
performance, but that's me.
>> Then mount the array, copy the data to the array, verify it, and then
>> unmount the old partition and add it.
>>     
>  I know this is a tried, tested and accept procedure to
> transfer/transform an existing ext3 partition to a RAID partition, but
> this takes allot of data coping and requires double extra storage ...
>   

You are going to use the NEW partition as part of the array anyway, it 
takes no extra storage.

> What I'm trying to get right, is to create and test a procedure ( with
> audience help and peer review ), to convert an ext3 partition to a
> RAID1, maybe later other RAID, but this is a first step/test ...
>
>   
Using a missing disk component should work with any raid level but 
raid-0.  ;-)
>>> Ran e2fsck -v /dev/md0 to check that the RAID1 device had no
>>> filesystem corruption on it, which it did not.
>>> Added a spared RAID device using mdadm --add /dev/md0 /dev/sdc1
>>> Then grew the RAID1 device to two compents with mdadm --grow /dev/md0
>>> --raid-disks=2 --backup-file=/root/raid1.backup.file
>>>       
>> I have an entry in my raid notes which says that's the wrong thing to do,
>> the array should be created with the correct number of members and one left
>> "missing" to be added later. My note says it should be done that way, but
>> not why it's better, but it says "per Neil" so I bet there is a reason. It
>> does seem to work that way, I just did an adventure in file moving to test
>> it the hard way. I was doing a mix of raid-1, raid-10, and raid-5 arrays
>> moving from little drives (750GB) to larger ones.
>>     
>  Okay, but now we have a big question, creating RAID MD with less
> devices than they should have should only be done with "missing" or
> forced with number of devices?  Could the really Neil stand up now?
> ;-)
>
>   
I'd like to hear at this point, too. I don't want to modify the old 
partition until the new one is working, other than being paranoid is 
there a downside to that?
>>> Did another filesystem check once the RAID finished rebuilding and all
>>> seemed fine.
>>> Double checked that the data on the RAID was the same as the original
>>> data by diffing the two, again all was fine.
>>>
>>>  Now is this just lucky or would this be an acceptable way to convert
>>> an existing ext3 filesystem to RAID1?
>>>       
>> See above, given the resize you didn't mention it's okay, but forget the
>> resize and you risk your data.
>>     
>  Okay, so, you saying that I should make sure that I shrink the ext3
> before try and convert, which is what was comment on before ... I only
> edited out what I thought was not needed for the basic question of
> converting, but, when I write up an article covering this, I will be
> sure to detail that and explain that md metadata version 0.90 puts
> it's metadata at the end of the device, which should be free, after
> the shrink ...
>   


-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc

"Now we have another quarterback besides Kurt Warner telling us during postgame
interviews that he owes every great thing that happens to him on a football
field to his faith in Jesus. I knew there had to be a reason why the Almighty
included a mute button on my remote."
			-- Arthur Troyer on Tim Tebow (Sports Illustrated)

