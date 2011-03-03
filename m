From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: ideas - raid write
Date: Thu, 3 Mar 2011 20:17:12 -0300
Message-ID: <AANLkTi=wGopixZdTaRwB6++w9nFHsJ1zUpyoU9Svna12@mail.gmail.com>
References: <AANLkTimd08XFTZ+x2id5f=a=UCSfZi1y_qQGw0wKj18A@mail.gmail.com>
	<AANLkTinr3fYB45220VJ+id+gvsvB5Xi_6nEQ8G-UgHYU@mail.gmail.com>
	<AANLkTikr6OtGEHmJX2y+ga6HX=PZtDaXM1MEt20a61NU@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikr6OtGEHmJX2y+ga6HX=PZtDaXM1MEt20a61NU@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

ops... ndb mysql cluster

it=B4s like to get more speed on small (cache time/size) writes
may be dirty, but if only X disks are in sync array could continue
running with async writes without problems


2011/3/3 Roberto Spadim <roberto@spadim.com.br>:
> if others fail, fail the disks =3D), it=B4s something like nbd (mysql=
) cluster
> two disks ok, return ok others works like async write
> on error, resync nodes/mirrors
> i don=B4t know the name but they call somethink like isosyncronous or
> semisyncronous, i don=B4t remember now
>
> 2011/3/3 Mathias Bur=E9n <mathias.buren@gmail.com>:
>> And if md sends ok when first write is complete, then other writes f=
ail?
>>
>> On 3 Mar 2011 22:45, "Roberto Spadim" <roberto@spadim.com.br> wrote:
>>> hi guys, i have some questions...
>>> how write works in raid1?
>>> md send write to all mirrors and wait write end to return 'ok' to
>>> filesystem?
>>> could we send write to mirrors and return with one 'ok'? like a asy=
nc
>>> write?
>>>
>>> --
>>> Roberto Spadim
>>> Spadim Technology / SPAEmpresarial
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-rai=
d" in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at http://vger.kernel.org/majordomo-info.html
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
