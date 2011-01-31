From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 13:27:32 -0200
Message-ID: <AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

hum that's right,
but not 'increase' (only if you compare raid0+1 betwen raid1+0) using
raid1 and after raid0 have LESS point of fail between raid 0 and after
raid 1, since the number of point of fail is proportional to number of
raid1 devices.

2011/1/31 Robin Hill <robin@robinhill.me.uk>:
> On Mon Jan 31, 2011 at 01:00:13PM -0200, Roberto Spadim wrote:
>
>> i think make two very big raid 0
>> and after raid1
>> is better
>>
> Not really - you increase the failure risk doing this. =A0With this s=
etup,
> a single drive failure from each RAID0 array will lose you the entire
> array. =A0With the reverse (RAID0 over RAID1) then you require both d=
rives
> in the RAID1 to fail in order to lose the array. =A0Of course, with a=
 4
> drive array then the risk is the same (33% with 2 drive failures) but
> with a 6 drive array it changes to 60% for RAID1 over RAID0 versus 20=
%
> for RAID0 over RAID1.
>
> Cheers,
> =A0 =A0Robin
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
