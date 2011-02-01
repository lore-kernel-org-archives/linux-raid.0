From: Roberto Spadim <roberto@spadim.com.br>
Subject: Re: nbd / hot plug
Date: Tue, 1 Feb 2011 18:49:07 -0200
Message-ID: <AANLkTinbrvs6Hh=y4qrAxNW5-=Kd+rTRspwnnASHH3YW@mail.gmail.com>
References: <AANLkTi=NEgB_fJPfsK+36wUWZ_Kc_W23v15nT1Qz9iTP@mail.gmail.com>
	<AANLkTi=uPpV0BGoMQytTofa3986a08GMGHT_8areu6Jk@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=uPpV0BGoMQytTofa3986a08GMGHT_8areu6Jk@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: paul.clements@us.sios.com
Cc: Linux-RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

nice =3DD raid over ethernet! =3DD
just a heart beath and a primary decision algorithm to make a HA :D
thanks for the notice paul
i didn=B4t like drbd it=B4s have a algorithm that i can=B4t execute sin=
ce my
app must return the primary decision algorithm :/

2011/2/1 Paul Clements <paul.clements@steeleye.com>:
> On Sun, Jan 30, 2011 at 3:27 PM, Roberto Spadim <roberto@spadim.com.b=
r> wrote:
>> hi guys, i was thinking about nbd problems with server disconnection=
 /
>> client disconnection
>> it's not like a SATA disk hot plug?
>> for example unplug the disk (SATA) =A0=3D unplug the network card
>> could md raid work with it?
>> i tried but i should run
>> mdadm fail / remove / add
>> to get nbd back in array, it's right?
>
> Yes, nbd with md/raid works fine. If the nbd connection gets broken,
> the nbd component of the array will fail, you can then remove it and
> re-add it.
>
> --
> Paul
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
