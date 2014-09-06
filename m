From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: AW: RAID456 direct I/O write performance
Date: Sat, 6 Sep 2014 19:46:47 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735864380B@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358642FF8@EXCHANGE.collogia.de>
 <12EF8D94C6F8734FB2FF37B9FBEDD17358643012@EXCHANGE.collogia.de>,<5408D5CC.101@shiftmail.org>,<12EF8D94C6F8734FB2FF37B9FBEDD173586435A5@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-2fd04474-8f84-418d-bc30-b2461e9a7a3e"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <12EF8D94C6F8734FB2FF37B9FBEDD173586435A5@EXCHANGE.collogia.de>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Ethan Wilson <ethan.wilson@shiftmail.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-2fd04474-8f84-418d-bc30-b2461e9a7a3e
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: Markus Stockhausen=0A=
> Gesendet: Freitag, 5. September 2014 20:06=0A=
> An: Ethan Wilson; linux-raid@vger.kernel.org=0A=
> Betreff: AW: AW: RAID456 direct I/O write performance=0A=
> =0A=
> > Von: Ethan Wilson [ethan.wilson@shiftmail.org]=0A=
> > Gesendet: Donnerstag, 4. September 2014 23:12=0A=
> > An: linux-raid@vger.kernel.org=0A=
> > Betreff: Re: AW: RAID456 direct I/O write performance=0A=
> >=0A=
> > On 04/09/2014 18:30, Markus Stockhausen wrote:=0A=
> > > A perf record of the 1 writer test gives:=0A=
> > >=0A=
> > >      38.40%      swapper  [kernel.kallsyms]   [k] default_idle=0A=
> > >      13.14%    md0_raid5  [kernel.kallsyms]   [k] _raw_spin_unlock_ir=
qrestore=0A=
> > >      13.05%      swapper  [kernel.kallsyms]   [k] tick_nohz_idle_ente=
r=0A=
> > >      10.01%          iot  [raid456]           [k] raid5_unplug=0A=
> > >       9.06%      swapper  [kernel.kallsyms]   [k] tick_nohz_idle_exit=
=0A=
> > >       3.39%    md0_raid5  [kernel.kallsyms]   [k] __kernel_fpu_begin=
=0A=
> > >       1.67%    md0_raid5  [xor]               [k] xor_sse_2_pf64=0A=
> > >       0.87%          iot  [kernel.kallsyms]   [k] finish_task_switch=
=0A=
> > >=0A=
> > > I'm confused and clueless. Especially I cannot see where the=0A=
> > > 10% overhead in the source of raid5_unplug might come=0A=
> > > from? Any idea from someone with better insight?=0A=
> >=0A=
> > I am no kernel developer but I have read that the CPU time for serving=
=0A=
> > interrupts is often accounted to the random process which has the bad=
=0A=
> > luck to be running at the time the interrupt comes and steals the CPU. =
I=0A=
> > read this for top, htop etc, which have probably a different accounting=
=0A=
> > mechanism than perf, but maybe something similar happens here, because=
=0A=
> > _raw_spin_unlock_irqrestore at 13% looks too absurd to me.=0A=
> > In fact, probably as soon as the interrupts are re-enabled by=0A=
> > _raw_spin_unlock_irqrestore, the CPU often goes serving one interrupt=
=0A=
> > that was queued, and this is before the function=0A=
> > _raw_spin_unlock_irqrestore exits, so the time is really accounted ther=
e=0A=
> > and that's why it's so high.=0A=
> =0A=
> Thanks Ethan for the explanation.=0A=
> =0A=
> In between I found the reason for the slowness. RAID5 handles direct IO=
=0A=
> write requests sequentially with each one restarting the raid5d() worker=
=0A=
> thread (more lke sync IO). The raid1d() worker thread can batch those=0A=
> requests. Maybe Neil can tell if that behaviour is desired.=0A=
=0A=
Hopefully right this time - correcting myself to not spread wrong =0A=
information: In raid1 case kernel writes via calling raid1_unplug(). Block =
=0A=
handling is done within the function inside the calling thread. In raid5 =
=0A=
case kernel calls raid5_unplug() for writeout handling. Inside we just =0A=
have waiting logic for the raid5d() thread completion. So the numbers=0A=
seem to be reasonable.=0A=
=0A=
A funny side effect is: A slow sequential directio or sync writer to a md=
=0A=
raid456 on fast devices can be sped up by starting a (independent) =0A=
reader - even to non md devices. Maybe because of thread scheduling =0A=
optimization.=0A=
=0A=
Markus=0A=
------=_NextPartTM-000-2fd04474-8f84-418d-bc30-b2461e9a7a3e
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

------=_NextPartTM-000-2fd04474-8f84-418d-bc30-b2461e9a7a3e--
