From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: removing RAID 1 from a RH 7.1 box
Date: Mon, 19 May 2003 19:26:10 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC913B2.8050403@hum.auc.dk>
References: <3EC911F6.B1797953@hailix.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EC911F6.B1797953@hailix.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Trevor Morrison wrote:

> Or, does any one know how to remove the RAID 1 setup from my system. =
 I
> followed the example for the the "Software RAID HOWTO" and it worked
> fine the first time.  Now, it looks like I may have to reverse it, bu=
t
> I don't know how.

You should be able to do that, by just doing this:

- Change your partition types from fd back to 83
- Move /etc/raidtab to some other name
- Change lilo back to not using /dev/md/*
- Change /etc/fstab back to not using /dev/md/*
- Reboot

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
