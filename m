From: Eric BENARD / Free <ebenard@free.fr>
Subject: Re: MD drivers problems on 2.4.x
Date: Wed, 28 May 2003 13:33:43 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <200305281333.44071.ebenard@free.fr>
References: <200305231535.17808.ebenard@free.fr> <200305260817.20409.ebenard@free.fr> <Pine.LNX.4.53.0305270728140.9980@duplo.agenda.si>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.53.0305270728140.9980@duplo.agenda.si>
Content-Disposition: inline
To: danci@agenda.si
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Le Mardi 27 Mai 2003 07:30, danci@agenda.si a =E9crit :
> There is your problem - Western Digital. The firmware on some of WD d=
rives
> is very BAD and WD offers an upgrade. Go check out their web site...
>
in fact, maybe you were right : I upgraded the firmware of the 4 disks =
(even=20
if Western says my drives were not affected by the problem), I upgraded=
 to=20
kernel 2.4.21-rc4 and ran heavy tests on the system without any crash (=
400 GB=20
transfered between the RAID filseystems, 400 GB transfered from network=
 at=20
the same time, cpubrun running ...)

Many thanks !
Eric
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
