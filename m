From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Thu, 29 Apr 2010 09:55:23 +0200
Message-ID: <062001cae771$545e0910$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org> <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org> <80a201cae621$684daa30$0400a8c0@dcccs> <4BD76CF6.5020804@shiftmail.org> <20100428113732.03486490@notabene.brown> <4BD830B0.1080406@shiftmail.org> <025e01cae6d7$30bb7870$0400a8c0@dcccs> <4BD843D4.7030700@shiftmail.org>
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


md3 : active raid6 sdd4[12] sdl4[11] sdk4[10] sdj4[9] sdi4[8] dm-1[13](F) 
sdg4[6
] sdf4[5] dm-0[4] sdc4[2] sdb4[1] sda4[0]
      14626538880 blocks level 6, 16k chunk, algorithm 2 [12/10] 
[UUU_UUU_UUUU]
      [===========>.........]  recovery = 56.8% (831095108/1462653888) 
finish=50
19.8min speed=2096K/sec

Drive dropped again with this patch!
+ the kernel freezed.
(I will try to get more info...)

Janos

----- Original Message ----- 
From: "MRK" <**************>
To: "Janos Haar" <janos.haar@netcenter.hu>
Cc: <linux-raid@vger.kernel.org>; "Neil Brown" <neilb@suse.de>
Sent: Wednesday, April 28, 2010 4:19 PM
Subject: Re: Suggestion needed for fixing RAID6


> On 04/28/2010 03:32 PM, Janos Haar wrote:
>> MRK, Neil,
>>
>> Please let me have one wish:
>> Please write down my name to the kernel tree with a note i was who 
>> reported and helped to track down this. :-)
>>
>> Thanks.
>> Janos Haar
>
> Ok I did
> However it would be nice if you can actually test the patch and confirm 
> that it solves your problem, starting with the raid6 array in 
> singly-degraded mode like you did yesterday. Then I think we can add one 
> further line on top:
>
> Tested-by: Janos Haar <janos.haar@netcenter.hu>
>
> before Neil (hopefully) acks it. Testing is needed anyway before pushing 
> it to mainline, I think...
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

