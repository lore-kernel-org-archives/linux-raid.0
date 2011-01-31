From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 17:41:28 -0200
Message-ID: <AANLkTim57HwYefXg=4CK06X+VXcW3o28VwRxCEnpaeEV@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<4D470F96.40409@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D470F96.40409@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice,
linux raid1 allow many mirrors
does raid10 allow many mirrors or just one?

2011/1/31 Phillip Susi <psusi@cfl.rr.com>:
> On 1/31/2011 1:35 PM, Denis wrote:
>> Roberto, to quite understend how better a raid 10 is over raid 01 =A0=
you
>> need to take down into a mathematical level:
>
> Raid 10 is not raid 1+0. =A0Raid 10 defaults to having 2 duplicate co=
pies,
> and so can withstand the failure of exactly one disk. =A0If two disks
> fail, it does not matter which two they are, the array has failed. =A0=
You
> can increase it to 3 copies so you can build an array of any size ( 4=
,
> 6, 8, whatever ) that can withstand exactly 2 failed disks, in any
> combination.
>
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
