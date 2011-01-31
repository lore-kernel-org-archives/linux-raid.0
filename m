From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: RAID HDDs spin up sequence
Date: Mon, 31 Jan 2011 21:11:21 +0000
Message-ID: <AANLkTi=Q7E5xhOxXA5KusWgpSb97hnmnbcm0fD1C9N5w@mail.gmail.com>
References: <20110131201823.GA15704@lazy.lzy>
	<AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinPTaDfVtjMfz7DHUa95cKFF7MZeg=WhuuTnZM8@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On 31 January 2011 21:09, Roberto Spadim <roberto@spadim.com.br> wrote:
> you psu must be dimensioned to work with everythink at full work load
> (it=C2=B4s a real production NAS right?! not a test)
> your SAS/IDE/SATA controller and HDD manual should be checked
> how hdd wake up? one command (read/write) over sata/sas/ide channel w=
ake it up?
> on linux raid we have a read algorithm and a write algorithm
> if a raid1 write occur all disks will wake up
> if a raid1 (raid0 or another) read occur only the disk will wake up
>
> but check you SATA/IDE/SATA controller, how it wake up your disk, and
> how you hdd wake up
>
> 2011/1/31 Piergiorgio Sartor <piergiorgio.sartor@nexgo.de>:
>> Hi all,
>>
>> assuming there is a NAS, with, for example, 10 HDDs
>> in RAID-6. Assuming the HDDs are put in standby, in
>> order to save energy, when the NAS is not used.
>> How is the spin up sequence when the corresponding
>> /dev/mdX device is accessed?
>> Will the system spin up one HDD at time or all together?
>>
>> Obviously, one at time will limit the peak current,
>> thus allowing a better dimensioned PSU, working almost
>> always around the optimal efficiency point.
>>
>> Thanks a lot for any information on the topic,
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
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

I would guess, that on a RAID0 setup, any read to that md device would
wake every disk up in that setup. No?

// Mathias
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
