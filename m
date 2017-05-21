From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: How to backup of large md raid volumes?
Date: Sun, 21 May 2017 14:48:01 -0500
Message-ID: <aa7ddea5-f700-a41f-8782-cd0fa6ffe7f9@gmail.com>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
 <75dc802b-1572-3c6f-ed62-4333deece4c2@websitemanagers.com.au>
 <8b840e53-1be2-b1b5-632f-e75f0c6c53b7@gmail.com>
 <95546cb8-e195-a693-f4c8-e8b250cec30e@cas.homelinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <95546cb8-e195-a693-f4c8-e8b250cec30e@cas.homelinux.org>
Sender: linux-raid-owner@vger.kernel.org
To: Linux Raid <linux-raid@vger.kernel.org>
Cc: Chris Schanzle <mdadm@cas.homelinux.org>
List-Id: linux-raid.ids

On 05/21/2017 12:04 PM, Chris Schanzle wrote:
> On 05/18/2017 11:39 PM, Ram Ramesh wrote:
>> On 05/18/2017 08:34 PM, Adam Goryachev wrote:
>>> On 19/05/17 07:37, Ram Ramesh wrote:
>>>> Any one have a method to backup large volumes like md raid6 (16TB)? 
>>>> Since the backup will not fit in one disk (in many cases and mine 
>>>> too) I am wondering, if there is a known/easy technique to backup 
>>>> using multiple usb hard drives. I googed and found a few fancy 
>>>> backup utils/systems like Amanda etc. They are overkill for me. I 
>>>> am choosing not to back up simply because of the complexity of 
>>>> setup as the data in my RAID volume is NOT precious and can be 
>>>> replaced with a week of effort.
>>>>
>>>> If any one can think of some thing simple, please point me to it 
>>>> and I will do the reading to figure out.
>>>>
>>> I suppose it depends on what you want to achieve. There are various 
>>> options such as mirroring to another raid6 array (ie, RAID60) but 
>>> really that isn't a backup, it's another replica.
>>> I use backuppc for my backups, it works well under linux with rsync, 
>>> I'm sure there are many various options (including amanda which I've 
>>> used in the past). Ultimately, it depends on your requirements, 
>>> backups vary significantly depending on needs/etc.
>>>
>>> Regards,
>>> Adam
>>>
>>>
>> Here is a summary of what I like to do. I want to backup files on to 
>> (multiple) disks that will be loaded on to a USB dock. Simple one to 
>> one copy is all I am looking for. I am not interested in full vs. 
>> incremental or keeping versions of files for restore. My data is just 
>> movies and songs. All I want is a SW that understands links (to avoid 
>> duplicates) and copy files in batch on to multiple disks. I want 
>> content of each (backup) disk to be independent. This way if one 
>> backup disk dies, I have all other files unaffected by this failure. 
>> The only reason I did not try multi-volume tar is the lack of 
>> independence across disks.
>>
>> I suppose this is a backup question rather than RAID question. I 
>> asked here because the size of RAID volumes make it impossible to 
>> back up to a single drive and this is a more common problem RAID 
>> world rather than general user forum in a backup mailing list.
>>
>> Ramesh
>
> Thanks for the additional info on your requirements.
>
> Rsync will be your best/fastest tool, as writing 16 TB of data over 
> USB will likely take days for a full backup...and that seems silly 
> when you probably already have 90% of the data already.
>
> If one drive failures are a concern, why not use RAID5 for your group 
> of USB backup disks?  Might take you a bit more effort 
> starting/stopping the array, but I'm sure you'll enjoy the large 
> single volume/filesystem in the long run.   Use a fairly large 
> --chunk= size for your large files.  I have had very positive 
> experience with XFS for large multimedia filesystems (mythtv user and 
> 20TB backup servers).
> If the drives you choose to use are desktop grade, be sure to increase 
> the timeouts.  Search this list archives for Chris Murphy's subject: 
> "Re: URE, link resets, user hostile defaults".
>
The only problem with raid is that all disks need to be present to 
create md. I only have the ability to load two disks and the disks are 
fairly small compared to RAID l (3TB vs. 16TB) So RAID5 won't work. 
Besides, I do not want to use RAID to backup RAID as my worry is md 
going bad and preventing access to my files. It is not disk that I am 
worried about mdadm layout and requirement that many disk to be alive to 
get even one file.

