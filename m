From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Performance question, RAID5
Date: Mon, 31 Jan 2011 01:54:11 -0200
Message-ID: <AANLkTi=8NbfzLhyCL_YzuLE42MsMG8WVdPnxq0mFtJ-K@mail.gmail.com>
References: <AANLkTimXp-vGP8fb2Y-2EiaGxj+H6UJ9DfjtYMVDhDri@mail.gmail.com>
	<AANLkTi=SbAM3BXxjH6Mvcn-Tw4b0FYyLjLFqSGuxY1fk@mail.gmail.com>
	<AANLkTik4MGS7V7ePBgbk+KW-FcBBV7MuYgB7n29RRXF=@mail.gmail.com>
	<20110130094444.68288b0e@natsu>
	<AANLkTi=jXwcEgRquKgsf5HQUA+AQdt8nHeHCUJYqdSbX@mail.gmail.com>
	<20110130171533.4c9e236b@natsu>
	<AANLkTi=6UnGjDXdrM76-8_iW+1D6MC5fkGB-vhhYxUXu@mail.gmail.com>
	<4D45C3FA.2040900@hardwarefreak.com>
	<AANLkTikLX-d6CtXhLBQU_qoxx0fQ2HdR8acFCU+o9JeP@mail.gmail.com>
	<4D462EFB.4050006@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D462EFB.4050006@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Stan Hoeppner <stan@hardwarefreak.com>
Cc: =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>, Roman Mamedov <rm@romanrm.ru>, CoolCold <coolthecold@gmail.com>, Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

try stress program, and sysstat
it make a nice stress test over filesystem (maybe you will use it,
only if using database over partition or something familiar)

2011/1/31 Stan Hoeppner <stan@hardwarefreak.com>:
> Mathias Bur=E9n put forth on 1/30/2011 3:43 PM:
>
>> 3) 7GB output from bonnie++. Like so:
>
> The column in your graph http://stuff.dyndns.org/logs/bonnie_results.=
html says
> "Chunk size". =A0I'm not a bonnie++ user so my apologies for not bein=
g familiar
> with it. =A0I use iozone instead (on rare occasion) which I like much=
 better.
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
