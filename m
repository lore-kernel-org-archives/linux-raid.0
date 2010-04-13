From: Simon Matthews <simon.d.matthews@gmail.com>
Subject: Re: raid10,f2 Add a Controller: Which drives to move?
Date: Mon, 12 Apr 2010 20:26:55 -0700
Message-ID: <j2t40b437201004122026zd43aa129nb501cfc83d5cdafd@mail.gmail.com>
References: <loom.20100411T185315-118@post.gmane.org>
	 <4BC29670.6020504@unart.cz> <4BC2B887.6020403@stud.tu-ilmenau.de>
	 <4BC2CF14.9000209@unart.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4BC2CF14.9000209@unart.cz>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-2?B?VG9t4bkgRHVs7Ws=?= <dulik@unart.cz>
Cc: st0ff@npl.de, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

2010/4/12 Tom=C3=A1=C5=A1 Dul=C3=ADk <dulik@unart.cz>:
> Stefan /*St0fF*/ H=C3=BCbner napsal(a):
>>
>> I cannot quite understand your problem. =C2=A0As every part of the a=
rray
>> contains it's own metadata, it doesn't matter to md which /dev/sdX a
>> drive is. =C2=A0It might matter a bit for boot-time assembly, but ac=
tually
>> that's what UUIDs are for.
>>
>
> I know how UUIDs work.
> My problem with device names is not a "critical", it's about "user
> friendliness" of the physical disk management.
> If a disk fails and I receive email "A Fail event had been detected o=
n md
> device /dev/md2. It could be related to component device /dev/sdd3", =
how
> will I know which disk should be replaced, if the device name is not
> fixed/persistent? I

Record the serial number of the disks and  which bay they are in.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
