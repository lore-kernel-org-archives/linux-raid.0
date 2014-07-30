From: Markus Stockhausen <stockhausen@collogia.de>
Subject: RAID6 - RMW logic
Date: Wed, 30 Jul 2014 20:24:30 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD17358639B87@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-acac4191-4f64-4403-983d-78f42343fa8e"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-acac4191-4f64-4403-983d-78f42343fa8e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi,=0A=
=0A=
the last days I tried to understand the RAID6 logic when recalculating=0A=
P/Q parity (or syndrome) if only parts of a stripe are updated. As far=0A=
as I get the current implementation right it will always read the whole=0A=
stripe and build parities from scratch. E.g. updating a single chunk=0A=
on a 10 disk RAID6 will read the other 7 data blocks to write the block=0A=
plus 2 P/Q parities afterwards. Compared to the best case 3 read plus=0A=
3 write operations this can be quite a heavy impact. RAID5 at least=0A=
has a shortcut for that.=0A=
=0A=
Being no specialist at all - but having some ideas - I would like to=0A=
get some feedback about the following way to improve the scenario.=0A=
=0A=
1) Write a modified gen_syndrome function (call it xor_syndrome)=0A=
like in lib/raid6/xxx.c that allows to XOR an existing P/Q parity=0A=
without overwriting it. The cost of that function would be the same=0A=
as it only changes a few assembler commands.=0A=
=0A=
2) Enhance the ops_run_prexor to call this xor_syndrome function=0A=
for an RAID6. Fill the not relevant pages (R5_wantdrain) with an=0A=
empty page or NULL. So the gen_syndrome will only find zeroes.=0A=
With this call P/Q will have a pre-xored version.=0A=
=0A=
3) Enhance ops_run_reconstruct6 to allow processing of changed=0A=
blocks only. We will call xor_snydrome from there too, to XOR=0A=
the prexored P/Q once again.=0A=
=0A=
4) Enhance handle_stripe_dirtying so it will allow calculation of=0A=
RCW versus RMW costs for the RAID6 case.=0A=
=0A=
Did I miss something? And if not: Will the doubled CPU consumption =0A=
for P/Q calculation justify that way of implementation? At least=0A=
we can avoid IOs on slow disks.=0A=
=0A=
Maybe it has been discussed before but I did not find it on the=0A=
mailing list.=0A=
=0A=
Thanks in advance.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-acac4191-4f64-4403-983d-78f42343fa8e
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

------=_NextPartTM-000-acac4191-4f64-4403-983d-78f42343fa8e--
