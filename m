From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH v1 0/0] raid5: fix init_stripe() inconsistencies
Date: Wed, 20 Aug 2014 08:13:27 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863EE95@EXCHANGE.collogia.de>
References: <fb820ed5-44e5-4596-b8d4-956027be204a@EXCHANGE.collogia.de>,<20140820133658.1e8f1fb9@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-75c959ac-800a-4b7b-837d-51beb1550778"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140820133658.1e8f1fb9@notabene.brown>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-75c959ac-800a-4b7b-837d-51beb1550778
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: NeilBrown [neilb@suse.de]=0A=
> Gesendet: Mittwoch, 20. August 2014 05:36=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-raid@vger.kernel.org=0A=
> Betreff: Re: [PATCH v1 0/0] raid5: fix init_stripe() inconsistencies=0A=
> ...=0A=
> For future reference:=0A=
>  - put "md" at the start of the subject line. e.g. "md/raid5:"=0A=
>  - use "git show --format=3Demail" or some other incantation which=0A=
>    avoids  indenting the description.  Also avoid the "commit"=0A=
>    line.  Author: and Date: are redundant but I don't think they=0A=
>    are actually hurting.=0A=
>  - Be sure to include a Signed-off-by: line.  Find and read the DCO=0A=
>    (Developer's Certificate of Origin) to know what that means.=0A=
>    This patch is sufficiently trivial that I won't insist, but it is a go=
od=0A=
>    habit to get into (git commit --amend --sign --no-edit)=0A=
=0A=
Hi Neil,=0A=
=0A=
Good to know. Adapted my generator scripts for that. Do you want me to =0A=
resend the RMW patches that way?=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-75c959ac-800a-4b7b-837d-51beb1550778
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

------=_NextPartTM-000-75c959ac-800a-4b7b-837d-51beb1550778--
