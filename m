From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 4 Feb 2011 19:13:45 -0200
Message-ID: <AANLkTim2_x1LUoAwLUP9v4hVP_A6k1_eFEfKGxGFSi-i@mail.gmail.com>
References: <20110131152151.GD7861@cthulhu.home.robinhill.me.uk>
	<AANLkTimfnRxm=chKx4MFSxX1c0hypnVW-jaYwq757DaH@mail.gmail.com>
	<AANLkTi=mLFwdLzcjcpzC0JJ=v8Aa817g+CzrR88pmy9y@mail.gmail.com>
	<AANLkTikvXk0gyXz6MBvhyzxXatk0FVeASPr8R8+74c_i@mail.gmail.com>
	<AANLkTinGSNmp6yUNfb9thnr3zKFTzw=fUFm+Gef3DAHw@mail.gmail.com>
	<4D470F96.40409@cfl.rr.com>
	<4D471A41.1090706@hardwarefreak.com>
	<4D4730C0.8080900@cfl.rr.com>
	<20110201092007.GA7860@cthulhu.home.robinhill.me.uk>
	<4D4C2352.9000407@cfl.rr.com>
	<20110204162212.GA21779@cthulhu.home.robinhill.me.uk>
	<4D4C6A25.5070604@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4C6A25.5070604@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: Phillip Susi <psusi@cfl.rr.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

http://www.lsi.com/DistributionSystem/AssetDocument/SCG_LSI_SAS_6Gbps_I=
R_PB_092909.pdf

raid10 =3D (can use linux raid10 too, but i=B4m just explaning raid 1+0=
)
mdadm --create /dev/md0 --level=3D1 --raid-devices 2 /dev/sda /dev/sdb
mdadm --create /dev/md1 --level=3D1 --raid-devices 2 /dev/sdc /dev/sdd
mdadm --create /dev/md2 --level=3D0 --raid-devices 2 /dev/md0 /dev/md1


2011/2/4 Stan Hoeppner <stan@hardwarefreak.com>:
> Robin Hill put forth on 2/4/2011 10:22 AM:
>> On Fri Feb 04, 2011 at 11:03:30AM -0500, Phillip Susi wrote:
>>
>>> FYI, you should get in the habit of using your mail client's reply =
to
>>> all function. =A0I did not see this until now because you did not s=
end me
>>> a copy.
>>>
>> I'll make an exception in this case, but I generally reply to messag=
es
>> on mailing lists to the list only, and I have no plans to change thi=
s.
>>
>>> On 2/1/2011 4:20 AM, Robin Hill wrote:
>>>> No, it's RAID 10 or RAID 1+0. RAID 0+1 would be 2 mirrored pairs o=
f
>>>> 5-disk RAID 0 arrays, in which case you could only lose 5 disks if
>>>
>>> In English we read from left to right and top to bottom, so 0+1 mea=
ns
>>> stripe on top of mirror.
>>>
>> The vast majority of online sources would disagree with you. =A0See:
>> =A0 =A0 http://en.wikipedia.org/wiki/Nested_RAID_levels
>> =A0 =A0 http://www.aput.net/~jheiss/raid10/
>> =A0 =A0 http://decipherinfosys.wordpress.com/2008/01/15/difference-b=
etween-raid-01-vs-raid-10/
>> =A0 =A0 http://www.raid.com/04_01_0_1.html
>> =A0 =A0 http://www.pcguide.com/ref/hdd/perf/raid/levels/multLevel01-=
c.html
>> =A0 =A0 http://www.adrc.com/raid-01.html
>>
>> The order it's written is the order of creation. =A0RAID0+1 =3D =A0R=
AID 0,
>> then RAID 1 (mirrored stripes) and RAID1+0 =3D RAID 1, then RAID 0
>> (striped mirrors).
>
> LSI is the undisputed king of HBA RAID, with all major server OEMs re=
badging LSI
> cards and/or using their storage processor chips on the mobo, includi=
ng Dell,
> HP, IBM, Intel, Sun, etc. =A0Note the diagram at the bottom of this P=
DF showing
> the layout of RAID 10:
>
> http://www.lsi.com/DistributionSystem/AssetDocument/SCG_LSI_SAS_6Gbps=
_IR_PB_092909.pdf
>
> It clearly shows a stripe over two mirrors.
>
> --
> Stan
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
