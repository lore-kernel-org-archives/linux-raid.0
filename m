From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: Network-based RAID6
Date: Wed, 30 Mar 2011 15:17:13 -0300
Message-ID: <AANLkTi=FY5vEbc2neYuVADHBX3xWSALJicW5CoiqB7Rn@mail.gmail.com>
References: <20110330131157.49fd2521@natsu>
	<AANLkTimGK49-XtV9CsfL90bKpb=e9tRRos7fJ50WzNHd@mail.gmail.com>
	<20110330144944.3c87185c@natsu>
	<4D933188.30003@hardwarefreak.com>
	<20110330235052.3a803d35@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110330235052.3a803d35@natsu>
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.ru>
Cc: Stan Hoeppner <stan@hardwarefreak.com>, CoolCold <coolthecold@gmail.com>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

DRBD - computer replication
raid1 - disk 'replication'

what your needs?

2011/3/30 Roman Mamedov <rm@romanrm.ru>:
> On Wed, 30 Mar 2011 08:35:04 -0500
> Stan Hoeppner <stan@hardwarefreak.com> wrote:
>
>> If you want true block level replication over a network, look into D=
RBD.
>> =A0However, it is also limited to mirroring.
>
> So I guess a viable and interesting solution could be an mdadm stripe=
 over two
> or more DRBD mirrors, effectively providing RAID10. Although that's n=
ot quite
> what I am looking for (RAID5/6-levels of overhead and resilience).
>
> --
> With respect,
> Roman
>



--=20
Roberto Spadim
Spadim Technology / SPAEmpresarial
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
