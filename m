From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: Bigger stripe size
Date: Thu, 14 Aug 2014 06:33:51 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863D7F2@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735863D351@EXCHANGE.collogia.de>,<20140814141151.15d473c2@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-afe532c3-7f24-447c-85e8-83db856f9c8c"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140814141151.15d473c2@notabene.brown>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "shli@kernel.org" <shli@kernel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-afe532c3-7f24-447c-85e8-83db856f9c8c
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: NeilBrown [neilb@suse.de]=0A=
> Gesendet: Donnerstag, 14. August 2014 06:11=0A=
> An: Markus Stockhausen=0A=
> Cc: shli@kernel.org; linux-raid@vger.kernel.org=0A=
> Betreff: Re: Bigger stripe size=0A=
> ...=0A=
> >=0A=
> > Will it make sense to work with per-stripe sizes? E.g.=0A=
> >=0A=
> > User reads/writes 4K -> Work on a 4K stripe.=0A=
> > User reads/writes 16K -> Work on a 16K stripe.=0A=
> >=0A=
> > Difficulties.=0A=
> >=0A=
> > - avoid overlapping of "small" and "big" stripes=0A=
> > - split stripe cache in different sizes=0A=
> > - Can we allocate multi-page memory to have continous work-areas?=0A=
> > - ...=0A=
> >=0A=
> > Benefits.=0A=
> >=0A=
> > - Stripe handling unchanged.=0A=
> > - paritiy calculation more efficient=0A=
> > -  ...=0A=
> >=0A=
> > Other ideas?=0A=
> =0A=
> I fear that we are chasing the wrong problem.=0A=
> =0A=
> The scheduling of stripe handling is currently very poor.  If you do a la=
rge=0A=
> sequential write which should map to multiple full-stripe writes, you sti=
ll=0A=
> get a lot of reads.  This is bad.=0A=
> The reason is that limited information is available to the raid5 driver=
=0A=
> concerning what is coming next and it often guesses wrongly.=0A=
> =0A=
> I suspect that it can be made a lot cleverer but I'm not entirely sure ho=
w.=0A=
> A first step would be to "watch" exactly what happens in terms of the way=
=0A=
> that requests come down, the timing of 'unplug' events, and the actual=0A=
> handling of stripes.  'blktrace' could provide most or all of the raw dat=
a.=0A=
>=0A=
=0A=
Thanks for that info. I did not expect to find so basic challenges in the c=
ode ...=0A=
Could you explain what you mean with unplug events? Maybe you can give me=
=0A=
the function in raid5.c that would be the right place to understand better =
how=0A=
changed data "leaves" the stripes and puts it on freelists again.=0A=
=0A=
> =0A=
> Then determine what the trace "should" look like and come up with a way f=
or=0A=
> raid5 too figure that out and do it.=0A=
> I suspect that might involve are more "clever" queuing algorithm, possibl=
y=0A=
> keeping all the stripe_heads sorted, possibly storing them in an RB-tree.=
=0A=
> =0A=
> Once you have that queuing in place so that the pattern of write requests=
=0A=
> submitted to the drives makes sense, then it is time to analyse CPU effic=
iency=0A=
> and find out where double-handling is happening, or when "batching" or=0A=
> re-ordering of operations can make a difference.=0A=
> If the queuing algorithm collects contiguous sequences of stripe_heads=0A=
> together, then processes a batch of them in succession make provide the s=
ame=0A=
> improvements as processing fewer larger stripe_heads.=0A=
> =0A=
> So: first step is to get the IO patterns optimal.  Then look for ways to=
=0A=
> optimise for CPU time.=0A=
> =0A=
> NeilBrown=0A=
=0A=
Markus=
------=_NextPartTM-000-afe532c3-7f24-447c-85e8-83db856f9c8c
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

------=_NextPartTM-000-afe532c3-7f24-447c-85e8-83db856f9c8c--
