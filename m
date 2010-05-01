From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Sat, 1 May 2010 11:37:36 +0200
Message-ID: <12cf01cae911$f0d92940$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org> <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org> <80a201cae621$684daa30$0400a8c0@dcccs> <4BD76CF6.5020804@shiftmail.org> <20100428113732.03486490@notabene.brown> <4BD830B0.1080406@shiftmail.org> <025e01cae6d7$30bb7870$0400a8c0@dcccs> <4BD843D4.7030700@shiftmail.org> <062001cae771$545e0910$0400a8c0@dcccs> <4BD9A41E.9050009@shiftmail.org> <0c1201cae7e0$01f9a930$0400a8c0@dcccs> <4BDA0F88.70907@shiftmail.org> <0d6401cae82c$da8b5590$0400a8c0@dcccs> <4BDB6DB6.5020306@sh
 iftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="ISO-8859-1";
	reply-type=response
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: MRK <mrk@shiftmail.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,

Now i am tried with 1 sector snapshot size.
the result was the same
first the snapshot have been invalidated, than DM dropped from the raid.

The next was this:
md3 : active raid6 sdl4[11] sdk4[10] sdj4[9] sdi4[8] dm-1[12](F) sdg4[6] 
sdf4[5]
 dm-0[4] sdc4[2] sdb4[1] sda4[0]
      14626538880 blocks level 6, 16k chunk, algorithm 2 [12/10] 
[UUU_UUU_UUUU]
      [===================>.]  resync = 99.9% (1462653628/1462653888) 
finish=0.0
min speed=2512K/sec

The sync progress bar jumped from 58.8% to 99.9% the speed falls, the 
1462653628/1462653888 is freezed in this point.
I can do dmesg once by hand, than save the dmesg output to file, but the 
system crashed after this.

The entire story was about 1 minute.

Whoever, the sync_min option generally solves my problem, becasue i can 
build up the missing disk from the 90% wich is good enough for me. :-)
If somebody is interested about playing more with this system, i still have 
some days for it, but i am not interested anymore to trace the md-dm 
behavior in this situation....
Additionally, i don't want to put in risk the data if not really needed....

Thanks a lot,
Janos Haar


----- Original Message ----- 
From: "MRK" <mrk@shiftmail.org>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Saturday, May 01, 2010 1:54 AM
Subject: Re: Suggestion needed for fixing RAID6


> On 04/30/2010 08:17 AM, Janos Haar wrote:
>> Hello,
>>
>> OK, MRK you are right (again).
>> There was some line in the messages wich avoids my attention.
>> The entire log is here: 
>> http://download.netcenter.hu/bughunt/20100430/messages
>>
>
> Ah here we go:
>
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: device-mapper: snapshots: 
> Invalidating snapshot: Error reading/writing.
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: ata8: EH complete
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5: Disk failure on dm-1, 
> disabling device.
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5: Operation continuing on 10 
> devices.
> Apr 29 09:50:29 Clarus-gl2k10-2 kernel: md: md3: recovery done.
>
> Firstly I'm not totally sure of how DM passed the information of the 
> device failing to MD. There is no error message about this on MD. If it 
> was a read error, MD should have performed the rewrite but this apparently 
> did not happen (the error message for a failed rewrite by MD I think is 
> "read error NOT corrected!!"). But anyway...
>
>> The dm founds invalid my cow devices, but i don't know why at this time.
>>
>
> I have just had a brief look ad DM code. I understand like 1% of it right 
> now, however I am thinking that in a not-perfectly-optimized way of doing 
> things, if you specified 8 sectors (8x512b = 4k, which you did) 
> granularity during the creation of your cow and cow2 devices, whenever you 
> write to the COW device, DM might do the thing in 2 steps:
>
> 1- copy 8 (or multiple of 8) sectors from the HD to the cow device, enough 
> to cover the area to which you are writing
> 2- overwrite such 8 sectors with the data coming from MD.
>
> Of course this is not optimal in case you are writing exactly 8 sectors 
> with MD, and these are aligned to the ones that DM uses (both things I 
> think are true in your case) because DM could have skipped #1 in this 
> case.
> However supposing DM is not so smart and it indeed does not skip step #1, 
> then I think I understand why it disables the device: it's because #1 
> fails with read error and DM does not know how to handle the situation in 
> that case in general. If you had written a smaller amount with MD such as 
> 512 bytes, if step #1 fails, what do you write in the other 7 sectors 
> around it? The right semantics is not obvious so they disable the device.
>
> Firstly you could try with 1 sector granularity instead of 8, during the 
> creation of dm cow devices. This MIGHT work around the issue if DM is at 
> least a bit smart. Right now it's not obvious to me where in the is code 
> the logic for the COW copying. Maybe tomorrow I will understand this.
>
> If this doesn't work, the best thing is probably if you can write to the 
> DM mailing list asking why it behaves like this and if they can guess a 
> workaround. You can keep me in cc, I'm interested.
>
>
>> [CUT]
>>
>> echo 0 $(blockdev --getsize /dev/sde4) \
>>        snapshot /dev/sde4 /dev/loop3 p 8 | \
>>        dmsetup create cow
>>
>> echo 0 $(blockdev --getsize /dev/sdh4) \
>>        snapshot /dev/sdh4 /dev/loop4 p 8 | \
>>        dmsetup create cow2
>
> See, you are creating it with 8 sectors granularity... try with 1.
>
>> I can try again, if there is any new idea, but it would be really good to 
>> do some trick with bitmaps or set the recovery's start point or something 
>> similar, because every time i need >16 hour to get the first poit where 
>> the raid do something interesting....
>>
>> Neil,
>> Can you say something useful about this?
>>
>
> I just looked into this and it seems this feature is already there.
> See if you have these files:
> /sys/block/md3/md/sync_min and sync_max
> Those are the starting and ending sector.
> But keep in mind you have to enter them in multiples of the chunk size so 
> if your chunk is e.g. 1024k then you need to enter multiples of 2048 
> (sectors).
> Enter the value before starting the sync. Or stop the sync by entering 
> "idle" in sync_action, then change the sync_min value, then restart the 
> sync entering "check" in sync_action. It should work, I just tried it on 
> my comp.
>
> Good luck
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

