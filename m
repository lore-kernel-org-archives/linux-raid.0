From: "Mr. James W. Laferriere" <babydr@baby-dragons.com>
Subject: Re: raid5:md3: read error corrected ,  followed by ,  Machine Check
 Exception: .
Date: Sat, 14 Jul 2007 19:32:38 -0700 (PDT)
Message-ID: <Pine.LNX.4.64.0707141826580.16611@filesrv1.baby-dragons.com>
References: <Pine.LNX.4.64.0707141658210.16611@filesrv1.baby-dragons.com>
 <20070715020454.19de921f@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20070715020454.19de921f@the-village.bc.nu>
Sender: linux-raid-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: linux-raid maillist <linux-raid@vger.kernel.org>, Linux Kernel Maillist <linux-kernel@vger.kernel.org>
List-Id: linux-raid.ids

 	Hello Alan (& Justin) ,

On Sun, 15 Jul 2007, Alan Cox wrote:
> On Sat, 14 Jul 2007 17:08:27 -0700 (PDT)
> "Mr. James W. Laferriere" <babydr@baby-dragons.com> wrote:
>
>>  	Hello All ,  I was under the impression that a 'machine check' would be
>> caused by some near to the CPU hardware failure ,  Not a bad disk ?
>
> It indicates a hardware failure

 	OK ,  Be funny :-} .  Tho it ain't .  I still think I am correct in 
stating that a "'machine check' would be caused by some near to the CPU hardware 
failure" .  Ie: like physically shoved into the motherboard .  Not a 
indirectly connected device .  Such as a disk drive .


>> Jul 14 23:00:26 filesrv2 kernel: sd 2:0:1:0: SCSI error: return code = 0x08000002
>> Jul 14 23:00:26 filesrv2 kernel: sdd: Current: sense key: Medium Error
>> Jul 14 23:00:26 filesrv2 kernel:     Additional sense: Read retries exhausted
>
> So your disk throws a fit

 	Actually it's brand new .  Infant mortallity ?  I at least have a cold 
spare available .  So Yes I am replacing that puppy .  I'll drop it into another 
system & give it the format command & see how much the user bad block table 
grows .  I'll bet I'll get a table full overflow on it .


>> Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269184 on sdd)
>> Jul 14 23:17:06 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 72269192 on sdd)
>
> Raid happily recovers the mess

 	That they did .  scsi & raid .


>> Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388336 on sdd)
>> Jul 14 23:20:28 filesrv2 kernel: raid5:md3: read error corrected (8 sectors at 76388344 on sdd)
>> Jul 14 23:38:48 filesrv2 -- MARK --
>> CPU 5: Machine Check Exception: 0000000000000004
>> CPU 4: Machine Check Exception: 0000000000000004
>
> And at some point at least 18 minutes after the raid incident you log
> CPU problems.

 	I didn't notice the 18 Minute differance .  Drats .
 	The 'MCE's have been ongoing for sometime .  I have replaced every item 
in the system except the chassis & scsi backplane & power supply(750Watts) .
 	Everything .  MB,cpu,memory,scsi controllers, ...
 	These MCE's only happen when I am trying to build or bonnie++ test the 
md3 .  It consists of (now 7+1spare) 146GB drives in the SuperMicro 
SYS-6035B-8B's backplane attached to a LSI22320 .

> Are you sure the box or the room it is in didn't get excessively hot ?

 	The room before and at the time of the MCE was never over 71F .  Now the 
memory temp might be a tad hot but I've got a small jet engine running in that 
chassis as noisy as it is with fans so I don't see how anything in there could 
be too hot .
 	Temp this time ,  71.2F .  everytime I try that array it MCE's .
 	I have another array in a JBOD box of 14 disks & I have no problems 
with this system as long as I disconnect all the drives in the 8 drive Backplane .
 	I guess I'll just have to do without the extra 143,564,800K of data 
space .
 		Twyl ,  JimL

ps: system face diagram ...
   +-------------------------+
   |0|1|2|3|4|6|7|-----------| 
+-| | | | | | | |-----------|
| | | | | | | | |-----------|
| +-------------------------+
|  \           /
|   +---md3---+
|
| +-------------------------+
| |0|1|2|3|4|6|0|1|2|3|4|5|6|
+-| | | | | | | | | | | | | |
   | | | | | | | | | | | | | |
   +-------------------------+
    \           /\          /
     +---md4---+  +---md4--+
-- 
+-----------------------------------------------------------------+
| James   W.   Laferriere | System   Techniques | Give me VMS     |
| Network        Engineer | 663  Beaumont  Blvd |  Give me Linux  |
| babydr@baby-dragons.com | Pacifica, CA. 94044 |   only  on  AXP |
+-----------------------------------------------------------------+
