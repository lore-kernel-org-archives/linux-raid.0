From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH v3 5/6] md/raid5: activate raid6 rmw feature
Date: Sun, 24 Aug 2014 17:22:55 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863FC91@EXCHANGE.collogia.de>
References: <5e18e849-8c3d-4812-8fb2-9da8df0ea883@EXCHANGE.collogia.de>,<21497.57016.978419.117894@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-3f7cfc07-ca31-4510-8e32-a4cfc5e2ee2e"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21497.57016.978419.117894@quad.stoffel.home>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-3f7cfc07-ca31-4510-8e32-a4cfc5e2ee2e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: John Stoffel [john@stoffel.org]=0A=
> Gesendet: Sonntag, 24. August 2014 14:46=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-raid@vger.kernel.org=0A=
> Betreff: Re: [PATCH v3 5/6] md/raid5: activate raid6 rmw feature=0A=
> ...=0A=
> Also, how does the patch look when you have a simple 4 disk RAID6 array? =
 =0A=
> I would hope that since the parity overhead is much higher, it would show=
 =0A=
> more improvement as well.=0A=
=0A=
Maybe I did not explain exactly what this patch is for. To boil it down to =
four=0A=
short and simple key facts.=0A=
=0A=
- The current kernel implementation of RAID6 is very I/O expensive for smal=
l =0A=
changes. We always need to read all unchanged blocks of the same stripe, =
=0A=
recalulate the parity and write the new data block plus two parities. So a =
single=0A=
block change will produce n (number of disks) I/Os. The source code calls i=
t =0A=
RCU - reconstruct write.=0A=
=0A=
- With the patch we will only read the old data of the to be changed block =
& the =0A=
parities, recalculate the parities with the new data and rewrite everthing =
back. A =0A=
single block change will only have 6 I/Os regardless of the number of disks=
. It =0A=
is called RMW - read modify write. =0A=
=0A=
- This patch will only kick in if you have 7 or more disks in a RAID6. And =
ONLY=0A=
if I/Os RMW < I/Os RCU. This should answer your question above.=0A=
=0A=
- The more disks we have and the smaller the changed data is the more benef=
it=0A=
we will get from that patch.  =0A=
=0A=
Markus=
------=_NextPartTM-000-3f7cfc07-ca31-4510-8e32-a4cfc5e2ee2e
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

------=_NextPartTM-000-3f7cfc07-ca31-4510-8e32-a4cfc5e2ee2e--
