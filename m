From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Removing drives
Date: Wed, 28 Apr 2010 19:55:10 -0700
Message-ID: <4BD8F50E.8070505@vorgon.com>
References: <4B8F26AF.7080308@vorgon.com>	 <4877c76c1003041445g2ac9aaf6ua5fac64db975da1@mail.gmail.com>	 <4B9154C0.7060200@vorgon.com>	 <4877c76c1003051222i584bdb19r65002981060a6360@mail.gmail.com>	 <4B91DF69.5030804@vorgon.com>	 <4877c76c1003052243r790e0528v71efe38038bfafeb@mail.gmail.com>	 <4B934FB2.3080104@vorgon.com>	 <4877c76c1003062333r13d83d6atd85d004a56218c7a@mail.gmail.com>	 <4B93F209.9030901@vorgon.com> <4877c76c1003071249y69368e2bt2f2c70dd0274df8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4877c76c1003071249y69368e2bt2f2c70dd0274df8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 3/7/2010 1:49 PM, Michael Evans wrote:
> On Sun, Mar 7, 2010 at 10:35 AM, Timothy D. Lenz<tlenz@vorgon.com>  wrote:
>>
>>
>> On 3/7/2010 12:33 AM, Michael Evans wrote:
>>>
>>> On Sat, Mar 6, 2010 at 11:03 PM, Timothy D. Lenz<tlenz@vorgon.com>    wrote:
>>>>
>>>>
>>>> On 3/5/2010 11:43 PM, Michael Evans wrote:
>>>>>
>>>>> On Fri, Mar 5, 2010 at 8:51 PM, Timothy D. Lenz<tlenz@vorgon.com>
>>>>>   wrote:
>>>>>>
>>>>>>
>>>>>> On 3/5/2010 1:22 PM, Michael Evans wrote:
>>>>>>>
>>>>>>> On Fri, Mar 5, 2010 at 11:00 AM, Timothy D. Lenz<tlenz@vorgon.com>
>>>>>>>   wrote:
>>>>>>>>
>>>>>>>> Current setup, 3 500gb sata drives, each with 3 partitions.
>>>>>>>> The first partition of each drive make up raid1 md0 boot and most
>>>>>>>> software
>>>>>>>> The next partition of each drive make up raid1 md1 swap
>>>>>>>> The 3rd partition of each drive make up raid5 md2 main data storage
>>>>>>>>
>>>>>>>> There is also a 40gb ide drive with 2 partitions, boot/software and
>>>>>>>> swap.
>>>>>>>> It
>>>>>>>> was used for install and setup. But I never got boot changed over to
>>>>>>>> md0.
>>>>>>>> So
>>>>>>>> currently md0 is not in use. md0 and md2 are mounted to folders on
>>>>>>>> the
>>>>>>>> 40gb
>>>>>>>> so a precopy to md0 could be made before booting with a cd and
>>>>>>>> copying
>>>>>>>> what
>>>>>>>> ever is left that needs coping. and to use md2.
>>>>>>>>
>>>>>>>> Current
>>>>>>>> # /etc/fstab: static file system information.
>>>>>>>> #
>>>>>>>> #<file system>        <mount point>           <type>          <options>
>>>>>>>> <dump>
>>>>>>>>   <pass>
>>>>>>>> proc            /proc           proc    defaults        0       0
>>>>>>>> /dev/hda1       /               ext3    defaults,errors=remount-ro 0
>>>>>>>>    1
>>>>>>>> /dev/hda5       none            swap    sw              0       0
>>>>>>>> /dev/md0        /mnt/md0        ext3    defaults        0       0
>>>>>>>> /dev/md2        /mnt/md2        ext3    defaults        0       0
>>>>>>>> /dev/hdb        /media/cdrom0   udf,iso9660 user,noauto     0       0
>>>>>>>> /dev/fd0        /media/floppy0  auto    rw,user,noauto  0       0
>>>>>>>>
>>>>>>>> I want to change md0 and md1 from 3 drive mirriors to 2 drive
>>>>>>>> mirrors.
>>>>>>>>
>>>>>>>> Finish changing over to booting from md0, move swap to md1 and move
>>>>>>>> the
>>>>>>>> mount point for md2 to md0
>>>>>>>>
>>>>>>>> Remove the the ide drive to free up space for the 4th 500gb drive.
>>>>>>>>
>>>>>>>> Copy md2 over to the new 500gb temparally.
>>>>>>>>
>>>>>>>> Get rid of the current md2 freeing up the 3rd drive since it was
>>>>>>>> already
>>>>>>>> taken out of the mirrors above.
>>>>>>>>
>>>>>>>> Make a new md2 raid1 with the remaining space of the first 2 sata
>>>>>>>> drives.
>>>>>>>>
>>>>>>>> Move the data from the 4th drive back to the new md2
>>>>>>>>
>>>>>>>> Repartition the 3rd drive to 1 partition same as the 4th drive.
>>>>>>>>
>>>>>>>> Make raid1 md3 from the 3rd and 4th drives.
>>>>>>>>
>>>>>>>> It's the steps/commands to change md0 and md1 from 3 drive mirrors to
>>>>>>>> 2
>>>>>>>> drive mirrors that I'm not sure about. Though now looking at fstab I
>>>>>>>> see
>>>>>>>> I
>>>>>>>> never even switched over the swap. So I guess, those to arrays would
>>>>>>>> be
>>>>>>>> rebuilt. So it's more how to do that without messing with md2.
>>>>>>>>
>>>>>>>> The computer is still on grub1. I haven't updated it it.
>>>>>>>>
>>>>>>>
>>>>>>> So you have:
>>>>>>>
>>>>>>> [3-devices]
>>>>>>> Raid 1: Unused
>>>>>>> Raid 1: Unused
>>>>>>> Raid 5: Used - 3 disks
>>>>>>>
>>>>>>> [1-device]
>>>>>>> Boot + swap
>>>>>>>
>>>>>>> Just swapoff the raid-swap you want to re-create, then:
>>>>>>> mdadm -S /dev/md(swap)
>>>>>>> mdadm -S /dev/md(boot)
>>>>>>> mdadm --zero-superblock /dev/devices in those arrays
>>>>>>>
>>>>>>> Repartition those two areas of the disks as necessary.
>>>>>>>
>>>>>>> Create new boot and swap partitions.
>>>>>>> For boot make SURE you use either -e 0.90 OR -e 1.0 .   Given the
>>>>>>> nature of /boot I'd say use -e 0.90 on it.
>>>>>>> For everything else, including swap use -e 1.1 and optionally
>>>>>>> write-intent bitmaps.
>>>>>>>
>>>>>>> At this point you should be able to move /boot and your swap off of
>>>>>>> the 40gb drive; just remember to re-install grub and that your BIOS
>>>>>>> likely sets the boot drive as bios-drive 0 regardless of which SDA/HDA
>>>>>>> linux sees it as.  This is what the device.map file is used to tell
>>>>>>> grub.
>>>>>>>
>>>>>>>
>>>>>>> I lost exactly what you wanted the result to look like amid a long
>>>>>>> list of steps you /thought/ you needed to make to get there and
>>>>>>> references to md numbers that only have meaning to you.  However it
>>>>>>> seems that you were mostly stuck getting to this point, so you might
>>>>>>> be able to determine a plan using the data you've yet to share with
>>>>>>> the rest of us with that 40gb drive out of the equation.
>>>>>>>
>>>>>>> Remember that you can't reshape raid10 yet, but you can start raid10
>>>>>>> with 'missing' devices (and add in the spares later).
>>>>>>>
>>>>>>
>>>>>> can't make it much clearer, and I don't know where you got raid10 from.
>>>>>>
>>>>>> ARRAY /dev/md0 level=raid1 num-devices=3
>>>>>> UUID=e4926be6:8d6f08e5:0ab6b006:621c4ec0
>>>>>> ARRAY /dev/md1 level=raid1 num-devices=3
>>>>>> UUID=eac96451:66efa3ab:0ab6b006:621c4ec0
>>>>>> ARRAY /dev/md2 level=raid5 num-devices=3
>>>>>> UUID=a7ed721e:04b10ab6:0ab6b006:621c4ec0
>>>>>>
>>>>>> md 0 and 1 I want to change to 2 deivces.
>>>>>> Then get it booting from md0 which I think I know how to do as I got
>>>>>> another
>>>>>> computer working that way. Then I can dump the ide drive making room
>>>>>> for
>>>>>> another 500gb sata. It will be used to store the data from md2 while
>>>>>> md2
>>>>>> is
>>>>>> remade from a 3 device raid5 to a 2 device raid1. This frees up a drive
>>>>>> giving me 2 500gb drives to make another 2 device raid1. Its the
>>>>>> seperating
>>>>>> out 1 device from each of the current raid1's, md0 and md1 that I was
>>>>>> asking
>>>>>> about.
>>>>>>
>>>>>
>>>>> That was concise enough to be worth reading through to get your desired
>>>>> result.
>>>>>
>>>>> I already told you how to do the safe portion of your last operation.
>>>>>
>>>>> Actually, I can see one benefit from two raid 1s over raid10; you
>>>>> could stripe them using LVM and for very little extra cost have a lot
>>>>> more flexibility.
>>>>>
>>>>> After you've followed my last email to get the system booting off your
>>>>> raid devices, you can replace the 40 with a 500, and then use the
>>>>> /new/ 500 to start a raid 1 with one device set as 'missing'.
>>>>> StartSlower but totally safe way:
>>>>>
>>>>> However what I'd do if I were you is get everything I could off of the
>>>>> 40gb drive; it would only take 10 DVDs at worse case; presuming it
>>>>> won't fit within ~500gb.
>>>>>
>>>>> 1) Duplicate all your data from the raid5 on to the single disk in a
>>>>> raid 1 + missing configuration.
>>>>> * you now have 1 copy with parity, and 1 copy waiting for mirroring.
>>>>> (two copies and some parity)
>>>>>
>>>>> 2) Fail one of the partitions from the raid5, --zero superblock it.
>>>>> * you now have 1 copy without parity, and 1 copy waiting for
>>>>> mirroring, and one free drive. (two copies)
>>>>>
>>>>> 3) --add the previous parity partition as part of the mirror set; IT
>>>>> MUST BE>= the size of the other partition in that mirror.
>>>>> * You have 1 copy without parity, 1 full copy being mirrored in to two
>>>>> copies.
>>>>>
>>>>> 4) WAIT for the mirroring operation to finish.
>>>>>
>>>>> 5) Optionally 'check' the mirror copy.
>>>>> * You now have 1 copy without parity, 1 fully mirrored copy (3 copies
>>>>> of your data)
>>>>>
>>>>> 6) With a fully safe copy of your data, and two partitions you can
>>>>> start a wider range of procedures.
>>>>>
>>>>> You could create two more raid 1 + missing arrays
>>>>> setup LVM with striping across them
>>>>> copy your data over in to one logical volume
>>>>> ++THEN AGAIN in to a second logical volume
>>>>> (Manually creating two copies of your data; this won't protect against
>>>>> drive failure but it will protect against individual failed sectors,
>>>>> which may be good enough.)
>>>>> Finally one at a time fail out members of the intact raid1 set and add
>>>>> them to the new raid 1s.
>>>>>
>>>>>
>>>>> Or probably proceed through other ideas; though none seems as
>>>>> appealing to me as what I just wrote; 4 drives isn't enough to
>>>>> seriously consider raid 5 or 6, and with the size of the drives you'd
>>>>> really be better off with going for raid 6, which is much slower and
>>>>> only slightly less risky than raid 1 + striping via LVM.
>>>>>
>>>>
>>>> I don't need to combine the two large arrays. They are mostly for storing
>>>> recordings for vdr. With vdr, the storage folders are video0, video1,
>>>> video2,... and you provide the path to video0 with the others being in
>>>> the
>>>> same parent folder. When it records, it sends the file to the folder with
>>>> the most free space and if that is not video0, then video0 gets a link to
>>>> where it really is.
>>>>
>>>>
>>>> I don't understand where "For boot make SURE you use either -e 0.90 OR -e
>>>> 1.0 ." comes in. When I partitioned the drives, I set them all to type
>>>> fd.
>>>> and made the first partition of each drive bootable. To create the arrays
>>>> I
>>>> used:
>>>> sudo mdadm --create /dev/md0 --level=1 --raid-devices=2 /dev/sda1
>>>> /dev/sdb1
>>>> --spare-devices=1 /dev/sdc1
>>>> sudo mdadm --create /dev/md1 --level=1 --raid-devices=2 /dev/sda2
>>>> /dev/sdb2
>>>> --spare-devices=1 /dev/sdc2
>>>>
>>>> And to format them:
>>>> sudo mkfs.ext3 /dev/md0
>>>> sudo mkswap /dev/md1
>>>>
>>>> Latter I used grow to change from a spare to a 3 way mirror.
>>>>
>>>
>>> Please, reply to ALL or manually add the list back to the message.
>>>
>>> You'll want the two types I specified for any boot device since it
>>> then appears to be a normal partition that happens to have an exact
>>> copy on another partition, except for a little bit at the end which is
>>> where the raid metadata is.
>>>
>>> For that same reason, using mdadm 1.1 or 1.2 would be preferable for
>>> any devices which are not directly used for boot.  Those place the
>>> data at the beginning thus ensuring that any set of layering
>>> (raid/lvm/filesystems) gets unpacked in the correct order since there
>>> is no question how they are stacked.
>>>
>>> Also, I don't really see how that changes the directions for getting
>>> your smaller drive out of the system so that you can proceed.  It
>>> sounds like you'll probably be able to adapt the steps to suit your
>>> needs and you've not actually told any of us what you're confused
>>> about or still have a problem with.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>
>>
>> First, with the other list I'm on, simply doing a reply replies back to the
>> list. This one for some reason forwards the responders email for the reply
>> to. I was in a hurry and forgot to put the right address back
>>
>> Next, you have now confused me with the part:
>>> You'll want the two types I specified for any boot device since it
>>> then appears to be a normal partition that happens to have an exact
>> Two types of what? To make both drives of the boot array bootable I have
>> been doing:
>>   sudo grub
>>   grub>device (hd0) /dev/sda
>>   grub>root (hd0,0)
>>   grub>setup (hd0)
>>
>>   grub>device (hd0) /dev/sdb
>>   grub>root (hd0,0)
>>   grub>setup (hd0)
>>
>> That was done after the array was made. That worked for the other computer I
>> setup which has 2 sata drives and raid1 for all 3 partitions. It has been
>> booting ok for nearly a year. I did just update it from lenny to testing and
>> started the change to grub2. It is now booting using chain to grub1.
>>
>> And what I was asking about in the last message was when you said:
>> "For boot make SURE you use either -e 0.90 OR -e 1.0 ."
>> Are those mdadm switches to use older version methods?
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>
> Yes, those are switches to the mdadm command; PLEASE RTFM: man mdadm .
>
> After reading the full manual (yeah, there's a 'fun' expansion too)
> most of the easy questions will already be answered.
>
> Grub2 / grub 2.0 / 'grub not legacy' , as I've stated, wants to see
> version 0.90 metadata for /boot .
>
> Installing grub is off topic for this mailing list, but you should be
> able to find documentation in the places you should expect to look.
>
> I have not yet experienced booting grub2 from mirrored devices, but
> the above information is what I have gleaned from various previous
> posts to the two related mailing lists.
>
> Remember to read the f* manuals.
>

This partly goes back to another thread when I started trying to switch 
these 2 computer to raid: Converting system to raid

I still seem to be having problems with the one with 3 sata drives 
running 64bit linux. It is still on the same kernel and files the 32bit 
one was when I switched it. To recap, I had set the 3 drive up with 
first 2 partitions of the first two drives to mirrors with the first 2 
of the 3rd as spares. The 3 partition of each drive formed a raid5 
array. I used a GRML boot disk to rsync the files from hda1, the current 
boot to md0 (sda1/sdb1/sdc1) and booted back to hda1. changed 
/mnt/md0/boot/grub/menu.lst and /mnt/md0/etc/fstab for raid boot, then 
restarted, moved the pata hard drive to the bottom of the list in cmos 
boot menu and then TRIED to boot to raid. With the 32bit system, that 
worked, but it only had 2 sata drives with md2 being a mirror instead of 
raid 5. What I get with the 3 drive was/is:
Grub loading stage 1.5
Grub loading, please wait
Error 2

It was thought it was because of the spares, so I added them in making 
the first 2 partitions 3-way mirrors. But things got busy and I never 
got to try booting to raid. Then I got a 4th drive and this thread 
started. Now I'm trying again to get this 64bit to raid boot. I removed 
SDC1 and SDC2 from their mirrors changing those back to 2-way. I 
zerrowed the superblock on both partitions and changed sdc1 boot flag 
back to not bootable. Still get the same error. Used fdisk to remove 
sdc1 and sdc2 leaving just sdc3 which is still part of md2 raid 5. I 
also redid the steps to make md0 bootable.

  sudo grub
  grub>device (hd0) /dev/sda
  grub>root (hd0,0)
  grub>setup (hd0)

  grub>device (hd0) /dev/sdb
  grub>root (hd0,0)
  grub>setup (hd0)

I still end up at error 2. Raid support should be built into the kernel, 
same as the 32bit system was. I'm at a loss to what I'm missing that it 
worked on the 32bit but not the 64 bit. Both systems even have the same 
motherboard and basicly the same cpu, cept the 32bit is a little faster 
clock.
