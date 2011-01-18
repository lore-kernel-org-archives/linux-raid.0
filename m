From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Hi! Why having LSR's chunk size 2^n limitation?
Date: Tue, 18 Jan 2011 14:59:38 -0200
Message-ID: <AANLkTim2D_CZsVH1=6MD5z1kuOFKXoLbsdpm_3xOgDyg@mail.gmail.com>
References: <AANLkTi=Nk_4vNH5BpHj5fMJxOaSAGjuiSD8agbACdzaQ@mail.gmail.com>
	<AANLkTimUq41Ki7A8=KvsmNUhCw1D9PiOjyVqHME1UvEz@mail.gmail.com>
	<AANLkTikSr3kpFzXKzmHZiKVAwA=141New=9Awqm5z2jW@mail.gmail.com>
	<AANLkTi=e_wQtQvsQs3=Hst-kyV8fjOWS5yPwHQc4=r90@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=e_wQtQvsQs3=Hst-kyV8fjOWS5yPwHQc4=r90@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: for.poige+linux@gmail.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

no, but....
you talk about a filesystem - device (md raid) feature
maybe you could get better performace configuring a different
filesystem, or another hard disk or flash memories, or another raid
configuration (1+0, 0 +1, 10, 0+5,0+6, 1+5, 1+6, x+y)

check source, round is for a easier (faster maybe less complex) code.


2011/1/18 Igor Podlesny <for.poige+linux@gmail.com>:
> On 18 January 2011 23:48, Roberto Spadim <roberto@spadim.com.br> wrot=
e:
>> start at make you hardware faster with your linux
>> after
>> make your device faster with your filesystem (xfs, reiserfs, ext4???=
)
>> after
>> make you application faster with your filesystem (for mysql: myisam
>> with fixed table type is faster than dynamic table type and faster
>> than aria(mariadb) page table type)
>
> =A0 Roberto, thanks, but did I ask your advices?
>
> --
> End of message. Next message?
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
