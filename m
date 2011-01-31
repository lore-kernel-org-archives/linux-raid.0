From: Denis <denismpa@gmail.com>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 14:55:38 -0200
Message-ID: <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
 <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
 <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
 <20110131152151.GD7861@cthulhu.home.robinhill.me.uk> <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
> hum that's right,
> but not 'increase' (only if you compare raid0+1 betwen raid1+0) using
> raid1 and after raid0 have LESS point of fail between raid 0 and afte=
r
> raid 1, since the number of point of fail is proportional to number o=
f
> raid1 devices.
In that case, in an occurency of a failury, you will take much longer
to rebuild the failed disk, at least, double the time.


>
> 2011/1/31 Robin Hill <robin@robinhill.me.uk>:
>> On Mon Jan 31, 2011 at 01:00:13PM -0200, Roberto Spadim wrote:
>>
>>> i think make two very big raid 0
>>> and after raid1
>>> is better
>>>
>> Not really - you increase the failure risk doing this. =A0With this =
setup,
>> a single drive failure from each RAID0 array will lose you the entir=
e
>> array. =A0With the reverse (RAID0 over RAID1) then you require both =
drives
>> in the RAID1 to fail in order to lose the array. =A0Of course, with =
a 4
>> drive array then the risk is the same (33% with 2 drive failures) bu=
t
>> with a 6 drive array it changes to 60% for RAID1 over RAID0 versus 2=
0%
>> for RAID0 over RAID1.
>>
>> Cheers,
>> =A0 =A0Robin
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Denis Anjos,
www.versatushpc.com.br
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
