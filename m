From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: ideas - raid write
Date: Thu, 3 Mar 2011 22:11:04 -0300
Message-ID: <AANLkTimR13o43eENZum8W9W1=-0d-gKg8QEJeTP8xGEF@mail.gmail.com>
References: <AANLkTimd08XFTZ+x2id5f=a=UCSfZi1y_qQGw0wKj18A@mail.gmail.com>
	<AANLkTinr3fYB45220VJ+id+gvsvB5Xi_6nEQ8G-UgHYU@mail.gmail.com>
	<AANLkTikr6OtGEHmJX2y+ga6HX=PZtDaXM1MEt20a61NU@mail.gmail.com>
	<AANLkTi=wGopixZdTaRwB6++w9nFHsJ1zUpyoU9Svna12@mail.gmail.com>
	<AANLkTim+BCATBoAFOmY+q=qw1ZviqyP4dV7f-=QQLnZJ@mail.gmail.com>
	<AANLkTike4YaaD3zeFG+11sFbpButTpE2OrjO8nz+kixa@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTike4YaaD3zeFG+11sFbpButTpE2OrjO8nz+kixa@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: chris <tknchris@gmail.com>
Cc: Linux-RAID <linux-raid@vger.kernel.org>, =?ISO-8859-1?Q?Mathias_Bur=E9n?= <mathias.buren@gmail.com>
List-Id: linux-raid.ids

just a idea, try new write performaces improvements, with 'partial
security', some mirrors stay 'in sync' (give some security) and others
are doing async writes
with raid1 (or raid10) with more than 2 mirrors

2011/3/3 chris <tknchris@gmail.com>:
> What is the point of these posts...
>
> On Mar 3, 2011 6:24 PM, "Roberto Spadim" <roberto@spadim.com.br> wrot=
e:
>
> in other words...
> the write speed is limited by the fastest disk (one or more disks how
> many sync/async writes should we allow is another problem, not for
> now), not the slowest
> the cache is another limit (when cache get full, async writes should =
wait)
>
> 2011/3/3 Roberto Spadim <roberto@spadim.com.br>:
>> ops... ndb mysql cluster
>>
>> it=B4s like to get mo...



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
