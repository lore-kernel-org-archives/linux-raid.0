From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Hot remove issue
Date: Mon, 14 Apr 2003 03:58:44 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3E9A15D4.3060706@hum.auc.dk>
References: <5.2.0.9.0.20030414113355.06084be0@144.135.24.13>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <5.2.0.9.0.20030414113355.06084be0@144.135.24.13>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Lucian Daniel Kafka wrote:
> Hi.
>=20
> I am having the noted problem of hot removing a drive from a md1 arra=
y=20
> (see log below).

You need to set the drive as faulty first, before you can remove it. Yo=
u can=20
use mdadm --fail to do that.
>=20
> Also, the /etc/raidtab seems to be ignored. I have tried to set drive=
s=20
> as failed-disk, hoping to remove them after the next reboot, but that=
=20
> didn't work.

No, that's only for building an array.

> Also, I have tried to change the order in which the md=20
> devices are initialized (by swapping entries in /etc/raidtab), but th=
at=20
> had no effect either.

You can disable the raid autostart and use mdadm to start your arrays i=
n the=20
order you want.

--=20
Mads Peter Bach
Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st
# whois MPB1-DK@whois.dk-hostmaster.dk

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
