From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Last ditch effort for RH9 and LSR0
Date: Wed, 14 May 2003 02:45:20 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC191A0.8050801@hum.auc.dk>
References: <20030514001320.55709.qmail@web14401.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030514001320.55709.qmail@web14401.mail.yahoo.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brennahn Chesteine wrote:
> I am at my witts and with trying to install a new
> kernel under RH9. My system is set up with "root" and
> "swap" in LSR0 and "/boot" in LSR5. I have taken all
> know suggestions to get 2.4.20 to boot but nothing
> after a month.=20

If you by LSR5 mean Linux software RAID5, I'm not surprised it isn't wo=
rking.=20
You can't boot from a software RAID5 on Linux. To do that, lilo would h=
ave to=20
know how to pull different data chunks from different drives.
/boot on RAID1 works because RAID1 puts the same data on both drives.

--=20
Mads Peter Bach
Systemadministrator,  Det Humanistiske Fakultet, Aalborg Universitet
Kroghstr=E6de 3 - 5.111, DK-9220 Aalborg =D8st - (+45) 96358062
# whois MPB1-DK@whois.dk-hostmaster.dk

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
