From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 13:34:13 -0200
Message-ID: <AANLkTikRaUp5yr+G8V3jC48GWFmSnp-m+LRMQ9+fOgVy@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTinOkzo2+ZO2fWHShOXPKE6ikQgo4LsOVpkdxHWq@mail.gmail.com>
	<AANLkTi=mWHz69_U1tWzyPGy3-drOA4T1-dHtu1OHLtA+@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=mWHz69_U1tWzyPGy3-drOA4T1-dHtu1OHLtA+@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

the only way to make it safer, is put more devices on raid1
for example:
disks=3D6 (was wrong on last email)
raid0=3D 1-2(a) 3-4(b) 5-6(c)
raid1=3D a,b,c

or
raid1=3D1-2-3(a) 4-5-6(b)
raid0=3Da,b
now you can loose tree disks

2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
> rewriting..
> using raid10 or raid01 you will have problems if you lose 2 drives to=
o...
> if you lose two raid 1 devices you loose raid 1...
> see:
>
> disks=3D4
> RAID 1+0
> raid1=3D 1-2(A) =A0; 3-4(B); 5-6(C)
> raid0=3D A-B-C
> if you lose (A,B or C) your raid0 stop
>
> RAID 0+1
> raid0=3D 1-2-3(A) =A0; 4-5-6(B)
> raid1=3D A-B
> if you lose (1,4 OR 1,5 OR 1,6 OR 2,4 OR 2,5 OR 2,6 OR 3,4 OR 4,5 OR
> 4,6) your raid0 stop
>
> using raid1+0 or raid0+1 you can't lose two disks...
>
>
>
> 2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
>> do you have a faster array using raid0+1 or raid1+0?
>>
>> 2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
>>> hum that's right,
>>> but not 'increase' (only if you compare raid0+1 betwen raid1+0) usi=
ng
>>> raid1 and after raid0 have LESS point of fail between raid 0 and af=
ter
>>> raid 1, since the number of point of fail is proportional to number=
 of
>>> raid1 devices.
>>>
>>> 2011/1/31 Robin Hill <robin@robinhill.me.uk>:
>>>> On Mon Jan 31, 2011 at 01:00:13PM -0200, Roberto Spadim wrote:
>>>>
>>>>> i think make two very big raid 0
>>>>> and after raid1
>>>>> is better
>>>>>
>>>> Not really - you increase the failure risk doing this. =A0With thi=
s setup,
>>>> a single drive failure from each RAID0 array will lose you the ent=
ire
>>>> array. =A0With the reverse (RAID0 over RAID1) then you require bot=
h drives
>>>> in the RAID1 to fail in order to lose the array. =A0Of course, wit=
h a 4
>>>> drive array then the risk is the same (33% with 2 drive failures) =
but
>>>> with a 6 drive array it changes to 60% for RAID1 over RAID0 versus=
 20%
>>>> for RAID0 over RAID1.
>>>>
>>>> Cheers,
>>>> =A0 =A0Robin
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe linux-ra=
id" in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.ht=
ml
>>>>
>>>
>>>
>>>
>>> --
>>> Roberto Spadim
>>> Spadim Technology / SPAEmpresarial
>>>
>>
>>
>>
>> --
>> Roberto Spadim
>> Spadim Technology / SPAEmpresarial
>>
>
>
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
