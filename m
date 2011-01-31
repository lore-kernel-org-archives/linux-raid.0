From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 13:32:06 -0200
Message-ID: <AANLkTi=mWHz69_U1tWzyPGy3-drOA4T1-dHtu1OHLtA+@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTinOkzo2+ZO2fWHShOXPKE6ikQgo4LsOVpkdxHWq@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinOkzo2+ZO2fWHShOXPKE6ikQgo4LsOVpkdxHWq@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

rewriting..
using raid10 or raid01 you will have problems if you lose 2 drives too.=
=2E.
if you lose two raid 1 devices you loose raid 1...
see:

disks=3D4
RAID 1+0
raid1=3D 1-2(A)  ; 3-4(B); 5-6(C)
raid0=3D A-B-C
if you lose (A,B or C) your raid0 stop

RAID 0+1
raid0=3D 1-2-3(A)  ; 4-5-6(B)
raid1=3D A-B
if you lose (1,4 OR 1,5 OR 1,6 OR 2,4 OR 2,5 OR 2,6 OR 3,4 OR 4,5 OR
4,6) your raid0 stop

using raid1+0 or raid0+1 you can't lose two disks...



2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
> do you have a faster array using raid0+1 or raid1+0?
>
> 2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
>> hum that's right,
>> but not 'increase' (only if you compare raid0+1 betwen raid1+0) usin=
g
>> raid1 and after raid0 have LESS point of fail between raid 0 and aft=
er
>> raid 1, since the number of point of fail is proportional to number =
of
>> raid1 devices.
>>
>> 2011/1/31 Robin Hill <robin@robinhill.me.uk>:
>>> On Mon Jan 31, 2011 at 01:00:13PM -0200, Roberto Spadim wrote:
>>>
>>>> i think make two very big raid 0
>>>> and after raid1
>>>> is better
>>>>
>>> Not really - you increase the failure risk doing this. =A0With this=
 setup,
>>> a single drive failure from each RAID0 array will lose you the enti=
re
>>> array. =A0With the reverse (RAID0 over RAID1) then you require both=
 drives
>>> in the RAID1 to fail in order to lose the array. =A0Of course, with=
 a 4
>>> drive array then the risk is the same (33% with 2 drive failures) b=
ut
>>> with a 6 drive array it changes to 60% for RAID1 over RAID0 versus =
20%
>>> for RAID0 over RAID1.
>>>
>>> Cheers,
>>> =A0 =A0Robin
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
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
