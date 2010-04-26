From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Suggestion needed for fixing RAID6
Date: Mon, 26 Apr 2010 16:06:16 -0700
Message-ID: <h2o4877c76c1004261606ueea01162h3891c7e54a66f6a@mail.gmail.com>
References: <626601cae203$dae35030$0400a8c0@dcccs> <695a01cae2c1$a72907d0$0400a8c0@dcccs>
	<4BD193D0.5080003@shiftmail.org> <717901cae3e5$6a5fa730$0400a8c0@dcccs>
	<4BD3751A.5000403@shiftmail.org> <756601cae45e$213d6190$0400a8c0@dcccs>
	<4BD569E2.7010409@shiftmail.org> <7a3e01cae53f$684122c0$0400a8c0@dcccs>
	<4BD5C51E.9040207@shiftmail.org> <7ca501cae591$4e779980$0400a8c0@dcccs>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7ca501cae591$4e779980$0400a8c0@dcccs>
Sender: linux-raid-owner@vger.kernel.org
To: Janos Haar <janos.haar@netcenter.hu>
Cc: MRK <mrk@shiftmail.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, Apr 26, 2010 at 3:39 PM, Janos Haar <janos.haar@netcenter.hu> w=
rote:
>
> ----- Original Message ----- From: "MRK" <mrk@shiftmail.org>
> To: "Janos Haar" <janos.haar@netcenter.hu>
> Cc: <linux-raid@vger.kernel.org>
> Sent: Monday, April 26, 2010 6:53 PM
> Subject: Re: Suggestion needed for fixing RAID6
>
>
>> On 04/26/2010 02:52 PM, Janos Haar wrote:
>>>
>>> Oops, you are right!
>>> It was my mistake.
>>> Sorry, i will try it again, to support 2 drives with dm-cow.
>>> I will try it.
>>
>> Great! post here the results... the dmesg in particular.
>> The dmesg should contain multiple lines like this "raid5:md3: read e=
rror
>> corrected ....."
>> then you know it worked.
>
> md3 : active raid6 sdd4[12] sdl4[11] sdk4[10] sdj4[9] sdi4[8] dm-1[13=
](F)
> sdg4[6] sdf4[5] dm-0[14](F) sdc4[2] sdb4[1] sda4[0]
> =A0 =A0 14626538880 blocks level 6, 16k chunk, algorithm 2 [12/9] [UU=
U__UU_UUUU]
> =A0 =A0 [>....................] =A0recovery =3D =A01.5% (22903832/146=
2653888)
> finish=3D3188383.4min speed=3D7K/sec
>
> Khm.... :-D
> It is working on something or stopped with 3 missing drive? : ^ )
>
> (I have found the cause of the 2 dm's failure.
> Now retry runs...)
>
> Cheers,
> Janos
>
>
>
>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>

What is displayed there seems like it can't be correct.  Please run

mdadm -Evvs

mdadm -Dvvs

and provide the results for us.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
