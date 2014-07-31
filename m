From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: RAID6 - RMW logic
Date: Thu, 31 Jul 2014 06:43:52 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD17358639D05@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358639B87@EXCHANGE.collogia.de>,<20140731073007.3fe4817a@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-977aaadd-0074-4917-9d0e-58137d02ac42"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140731073007.3fe4817a@notabene.brown>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-977aaadd-0074-4917-9d0e-58137d02ac42
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-raid-owner@vger.kernel.org =0A=
> Gesendet: Mittwoch, 30. Juli 2014 23:30=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-raid@vger.kernel.org=0A=
> Betreff: Re: RAID6 - RMW logic=0A=
> =0A=
> On Wed, 30 Jul 2014 20:24:30 +0000 Markus Stockhausen=0A=
> <stockhausen@collogia.de> wrote:=0A=
> =0A=
> > Hi,=0A=
> >=0A=
> > the last days I tried to understand the RAID6 logic when recalculating=
=0A=
> > P/Q parity (or syndrome) if only parts of a stripe are updated. As far=
=0A=
> > ...=0A=
>=0A=
> Please see=0A=
>   http://comments.gmane.org/gmane.linux.raid/42559=0A=
> =0A=
> Yes, this is something we probably want.=0A=
> The previous effort stalled somehow.  Maybe it just needs someone to star=
t=0A=
> pushing again.=0A=
> =0A=
> NeilBrown=0A=
=0A=
Hi,=0A=
=0A=
thanks for the link. Crawling through the modifcation I isolated two steps=
=0A=
that we must achieve in first place to get it on track. I'm far away from=
=0A=
implementing a full patch so I focus on what I understand.=0A=
=0A=
1) Implement a generic switch so we can configure rmw/rcw handling=0A=
on the fly. Without any RAID6 rmw patches yet it will simply focus on the=
=0A=
current RAID5 implementation. Later on RAID6 can use it too and we=0A=
are able to  compare rmw versus rcw performance in all cases.=0A=
I would name the parameter enable_rmw and default it to 1. In RAID6 case =
=0A=
it will be ignored.=0A=
=0A=
-> Ok with that?=0A=
=0A=
2) The previous patch was quite tricky with handling the P/Q calculation.=
=0A=
It combined a gen_syndrome run with 2 extra xor runs. Additionally it=0A=
saved P/Q delta in spare pages. Maybe to avoid patching gen_syndrome =0A=
functions. I understand the discussion that the flag "subtract" and the han=
dling=0A=
of the second spare page is not easy to understand. As explained in my=0A=
last mail I would enhance the syndrome functions with the option to XOR the=
 =0A=
target P/Q pages instead of only storing the calculated values. This would =
allow =0A=
to work the same way the RAID5 shortcut does. See ops_run_prexor that uses =
=0A=
parity page to store the interim result.=0A=
=0A=
From a performance perspective I would write separate logic in /lib/raid6 =
=0A=
by copying the existing functions. Another approach could be to change =0A=
all gen_syndrome functions to xor the destination page - and empty the=0A=
target page in advance for the rcw case. In all cases this patch will be qu=
ite =0A=
huge but I should be easy to understand and to verify.=0A=
=0A=
-> Suggestions?=0A=
=0A=
Best regards.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-977aaadd-0074-4917-9d0e-58137d02ac42
Content-Type: text/plain;
	name="InterScan_Disclaimer.txt"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="InterScan_Disclaimer.txt"

****************************************************************************
Diese E-Mail enthält vertrauliche und/oder rechtlich geschützte
Informationen. Wenn Sie nicht der richtige Adressat sind oder diese E-Mail
irrtümlich erhalten haben, informieren Sie bitte sofort den Absender und
vernichten Sie diese Mail. Das unerlaubte Kopieren sowie die unbefugte
Weitergabe dieser Mail ist nicht gestattet.

Über das Internet versandte E-Mails können unter fremden Namen erstellt oder
manipuliert werden. Deshalb ist diese als E-Mail verschickte Nachricht keine
rechtsverbindliche Willenserklärung.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

Vorstand:
Kadir Akin
Dr. Michael Höhnerbach

Vorsitzender des Aufsichtsrates:
Hans Kristian Langva

Registergericht: Amtsgericht Köln
Registernummer: HRB 52 497

This e-mail may contain confidential and/or privileged information. If you
are not the intended recipient (or have received this e-mail in error)
please notify the sender immediately and destroy this e-mail. Any
unauthorized copying, disclosure or distribution of the material in this
e-mail is strictly forbidden.

e-mails sent over the internet may have been written under a wrong name or
been manipulated. That is why this message sent as an e-mail is not a
legally binding declaration of intention.

Collogia
Unternehmensberatung AG
Ubierring 11
D-50678 Köln

executive board:
Kadir Akin
Dr. Michael Höhnerbach

President of the supervisory board:
Hans Kristian Langva

Registry office: district court Cologne
Register number: HRB 52 497

****************************************************************************

------=_NextPartTM-000-977aaadd-0074-4917-9d0e-58137d02ac42--
