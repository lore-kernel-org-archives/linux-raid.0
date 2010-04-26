From: "Janos Haar" <janos.haar@netcenter.hu>
Subject: Re: Suggestion needed for fixing RAID6
Date: Tue, 27 Apr 2010 00:39:15 +0200
Message-ID: <7ca501cae591$4e779980$0400a8c0@dcccs>
References: <626601cae203$dae35030$0400a8c0@dcccs> <20100423065143.GA17743@maude.comedia.it> <695a01cae2c1$a72907d0$0400a8c0@dcccs> <4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs> <4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs> <4BD569E2.7010409@shiftmail.org> <7a3e01cae53f$684122c0$0400a8c0@dcccs> <4BD5C51E.9040207@shiftmail.org>
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="iso-8859-1";
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
Sent: Monday, April 26, 2010 6:53 PM
Subject: Re: Suggestion needed for fixing RAID6


> On 04/26/2010 02:52 PM, Janos Haar wrote:
>>
>> Oops, you are right!
>> It was my mistake.
>> Sorry, i will try it again, to support 2 drives with dm-cow.
>> I will try it.
>
> Great! post here the results... the dmesg in particular.
> The dmesg should contain multiple lines like this "raid5:md3: read error 
> corrected ....."
> then you know it worked.

md3 : active raid6 sdd4[12] sdl4[11] sdk4[10] sdj4[9] sdi4[8] dm-1[13](F) 
sdg4[6] sdf4[5] dm-0[14](F) sdc4[2] sdb4[1] sda4[0]
      14626538880 blocks level 6, 16k chunk, algorithm 2 [12/9] 
[UUU__UU_UUUU]
      [>....................]  recovery =  1.5% (22903832/1462653888) 
finish=3188383.4min speed=7K/sec

Khm.... :-D
It is working on something or stopped with 3 missing drive? : ^ )

(I have found the cause of the 2 dm's failure.
Now retry runs...)

Cheers,
Janos




> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html 

