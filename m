From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH v1 0/8] raid6: support read-modify-write
Date: Tue, 19 Aug 2014 16:40:25 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863EB4C@EXCHANGE.collogia.de>
References: <70b876f5-2336-4af1-bdc7-da789ecc3599@EXCHANGE.collogia.de>,<20140819171652.3fc62742@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-ffee0efb-06a6-431a-a068-f2f487a77ec3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140819171652.3fc62742@notabene.brown>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-ffee0efb-06a6-431a-a068-f2f487a77ec3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: NeilBrown [neilb@suse.de]=0A=
> Gesendet: Dienstag, 19. August 2014 09:16=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-raid@vger.kernel.org=0A=
> Betreff: Re: [PATCH v1 0/8] raid6: support read-modify-write=0A=
> =0A=
> Thanks for your effort so far.  If you can revise the patches so:=0A=
>  - config option is last=0A=
>  - 'hasxor' is not used=0A=
> I'll put them all in my git tree to make it a little easier for people to=
=0A=
> test, and probably do a little myself.=0A=
=0A=
Sent and hopefully up to your expectations.=0A=
=0A=
> Thanks=0A=
> NeilBrown=0A=
=0A=
Markus=
------=_NextPartTM-000-ffee0efb-06a6-431a-a068-f2f487a77ec3
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

------=_NextPartTM-000-ffee0efb-06a6-431a-a068-f2f487a77ec3--
