From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: RAID456 direct I/O write performance
Date: Thu, 4 Sep 2014 16:30:12 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD17358643012@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358642FF8@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-1b781858-5b9e-4858-9189-b060f91d0e78"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD17358642FF8@EXCHANGE.collogia.de>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-1b781858-5b9e-4858-9189-b060f91d0e78
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Sorry must be=0A=
=0A=
>=0A=
> Hello,=0A=
> =0A=
> Doing some benchmark tests for my patch series I discovered that=0A=
> direct I/O performance for a single thread onto raid456 md seems=0A=
> to be not on par with what I would have expected.=0A=
> =0A=
> A simple 5 minute test run with md on top of /dev/ramX ramdisks=0A=
> reveals:=0A=
> =0A=
> raid5 - 3 disks - chunk 32k - 1 writer=0A=
> 4K random direct IO writes: 5MB/sec (five megabytes per second)=0A=
> =0A=
=0A=
raid5 - 3 disks - chunk 32k - 1 writer=0A=
4K random writes (*NOT direct IO*): 600MB/sec=0A=
=0A=
>=0A=
>raid5 - 3 disks - chunk 32k - 8 writers=0A=
>4K random direct IO writes: 45MB/sec=0A=
>=0A=
=0A=
raid5 - 3 disks - chunk 32k - 8 writers=0A=
4K random writes (*NOT direct IO*): 800MB/sec=0A=
=0A=
> =0A=
> for comparison:=0A=
> =0A=
> raid1 - 3 disks - 1 writer=0A=
> 4K random direct IO writes: 150MB/sec=0A=
> =0A=
> That would be a 1ms penalty per one md block write (or to be=0A=
> precise per 3 device I/Os). A similar I/O overhead on the three=0A=
> disk RAID1 shows reasonable numbers.=0A=
> =0A=
> A perf record of the 1 writer test gives:=0A=
> =0A=
>     38.40%      swapper  [kernel.kallsyms]   [k] default_idle=0A=
>     13.14%    md0_raid5  [kernel.kallsyms]   [k] _raw_spin_unlock_irqrest=
ore=0A=
>     13.05%      swapper  [kernel.kallsyms]   [k] tick_nohz_idle_enter=0A=
>     10.01%          iot  [raid456]           [k] raid5_unplug=0A=
>      9.06%      swapper  [kernel.kallsyms]   [k] tick_nohz_idle_exit=0A=
>      3.39%    md0_raid5  [kernel.kallsyms]   [k] __kernel_fpu_begin=0A=
>      1.67%    md0_raid5  [xor]               [k] xor_sse_2_pf64=0A=
>      0.87%          iot  [kernel.kallsyms]   [k] finish_task_switch=0A=
> =0A=
> I'm confused and clueless. Especially I cannot see where the=0A=
> 10% overhead in the source of raid5_unplug might come=0A=
> from? Any idea from someone with better insight?=0A=
> =0A=
=0A=
Markus=0A=
=0A=
=0A=
=0A=
=0A=
=0A=
------=_NextPartTM-000-1b781858-5b9e-4858-9189-b060f91d0e78
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

------=_NextPartTM-000-1b781858-5b9e-4858-9189-b060f91d0e78--
