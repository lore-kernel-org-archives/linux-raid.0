From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: RAID6 - RMW logic
Date: Sun, 10 Aug 2014 17:49:58 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735863C68A@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD17358639B87@EXCHANGE.collogia.de>
	<20140731073007.3fe4817a@notabene.brown>
	<12EF8D94C6F8734FB2FF37B9FBEDD17358639D05@EXCHANGE.collogia.de>,<20140804112228.6ef95b10@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-3a4c7dfb-1055-4363-80e0-0a99f0787c77"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140804112228.6ef95b10@notabene.brown>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-3a4c7dfb-1055-4363-80e0-0a99f0787c77
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: NeilBrown [neilb@suse.de]=0A=
> Gesendet: Montag, 4. August 2014 03:22=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-raid@vger.kernel.org=0A=
> Betreff: Re: RAID6 - RMW logic=0A=
> =0A=
> > On Thu, 31 Jul 2014 06:43:52 +0000 Markus Stockhausen=0A=
> > <stockhausen@collogia.de> wrote:=0A=
> > =0A=
> > Hi,=0A=
> >=0A=
> > thanks for the link. Crawling through the modifcation I isolated two st=
eps=0A=
> > that we must achieve in first place to get it on track. I'm far away fr=
om=0A=
> > implementing a full patch so I focus on what I understand.=0A=
> >=0A=
> > 1) Implement a generic switch so we can configure rmw/rcw handling=0A=
> > on the fly. Without any RAID6 rmw patches yet it will simply focus on t=
he=0A=
> > current RAID5 implementation. Later on RAID6 can use it too and we=0A=
> > are able to  compare rmw versus rcw performance in all cases.=0A=
> > I would name the parameter enable_rmw and default it to 1. In RAID6 cas=
e=0A=
> > it will be ignored.=0A=
> >=0A=
> > -> Ok with that?=0A=
> =0A=
> No, sorry.  Or not very.=0A=
> =0A=
> In that email thread I pointed you to I wrote:=0A=
> =0A=
> - Can you  explain *why* rcw is sometimes better than rmw even on large=
=0A=
>   arrays? Even a fairly hand-wavy arguement would help.  And it would go =
in=0A=
>   the comment at the top of the patch that adds enable_rmw.=0A=
> =0A=
> =0A=
> I see you've posted a patch, but there is no "why".=0A=
> I don't like adding configuration options.  If there is some clear and ea=
sy=0A=
> to understand benefit, like "this trades throughput against latency", the=
n I=0A=
> might be able to live with one, because it would be easy to tell people h=
ow=0A=
> to tune it.=0A=
> =0A=
> Why would I ever disable rmw?  Don't say "choose the option that performs=
 best=0A=
> for your workload", because that is nearly meaningless: workloads change =
from=0A=
> moment to moment.  If rwm is good in some cases and bad in others, then w=
e=0A=
> should at least make sure we understand why, and then hopefully get the m=
d=0A=
> driver  to auto-detect the different cases.=0A=
> =0A=
> There might be a case for allowing an option like that to support a=0A=
> "developer only preview" of the code.  i.e.  Add the rmw-for-RAID6 code, =
find=0A=
> that is slows down some workloads, get confused about why, ask for help,=
=0A=
> people are only happy to  test if it is in mainline, so use a developer-o=
nly=0A=
> config option.=0A=
> Then at least I could tell people when to turn it on: only if you are a=
=0A=
> developer.=0A=
=0A=
As you might have seen I posted a complete rmw patch to the mailing list.=
=0A=
It is the first test version with the "developer switch". Sorry for being v=
ery=0A=
defensive in that way. Working only one week with the md raid code I=0A=
wanted to ensure that nothing gets broken. Especially I had hard times to=
=0A=
figure out the logic of the async layer. Therefore I'm very unsure if a sys=
tem =0A=
with hardware assisted P/Q calculation will benefit straight forward from =
=0A=
my patches. =0A=
=0A=
Additionaly I thought about some corner cases that might work better with=
=0A=
one special switch option. To detect them automatically in md might be beyo=
nd=0A=
the scope of this patch.=0A=
=0A=
Hopefully you can allay my concerns. If you like I can simply drop that swi=
tch=0A=
in the next version. =0A=
=0A=
> =0A=
> NeilBrown=0A=
=0A=
Thanks for your thoughts.=0A=
=0A=
Markus=
------=_NextPartTM-000-3a4c7dfb-1055-4363-80e0-0a99f0787c77
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

------=_NextPartTM-000-3a4c7dfb-1055-4363-80e0-0a99f0787c77--
