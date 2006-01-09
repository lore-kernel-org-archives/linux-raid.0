From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: [linux-lvm] Re: more info on the hang with 2.6.15-rc5
Date: Mon, 09 Jan 2006 16:35:32 +0000
Message-ID: <43C290D4.5030209@projecthugo.co.uk>
References: <E1EpIfb-0001e2-GR@highlab.com> <43C1580B.9020609@tmr.com> <E1Evmqw-0001pO-Ng@highlab.com> <43C28E52.8080104@mattgillen.net>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C28E52.8080104@mattgillen.net>
Sender: linux-raid-owner@vger.kernel.org
To: Matthew Gillen <me@mattgillen.net>
Cc: LVM general discussion and development <linux-lvm@redhat.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Matthew Gillen wrote:

>Sebastian Kuzminsky wrote:
>  
>
>>Bill Davidsen <davidsen@tmr.com> wrote:
>>
>>    
>>
>>>Sebastian Kuzminsky wrote:
>>>
>>>
>>>      
>>>
>>>>Now it works, but I dont trust it one bit.
>>>>
>>>>I had been seeing almost immediate, perfectly repeatable hard lockups
>>>>in 2.6.15-rc5 and 2.6.15-rc5-mm3, when using sata_mv, RAID, and LVM
>>>>together.  Nothing in the syslog or on the console, and the system is
>>>>totally unresponsive to the keyboard & network.
>>>>
>>>>My hardware setup is: four Seagate Barracuda 500 GB disks, on a Marvell
>>>>MV88SX6081 8-port SATA-II PCI-X controller, on a PCI-X bus (64/66).
>>>>
>>>>The disks work great when accessed directly.  They work great when used
>>>>as four PVs for LVM, and when assembled into a 4-disk RAID-6.
>>>>
>>>>But when I make a RAID-6 array out of them, and use the array as a PV,
>>>>the system would hang completely, within seconds.  (This is with LVM
>>>>2.02.01, libdevicemapper 1.02.02, and dm-driver 4.5.0.)
>>>>
>>>>I turned on all the debugging options in the kernel config hoping to get
>>>>some insight, but this "debug" kernel doesnt crash.  It's running fine,
>>>>and I'm pounding on it.  A timing problem in the interaction between
>>>>LVM and RAID?  Some kind of wierd heisenbug....
>>>>
>>>>
>>>>I'd be happy to do any debugging tests people suggest.
>>>>
>>>>
>>>>
>>>>
>>>>        
>>>>
>>>I've been waiting for more info on this, did it get fixed? 2.6.15?
>>>      
>>>
>>Still broken in 2.6.15.  With all the debugging options OFF in the config,
>>the system stayed up < 24 hours under load, then a hard lockup like
>>before: nothing on the console, magic sysrq doesnt work, no caps-lock,
>>no ping.  Note that this is different from before: it actually ran a
>>little bit before locking up, rather than locking up within seconds like
>>it did with 2.6.15-rc5.
>>
>>With all the debugging options ON, it's stayed up for 3+ days now (and
>>still running) with no problems.
>>
>>
>>Any suggestions for how to debug this are welcome!  ;-)
>>    
>>
>
>I couldn't quite tell from your description: are you getting the lockup
>when you try to mount a filesystem that uses the RAID+LVM as a device?
>Or do you get errors when doing LVM-level stuff (ie no filesystem can
>even be put on the device)?
>In the case of the former, what filesystem are you using?
>
>--Matt
>-
>To unsubscribe from this list: send the line "unsubscribe linux-raid" in
>the body of a message to majordomo@vger.kernel.org
>More majordomo info at  http://vger.kernel.org/majordomo-info.html
>  
>
Judging from the ammount of problems with this driver it is %90 the 
driver and %10 raid interaction with the dirver

I don't believe this is an LVM issue, more a case of the driver's just 
not ready for use, so if you use it with raid and lvm you speed up the 
crash.

Matt


