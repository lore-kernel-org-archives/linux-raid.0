From: Jon Nelson <jnelson-linux-raid@jamponi.net>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 16:08:33 -0600
Message-ID: <AANLkTimYzZLjtgrppZKw1H3d+RUV7doEQ-G+P8V7OTTV@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
	<AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
	<20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<4D470F96.40409@cfl.rr.com>
	<4D471A41.1090706@hardwarefreak.com>
	<4D4730C0.8080900@cfl.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4730C0.8080900@cfl.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: Phillip Susi <psusi@cfl.rr.com>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, Denis <denismpa@gmail.com>, Roberto Spadim <roberto@spadim.com.br>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Jan 31, 2011 at 3:59 PM, Phillip Susi <psusi@cfl.rr.com> wrote:
> On 1/31/2011 3:23 PM, Stan Hoeppner wrote:
>>> Raid 10 is not raid 1+0. =C2=A0Raid 10 defaults to having 2 duplica=
te copies,
>>
>> Yes, actually, they are two names for the same RAID level.
>
> No, they are not. =C2=A0See the mdadm man page. =C2=A0Raid10 can oper=
ate on 3
> drives, raid1+0 can not. =C2=A0In theory a raid10 could be done on tw=
o disks
> though mdadm seems to want at least 3.

I operate (and have done so for a long time) a raid10,f2 on two drives.
What makes you think it wants at least 3?


--=20
Jon
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
