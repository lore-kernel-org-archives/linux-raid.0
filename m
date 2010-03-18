From: Joachim Otahal <Jou@gmx.net>
Subject: Re: RAID Class Drives`
Date: Thu, 18 Mar 2010 17:45:33 +0100
Message-ID: <4BA258AD.5020605@gmx.net>
References: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <7db987b31003170648j19e3346bi1050e703ef8c811c@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Randy Terbush <randy@terbush.org>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Randy Terbush schrieb:
> So the question becomes, do I try it again with the replacement drive=
s
> that Seagate is sending me, or do I hang them in my "desktop" and
> spend the money for RAID Class drives? (I've grown tired of this
> learning experience and would like to just have a dependable storage
> system)
>   =20
Desktop class drives are usually enough. On todays mobo's chipset SATA=20
is enough too. You should take care of the temperature of the drives,=20
30=B0C to 35=B0C is preferred, above 35=B0C the lifespan goes down, ove=
r 40=B0C=20
rapidly down.
Do you have a regular checkarray interval? Like this one from debian=20
(monthly first sunday):
57 0 * * 0 root [ -x /usr/share/mdadm/checkarray ] && [ $(date +\%d) -l=
e=20
7 ] && /usr/share/mdadm/checkarray --cron --all --quiet
Do you have a regular SMART check? Not only check the SMART status, kee=
p=20
the history of some values which change over time, most notably the=20
Reallocated Sector Count, if that one changes every week on one drive=20
(or even faster) it is time to take that drive out of the array.

> Why would these drives be developing errors as a result of their
> tortuous experience in a RAID array?
>   =20
I don't think RAID is more stress than normal use at home, it depends o=
n=20
how long they run, how often they spin up, how hot they get.
As for you description of the error behaviour: This is correct,=20
RAID-SATA-drives don't spend a minute or more trying to read a possibly=
=20
failing sector, most only try for less than 5 seconds to re-read a=20
sector Also their mechanics have lower tolerance allowing higher MBTF=20
values.

kind regards,

Joachim Otahal
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
