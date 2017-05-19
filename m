From: Ram Ramesh <rramesh2400@gmail.com>
Subject: Re: How to backup of large md raid volumes?
Date: Thu, 18 May 2017 22:39:59 -0500
Message-ID: <8b840e53-1be2-b1b5-632f-e75f0c6c53b7@gmail.com>
References: <442a4af0-00d2-853d-5294-84ae0353262b@gmail.com>
 <75dc802b-1572-3c6f-ed62-4333deece4c2@websitemanagers.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <75dc802b-1572-3c6f-ed62-4333deece4c2@websitemanagers.com.au>
Sender: linux-raid-owner@vger.kernel.org
To: Adam Goryachev <mailinglists@websitemanagers.com.au>, Linux Raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 05/18/2017 08:34 PM, Adam Goryachev wrote:
> On 19/05/17 07:37, Ram Ramesh wrote:
>> Any one have a method to backup large volumes like md raid6 (16TB)? 
>> Since the backup will not fit in one disk (in many cases and mine 
>> too) I am wondering, if there is a known/easy technique to backup 
>> using multiple usb hard drives. I googed and found a few fancy backup 
>> utils/systems like Amanda etc. They are overkill for me. I am 
>> choosing not to back up simply because of the complexity of setup as 
>> the data in my RAID volume is NOT precious and can be replaced with a 
>> week of effort.
>>
>> If any one can think of some thing simple, please point me to it and 
>> I will do the reading to figure out.
>>
> I suppose it depends on what you want to achieve. There are various 
> options such as mirroring to another raid6 array (ie, RAID60) but 
> really that isn't a backup, it's another replica.
> I use backuppc for my backups, it works well under linux with rsync, 
> I'm sure there are many various options (including amanda which I've 
> used in the past). Ultimately, it depends on your requirements, 
> backups vary significantly depending on needs/etc.
>
> Regards,
> Adam
>
>
Here is a summary of what I like to do. I want to backup files on to 
(multiple) disks that will be loaded on to a USB dock. Simple one to one 
copy is all I am looking for. I am not interested in full vs. 
incremental or keeping versions of files for restore. My data is just 
movies and songs. All I want is a SW that understands links (to avoid 
duplicates) and copy files in batch on to multiple disks. I want content 
of each (backup) disk to be independent. This way if one backup disk 
dies, I have all other files unaffected by this failure. The only reason 
I did not try multi-volume tar is the lack of independence across disks.

I suppose this is a backup question rather than RAID question. I asked 
here because the size of RAID volumes make it impossible to back up to a 
single drive and this is a more common problem RAID world rather than 
general user forum in a backup mailing list.

Ramesh

