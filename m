From: David Greaves <david@dgreaves.com>
Subject: Re: The right way to recover from md partition failure?
Date: Mon, 30 Aug 2004 23:11:07 +0100
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <4133A5FB.9050001@dgreaves.com>
References: <NDBBJAGHALMCJCFDHBILMEPCENAA.jonathan@bakerbates.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <NDBBJAGHALMCJCFDHBILMEPCENAA.jonathan@bakerbates.com>
To: Jonathan Baker-Bates <jonathan@bakerbates.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Jonathan Baker-Bates wrote:

>>-----Original Message-----
>>From: David Greaves [mailto:david@dgreaves.com]
>>Sent: 30 August 2004 22:33
>>To: Guy
>>Cc: 'Jonathan Baker-Bates'; linux-raid@vger.kernel.org
>>Subject: Re: The right way to recover from md partition failure?
>>
>>
>>I think a better approach might be:
>>
>>mdadm /dev/md1 -r /dev/hde3
>>dd if=/dev/hde3 of=/dev/null
>>    
>>
>
>Why the /dev/null-ing?
>  
>
Since you ask I guess you're new at this?
First of be careful - check the dd syntax carefully - it can ruin your 
whole day.
In this case dd goes straight to the hard disk device and pulls data 
from the disk and sends it to /dev/null
The objective is to cause the disk to read every sector in the partition 
and cause the OS to flag any low-level read errors.
If the dd command doesn't produce any errors - CHECK THE LOGS
If it succeeds on a 'retry' then I'd suspect the disk - if you have 
*any* errors - suspect the disk.

>>check logs for nasty errors and only continue if there weren't any :)
>>    
>>
check /var/log/messages and /var/log/kernel
Let us know what they say.

>>mdadm /dev/md1 -a /dev/hde3
>>
>>Having done this very thing this afternoon!!
>>
>>If you have "some console messages about a bad block or something" then
>>I'd make damn sure your disk is good before putting it back.
>>If you end up doing lots of retries during the resync and an error
>>occurs on a remaining drive you'll be sorry!
>>
>>In general a raid failure means you should suspect a disk failure.
>>
>>    
>>
>
>Now it's the issue of making sure the disk is good that was worrying me. How
>do I make sure? Hence my question to Guy about fsck.
>  
>
No
fsck will check to see if the *filesystem* is good - it will be.
To be honest you shouldn't have noticed any problems - the disk failed - 
it happens - that's why you have RAID.
Smile - right now your system would be toast without it.

[Aside: FYI, disk systems are 'layered'.
In your case data (files) lives 'on top' of the filesystem which lives 
on top of the md1 device which lives on top of the /dev/hd?? devices.
The md1 is designed to keep working if either /dev/hd?? fails - so the 
filesystem and your files should never notice.
]

Anyway, of course disks sometimes have glitches (eg if it gets too hot etc).
You should probably go and get smartmon or smarttools (they look at your 
disk's health status)

If you do have errors then shut down if you can and check your cables 
and make sure all your fans are OK.
Reboot and try the dd again.
If you get errors again then you can try changing the IDE cable.
If you *still* have errors then get yourself online and dig out the 
credit-card for a new disk.

David

