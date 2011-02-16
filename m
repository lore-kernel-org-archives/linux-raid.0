From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: md - cache
Date: Wed, 16 Feb 2011 16:30:25 -0200
Message-ID: <AANLkTi=XTe1OnkaBTtWJnKR849k=ybp4KFA_r1otCr3k@mail.gmail.com>
References: <AANLkTi=qav77Q8pjU8_xhmuvYSkZk7_Hwd3Xe89BWtBK@mail.gmail.com>
	<4D5BFE35.7090408@tomt.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4D5BFE35.7090408@tomt.net>
Sender: linux-raid-owner@vger.kernel.org
To: Andre Tomt <andre@tomt.net>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

i don=B4t know the real history of md, but dm-cache is something simila=
r
to flashcache and bcache, i don=B4t know if they stoped in time, or jus=
t
md takes the place of dm

2011/2/16 Andre Tomt <andre@tomt.net>:
> On 02/16/2011 05:01 PM, Roberto Spadim wrote:
>>
>> hi guys, i was thinking about cache insues
>> since md =3D multiple devices
>> could we implement a new device used for caches? (port bcache to md,
>> or flashcache (facebook))
>> something like:
>> mdadm --create /dev/md1 --level=3Dcache --cache-device=3D/dev/XXX
>> --data-device=3D/dev/ZZZZ
>>
>
> Wny would you want to port when it works fine across different types =
of
> block devices already, including md? At least bcache is supposed to -=
 and I
> think flashcache too.
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
