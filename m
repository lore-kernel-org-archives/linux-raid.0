From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: RAID HDDs spin up sequence
Date: Mon, 31 Jan 2011 20:42:59 -0200
Message-ID: <AANLkTi=11rtmUjncnE5ABPeqTWuBjN+hYJysxc8KKUdQ@mail.gmail.com>
References: <20110131201823.GA15704@lazy.lzy>
	<AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
	<20110131222348.GA15912@lazy.lzy>
	<AANLkTi=gL3ATPN1+HHE+mhK7ZsM+aPyyQfVsz9Pq1Ajf@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=gL3ATPN1+HHE+mhK7ZsM+aPyyQfVsz9Pq1Ajf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

source code is the best source of information
try here too (WIKI)
https://raid.wiki.kernel.org/index.php/Main_Page

2011/1/31 Roberto Spadim <roberto@spadim.com.br>:
> the better probability here is: all disks must be waked up
> since you can have acces of 1gb but starting at a position that all
> disks must be used
> don=C2=B4t try used small PSU
> HP Proliant ML310G5 start all hardware on power up (a lot o Watts) an=
d
> after slow down thinks... why? check if PSU is ok, if not, don=C2=B4t=
 start
> server. that=C2=B4s a good PSU system.
> ok if you want to test, i think the worst scenario is all disks beein=
g
> waked up, i think linux use async (many threads) commands to send
> write/read, maybe you will have a small time between wake up (maybe
> just some microseconds)
>
> 2011/1/31 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
>> On Mon, Jan 31, 2011 at 07:09:24PM -0200, Roberto Spadim wrote:
>>> you psu must be dimensioned to work with everythink at full work lo=
ad
>>> (it=E6=84=80 a real production NAS right?! not a test)
>>> your SAS/IDE/SATA controller and HDD manual should be checked
>>> how hdd wake up? one command (read/write) over sata/sas/ide channel=
 wake it up?
>>> on linux raid we have a read algorithm and a write algorithm
>>> if a raid1 write occur all disks will wake up
>>> if a raid1 (raid0 or another) read occur only the disk will wake up
>>>
>>> but check you SATA/IDE/SATA controller, how it wake up your disk, a=
nd
>>> how you hdd wake up
>>
>> Hi, thanks for the answer, unfortunately I was
>> hoping to have made myself clear enough.
>>
>> First of all, it is a RAID-6, so let's say that's
>> already decided by requirements. With SATA HDDs.
>>
>> Second, the question was exactly about how the HDDs
>> are waked up. This is a SW issue, trying with normal
>> setups, i.e. a couple of disks, it is possible to
>> send them to sleep (hdparm -y /dev/hdX) and the wake
>> them up by a simple access.
>> I had no opportunity to check this with a RAID-5/6,
>> so I was asking if anyone knows.
>>
>> Finally, in order to be power efficient, the PSU,
>> assuming something like an 80 Plus Gold, should work
>> at not less than 20% of the nominal power, otherwise
>> (according to some reviews), the efficiency drops far
>> below the 80%~90% declared by the 80 Plus standard
>> (which is measured at 20%, 50% and 100% of the maximum
>> specified power).
>> It seem it gets easily around 40%~50%.
>> So, the PSU must be somehow under dimensioned for the
>> spin up of 10 HDDs, which seem to require a possible
>> 30W*10=3D300W (some nasty HDDs seem to require 30W, in
>> this situation) only for the storage.
>>
>> If the HDDs spin up one after the other, then the peak
>> consumption is only 30W, which might allow a lower
>> power PSU, in contrast with the requirement to provide
>> 300W alone for the spin up.
>>
>> So, back to the original question, if a 10 HDDs RAID-6
>> is in standby, how do the single HDD will be waked up,
>> in case of access? Of course, a quite larger access,
>> i.e. some GiB of data.
>>
>> Thanks again,
>>
>> bye,
>>
>> --
>>
>> piergiorgio
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.h=
tml
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
