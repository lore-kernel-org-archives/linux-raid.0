From: MRK <mrk@shiftmail.org>
Subject: Re: Suggestion needed for fixing RAID6
Date: Thu, 29 Apr 2010 17:22:06 +0200
Message-ID: <4BD9A41E.9050009@shiftmail.org>
References: <626601cae203$dae35030$0400a8c0@dcccs>
 <20100423065143.GA17743@maude.comedia.it>
 <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org>
 <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org>
 <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org>
 <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org>
 <80a201cae621$684daa30$0400a8c0@dcccs> <4BD76CF6.5020804@shiftmail.org>
 <20100428113732.03486490@notabene.brown> <4BD830B0.1080406@shiftmail.org>
 <025e01cae6d7$30bb7870$0400a8c0@dcccs> <4BD843D4.7030700@shiftmail.org>
 <062001cae771$545e0910$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <062001cae771$545e0910$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/29/2010 09:55 AM, Janos Haar wrote:
>
> md3 : active raid6 sdd4[12] sdl4[11] sdk4[10] sdj4[9] sdi4[8] 
> dm-1[13](F) sdg4[6
> ] sdf4[5] dm-0[4] sdc4[2] sdb4[1] sda4[0]
>      14626538880 blocks level 6, 16k chunk, algorithm 2 [12/10] 
> [UUU_UUU_UUUU]
>      [===========>.........]  recovery = 56.8% (831095108/1462653888) 
> finish=50
> 19.8min speed=2096K/sec
>
> Drive dropped again with this patch!
> + the kernel freezed.
> (I will try to get more info...)
>
> Janos

Hmm too bad :-( it seems it still doesn't work, sorry for that

I suppose the kernel didn't freeze immediately after disabling the drive 
or you wouldn't have had the chance to cat /proc/mdstat...

Hence dmesg messages might have gone to /var/log/messages or something. 
Can you look there to see if there is any interesting message to post here?
Did the COW device fill up at least a bit?

Also: you know that if you disable graphics on the server 
("/etc/init.d/gdm stop" or something like that) you usually can see the 
stack trace of the kernel panic on screen when it hangs (unless terminal 
was blank for powersaving, which you can disable too). You can take a 
photo of that one (or write it down but it will be long) to so maybe 
somebody can understand why it hanged. You might be even obtain the 
stack trace through a serial port but that will take more effort.

