From: MRK <mrk@shiftmail.org>
Subject: Re: Suggestion needed for fixing RAID6 [SOLVED]
Date: Wed, 05 May 2010 21:27:55 +0200
Message-ID: <4BE1C6BB.8060408@shiftmail.org>
References: <626601cae203$dae35030$0400a8c0@dcccs>
 <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org>
 <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org>
 <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org>
 <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org>
 <80a201cae621$684daa30$0400a8c0@dcccs> <4BD76CF6.5020804@shiftmail.org>
 <20100428113732.03486490@notabene.brown> <4BD830B0.1080406@shiftmail.org>
 <025e01cae6d7$30bb7870$0400a8c0@dcccs> <4BD843D4.7030700@shiftmail.org>
 <062001cae771$545e0910$0400a8c0@dcccs> <4BD9A41E.9050009@shiftmail.org>
 <0c1201cae7e0$01f9a930$0400a8c0@dcccs> <4BDA0F88.70907@shiftmail.org>
 <0d6401cae82c$da8b5590$0400a8c0@dcccs> <4BDB6DB6.5020306@shiftmail.org>
 <12cf01cae911$f0d92940$0400a8c0@dcccs> <4BDC6217.9000209@shiftmail.org>
 <154b01cae977$6e09da80$0400a8c0@dcccs>
 <20100503121747.7f2cc1f1@notabene.brown> <25a201caec67$15b26580$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
In-reply-to: <25a201caec67$15b26580$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: linux-raid@vger.kernel.org, Neil Brown <neilb@suse.de>
List-Id: linux-raid.ids

On 05/05/2010 05:24 PM, Janos Haar wrote:
>> I think without DM COW it should probably work in his case.
>
> First sorry for delay.
> Without DM, the original behavior-fix patch worked very well.

Great!
Ok I have just resubmitted the patch (v2) which includes a "Tested-by: 
Janos Haar <janos.haar@netcenter.hu>" line and a few fixes on the 
description.

> [CUT]
> Thanks a lot for all who helped me to solve this....
>
> And MRK, please don't forget to write in my name. :-)

I did it. Now it's in Neil's hands, hopefully he acks it and pushes it 
to mainline.

Thanks everybody,
GAT
