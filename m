From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid over ethernet
Date: Sat, 29 Jan 2011 04:48:17 -0200
Message-ID: <AANLkTik7n1FfU2u9oE8nywFeqTvUeXen91mtY2pcUyTU@mail.gmail.com>
References: <AANLkTi=2PDZdVSEgF0mQ_ZdwxvkPoSywM6U0e4hMxTXS@mail.gmail.com>
	<alpine.DEB.1.10.1101290741510.13151@uplift.swm.pp.se>
	<AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTikFHBD_TjTe96tgd4Kmy6zZuD8kdE0W-0ncdCev@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

better than drbd?

2011/1/29 Roberto Spadim <roberto@spadim.com.br>:
> faster than nbd?
>
> 2011/1/29 Mikael Abrahamsson <swmike@swm.pp.se>:
>> On Fri, 28 Jan 2011, Roberto Spadim wrote:
>>
>>> hi guys, i was thinking about raid over ethernet... there's a solut=
ion
>>> to make a syncronous replica of my filesystem? no problem if my
>>> primary server get down, i can mout my replica fsck it and continue
>>> with available data
>>> i was reading about nbd, anyone have more ideas?
>>
>> Look into AoE (ATA over Ethernet).
>>
>> --
>> Mikael Abrahamsson =A0 =A0email: swmike@swm.pp.se
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
