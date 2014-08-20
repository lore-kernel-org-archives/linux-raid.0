From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH v2 0/6] raid6: support read-modify-write
Date: Wed, 20 Aug 2014 06:30:46 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863ED72@EXCHANGE.collogia.de>
References: <677cbe3b-4301-4650-962a-043f6ae59086@EXCHANGE.collogia.de>,<21491.57825.401637.881344@quad.stoffel.home>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-b9066506-9599-45c6-a799-b91d0927ffa3"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <21491.57825.401637.881344@quad.stoffel.home>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: John Stoffel <john@stoffel.org>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-b9066506-9599-45c6-a799-b91d0927ffa3
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: John Stoffel [john@stoffel.org]=0A=
> Gesendet: Mittwoch, 20. August 2014 01:46=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-raid@vger.kernel.org=0A=
> Betreff: Re: [PATCH v2 0/6] raid6: support read-modify-write=0A=
> =0A=
> >>>>> "Markus" =3D=3D Markus Stockhausen <stockhausen@collogia.de> writes=
:=0A=
> =0A=
> Markus> 300 seconds random write with 8 threads=0A=
> Markus> 3,2TB (10*400GB) RAID6 64K chunk without spare=0A=
> Markus> group_thread_cnt=3D4=0A=
> =0A=
> Markus> bsize   rmw_level=3D1   rmw_level=3D0   rmw_level=3D1   rmw_level=
=3D0=0A=
> Markus>         skip_copy=3D1   skip_copy=3D1   skip_copy=3D0   skip_copy=
=3D0=0A=
> Markus>    4K      115 KB/s      141 KB/s      165 KB/s      140 KB/s=0A=
> Markus>    8K      225 KB/s      275 KB/s      324 KB/s      274 KB/s=0A=
> Markus>   16K      434 KB/s      536 KB/s      640 KB/s      534 KB/s=0A=
> Markus>   32K      751 KB/s    1,051 KB/s    1,234 KB/s    1,045 KB/s=0A=
> Markus>   64K    1,339 KB/s    1,958 KB/s    2,282 KB/s    1,962 KB/s=0A=
> Markus>  128K    2,673 KB/s    3,862 KB/s    4,113 KB/s    3,898 KB/s=0A=
> Markus>  256K    7,685 KB/s    7,539 KB/s    7,557 KB/s    7,638 KB/s=0A=
> Markus>  512K   19,556 KB/s   19,558 KB/s   19,652 KB/s   19,688 Kb/s=0A=
> =0A=
> Which is the current 3.16.0 implementation?  I can't keep it straight=0A=
> in my head and you don't clearly specify which set is what we have=0A=
> now, and which is your patch and it's option(s) in place.=0A=
=0A=
Standard of 3.16 in the above numbers is rmw_level=3D0/skip_copy=3D0.=0A=
My patch will be rmw_level=3D1/skip_copy=3D0. I just included skip copy as=
=0A=
I found it on the mailing list and was interested how rmw plays with stable=
=0A=
pages without need for bio page copies.=0A=
 =0A=
> What type of system did you run this test on?  How much CPU/RAM, etc?=0A=
> Can you should the configuration of the filesystem/MD volume you wrote=0A=
> too as well?  Sorry to be picky here, I'm just trying to see what this=0A=
> buys us.  Were the disks using SATA?  IDE?  What speed are the disks?=0A=
=0A=
It is a single E5630 with 24GB RAM. Although this should not matter as I=0A=
made direct I/O. My tests wrote directly to /dev/md0 no filesystem in betwe=
en.=0A=
Disks are a bunch of 500GB-1TB SATA I/II 7200rpm. Server/Desktop mixed.=0A=
 =0A=
> Also, how does the SSE2 optimization work?  Can it be turned on/off?=0A=
> And how much speedup does it provide?=0A=
=0A=
SSE2 optimization is not an option it is a must. The RAID6 algorithms are =
=0A=
choosen on startup. In my case the system chooses the SSE2 implementation.=
=0A=
The old patch used the already available implementation of gen_syndrome().=
=0A=
This always overwrote the parity blocks and needed extra spare pages. The =
=0A=
discussion result about it was, that md should use an inplace syndrome =0A=
calculation for the rmw case. Thus I was forced to copy the algorithms to a=
 =0A=
new xor_syndrome() call. =0A=
=0A=
Difference between standard and SSE optimized gen_syndrome is in my=0A=
case 1-2GB/sec versus 9-10GB/sec (iirc). So it won't make any sense to offe=
r=0A=
rmw and fall back to a xor_syndrome() calulation with a default implementat=
ion=0A=
that is 5 times slower.=0A=
=0A=
To avoid side effects the patch will disable rmw if the choosen existing =
=0A=
optimized gen_syndrome() function does not offer a xor_syndrome() =0A=
"brother".=0A=
=0A=
> Otherwise, I don't see any huge improvements with the  numbers, and=0A=
> the only consistent win is the rmw_level=3D1, skip_copy=3D0 case.  But=0A=
> even then when the bsize is big enough it's slower than other=0A=
> options.  So is it a win overall?=0A=
=0A=
This was the maximum of hardware that I could find in the short time. The=
=0A=
original patch post gives better numbers because it used 12 disks. For me=
=0A=
reasonable raid6 configurations range from 10-16 disks. So for the upper=0A=
end the caluclation shows even more potential (but must be proven). =0A=
=0A=
From simple math for 16 disks:=0A=
- Update one block or one chunk=0A=
- RCW case: 13 read  I/Os + 3 write I/Os=0A=
- RMW case: 3 read I/Os + 3 write I/Os=0A=
 =0A=
> John=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-b9066506-9599-45c6-a799-b91d0927ffa3
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

------=_NextPartTM-000-b9066506-9599-45c6-a799-b91d0927ffa3--
