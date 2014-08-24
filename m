From: Markus Stockhausen <stockhausen@collogia.de>
Subject: [PATCH v3 0/6] md/raid6: support read-modify-write
Date: Sun, 24 Aug 2014 08:12:19 +0000
Message-ID: <790c83e3-5bc5-4ede-9b9e-370a786f4444@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-515d0382-2a91-4355-9475-9e2cd5ba8b49"
Return-path: <linux-raid-owner@vger.kernel.org>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-515d0382-2a91-4355-9475-9e2cd5ba8b49
Content-Type: text/plain

md/raid6: support read-modify-write 

v3: s-o-b comment

Once again thanks to an older patch from Kumar Sundararajan and 
Dan Williams that helped me to understand RAID6 logic inside md 
better. Everything is based on ideas & discussions that started
with http://marc.info/?l=linux-raid&m=136624783417452&w=1

Another try to implement RMW support for RAID6. This time improve
syndrome calculation too. A few things to note:

1) Patches are based on official 3.16 kernel git.

2) The required optimized syndrome functions were implemented if
possible. Generic & SSE2 are the ones that I could write & test
on my machine. If you want to test/benchmark this patch ensure
that you force select one of the two. Programmers with appropriate
hardware in their hands are encouraged to send the missing 
algorithms.

3) raid6 test program was enhanced to verify algorithm correctness. 
Additionaly this release was checked with a self written single 
threaded test tool I called wprd (write predictable random data).
Checked features include raid expansion, rebuild of failed drives, 
different RAID6 geometries, ... /dev/md0 and the underlying block
devices contents were checked with sha256sum against an expected 
result of the unpatched module. Knock on wood so far no failures.

Thanks Neil for your support.

Markus


------=_NextPartTM-000-515d0382-2a91-4355-9475-9e2cd5ba8b49
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

------=_NextPartTM-000-515d0382-2a91-4355-9475-9e2cd5ba8b49--
