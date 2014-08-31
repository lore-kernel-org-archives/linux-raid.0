From: Markus Stockhausen <stockhausen@collogia.de>
Subject: RAID6 rmw - new numbers
Date: Sun, 31 Aug 2014 16:05:50 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173586419F5@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-f4aa4cfe-ee59-4710-9e8c-9f0a71950f53"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>, "john@stoffel.org" <john@stoffel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-f4aa4cfe-ee59-4710-9e8c-9f0a71950f53
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hello,=0A=
=0A=
I had some time for additional benchmarks. My initial numbers=0A=
were too low because I didn't push the system to its limits with=0A=
high parallelism.=0A=
=0A=
Test program http://www.corpit.ru/mjt/iot.c=0A=
settings: 180 seconds random write, 3 runs, 64 threads, direct I/O=0A=
command line: iot -d -W64 -b <blocksize> -t 180 /dev/md0=0A=
=0A=
bsize    w/o patch   w/o patch   w/o patch=0A=
               min         avg         max=0A=
   4K      317KB/s     318KB/s     319KB/s=0A=
   8K      611KB/s     614KB/s     617KB/s=0A=
  16K     1153KB/s    1153KB/s    1154KB/s=0A=
  32K     2239KB/s    2253KB/s    2263KB/s=0A=
  64K     3944KB/s    3959KB/s    3978KB/s=0A=
 128K     7792KB/s    7891KB/s    8025KB/s=0A=
 256K    15456KB/s   15574KB/s   15805KB/s=0A=
 512K    32406KB/s   32564KB/s   32799KB/s=0A=
1024K    57378KB/s   57965KB/s   58550KB/s=0A=
=0A=
bsize   with patch  with patch  with patch    real  math gain=0A=
               min         avg         max    gain  in theory=0A=
   4K      417KB/s     420KB/s     423KB/s  +32,1%       +66%=0A=
   8K      806KB/s     818KB/s     826KB/s  +33,2%       +66%=0A=
  16K     1504KB/s    1518KB/s    1531KB/s  +31,6%       +66%=0A=
  32K     2993KB/s    3001KB/s    3016KB/s  +33,2%       +66%=0A=
  64K     5396KB/s    5477KB/s    5543KB/s  +38,3%       +66%=0A=
 128K     8971KB/s    9082KB/s    9169KB/s  +15,1%       +25%=0A=
 256K    15406KB/s   15545KB/s   15751KB/s   -0,2%         0%=0A=
 512K    32361KB/s   32619KB/s   32981KB/s   +0,1%         0%=0A=
1024K    58134KB/s   58239KB/s   58419KB/s   +0,4%         0%=0A=
=0A=
As I got no feedback from Neil until now:=0A=
=0A=
- Shall I resend the patches with the new numbers?=0A=
- What else can I do to push the patches further?=0A=
=0A=
Markus=
------=_NextPartTM-000-f4aa4cfe-ee59-4710-9e8c-9f0a71950f53
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

------=_NextPartTM-000-f4aa4cfe-ee59-4710-9e8c-9f0a71950f53--
