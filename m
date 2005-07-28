From: Max Waterman <davidmaxwaterman+news@fastmail.co.uk>
Subject: Re: raidreconfig advice
Date: Thu, 28 Jul 2005 10:28:05 +0800
Message-ID: <dc9fsa$r94$1@sea.gmane.org>
References: <4232B49C.6080306@fastmail.co.uk> <42331AC6.6050109@h3c.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <42331AC6.6050109@h3c.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Mike Hardy wrote:
> 
> 
> Max Waterman wrote:
> 
>> OK, I am going to try to expand the capacity of my raid5 array and I 
>> want to make sure I've got it right.
> 
> 
> Not a bad idea, as its all or nothing...
> 
>> Disk /dev/hdg: 200.0 GB, 200049647616 bytes
>> Disk /dev/hdi: 200.0 GB, 200049647616 bytes
>> Disk /dev/hdk: 200.0 GB, 200049647616 bytes
>> Disk /dev/sda: 200.0 GB, 200049647616 bytes
>> Disk /dev/sdb: 200.0 GB, 200049647616 bytes
>> Disk /dev/sdc: 200.0 GB, 200049647616 bytes
>> Disk /dev/sdd: 200.0 GB, 200049647616 bytes
> 
> 
> They certainly all looked the same (including the C/H/S counts)
> 
>> This leaves me with sdc which I can try to add. If that goes OK, I'll 
>> trash the backup and add sd[ab] too.
> 
> 
> I'd be very wary of this, for two reasons. One, you have the backup 
> during the add for a reason. If anything goes wrong, there goes your 
> data. Second, where would you ever back your raid up to? What about fs 
> corruption?
> 
> The rule of thumb with databases is to always have enough contiguous 
> scratch space to dump and restore your biggest table. With large RAID, 
> you should always be able to dump and restore your largest raid device, 
> imho. Its a bunch more disk yes, but you'll need it at some point, I 
> promise. Many future tears can be averted...

I'm not worried about losing my data enough to make regular backups.
I recently thought I'd lost all my data - it wasn't that much of a 
shock. I since discovered I hadn't lost it all, so all is well.

I've made a backup onto a spare array, plus onto one of the 200GB disks 
which I will use as a spare later.

> 
>> 3) Are there any instructions for raidreconfig? I understand is uses 
>> some non-mdadm config files as from/to input.
> 
> 
> the man page is great - honest. Two conf files (current and future) and 
> you're set

Yeah, but I don't know how to use raidconf files. I use mdadm. I 
currently have in my mdadm.conf :

DEVICE /dev/hd[egik]
ARRAY /dev/md0 level=raid5 num-devices=4  devices=/dev/hd[egik]

I think my target mdadm.conf would be :

DEVICE /dev/hd[egik] /dev/sd[abc]
ARRAY /dev/md0 level=raid5 num-devices=7
devices=/dev/hd[egik],/dev/sd[abc]

What are these in raidtab(5) terms?

Max.

