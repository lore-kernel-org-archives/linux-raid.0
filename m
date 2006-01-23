From: John Hendrikx <hjohn@xs4all.nl>
Subject: Re: multiple Sata SATAII 150, TX4  - how to tell which drive is which?
 headaches galore!
Date: Mon, 23 Jan 2006 21:22:04 +0100
Message-ID: <43D53AEC.7060302@xs4all.nl>
References: <200601230336.55220.mlaks@verizon.net> <op.s3ty89rfcigqcu@apollo13>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <op.s3ty89rfcigqcu@apollo13>
Sender: linux-raid-owner@vger.kernel.org
To: PFC <lists@peufeu.com>
Cc: Mitchell Laks <mlaks@verizon.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

>
>> I wanted to ask for any experience with running raid with SATA drives 
>> and
>> controllers here under linux.
>>
>     Maxtor SATA drives series 6V (those with 16 MB cache) are 
> incompatible with nforce 3-4 SATA controllers. Maxtor acknowledges 
> this. Symptom is a slow death of the drive, ending with command 
> timeouts. When reverting the drive to SATA 1.5Gbps with the jumper, it 
> works perfectly again (for a few days...). nvidia doesn't care. This 
> is on windows and linux. In windows, you have to use fucking PIO mode 
> or you get corruptions. nforce4 sata also has problems with plextor 
> sata burners, and possibly others.
I don't have much SATA experience, although a Western Digital 
WD2500JD-75F seems to work fine with the nforce 4 ultra chipset.
>     The Maxtor 6L series (with 8 MB cache) work flawlessly.
>
>     I currently have these SATA drives, on a nforce3 MSI mobo :
>
> # hdparm -I /dev/sd? |grep "Model Numb"
>
>         Model Number:       Maxtor 6L200M0
>         Model Number:       Maxtor 6L250S0
>         Model Number:       ST3250823AS
>         Model Number:       ST3250823AS
>
>     All work. I RMA'd the 6V250 drive and exchanged it against a good, 
> old, IDE drive, which works perfect.
>
>     It took me a month, 3 maxtor drives, and nights of googling to 
> figure this out...
>
>     My gut feeling is that SATA isn't that ready for prime-time after 
> all...
Does SMART work for your SATA drives?  Without SMART support I don't 
really want to get any more SATA drives.  Mine reports this:

~$ smartctl -a /dev/sda
smartctl version 5.32 Copyright (C) 2002-4 Bruce Allen
Home page is http://smartmontools.sourceforge.net/

Device: ATA      WDC WD2500JD-75F Version: 02.0
Serial number: WD-WMAEH1585485
Device type: disk
Local Time is: Mon Jan 23 21:14:56 2006 CET
Device does not support SMART
Request Sense failed, [Input/output error]

Device does not support Error Counter logging

[GLTSD (Global Logging Target Save Disable) set. Enable Save with '-S on']
Device does not support Self Test logging

