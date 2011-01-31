From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 17:53:28 -0200
Message-ID: <AANLkTinVdMA0izAvN0ZS14wMV=p3XUtbgBe+1LwxafD=@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<4D470F96.40409@cfl.rr.com>
	<AANLkTim57HwYefXg=4CK06X+VXcW3o28VwRxCEnpaeEV@mail.gmail.com>
	<4D4711A5.8070601@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4711A5.8070601@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Denis <denismpa@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice, copies (mirrors)
if you lose 2 mirros in a 2 mirrors raid, you lost you information
so 2 mirrors fail >=3D 2 disk fail
you have a probability to fail of 1/2 (50%, 1 failed mirror, 2 total mi=
rrors)
if you have a bigger and bigger and bigger disk configuration and only
two mirrors you still with  50%
if you put more mirrors: 1/3 (33%, 1 failed, 3 total), 1/4=3D25%, 1/5=3D=
20% ......
got?
is this information on wikipedia? maybe we could put there

(raid0/raid1/raid10) fail system:
1 disk failed =3D 1 mirror failed
2 disk failed on same mirror =3D 1 mirror failed
probability to crash:
(failed mirrors / total mirrors)!=3D(failed disks / total
disks)!=3D(failed disks / total mirrors)!=3D(failed mirrors / total dis=
ks)



2011/1/31 Phillip Susi <psusi@cfl.rr.com>:
> On 1/31/2011 2:41 PM, Roberto Spadim wrote:
>> nice,
>> linux raid1 allow many mirrors
>> does raid10 allow many mirrors or just one?
>
> See the man page. =A0You can specify any number for near, far, or off=
set
> copies. =A0The default is 2 near.
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
