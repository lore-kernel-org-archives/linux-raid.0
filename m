From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 15:31:14 -0200
Message-ID: <AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Denis <denismpa@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i think that partial failure (raid0 fail) of a mirror, is a fail
(since all mirror is repaired and resync)
the security is, if you lose all mirrors you have a device
so your 'secure' is the number of mirrors, not the number of disks ssd
or another type of device...
how many mirrors you have here:
raid0=3D 1,2(a) 3,4(b)
raid1=3Da,b
1 mirror (a or b)

and here:
raid1=3D1,2(a) 3,4(b)
raid0=3Dab
1 mirror (a or b)

let=B4s think about hard disk?
your hard disk have 2 disks?
why not make two partition? first partition is disk1, second partition =
is disk2
mirror it
what=B4s your security? 1 mirror
is it security? normaly when a harddisk crash all disks inside it
crash but you is secury if only one internal disk fail...

that=B4s the point, how many mirror?
the point is
with raid1+0 (raid10) we know that disks are fragments (raid1)
with raid0+1 we know that disks are a big disk (raid0)
the point is, we can=B4t allow that information stop, we need mirror to
be secured (1 is good, 2 better, 3 really better, 4 5 6 7...)
you can=B4t break mirror (not disk) to don=B4t break mirror have a seco=
nd
mirror (raid0 don=B4t help here! just raid1)

with raid10 you will repair smal size of information (raid1), here
sync will cost less time
with raid01 you will repair big  size of information (raid0), here
sync will cost more time




2011/1/31 Denis <denismpa@gmail.com>:
> 2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
>> hum that's right,
>> but not 'increase' (only if you compare raid0+1 betwen raid1+0) usin=
g
>> raid1 and after raid0 have LESS point of fail between raid 0 and aft=
er
>> raid 1, since the number of point of fail is proportional to number =
of
>> raid1 devices.
> In that case, in an occurency of a failury, you will take much longer
> to rebuild the failed disk, at least, double the time.
>
>
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
> Denis Anjos,
> www.versatushpc.com.br
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =A0http://vger.kernel.org/majordomo-info.html
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
