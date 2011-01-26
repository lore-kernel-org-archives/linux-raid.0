From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: raid1 mirror optimizations
Date: Wed, 26 Jan 2011 13:39:39 -0200
Message-ID: <AANLkTik5rWNd+K8Cji=R3iMGNXjetXUgCbJyPyfD_A9K@mail.gmail.com>
References: <AANLkTimUbWcHi8w6UzxKjkavpOihV7V5Nm58mV7HA0AE@mail.gmail.com>
	<tqn318-q0c.ln1@oberon.scorpius.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <tqn318-q0c.ln1@oberon.scorpius.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Oliver Brakmann <obrakmann@gmx.net>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

i don't know what layout does, but, does raid1 have layout?

2011/1/25 Oliver Brakmann <obrakmann@gmx.net>:
> Hi,
>
> On 2011-01-25 19:56, Roberto Spadim wrote:
>> could we implement a 'inverted' mirror? just for hard disks (for ssd
>> it=B4s a small loss of cpu/memory)
>
> If I understood that correctly, this is exactly what the raid10 'far'
> layout does.
>
> Regards,
> Oliver
>
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
