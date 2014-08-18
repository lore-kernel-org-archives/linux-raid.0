From: Markus Stockhausen <stockhausen@collogia.de>
Subject: raid5.c internal stripe layout
Date: Mon, 18 Aug 2014 18:32:57 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863E62B@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-30692194-f250-489a-811c-060fd8993103"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-30692194-f250-489a-811c-060fd8993103
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,=0A=
=0A=
I'm wondering if there are any pros/cons for handling stripes in memory=0A=
exactly in the same layout as on disks. There are several places that could=
=0A=
be simplified if parity disks would be always at the end (DDD..DDPQ). Of =
=0A=
course one would have to do the mapping during read/write operations.=0A=
=0A=
Cases for optimization would be:=0A=
=0A=
- replace conditions "i =3D=3D pd_idx || i =3D=3D qd_qdx" with "i>=3Dpd_idx=
"=0A=
- run data disk loops starting/ending with pd_idx (triple parity raid somed=
ay?)=0A=
- remove syndrome disk order calculation functions=0A=
- Shaohua's last patch could cross chunks=0A=
- ...=0A=
=0A=
Just in case I missed a discussion I'm interested if patches are welcome.=
=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-30692194-f250-489a-811c-060fd8993103
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

------=_NextPartTM-000-30692194-f250-489a-811c-060fd8993103--
