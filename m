From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6 [SOLVED]
Date: Wed, 5 May 2010 17:24:37 +0200
Message-ID: <25a201caec67$15b26580$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org> <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org> <80a201cae621$684daa30$0400a8c0@dcccs> <4BD76CF6.5020804@shiftmail.org> <20100428113732.03486490@notabene.brown> <4BD830B0.1080406@shiftmail.org> <025e01cae6d7$30bb7870$0400a8c0@dcccs> <4BD843D4.7030700@shiftmail.org> <062001cae771$545e0910$0400a8c0@dcccs> <4BD9A41E.9050009@shiftmail.org> <0c1201cae7e0$01f9a930$0400a8c0@dcccs> <4BDA0F88.70907@shiftmail.org> <0d6401cae82c$da8b5590$0400a8c0@dcccs> <4BDB6DB6.5020306@sh
 iftmail.org> <12cf01cae911$f0d92940$0400a8c0@dcccs> <4BDC6217.9000209@shiftmail.org> <154b01cae977$6e09da80$0400a8c0@dcccs> <20100503121747.7f2cc1f1@notabene.brown> <4BDE9FB6.80309@shiftmai!
 l.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

>
> It is not clear to me what kind of error MD got from DM:
>
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: device-mapper: snapshots: 
> Invalidating snapshot: Error reading/writing.
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: ata8: EH complete
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5: Disk failure on dm-1, 
> disabling device.
>
> I don't understand from what place the md_error() is called...
> but also in this case it doesn't look like a rewrite error...
>
> I think without DM COW it should probably work in his case.

First sorry for delay.
Without DM, the original behavior-fix patch worked very well.

Neil is generally right about the drive should reallocate the bad sectors on 
rewrite, but this is the ideal scenario wich is far from the real world 
unfortunately....
I needed to repeat 4 times the "repair" sync methode on the better HDD (wich 
have only 123 bads) to get readable again.
The another hdd have >2500 bads wich looks like have no chance to fix this 
way.

>
> Your new patch skips the rewriting and keeps the unreadable sectors, 
> right? So that the drive isn't dropped on rewrite...
>
>> The following patch should address this issue for you.
>> It is*not*  a general-purpose fix, but a specific fix
> [CUT]

Neil, i think this patch should be in the sysfs or in the proc to be 
inactive by default, and of course will be good for recover bad cases like 
mine.
There is a lot of hdd problems wich can make really uncorrectable sectors 
wich can't be good again even on rewrite....

Thanks a lot for all who helped me to solve this....

And MRK, please don't forget to write in my name. :-)

Cheers,
Janos 

