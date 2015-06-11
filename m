From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: write performance of HW RAID VS MD RAID
Date: Thu, 11 Jun 2015 05:39:36 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735FCBEA69@EXCHANGE.collogia.de>
References: <CAF1ivSa644NVVd5R=2g8rvbZ-FK5cgXy_U1XJjYwMf+TJdftCw@mail.gmail.com>,<20150611052729.258dddfa@natsu>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-fad4ba7d-3eef-4eb3-8706-a85dd9f7763f"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20150611052729.258dddfa@natsu>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Ming Lin <mlin@kernel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, Neil Brown <neilb@suse.de>, Roman Mamedov <rm@romanrm.net>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-fad4ba7d-3eef-4eb3-8706-a85dd9f7763f
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&=
quot; im Auftrag von &quot;Roman Mamedov [rm@romanrm.net]=0A=
> Gesendet: Donnerstag, 11. Juni 2015 02:27=0A=
> An: Ming Lin=0A=
> Cc: linux-raid@vger.kernel.org; Neil Brown=0A=
> Betreff: Re: write performance of HW RAID VS MD RAID=0A=
> =0A=
> On Wed, 10 Jun 2015 15:27:07 -0700=0A=
> Ming Lin <mlin@kernel.org> wrote:=0A=
> =0A=
> > Hi NeilBrown,=0A=
> >=0A=
> > As you may already see, I run a lot of tests with 10 HDDs for the patch=
set=0A=
> > "simplify block layer based on immutable biovecs"=0A=
> >=0A=
> > Here is the summary.=0A=
> > http://minggr.net/pub/20150608/fio_results/summary.log=0A=
> >=0A=
> > MD RAID6 read performance is OK.=0A=
> > But write performance is much lower than HW RAID6.=0A=
> >=0A=
> > Is it a known issue?=0A=
> =0A=
> Did you tune the stripe_cache_size for the array? Try 32768.=0A=
> https://peterkieser.com/2009/11/29/raid-mdraid-stripe_cache_size-vs-write=
-transfer/=0A=
=0A=
+1 for giving an increased cache size a try. =0A=
=0A=
From the numbers I anticipate that you are doing sequential =0A=
read/write tests. Otherwise I would expect a write penalty for =0A=
the HW RAID setup too.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-fad4ba7d-3eef-4eb3-8706-a85dd9f7763f
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

------=_NextPartTM-000-fad4ba7d-3eef-4eb3-8706-a85dd9f7763f--
