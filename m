From: Mads Peter Bach <mpb@hum.auc.dk>
Subject: Re: RAID-5 missing one disk.
Date: Sun, 18 May 2003 11:27:49 +0200
Sender: linux-raid-owner@vger.kernel.org
Message-ID: <3EC75215.9040104@hum.auc.dk>
References: <3EC6AC4D.EDBE151E@vitoni.de> <3EC70A1C.4030401@hum.auc.dk> <3EC74F2C.17E260E8@vitoni.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <3EC74F2C.17E260E8@vitoni.de>
To: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

Victor wrote:
> Ok, so is it possible to build such an array?

Yes.

> I have 3 empty disks and 1 full of data. I would like to use the 3 di=
sks to build the array, copy the
> data from the full one into the array and then add the now empty disk=
=2E I read something of "degraded"
> arrays, but I haven't seen a self-explanatory howto about this anywhe=
re.

Install mdadm (http://www.cse.unsw.edu.au/~neilb/source/mdadm/) and rea=
d the=20
mdadm manpage (search for 'To create a "degraded" array').

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
