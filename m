From: PFC <lists@peufeu.com>
Subject: Re: Kanotix crashed my raid...
Date: Mon, 09 Jan 2006 19:30:25 +0100
Message-ID: <op.s24i0zf0cigqcu@apollo13>
References: <fd8d0180601050104x15079396h@mail.gmail.com> <op.s2yhczepcigqcu@apollo13> <op.s2y8sekvcigqcu@apollo13> <200601090803.03588.mlaks@verizon.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed; delsp=yes; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <200601090803.03588.mlaks@verizon.net>
Sender: linux-raid-owner@vger.kernel.org
To: Mitchell Laks <mlaks@verizon.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> 	OK, I bit the bullet and removed the "goto abort" in raid5.c
>>
>> 	I was then able to mount everything and recover all of my data without
>> any problem. Hm.
>>
>> 	There should be a way to do this with mdadm without recompiling the
>> kernel, but anyway, opensource saved my ass xDDD
> Could you explain to me what you did? It sounds very important for me to
> understand!

	Well, I ought to update.

	So the kernel refused to start my raid because it was dirty and degraded.  
I understand this, but getting some data out is better than none. I knew  
that the PC had crashed while starting the array. So, it wouldn't have had  
much time to cause a lot of corruption. Most likely everything was  
alright, just marked dirty. So I just removed the test in the kernel which  
refuses to start the array in this condition (that's why I love  
opensource). And it worked.

	raid5.c in the 2.6.14 kernel :

if (mddev->degraded == 1 &&
     mddev->recovery_cp != MaxSector) {
printk(KERN_ERR "raid5: cannot start dirty degraded array for  
%s",mdname(mddev));
goto abort;
}

	I just commented out the goto abort.

	Anyway, that's not the end ! I got 3 harddisk failures in a week. All  
maxtor 250G SATA HDDs. I RMA'd the first one and got a new drive. It  
worked for 2 days and then boom. So I went to all the computer shops  
around here and they only had maxtor so I bought another maxtor. AND  
YESTERDAY IT DIED TOO.

	I spent a lot of time with google, and :	

	Kanotix was not the culprit ; it's nvidia. Turns out the nforce 3 and 4  
chipsets have some SATA problems. This might be a hardware issue, or maybe  
a driver issue, who knows, but the end result is this :

	- My nforce 3 / Athlon 64 PC running Linux has 4 SATA ports (2x 2 ports)
	- 2 of these ports (sda and sdb) are compatible with maxtor harddrives  
(ie. it seems it works)
	- the other two (sdc and sdd) are not compatible with maxtor drives.

	My other computer, which has a nforce4 mobo / Athlon 64 PC and runs  
windows, has the exactly same problem !

	- If I plug a seagate harddrive as sda,b,c,d, it works.
	- If I plug a maxtor harddrive as sda or sdb, it works.
	- If I plug a maxtor harddrive as sdc or sdd (the other sata ports), on  
linux it works for a day or two then the drive "dies" ; on windows it just  
fucks everything up (takes forever to boot, disk management console  
crashes, mouse freezes, disk exists then disappears, etc).

	Re-plugging the "dead" drive as sda or sdb makes it work ! So now all is  
well. I have plugged my 2 maxtor drives on the "maxtorphile" sata sockets,  
and the 2 seagate drives on the "maxtorphobe" sata sockets. Everything  
works. I feel like banging head against wall.

	Oh yeah, on linux I also deactivated USB, firewire, and unplugged teh  
CDROM drive. Who knows. It seems to work now. At least it has worked for  
24 hours now.

	Actually it's quite hallucinating. And I found people in forums with the  
same experience ! Some guy had to unplug his IDE CDR to get his SATA hdd  
to work. On windows. Cool. Actually sata + nforce = broken.

	(the "maxtorphile" sata sockets are not driven by the nforce chipset but  
by a SIS chip, or so it seems).

	DON'T BUY NFORCE FOR MAKING SATA RAID !!!











