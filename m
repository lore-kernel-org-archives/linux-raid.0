From: Bill Davidsen <davidsen@tmr.com>
Subject: Re: RAID-6 mdadm disks out of sync issue (more questions)
Date: Mon, 15 Jun 2009 11:48:33 -0400
Message-ID: <4A366D51.6020003@tmr.com>
References: <b95d48b03b2756869e786c0982e54f86.squirrel@neil.brown.name> <200906142101.n5EL1Hpj087478@cjb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200906142101.n5EL1Hpj087478@cjb.net>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid.vger.kernel.org@atu.cjb.net
Cc: NeilBrown <neilb@suse.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

linux-raid.vger.kernel.org@atu.cjb.net wrote:
>> This doesn't make a lot of sense.  It should not have been marked
>> as a spare unless someone explicitly tried to "Add" it to the
>> array.
>>
>> However you description of event suggests that this was automatic
>> which is strange.
>>     
>
> Yes, it was entirely automatic.  The only commands I had running on the computer when it happened were:
>
> # watch -n 0.1 'uptime; echo; cat /proc/mdstat|grep md13 -A 2; echo; dmesg|tac'
>
> This gave me a nice, simple display of what was going on with the
> rebuild, and a monitor of dmesg in case there were any new kernel
> messages.
>
>   
>> Can I get the complete kernel logs from when the rebuild started
>> to when you finally gave up?  It might help me understand.
>>     
>
> Sure.
>
> Just to confirm, /dev/sd{a,b,c,d,e,f}1 are the partitions which
> contain my up-to-date data.  /dev/sd{i,j}1 contain many days old data.
>
> Here is the entire dmesg output during the rebuild:
>   
> I left it running for about an hour, and none of the disks had any errors.
> I really hope it is not a permanent fault 75% of the way through the disk.
> Though if it was just bad sectors, why would the disk be disconnecting
> from the system?
>
> Thanks again for all your help.
>
>   

I really don't see any indication that this is a kernel issue, my VM 
host machine has multiple VMs, including this "desktop" system, and runs 
raid5 and raid10, and has had no "ata" messages in 15 days of uptime, 
obviously with lots of disk use. The only thought I do have is that it 
is at least possible that you have a marginal something in your 
hardware, possibly memory, or a controller, and that two things which 
might be useful to check are the memory (memtest) and using 'sensors' to 
monitor heat. I have seen drives which worked fine until you ran them 
hard for 20-30 minutes and then started getting errors (usually seek). 
Just a few things to consider, since you have put this much effort into 
characterizing the problem.

-- 
Bill Davidsen <davidsen@tmr.com>
  Obscure bug of 2004: BASH BUFFER OVERFLOW - if bash is being run by a
normal user and is setuid root, with the "vi" line edit mode selected,
and the character set is "big5," an off-by-one error occurs during
wildcard (glob) expansion.

