From: =?UTF-8?Q?Mathias_Bur=C3=A9n?= <mathias.buren@gmail.com>
Subject: Re: md - cache
Date: Wed, 16 Feb 2011 16:18:48 +0000
Message-ID: <AANLkTikxz2sBxJWdbPrddJh5uzO8ksQeMPiyL_zH4Z_Z@mail.gmail.com>
References: <AANLkTi=qav77Q8pjU8_xhmuvYSkZk7_Hwd3Xe89BWtBK@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=qav77Q8pjU8_xhmuvYSkZk7_Hwd3Xe89BWtBK@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Roberto Spadim <roberto@spadim.com.br>
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 16 February 2011 16:01, Roberto Spadim <roberto@spadim.com.br> wrote=
:
> hi guys, i was thinking about cache insues
> since md =3D multiple devices
> could we implement a new device used for caches? (port bcache to md,
> or flashcache (facebook))
> something like:
> mdadm --create /dev/md1 --level=3Dcache --cache-device=3D/dev/XXX
> --data-device=3D/dev/ZZZZ
>
> --
> Roberto Spadim
> Spadim Technology / SPAEmpresarial
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml
>

RAM
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
