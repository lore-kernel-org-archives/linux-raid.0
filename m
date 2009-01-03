From: Bernd Schubert <bs@q-leap.de>
Subject: Re: Corrupt data - RAID sata_sil 3114 chip
Date: Sat, 3 Jan 2009 22:11:47 +0100
Message-ID: <20090103211147.GA3707@lanczos.q-leap.de>
References: <200901032104.15242.bs@q-leap.de> <495FD035.8080501@shaw.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <495FD035.8080501@shaw.ca>
Sender: linux-raid-owner@vger.kernel.org
To: Robert Hancock <hancockr@shaw.ca>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Justin Piszcz <jpiszcz@lucidpixels.com>, debian-user@lists.debian.org, linux-raid@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-raid.ids

On Sat, Jan 03, 2009 at 02:53:09PM -0600, Robert Hancock wrote:
> Bernd Schubert wrote:
>> [sorry sent again, since Robert dropped all mailing list CCs and I 
>> didn't notice first]
>>
>> On Sat, Jan 03, 2009 at 12:31:12PM -0600, Robert Hancock wrote:
>>> Bernd Schubert wrote:
>>>> On Sat, Jan 03, 2009 at 01:39:36PM +0000, Alan Cox wrote:
>>>>> On Fri, 2 Jan 2009 22:30:07 +0100
>>>>> Bernd Schubert <bs@q-leap.de> wrote:
>>>>>
>>>>>> Hello Bengt,
>>>>>>
>>>>>> sil3114 is known to cause data corruption with some disks. 
>>>>> News to me. There are a few people with lots of SI and other devices
>>>> No no, you just forgot about it, since you even reviewed the patches ;)
>>>>
>>>> http://lkml.org/lkml/2007/10/11/137
>>> And Jeff explained why they were not merged:
>>>
>>> http://lkml.org/lkml/2007/10/11/166
>>>
>>> All the patch does is try to reduce the speed impact of the 
>>> workaround.  But as was pointed out, they don't reliably solve the 
>>> problem the  workaround is trying to fix, and besides, the workaround 
>>> is already not  applied to SiI3114 at all, as it is apparently not 
>>> applicable on that  controller (only 3112).
>>
>> Well, do they reliable solve the problem in our case (before taking the patch
>> into production I run a checksum tests for about 2 weeks). Anyway, I entirely
>> understand the patches didn't get accepted. 
>>
>> But now more than a year has passed again without doing anything
>> about it and actually this is what I strongly criticize. Most people don't
>> know about issues like that and don't run file checksum tests as I now always
>> do before taking a disk into production. So users are exposed to known
>> data corruption problems without even being warned about it. Usually
>> even backups don't help, since one creates a backup of the corrupted data.
>>
>> So IMHO, the driver should be deactived for sil3114 until a real 
>> solution is found. And it only should be possible to force activate it 
>> by a kernel flag, which then also would print a huuuge warning about 
>> possible data corruption (unfortunately most distributions disables 
>> inital kernel messages *grumble*).
>
> If the corruption was happening on all such controllers then people  
> would have been complaining in droves and something would have been  
> done. It seems much more likely that in this case the problem is some  
> kind of hardware fault or combination of hardware which is causing the  
> problem. Unfortunately these kind of not-easily-reproducible issues tend  
> to be very hard to track down.
>

Well yes, it only happens with certain drives. But these drives work fine on
other controllers. But still these are by now 
known issues and nothing is done for that.
I would happily help to solve the problem, I just don't have any knowledge 
about hardware programming. What would be your next step, if you had remote
access to such a system? 

Thanks,
Bernd
