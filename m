From: John Robinson <john.robinson@anonymous.org.uk>
Subject: Re: RAID mirror, resyncing from bad disk
Date: Mon, 14 Sep 2009 10:23:15 +0100
Message-ID: <4AAE0B83.8040009@anonymous.org.uk>
References: <4AAD45AE.6060503@amazinginternet.com> <4AAD5510.2060505@anonymous.org.uk> <4AAE0930.1030204@amazinginternet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4AAE0930.1030204@amazinginternet.com>
Sender: linux-raid-owner@vger.kernel.org
To: Ronny Adsetts <ronny.adsetts@amazinginternet.com>
Cc: Linux RAID ML <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 14/09/2009 10:13, Ronny Adsetts wrote:
> John Robinson said at 13/09/2009 21:24:
>> On 13/09/2009 20:19, Ronny Adsetts wrote:
>> [...]
>>> The problematic array is /dev/md2 and the dying disk is /dev/sdc.
>>>
>>> When I try to resync it gets to about 99.2% then gives load of I/O
>>> errors in /var/log/kern.log and finally gives up and restarts the sync.
>>>
>>> Ideally I just want to tell the system to ignore the bad sector and
>>> just resync the array.
>>>
>>> Does anyone have any ideas on how I can get this resolved short of
>>> reinstalling?
>> You need to ddrescue the contents of the dying drive onto a good one,
>> then replace the dying drive with the fresh one. This will require
>> taking the array down but you won't have to reinstall, unless you've
>> lost something important in the lost sectors on the dying drive.
> 
> The bad sector is thankfully right at the end of the disk in an unallocated part of the LVM setup.
> 
> So, do I ddrescue the entire disk? I assume this will copy everything including the partition table and other gubbins?

Yes you do, and yes it will. You don't have to use ddrescue, there are 
other tools - for examples see 
http://www.forensicswiki.org/wiki/Ddrescue - but ddrescue would be my 
choice.

> Thanks very much, this looks like a winner to me. :-).

Good luck with it!

Cheers,

John.
