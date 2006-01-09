From: Matt Darcy <kernel-lists@projecthugo.co.uk>
Subject: Re: more info on the hang with 2.6.15-rc5
Date: Mon, 09 Jan 2006 09:54:44 +0000
Message-ID: <43C232E4.1060504@projecthugo.co.uk>
References: <E1EpIfb-0001e2-GR@highlab.com> <43C1580B.9020609@tmr.com>
Reply-To: kernel-lists@projecthugo.co.uk
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <43C1580B.9020609@tmr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Bill Davidsen <davidsen@tmr.com>
Cc: Sebastian Kuzminsky <seb@highlab.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Bill Davidsen wrote:

> Sebastian Kuzminsky wrote:
>
>> Now it works, but I dont trust it one bit.
>>
>> I had been seeing almost immediate, perfectly repeatable hard lockups
>> in 2.6.15-rc5 and 2.6.15-rc5-mm3, when using sata_mv, RAID, and LVM
>> together.  Nothing in the syslog or on the console, and the system is
>> totally unresponsive to the keyboard & network.
>>
>> My hardware setup is: four Seagate Barracuda 500 GB disks, on a Marvell
>> MV88SX6081 8-port SATA-II PCI-X controller, on a PCI-X bus (64/66).
>>
>> The disks work great when accessed directly.  They work great when used
>> as four PVs for LVM, and when assembled into a 4-disk RAID-6.
>>
>> But when I make a RAID-6 array out of them, and use the array as a PV,
>> the system would hang completely, within seconds.  (This is with LVM
>> 2.02.01, libdevicemapper 1.02.02, and dm-driver 4.5.0.)
>>
>> I turned on all the debugging options in the kernel config hoping to get
>> some insight, but this "debug" kernel doesnt crash.  It's running fine,
>> and I'm pounding on it.  A timing problem in the interaction between
>> LVM and RAID?  Some kind of wierd heisenbug....
>>
>>
>> I'd be happy to do any debugging tests people suggest.
>>
>>
>>  
>>
> I've been waiting for more info on this, did it get fixed? 2.6.15?
>
No,

not at all.

The stability of the driver in 2.6.15 is totally unusable. The 
2.6.15-rc5-mm3 appears to be the most usable driver from my experience, 
although this too has problems with it. Keep in mind that this is a very 
early driver development tree.  I'm currently using the libata git tree 
kernel, and some of the usability of the sata_mv driver appears a bit 
better, however the stability is still unusable (300 minutes to build a 
1.4 TB raid 5 array - constant hangs on about %25-30 completion of the 
array build)

Take a look at my other posts with the subjects

[git patches] 2.6 libata updates
2.6.15-rc5 mm3 V mm3 (although it should be mm1 V mm3)

I'd be happy to talk this through more with you so that more feecback 
can be given to the sata_mv driver (which looks like its actually in 
quite reasonable demand)

Matt






