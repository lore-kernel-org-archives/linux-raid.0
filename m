From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Wed, 28 Apr 2010 15:32:02 +0200
Message-ID: <025e01cae6d7$30bb7870$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org> <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org> <80a201cae621$684daa30$0400a8c0@dcccs> <4BD76CF6.5020804@shiftmail.org> <20100428113732.03486490@notabene.brown> <4BD830B0.1080406@shiftmail.org>
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

MRK, Neil,

Please let me have one wish:
Please write down my name to the kernel tree with a note i was who reported 
and helped to track down this. :-)

Thanks.
Janos Haar

----- Original Message ----- 
From: "MRK" <mrk@shiftmail.org>
To: "Neil Brown" <neilb@suse.de>
Cc: "Janos Haar" <janos.haar@netcenter.hu>; <linux-raid@vger.kernel.org>
Sent: Wednesday, April 28, 2010 2:57 PM
Subject: Re: Suggestion needed for fixing RAID6


> On 04/28/2010 03:37 AM, Neil Brown wrote:
>>> --- linux-2.6.33-vanilla/drivers/md/raid5.c     2010-02-24
>>> 19:52:17.000000000 +0100
>>> +++ linux-2.6.33/drivers/md/raid5.c     2010-04-27 23:58:31.000000000 
>>> +0200
>>> @@ -1526,7 +1526,7 @@ static void raid5_end_read_request(struc
>>>
>>>                   clear_bit(R5_UPTODATE,&sh->dev[i].flags);
>>>                   atomic_inc(&rdev->read_errors);
>>> -               if (conf->mddev->degraded)
>>> +               if (conf->mddev->degraded == conf->max_degraded)
>>>                           printk_rl(KERN_WARNING
>>>                                     "raid5:%s: read error not 
>>> correctable "
>>>                                     "(sector %llu on %s).\n",
>>>
>>> ------------------------------------------------------
>>> (This is just compile-tested so try at your risk)
>>>
>>> I'd like to hear what Neil thinks of this...
>>>
>> I think you've found a real bug - thanks.
>>
>> It would make the test '>=' rather than '==' as that is safer, otherwise 
>> I
>> agree.
>>
>>
>>> -               if (conf->mddev->degraded)
>>> +               if (conf->mddev->degraded>= conf->max_degraded)
>>>
>
> Right, agreed...
>
>> Thanks,
>> NeilBrown
>>
>
> Ok then I'll post a more official patch in a separate email shortly, 
> thanks 

