From: "Daniel L. Miller" <dmiller@amfes.com>
Subject: Re: Raid-10 mount at startup always has problem
Date: Wed, 24 Oct 2007 22:43:51 -0700
Message-ID: <47202D17.3040000@amfes.com>
References: <46D3147D.2040201@amfes.com> <46D49F1A.7030409@tmr.com> <46E4A39C.8040509@amfes.com> <46E4A5F0.9090407@sauce.co.nz> <46E4A7C3.1040902@amfes.com> <471F5542.3020504@amfes.com> <471FA485.6010705@tmr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <471FA485.6010705@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:
>>>> Daniel L. Miller wrote:
>> Current mdadm.conf:
>> DEVICE partitions
>> ARRAY /dev/.static/dev/md0 level=raid10 num-devices=4 
>> UUID=9d94b17b:f5fac31a:577c252b:0d4c4b2a auto=part
>>
>> still have the problem where on boot one drive is not part of the 
>> array.  Is there a log file I can check to find out WHY a drive is 
>> not being added?  It's been a while since the reboot, but I did find 
>> some entries in dmesg - I'm appending both the md lines and the 
>> physical disk related lines.  The bottom shows one disk not being 
>> added (this time is was sda) - and the disk that gets skipped on each 
>> boot seems to be random - there's no consistent failure:
>
> I suspect the base problem is that you are using whole disks instead 
> of partitions, and the problem with the partition table below is 
> probably an indication that you have something on that drive which 
> looks like a partition table but isn't. That prevents the drive from 
> being recognized as a whole drive. You're lucky, if the data looked 
> enough like a partition table to be valid the o/s probably would have 
> tried to do something with it.
> [...]
> This may be the rare case where you really do need to specify the 
> actual devices to get reliable operation.
OK - I'm officially confused now (I was just unofficially before).  WHY 
is it a problem using whole drives as RAID components?  I would have 
thought that building a RAID storage unit with identically sized drives 
- and using each drive's full capacity - is exactly the way you're 
supposed to!  I should mention that the boot/system drive is IDE, and 
NOT part of the RAID.  So I'm not worried about losing the system - but 
I AM concerned about the data.  I'm using four drives in a RAID-10 
configuration - I thought this would provide a good blend of safety and 
performance for a small fileserver.

Because it's RAID-10 - I would ASSuME that I can drop one drive (after 
all, I keep booting one drive short), partition if necessary, and add it 
back in.  But how would splitting these disks into partitions improve 
either stability or performance?

-- 
Daniel
