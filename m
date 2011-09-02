From: "Timothy D. Lenz" <tlenz@vorgon.com>
Subject: Re: Raid failing, which command to remove the bad drive?
Date: Fri, 02 Sep 2011 08:42:20 -0700
Message-ID: <4E60F95C.40203@vorgon.com>
References: <4E57FE4D.5080503@vorgon.com> <20110827084535.5e64bf5c@notabene.brown> <4E5FC63A.1040206@vorgon.com> <CAEUYfyN6nfEDwgE8_eZN48UFzaJNCN2NjBpJbeQR_G01CYCgvQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAEUYfyN6nfEDwgE8_eZN48UFzaJNCN2NjBpJbeQR_G01CYCgvQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
Cc: Simon Matthews <simon.d.matthews@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids



On 9/1/2011 10:24 PM, Simon Matthews wrote:
> On Thu, Sep 1, 2011 at 10:51 AM, Timothy D. Lenz<tlenz@vorgon.com>  wrote:
>>
>>
>> On 8/26/2011 3:45 PM, NeilBrown wrote:
>>>
>>> On Fri, 26 Aug 2011 13:13:01 -0700 "Timothy D. Lenz"<tlenz@vorgon.com>
>>>   wrote:
>>>
>>>> I have 4 drives set up as 2 pairs.  The first part has 3 partitions on
>>>> it and it seems 1 of those drives is failing (going to have to figure
>>>> out which drive it is too so I don't pull the wrong one out of the case)
>>>>
>>>> It's been awhile since I had to replace a drive in the array and my
>>>> notes are a bit confusing. I'm not sure which I need to use to remove
>>>> the drive:
>>>>
>>>>
>>>>         sudo mdadm --manage /dev/md0 --fail /dev/sdb
>>>>         sudo mdadm --manage /dev/md0 --remove /dev/sdb
>>>>         sudo mdadm --manage /dev/md1 --fail /dev/sdb
>>>>         sudo mdadm --manage /dev/md1 --remove /dev/sdb
>>>>         sudo mdadm --manage /dev/md2 --fail /dev/sdb
>>>>         sudo mdadm --manage /dev/md2 --remove /dev/sdb
>>>
>>> sdb is not a member of any of these arrays so all of these commands will
>>> fail.
>>>
>>> The partitions are members of the arrays.
>>>>
>>>> or
>>>>
>>>> sudo mdadm /dev/md0 --fail /dev/sdb1 --remove /dev/sdb1
>>>> sudo mdadm /dev/md1 --fail /dev/sdb2 --remove /dev/sdb2
>>>
>>> sd1 and sdb2 have already been marked as failed so there is little point
>>> in
>>> marking them as failed again.  Removing them makes sense though.
>>>
>>>
>>>> sudo mdadm /dev/md2 --fail /dev/sdb3 --remove /dev/sdb3
>>>
>>> sdb3 hasn't been marked as failed yet - maybe it will soon if sdb is a bit
>>> marginal.
>>> So if you want to remove sdb from the machine this the correct thing to
>>> do.
>>> Mark sdb3 as failed, then remove it from the array.
>>>
>>>>
>>>> I'm not sure if I fail the drive partition or whole drive for each.
>>>
>>> You only fail things that aren't failed already, and you fail the thing
>>> that
>>> mdstat or mdadm -D tells you is a member of the array.
>>>
>>> NeilBrown
>>>
>>>
>>>
>>>>
>>>> -------------------------------------
>>>> The mails I got are:
>>>> -------------------------------------
>>>> A Fail event had been detected on md device /dev/md0.
>>>>
>>>> It could be related to component device /dev/sdb1.
>>>>
>>>> Faithfully yours, etc.
>>>>
>>>> P.S. The /proc/mdstat file currently contains the following:
>>>>
>>>> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
>>>> md1 : active raid1 sdb2[2](F) sda2[0]
>>>>         4891712 blocks [2/1] [U_]
>>>>
>>>> md2 : active raid1 sdb3[1] sda3[0]
>>>>         459073344 blocks [2/2] [UU]
>>>>
>>>> md3 : active raid1 sdd1[1] sdc1[0]
>>>>         488383936 blocks [2/2] [UU]
>>>>
>>>> md0 : active raid1 sdb1[2](F) sda1[0]
>>>>         24418688 blocks [2/1] [U_]
>>>>
>>>> unused devices:<none>
>>>> -------------------------------------
>>>> A Fail event had been detected on md device /dev/md1.
>>>>
>>>> It could be related to component device /dev/sdb2.
>>>>
>>>> Faithfully yours, etc.
>>>>
>>>> P.S. The /proc/mdstat file currently contains the following:
>>>>
>>>> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
>>>> md1 : active raid1 sdb2[2](F) sda2[0]
>>>>         4891712 blocks [2/1] [U_]
>>>>
>>>> md2 : active raid1 sdb3[1] sda3[0]
>>>>         459073344 blocks [2/2] [UU]
>>>>
>>>> md3 : active raid1 sdd1[1] sdc1[0]
>>>>         488383936 blocks [2/2] [UU]
>>>>
>>>> md0 : active raid1 sdb1[2](F) sda1[0]
>>>>         24418688 blocks [2/1] [U_]
>>>>
>>>> unused devices:<none>
>>>> -------------------------------------
>>>> A Fail event had been detected on md device /dev/md2.
>>>>
>>>> It could be related to component device /dev/sdb3.
>>>>
>>>> Faithfully yours, etc.
>>>>
>>>> P.S. The /proc/mdstat file currently contains the following:
>>>>
>>>> Personalities : [raid1] [raid6] [raid5] [raid4] [multipath]
>>>> md1 : active raid1 sdb2[2](F) sda2[0]
>>>>         4891712 blocks [2/1] [U_]
>>>>
>>>> md2 : active raid1 sdb3[2](F) sda3[0]
>>>>         459073344 blocks [2/1] [U_]
>>>>
>>>> md3 : active raid1 sdd1[1] sdc1[0]
>>>>         488383936 blocks [2/2] [UU]
>>>>
>>>> md0 : active raid1 sdb1[2](F) sda1[0]
>>>>         24418688 blocks [2/1] [U_]
>>>>
>>>> unused devices:<none>
>>>> -------------------------------------
>>
>>
>> Got another problem. Removed the drive and tried to start it back up and now
>> get Grub Error 2. I'm not sure if when I did the mirrors if something when
>> wrong with installing grub on the second drive<  or if is has to do with [U_]
>> which points to sda in that report instead of [_U].
>>
>> I know I pulled the correct drive. I had it labled sdb, it's the second
>> drive in the bios bootup drive check and it's the second connector on the
>> board. And when I put just it in instead of the other, I got the noise
>> again.  I think last time a drive failed it was one of these two drives
>> because I remember recopying grub.
>>
>> I do have another computer setup the same way, that I could put this
>> remaining drive on to get grub fixed, but it's a bit of a pain to get the
>> other computer hooked back up and I will have to dig through my notes about
>> getting grub setup without messing up the array and stuff. I do know that
>> both computers have been updated to grub 2
>
>
> How did you install Grub on the second drive? I have seen some
> instructions on the web that would not allow the system to boot if the
> first drive failed or was removed.
>


I think this is how I did it, at least it is what I had in my notes:

grub-install /dev/sda && grub-install /dev/sdb

And this is from my notes also. It was from an IRC chat. Don't know if 
it was the raid channel or the grub channel:

[14:02] <Jordan_U> Vorg: No. First, what is the output of grub-install 
--version?
[14:02] <Vorg>  (GNU GRUB 1.98~20100115-1)
[14:04] <Jordan_U> Vorg: Ok, then run "grub-install /dev/sda && 
grub-install /dev/sdb" (where sda and sdb are the members of the array)
