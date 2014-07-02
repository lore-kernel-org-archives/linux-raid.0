From: Pedro Teixeira <finas@aeiou.pt>
Subject: Re: strange problem with raid6 read errors on active non-degraded
 array
Date: Wed, 02 Jul 2014 12:03:51 +0100
Message-ID: <20140702120351.Horde.rSu6OvYRo99Ts_cXBPpx7dA@webmail.aeiou.pt>
References: <20140702103241.Horde.iempNvYRo99Ts9G5Op7ionA@webmail.aeiou.pt>
 <20140702155224.072d09ef@natsu>
 <20140702110713.Horde.4jCzQvYRo99Ts9nRe3Oy26A@webmail.aeiou.pt>
 <20140702161109.70843874@natsu>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed	DelSp=Yes
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140702161109.70843874@natsu>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hi Neil,

"
Can't possible happen!
(Do worry, I say that a lot - I'm usually wrong).
"

:)

- I'll simply do a dd if=3D/dev/md0 off=3D/dev/null and see what errors=
 =20
show up. I will report back when if finishes.

- Debian squeeze x64, with custom 3.15.3 kernel and mdadm 3.3. The md =20
volume was created with mdadm 3.3 and kernel 3.13 or 3.14 I think.

Cheers
Pedro

_______________________________________________________________________=
_________
Mensagem enviada atrav=C3=A9s do email gr=C3=A1tis AEIOU
http://www.aeiou.pt
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
