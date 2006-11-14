From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: Recovering from default FC6 install
Date: Tue, 14 Nov 2006 13:34:23 -0500
Message-ID: <455A0C2F.4050603@tmr.com>
References: <4556B86D.3030802@tmr.com> <1163345905.4138.501.camel@fc6.xsintricity.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <1163345905.4138.501.camel@fc6.xsintricity.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Doug Ledford wrote:

>On Sun, 2006-11-12 at 01:00 -0500, Bill Davidsen wrote:
>  
>
>>I tried something new on a test system, using the install partitioning 
>>tools to partition the disk. I had three drives and went with RAID-1 for 
>>boot, and RAID-5+LVM for the rest. After the install was complete I 
>>noted that it was solid busy on the drives, and found that the base RAID 
>>appears to have been created (a) with no superblock and (b) with no 
>>bitmap. That last is an issue, as a test system it WILL be getting hung 
>>and rebooted, and recovering the 1.5TB took hours.
>>
>>Is there an easy way to recover this? The LVM dropped on it has a lot of 
>>partitions, and there is a lot of data in them asfter several hours of 
>>feeding with GigE, so I can't readily back up and recreate by hand.
>>
>>Suggestions?
>>    
>>
>
>First, the Fedora installer *always* creates persistent arrays, so I'm
>not sure what is making you say it didn't, but they should be
>persistent.
>  
>
I got the detail on the md device, then -E on the components, and got a 
"no super block found" message, which made me think it wasn't there. 
Given that, I didn't have much hope for the part which starts "assuming 
that they are persistent" but I do thank you for the information, I'm 
sure it will be useful.

I did try recreating, from the running FC6 rather than the rescue, since 
the large data was on it's own RAID and I could umount the f/s and stop 
the array. Alas, I think a "grow" is needed somewhere, after 
configuration, start, and mount of the f/s on RAID-5, e2fsck told me my 
data was toast. Shortest time to solution was to recreate the f/s and 
reload the data.

The RAID-1 stuff is small, a total rebuild is acceptable in the case of 
a failure.

FC install suggestion: more optional control over the RAID features 
during creation. Maybe there's an "advanced features" button in the 
install and I just missed it, but there should be, since the non-average 
user might be able to do useful things with the chunk size, and specify 
a bitmap. I would think that a bitmap would be the default on large 
arrays, assuming that >1TB is still large for the moment.

Instructions and attachments save for future use, trimmed here.

-- 
bill davidsen <davidsen@tmr.com>
  CTO TMR Associates, Inc
  Doing interesting things with small computers since 1979

