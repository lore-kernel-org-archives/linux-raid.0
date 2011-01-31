From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: What's the typical RAID10 setup?
Date: Mon, 31 Jan 2011 13:00:13 -0200
Message-ID: <AANLkTimoSvWj3mnowZbVKKHEMzwjiQ=WqRUUsj91n_Zr@mail.gmail.com>
References: <AANLkTi=oCi1oMTMk_uhsiYA0CA80+8_k-AtvYXZ3jC+U@mail.gmail.com>
	<AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimc35i0W8vmsEGWrjCH7pYLBo=Ju1inA6xQ8bj6@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: CoolCold <coolthecold@gmail.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i think make two very big raid 0
and after raid1
is better

using raid10 you can use some layouts (how data is write on same raid
system (for raid1 part of raid10), first disk write from head 0 to
last head, second disk write from last head to head 0)

2011/1/31 CoolCold <coolthecold@gmail.com>:
> On Mon, Jan 31, 2011 at 12:41 PM, Mathias Bur=E9n <mathias.buren@gmai=
l.com> wrote:
>> Hi,
>>
>> RAID10 is (could be) setup in this way, correct?
>>
>> 2 devices in a RAID1
>> 2 devices in another RAID1
> I usually use LVM striping over two RAID1 arrays for this.
>>
>> Then you run RAID0 on top of them. If you're lucky you can lose 2
>> devices at most (1 in each RAID1).
>>
>> If you have, say 6 HDDs, would you create 3 RAID1 volumes? Then crea=
te
>> a RAID0 on top of them?
>>
>> How would one go about expanding a 4 HDD RAID10 into a 6 HDD RAID10?
>> Is it "just" a matter of creating a new RAID1 array of the 2 new HDD=
s,
>> then adding them to the RAID0, then expanding whatever is on that
>> (lvm, xfs, ext4)?
>>
>> Are there any design tips, or caveats? For example, how many disks
>> would you use at most, in a RAID10 setup?
>>
>> Kind regards,
>> // Mathias
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
> Best regards,
> [COOLCOLD-RIPN]
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
