From: David Brown <david@westcontrol.com>
Subject: Re: What's the typical RAID10 setup?
Date: Fri, 04 Feb 2011 12:34:00 +0100
Message-ID: <iigobc$n0n$2@dough.gmane.org>
References: <AANLkTim_uQ7AQs_ZSyeYPJPYSLCJd6ChzzTBwBNk2qA9@mail.gmail.com> <20110131192858.GD27952@www2.open-std.org> <4D4718E1.9040607@hardwarefreak.com> <20110131203725.GB2283@www2.open-std.org> <AANLkTimxCkxkg6xuz8FgFf0=u4KY=0M=6+afnxLzT+Tu@mail.gmail.com> <AANLkTi=+rPzaNTKAjB=QUEGsbUcwfN8uijm96DoY_4FA@mail.gmail.com> <AANLkTinM6FkJtxL8dNpoy-haGqNsZVfLDwmvZcshTEYQ@mail.gmail.com> <4D475AB5.10600@hardwarefreak.com> <20110203110428.GA26762@www2.open-std.org> <4D4B3DAE.3070502@hardwarefreak.com> <20110204070613.GA3788@www2.open-std.org> <4D4BB87A.30800@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D4BB87A.30800@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 04/02/2011 09:27, Stan Hoeppner wrote:
> Keld J=F8rn Simonsen put forth on 2/4/2011 1:06 AM:
>
>> Well RAID1+0 is not the best combination available. I would argue th=
at
>> raid10,f2 is significantly better in a number of areas.
>
> I'd guess Linux software RAID would be lucky to have 1% of RAID deplo=
yments
> worldwide--very lucky.  The other 99%+ are HBA RAID or SAN/NAS "appli=
ances" most
> often using custom embedded RTOS with the RAID code written in assemb=
ler,
> especially in the case of the HBAs.  For everything not Linux mdraid,=
 RAID 10
> (aka 1+0) is king of the hill, and has been for 15 years+
>

I wonder what sort of market penetration small cheap SAN/NAS=20
"appliances" have these days, aimed at the home markets and small=20
offices.  These are almost invariably Linux md raid devices, although=20
the user views them as an black-box appliance.

However, though they use md raid, they typically don't support RAID10,=20
RAID1+0, RAID10,f2, or anything other than RAID0, RAID1 and RAID5.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
