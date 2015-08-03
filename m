From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: Thoughts on big SSD arrays?
Date: Mon, 3 Aug 2015 10:52:55 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735FCD391F@EXCHANGE.collogia.de>
References: <CAJvUf-AW08pcRkADn4Fgh46_vVAxgofiuB93+pzQYk99hx1nbw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-d8d0aa70-9089-46e7-ae9d-521397a2775a"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAJvUf-AW08pcRkADn4Fgh46_vVAxgofiuB93+pzQYk99hx1nbw@mail.gmail.com>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Matt Garman <matthew.garman@gmail.com>, Mdadm <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-d8d0aa70-9089-46e7-ae9d-521397a2775a
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&=
quot; im Auftrag von &quot;Matt Garman [matthew.garman@gmail.com]=0A=
> Gesendet: Freitag, 31. Juli 2015 17:23=0A=
> An: Mdadm=0A=
> Betreff: Thoughts on big SSD arrays?=0A=
> =0A=
> Every few years I reprise this topic on this mailing list[1], [2].=0A=
> Basically I'm just brainstorming what is possible on the DIY front=0A=
> versus purchased solutions from a traditional "big iron" storage=0A=
> vendor.  Our particular use case is "ultra-high parallel sequential=0A=
> read throughput".  Our workload is effectively WORM: we do a small=0A=
> daily incremental write, and then the rest of the time it's constant=0A=
> re-reading of the data.  Literally 99:1 read:write=0A=
> =0A=
> I continue to be inspired by the "Dirt Cheap Data Warehouse (DCDW)"=0A=
> [3].  SSD are getting bigger and prices are dropping rapidly (2 TB=0A=
> SSDs available now for $800).  With our WORM-like workload, I believe=0A=
> we can safely get away with consumer drives, as durability shouldn't=0A=
> be an issue.=0A=
> =0A=
> So at this point I'm just putting out a feeler---has anyone out there=0A=
> actually built a massive SSD array, using either Linux software raid=0A=
> or hardware raid (technically off-topic for this list, though I hope=0A=
> the discussion is interesting enough to let it slide).  If so, how big=0A=
> of an array (i.e. drives/capacity)?  What was the target versus actual=0A=
> performance?  Any particularly challenging issues that came up?=0A=
=0A=
Hi Matt,=0A=
=0A=
maybe not 100% matching... We wanted to start a 22 HDD md raid 6 last =0A=
year for one of our storage servers. Doing some tests we experienced =0A=
slow random write I/Os and got discouraged. So we headed over to=0A=
hardware raid. =0A=
=0A=
To get a clearer picture we did further analysis. The bootleneck arised =0A=
from two sources. md issued only 4K I/Os and it always did a reconstruct=0A=
write. Thus massive write amplification. Several patches in 4.1 mitigate=0A=
the situation. In between I like a lot of things in md raid 4/5/6. Especial=
ly =0A=
the parity calucation massively benefits from high power CPUs.=0A=
=0A=
Back to the reason for my explanation: The biggest "area under construction=
"=0A=
in md raid 4/5/6 is the internal stripe cache handling. Allocating, flushin=
g=0A=
and freeing stripes is based on solid but not tuned algorithms (like LRU). =
=0A=
IIRC it does not even have a scheduling or queueing. That could become=0A=
your bottleneck. Maybe massive CPU power easily compensates the gap. =0A=
=0A=
That said. Your read mostly setup might avoid a lot of headaches but you =
=0A=
need to push it to the limits yourself. I do not see benchmarks in the net =
=0A=
that closely fit your case. So I advise to enable ramdisks in the Linux =0A=
kernel and build a raid 6 on top of /dev/ramX. A synthetic test according=
=0A=
to your needs should give an idea of scalability and overhead of md raid. =
=0A=
=0A=
Good luck.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-d8d0aa70-9089-46e7-ae9d-521397a2775a
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

------=_NextPartTM-000-d8d0aa70-9089-46e7-ae9d-521397a2775a--
