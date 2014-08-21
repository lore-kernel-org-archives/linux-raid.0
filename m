From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH v2 0/6] raid6: support read-modify-write
Date: Thu, 21 Aug 2014 07:08:03 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863F22C@EXCHANGE.collogia.de>
References: <677cbe3b-4301-4650-962a-043f6ae59086@EXCHANGE.collogia.de>,<20140821145808.1ca8c5ee@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-81b81641-6d24-435c-b7dd-1d41b6474e86"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140821145808.1ca8c5ee@notabene.brown>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-81b81641-6d24-435c-b7dd-1d41b6474e86
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: NeilBrown [neilb@suse.de]=0A=
> Gesendet: Donnerstag, 21. August 2014 06:58=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-raid@vger.kernel.org=0A=
> Betreff: Re: [PATCH v2 0/6] raid6: support read-modify-write=0A=
> =0A=
> =0A=
> Thanks.  This looks a lot nicer.  If you resend them with the formatting =
a=0A=
> s-o-b changes I mentioned I'll put them in my try and try to do some test=
ing=0A=
> and look at bits more closely.=0A=
> Two things:=0A=
> 1/ I would be good to have performance numbers in the patch description f=
or=0A=
>    the patch that makes it all work.  Put yours there now, we can add oth=
er=0A=
>    later..=0A=
=0A=
will send patches the next days=0A=
=0A=
> 2/ When you do a partial syndrome you specify a start and end.=0A=
>    Is that really what is always wanted, or what is easiest?=0A=
>    I imaging that you might want to "add" or "subtract" an arbitrary subs=
et=0A=
>    of blocks.  I imaging that the "blocks" array of pointers that is=0A=
>    passing could have NULLs for the blocks to ignore and would include=0A=
>    all others in the computation.=0A=
>    Is there a good reason for not doing that.=0A=
=0A=
If you have a closer look the upper layers of the patch will do the NULL pa=
ge=0A=
handling - see set_syndrome_sources(). This is broken down into a design of=
=0A=
"start+stop+kernel zero page" algorithm in the syndrome functions. I opted =
=0A=
for that way because of the following reasons:=0A=
=0A=
- The original algorithms are based on "per-line" syndrome calculation. So =
they =0A=
will fully calculate x bytes of the syndrome while loading x bytes from all=
e the =0A=
source pages. If we would do a full calculation for the D0 page, then the D=
1 =0A=
page and so on we need to load/store the partially calculated P/Q values =
=0A=
multiple times. Additionally the calculation of GF(X) would be quite hard.=
=0A=
=0A=
- The stop page marker is the essential winner in our calculations because=
=0A=
everything right of that can be ignored.=0A=
=0A=
- NULL pages between data pages are hard to handle. This would lead to=0A=
more complexity & additional branches in the assembler routines. The SSE2=
=0A=
implementation needs 34*<number of disks> instructions to calculate 64=0A=
bytes of the syndrome. If a disk is zero one of these cycles can be reduced=
 =0A=
to 20 instructions. In my consideration chances will be high that only=0A=
adjacent pages will be written most of the time. So stay close to the=0A=
original design and keep things clean.=0A=
=0A=
- The start page marker is the clear indication for the functions that from=
=0A=
now on they only need the GF(X) multiplication. So once again do not=0A=
switch over to table lookups but stay with the old design. I know that=0A=
this is overhead if you change D13 in a 16 disk raid6. But even with this=
=0A=
we have only a quite small CPU overhead (factor 2 for calling the=0A=
xor_syndrome twice per rmw):=0A=
=0A=
- RCW: (14*34 instructions)/64 bytes + 13 read I/Os + 3 write I/Os=0A=
- RMW: (2*34+2*13*20 instructions)/64 bytes + 3 read I/Os + 3 write I/Os=0A=
=0A=
On the other hand changing D0 is a not-to-discuss clear win for the new=0A=
implementation:=0A=
=0A=
- RCW: (14*34 instructions)/64 bytes + 13 read I/Os + 3 write I/Os=0A=
- RMW: (2*34)/64 bytes + 3 read I/Os + 3 write I/Os=0A=
=0A=
Conclusion of it all: I had the choice between simply copying the=0A=
functions and adding the XOR at the end, my optimizations or a fully =0A=
optimized version. For the third part one needs a lot of real life sample d=
ata =0A=
and well defined perfomance comparisons. In my opinion all this =0A=
distracts from the original goal to save disk I/Os on spinning media. =0A=
=0A=
So the current design is a good balance between performance, simplicity =0A=
code-readability and avoiding spare pages. If you look at the original=0A=
implementation it just called gen_syndrome() twice for rmw and even =0A=
with that the numbers where quite impressive.=0A=
=0A=
> Apart from the the code looks quite nice and clean .... though I don't se=
em=0A=
> to be concentrating at my best today so I reserve the right to revise tha=
t=0A=
> assessment at a later date :-)=0A=
> =0A=
> Thanks,=0A=
> NeilBrown=0A=
=0A=
Markus=
------=_NextPartTM-000-81b81641-6d24-435c-b7dd-1d41b6474e86
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

------=_NextPartTM-000-81b81641-6d24-435c-b7dd-1d41b6474e86--
