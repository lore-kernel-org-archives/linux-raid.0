From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: RAID6 write I/O amplification?
Date: Tue, 24 Feb 2015 06:29:38 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735F9E168E@EXCHANGE.collogia.de>
References: <20150224045835.14e40dcb@natsu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-a8269282-6203-4548-aca4-44b5f60eebf6"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150224045835.14e40dcb@natsu>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Roman Mamedov <rm@romanrm.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-a8269282-6203-4548-aca4-44b5f60eebf6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&=
quot; im Auftrag von &quot;Roman Mamedov [rm@romanrm.net]=0A=
> Gesendet: Dienstag, 24. Februar 2015 00:58=0A=
> An: linux-raid@vger.kernel.org=0A=
> Betreff: RAID6 write I/O amplification?=0A=
> =0A=
> Hello,=0A=
> =0A=
> Got a bit of a "how does it actually work" question...=0A=
> =0A=
> Suppose I have an MD RAID6 of 8 drives, with 64KB chunk size.=0A=
> =0A=
> I am rewriting a 4KB filesystem sector somewhere on that RAID (not crossi=
ng=0A=
> the stripe boundary).=0A=
> =0A=
> What's the amount of disk I/O in total this will result in?=0A=
> =0A=
> I assume the RAID will need to read data from all drives, recompute parit=
y,=0A=
> then write to the data stripe where the updated piece happened to be, and=
 also=0A=
> write to two parity stripes.=0A=
> =0A=
> Is this done at a stripe granularity, so 6x64KB reads, 3x64KB writes?=0A=
> Or down to individual sectors (pages), i.e. 6x4KB reads, 3x4KB writes?=0A=
> Or am I describing this algorithm correctly at all?=0A=
=0A=
Implementation will work on "internal" stripe granularity and that is 4K=0A=
So your case will be 6x4KB read + 3x4KB write. That said, you can only =0A=
reduce the I/O overhead by writing data that is larger than your configured=
 =0A=
stripe size (e.g. 64K).=0A=
=0A=
Looking at Neils development GIT you will find patches that allow =0A=
read-modify-write cycles for RAID6. So we only need the old block, the=0A=
old parities, recaluclate them and write the new block and the new parities=
.=0A=
In your case that would reduce the I/Os to 3x4KB read + 3x4KB write.=0A=
See http://git.neil.brown.name/?p=3Dmd.git;a=3Dshortlog;h=3Drefs/heads/deve=
l=0A=
=0A=
I posted them 6 months ago but they did not made their way into the=0A=
stable tree. Additionally it conatins patches to batch adjacent writes=0A=
to be processed in less & larger I/Os. Currently Linux Raid will break=0A=
each operation into 4K I/Os.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-a8269282-6203-4548-aca4-44b5f60eebf6
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

------=_NextPartTM-000-a8269282-6203-4548-aca4-44b5f60eebf6--
