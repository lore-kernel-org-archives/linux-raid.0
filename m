From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: i made sh*t can anyone help!?
Date: Fri, 18 Mar 2011 10:52:25 -0300
Message-ID: <AANLkTikehwmXbm4w4JYaOSgj0ogiwZPouFpWPzvZVizH@mail.gmail.com>
References: <AANLkTinGkgSrfqTjYUKGXeR9yfuGws=o8bVhVnuDFMWx@mail.gmail.com>
	<AANLkTimE-P5AgWsP69YKPVvONXbjmV6QswV_eXuoRo=k@mail.gmail.com>
	<AANLkTinvWdGaq8+H17zyS-ij6PRCb6W6JjQrJC68iCSJ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTinvWdGaq8+H17zyS-ij6PRCb6W6JjQrJC68iCSJ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i see some files contents with
cat /dev/md0 | less

2011/3/18 Roberto Spadim <roberto@spadim.com.br>:
> only one :( the other was broken :(
> it's xfs filesystem
>
> mdadm --create /dev/md0 /dev/sdb
> mkfs.xfs /dev/md0
> mount /dev/md0 /home/
>
> but since i made mdadm --create twice, it can't mount :(
>
> # mount /dev/md0 /tmp2 -t xfs
> mount: wrong fs type, bad option, bad superblock on /dev/md0,
> =A0 =A0 =A0 missing codepage or helper program, or other error
> =A0 =A0 =A0 In some cases useful info is found in syslog - try
> =A0 =A0 =A0 dmesg | tail =A0or so
>
>
>
> 2011/3/18 Mathias Bur=E9n <mathias.buren@gmail.com>:
>> On 18 March 2011 13:43, Roberto Spadim <roberto@spadim.com.br> wrote=
:
>>> hi guys i had a raid1 array, and i made shit, could i undo it? it h=
ave
>>> filesystem with files :(
>>>
>>> # mdadm --create /dev/md0 --level=3D1 --raid-devices=3D2 /dev/sdb m=
issing
>>> mdadm: /dev/sdb appears to be part of a raid array:
>>> =A0 =A0level=3Draid1 devices=3D2 ctime=3DWed Mar 16 19:01:50 2011
>>> mdadm: Note: this array has metadata at the start and
>>> =A0 =A0may not be suitable as a boot device. =A0If you plan to
>>> =A0 =A0store '/boot' on this device please ensure that
>>> =A0 =A0your boot-loader understands md/v1.x metadata, or use
>>> =A0 =A0--metadata=3D0.90
>>> Continue creating array?
>>> Continue creating array? (y/n) y
>>> mdadm: Defaulting to version 1.2 metadata
>>> mdadm: array /dev/md0 started.
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at =A0http://vger.kernel.org/majordomo-info.htm=
l
>>>
>>
>> You had a RAID1 array? Of which devices did it consists of? Looks li=
ke
>> you only destroyed one.
>>
>> // M
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
