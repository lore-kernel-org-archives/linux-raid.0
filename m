From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: Last ditch effort for RH9 and LSR0
Date: Wed, 14 May 2003 03:03:57 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC195FD.70609@hum.auc.dk>
References: <20030514005119.10758.qmail@web14410.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20030514005119.10758.qmail@web14410.mail.yahoo.com>
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Brennahn Chesteine wrote:
> Then how does the stock RH kernel boot this cursid thing up? I have h=
ad 1
> and 5 and just a lone /boot partition but nothing has worked so far.

I have no idea. I can't see how they would be able to do it with RAID5,=
 unless
grub or whatever bootloader RedHat uses is MUCH smarter than I give it =
credit for.

If you can't get it to boot, when your /boot is just a normal partition=
, then
you should probably look elsewhere for a problem.

If you include your bootup messages, it would be much easier to figure =
out what
goes wrong.

You could also include the output of "cat /proc/mdstat" and "mount", wh=
en your
system is bootet with the redhat kernel.

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
