From: <stockhausen@collogia.de>
Subject: [PATCH v1 0/8] raid6: support read-modify-write
Date: Sun, 10 Aug 2014 11:56:23 +0000
Message-ID: <70b876f5-2336-4af1-bdc7-da789ecc3599@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-ff859fb9-7fb3-422b-b0b8-9dd32788cc4a"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-ff859fb9-7fb3-422b-b0b8-9dd32788cc4a
Content-Type: text/plain

Hello all.

First of all thanks to an older patch from Kumar Sundararajan and 
Dan Williams that helped me to understand RAID6 logic inside md 
better. Everything is based on ideas & discussions that started
with http://marc.info/?l=linux-raid&m=136624783417452&w=1

So once again. Implement RMW support for RAID6. This time improve
syndrome calculation too. The logic was split into very small  
parts. Each having a detailed explanation about what is going on.
A few things to note:

1) Patches are based on official 3.16 kernel git.

2) The required optimized syndrome functions were implemented if
possible. Generic & SSE2 are the ones that I could write & test
on my machine. If you want to test/benchmark this patch ensure
that you force select one of the two. Programmers with appropriate
hardware in their hands are encouraged to send the missing 
algorithms.

3) raid6 test program was enhanced to verify algorithm correctness. 
This first release is based on single threaded tests writing blocks 
with random data and size directly onto the /dev/mdX device using 
dd.  Afterwards a md check run verified consistency of the array.
So we are in need for experienced stress testers.

4) With only a VM on my laptop available I have no real benchmark
numbers. They should be on par and sometimes even higher (or less 
CPU consuming) than the old patch because of the syndrome redesign.
Maybe testers can contribute some numbers.

Any kind of feedback appreciated.

Markus


------=_NextPartTM-000-ff859fb9-7fb3-422b-b0b8-9dd32788cc4a
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

------=_NextPartTM-000-ff859fb9-7fb3-422b-b0b8-9dd32788cc4a--
