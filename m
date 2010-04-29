From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Thu, 29 Apr 2010 23:07:40 +0200
Message-ID: <0c1201cae7e0$01f9a930$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org> <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org> <80a201cae621$684daa30$0400a8c0@dcccs> <4BD76CF6.5020804@shiftmail.org> <20100428113732.03486490@notabene.brown> <4BD830B0.1080406@shiftmail.org> <025e01cae6d7$30bb7870$0400a8c0@dcccs> <4BD843D4.7030700@shiftmail.org> <062001cae771$545e0910$0400a8c0@dcccs> <4BD9A41E.9050009@shiftmail.org>
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


----- Original Message ----- 
From: "MRK" <mrk@shiftmail.org>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>
Sent: Thursday, April 29, 2010 5:22 PM
Subject: Re: Suggestion needed for fixing RAID6


> On 04/29/2010 09:55 AM, Janos Haar wrote:
>>
>> md3 : active raid6 sdd4[12] sdl4[11] sdk4[10] sdj4[9] sdi4[8] dm-1[13](F) 
>> sdg4[6
>> ] sdf4[5] dm-0[4] sdc4[2] sdb4[1] sda4[0]
>>      14626538880 blocks level 6, 16k chunk, algorithm 2 [12/10] 
>> [UUU_UUU_UUUU]
>>      [===========>.........]  recovery = 56.8% (831095108/1462653888) 
>> finish=50
>> 19.8min speed=2096K/sec
>>
>> Drive dropped again with this patch!
>> + the kernel freezed.
>> (I will try to get more info...)
>>
>> Janos
>
> Hmm too bad :-( it seems it still doesn't work, sorry for that
>
> I suppose the kernel didn't freeze immediately after disabling the drive 
> or you wouldn't have had the chance to cat /proc/mdstat...

this was this command in putty.exe window:
watch "cat /proc/mdstat ; du -h /snap*"

I think it have crashed soon.
I had no time to recognize what happened and exit from the watch.

>
> Hence dmesg messages might have gone to /var/log/messages or something. 
> Can you look there to see if there is any interesting message to post 
> here?

Yes, i know that.
The crash was not written up unfortunately.
But there is some info:

(some UNC reported from sdh)
....
Apr 29 09:50:29 Clarus-gl2k10-2 kernel:          res 
51/40:00:27:c0:5e/40:00:63:00:00/e0 Emask 0x9 (media error)
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: ata8.00: status: { DRDY ERR }
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: ata8.00: error: { UNC }
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: ata8.00: configured for UDMA/133
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: sd 7:0:0:0: [sdh] Result: 
hostbyte=DID_OK driverbyte=DRIVER_SENSE,SUGGEST_OK
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: sd 7:0:0:0: [sdh] Sense Key : Medium 
Error [current] [descriptor]
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: Descriptor sense data with sense 
descriptors (in hex):
Apr 29 09:50:29 Clarus-gl2k10-2 kernel:         72 03 11 04 00 00 00 0c 00 
0a 80 00 00 00 00 00
Apr 29 09:50:29 Clarus-gl2k10-2 kernel:         63 5e c0 27
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: sd 7:0:0:0: [sdh] Add. Sense: 
Unrecovered read error - auto reallocate failed
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: end_request: I/O error, dev sdh, 
sector 1667153959
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189872 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189880 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189888 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189896 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189904 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189912 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189920 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189928 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189936 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: raid5:md3: read error not 
correctable (sector 1662189944 on dm-1).
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: ata8: EH complete
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: sd 7:0:0:0: [sdh] Write Protect is 
off
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: sd 7:0:0:0: [sdh] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: sd 7:0:0:0: [sdh] 2930277168 
512-byte hardware sectors: (1.50 TB/1.36 TiB)
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: sd 7:0:0:0: [sdh] Write Protect is 
off
Apr 29 09:50:29 Clarus-gl2k10-2 kernel: sd 7:0:0:0: [sdh] Write cache: 
enabled, read cache: enabled, doesn't support DPO or FUA
Apr 29 13:07:39 Clarus-gl2k10-2 syslogd 1.4.1: restart.


> Did the COW device fill up at least a bit?

The initial size is 1.1MB, and what we wants to see is only some kbytes...
I don't know exactly.
Next time i will try to reduce the initial size to 16KByte.

>
> Also: you know that if you disable graphics on the server 
> ("/etc/init.d/gdm stop" or something like that) you usually can see the 
> stack trace of the kernel panic on screen when it hangs (unless terminal 
> was blank for powersaving, which you can disable too). You can take a 
> photo of that one (or write it down but it will be long) to so maybe 
> somebody can understand why it hanged. You might be even obtain the stack 
> trace through a serial port but that will take more effort.

This pc based server have no graphic card at all. :-) (this is one of my 
freak ideas)
And the terminal is redirected to the com1.
If i really want, i can catch this with serial cable, but i think the log 
should be enough from the messages file.

Thanks,
Janos 

