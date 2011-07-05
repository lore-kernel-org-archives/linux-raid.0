From: Drew <drew.kay@gmail.com>
Subject: Re: Recommended sw raid setup
Date: Mon, 4 Jul 2011 23:40:35 -0700
Message-ID: <CACJz6Qt2n0hcP6pmL3n0ZQs5aEDb_=L-4P-O4MZoUFeF+tUU_w@mail.gmail.com>
References: <BANLkTinbBu6zX-6s2NYH5BQvnaJZJYt_BA@mail.gmail.com>
 <BANLkTinghqiT4QbBb--X7Eh_RRWnRg_0RQ@mail.gmail.com> <CACJz6Qv=u0-66hwOEg5AeZ2rWuw2OE10ozUKEQGTbuGn0_fgGg@mail.gmail.com>
 <BANLkTing8Ei+najZAFXN_ib0LRmQfS8e9Q@mail.gmail.com> <CACJz6QuzTj3cmESu0eBGgq3rK3wopXZpj9m34N5ecR=uj6FvCQ@mail.gmail.com>
 <4E12ABDF.50409@stud.tu-ilmenau.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4E12ABDF.50409@stud.tu-ilmenau.de>
Sender: linux-raid-owner@vger.kernel.org
To: stefan.huebner@stud.tu-ilmenau.de
Cc: Simon Matthews <simon.d.matthews@gmail.com>, linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>> TLER just shortens the firmware's error recovery from something like
>> 60 seconds down to 4 seconds. It's mainly useful in hardware RAID bu=
t
>> I can see it being useful with mdraid in the enterprise where you
>> can't afford to wait for the drive to do it's own recovery attempts.
>>
>>
> This is not correct. =C2=A0You may want to read the ATA8-ACS2 draft s=
tandard
> (see www.t13.org). =C2=A0There you'll find: SCT-ERC
>
> The internal error recovery procedure includes a vast amount of
> algorithms. =C2=A0If a disk cannot read a sector and starts error rec=
overy,
> it may take far more than a minute.
> With ERC you can tell the disk beforehand to stop processing the comm=
and
> (may it be "read" or "write") and return a "uncorrectable error" to t=
he
> host. =C2=A0Some drives (i.E. recent Hitachi Deskstar, which I do rec=
ommend!)
> do not allow you to set ERC lower than 6.5s.

And how is that any different from what I said? The observable effect
of TLER is the drive giving up after a few seconds instead of a minute
or more. Algorithm XYZ and spec ABC of the t13 committee doesn't
change what we see. And for most people, the effect is what matters,
not how we got there.

Myself, I could care less about what goes on under the hood. I enable
TLER for HW raid and disable it for regular use.


--=20
Drew

"Nothing in life is to be feared. It is only to be understood."
--Marie Curie

"This started out as a hobby and spun horribly out of control."
-Unknown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
