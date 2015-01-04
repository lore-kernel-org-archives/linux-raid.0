From: sylvain.depuille@laposte.net
Subject: =?utf-8?Q?Re:_Re=C2=A0:_Re:_Big_trouble_during_reassemble_a_Raid5?=
Date: Sun, 4 Jan 2015 19:19:47 +0100 (CET)
Message-ID: <88720318.23672175.1420395587173.JavaMail.zimbra@laposte.net>
References: <2105542796.11263344.1419768937013.JavaMail.zimbra@laposte.net> <A6F7476D-8314-480D-B6B5-F84FF1F0960B@laposte.net> <21668.12775.212408.482021@quad.stoffel.home> <480970436.16926591.1420048769566.JavaMail.zimbra@laposte.net> <21668.19044.575022.311461@quad.stoffel.home> <1476942476.18574241.1420136514556.JavaMail.zimbra@laposte.net> <21670.6532.641717.517799@quad.stoffel.home> <54A64FEB.8090109@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <54A64FEB.8090109@gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Can Jeuleers <can.jeuleers@gmail.com>
Cc: John Stoffel <john@stoffel.org>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello,=20

thank's for the tricks.

I have modify the #! as #!/usr/bin/python2 because i have python 2.7 an=
d 3.3 as default on my PCs.

I keep this script on my PCs, and the output ;-)

Thank's a lot.
Best Regards

----- Mail original -----=20
De: "Can Jeuleers" <can.jeuleers@gmail.com>=20
=C3=80: "John Stoffel" <john@stoffel.org>, "sylvain depuille" <sylvain.=
depuille@laposte.net>=20
Cc: linux-raid@vger.kernel.org=20
Envoy=C3=A9: Vendredi 2 Janvier 2015 08:59:39=20
Objet: Re: Re : Re: Big trouble during reassemble a Raid5=20

On 02/01/15 05:07, John Stoffel wrote:=20
> My real suggestion to you is to now collect all the information you=20
> can on the system, including drive serial numbers, and how they map t=
o=20
> each device and member of the RAID array. Sometimes when a system=20
> reboots, or you add new disks, things get re-arranged and you don't=20
> notice at first. And that leads you down the wrong path quite=20
> quickly.=20

Sylvain, a nice script for documenting device serial numbers,=20
partitions, RAID memberships etc can be found here:=20

https://github.com/pturmel/lsdrv/raw/master/lsdrv=20

Written by Phil Turmel; a frequent contributor to this list.=20

Jan=20

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
