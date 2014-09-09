From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: raid5: direct IO and md_wakeup_thread
Date: Tue, 9 Sep 2014 18:48:50 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD173586451C4@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735864357D@EXCHANGE.collogia.de>,<20140908164615.0a7eb26d@notabene.brown>,<12EF8D94C6F8734FB2FF37B9FBEDD17358644B61@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-b87c5a3c-1653-42ad-a2de-6e9288fd5bf8"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD17358644B61@EXCHANGE.collogia.de>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-b87c5a3c-1653-42ad-a2de-6e9288fd5bf8
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> HI Neil,=0A=
> =0A=
> thanks for the explanations. I tried to understand the reason for the=0A=
> "bad" benchmark numbers during my direct IO write tests for my rmw=0A=
> patch. I only choose it to avoid caching side effects. Even with 64=0A=
> threads there is still a large gap to the theoretical maximum. So I=0A=
> reduced the test to 1 writer and took some time to have a look how=0A=
> raid5.c handles sync/direct writes. See my other post with only 5MB/s=0A=
> 4K direct writes to ramdisk backed raid5 md.=0A=
> =0A=
> With that insight I started to compare it to raid1.c. After some=0A=
> iterations it came to my mind that the empty raid5d() runs between=0A=
> two sync writes might give extra latency and so I looked for corners=0A=
> where md_wakeup_thread() might be unnecessary. The result are=0A=
> the questions above.=0A=
> =0A=
> I'll give the clear_bit(THREAD_WAKEUP,...) a try.=0A=
> =0A=
> Markus=0A=
=0A=
Just an all-clear response. The error I was analyzing came from my=0A=
Virutalbox test environment. With more than one CPU activated=0A=
process synchronzation seems to face high synchonization penalties=0A=
between make_request() and raid5d(). Switching back to real =0A=
hardware with /dev/ramX shows normal throughput.  =0A=
=0A=
A lot to wonder about when testing the kernel ...=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-b87c5a3c-1653-42ad-a2de-6e9288fd5bf8
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

------=_NextPartTM-000-b87c5a3c-1653-42ad-a2de-6e9288fd5bf8--
