From: Mikhail Yakshin <greycat@altlinux.org>
Subject: [ANNOUNCE] Einarc - universal RAID management/monitoring tool
Date: Thu, 29 Nov 2007 02:17:41 +0300
Message-ID: <474DF715.8030708@altlinux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Hello!

I'd like to introduce release of Einarc project - an universal RAID=20
management/monitoring tool.

Some time ago, I've started working with various hardware RAID=20
controllers and quickly was disappointed by the fact that almost all of=
=20
them require proprietary utilities to manage. For example, it's=20
virtually impossible to monitor RAID status from running Linux without=20
installing one on Areca, Adaptec, LSI, 3ware, CCISS, etc controllers.

Moreover, all these proprietary utilities were sometimes hard to find=20
and every one of the have a different interface, command line options,=20
etc. There seemed to be even no standard for entities hierarchy: Areca=20
uses 3-tier hierarchy (physical discs - raidsets - volumesets), LSI use=
s=20
2-tier one (physical - logical discs).

So, after giving it some thought and searching for a solution to unite=20
them all, I've found out that there almost no such thing. ManageEngine=20
OpStor is a proprietary and pretty expensive product that can do it and=
=20
only other attempts in this area seemed to be OpenBSD's bioctl=20
initiative that faded out in 2005-2006.

Generally, the idea is simple: Einarc works as a translator that makes=20
it possible for a user to control all these devices using simple terms=20
like =E2=80=9Cphysical disc=E2=80=9D, =E2=80=9Clogical disc=E2=80=9D, =E2=
=80=9Cadapter=E2=80=9D, etc, while=20
transparently converting these requests to proprietary RAID paradigms.=20
In fact, the system still uses underlying proprietary CLIs, but the use=
r=20
doesn=E2=80=99t interact with them directly, staying in a single,=20
well-documented interface.

During its installation, it automatically downloads these proprietary=20
utils (after reading & agreeing to their licenses), unpacks and install=
s=20
them, and then, for example, command like

einarc -t areca physical list

would be translated into

/usr/local/lib/einarc/areca/cli disk info

then it's result parsed and returned in the same well-documented form a=
s=20
for any other Einarc-supported adapter.

I'd be really happy to hear any opinions / thoughts / feature requests=20
on this project and I hope it would come useful to someone :) Einarc ca=
n=20
be reached at

http://www.inquisitor.ru/doc/einarc/

for downloading and documentation.

--=20
WBR, Mikhail Yakshin AKA GreyCat
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
