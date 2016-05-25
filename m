From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: [PATCH] right meaning of PARITY_ENABLE_RMW and PARITY_PREFER_RMW
Date: Wed, 25 May 2016 17:07:41 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1739B8071B4@EXCHANGE.collogia.de>
References: <1464049506-1589075-1-git-send-email-songliubraving@fb.com>,<20160525160216.GA15101@kernel.org>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-02e1678a-065d-44ce-8fcf-859a89c0a029"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20160525160216.GA15101@kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: Shaohua Li <shli@kernel.org>, Song Liu <songliubraving@fb.com>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-02e1678a-065d-44ce-8fcf-859a89c0a029
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.org]&=
quot; im Auftrag von &quot;Shaohua Li [shli@kernel.org]=0A=
> Gesendet: Mittwoch, 25. Mai 2016 18:02=0A=
> An: Song Liu=0A=
> Cc: linux-raid@vger.kernel.org; Markus Stockhausen; neilb@suse.de=0A=
> Betreff: Re: [PATCH] right meaning of PARITY_ENABLE_RMW and PARITY_PREFER=
_RMW=0A=
> =0A=
> On Mon, May 23, 2016 at 05:25:06PM -0700, Song Liu wrote:=0A=
> > In current handle_stripe_dirtying, the code prefers rmw with=0A=
> > PARITY_ENABLE_RMW; while prefers rcw with PARITY_PREFER_RMW.=0A=
> >=0A=
> > This patch reverses this behavior.=0A=
> >=0A=
> > Signed-off-by: Song Liu <songliubraving@fb.com>=0A=
> > Signed-off-by: Shaohua Li <shli@fb.com>=0A=
> > ---=0A=
> >  drivers/md/raid5.c | 4 ++--=0A=
> >  1 file changed, 2 insertions(+), 2 deletions(-)=0A=
> >=0A=
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c=0A=
> > index 8959e6d..ad9e15a 100644=0A=
> > --- a/drivers/md/raid5.c=0A=
> > +++ b/drivers/md/raid5.c=0A=
> > @@ -3600,7 +3600,7 @@ static void handle_stripe_dirtying(struct r5conf =
*conf,=0A=
> >       pr_debug("for sector %llu, rmw=3D%d rcw=3D%d\n",=0A=
> >               (unsigned long long)sh->sector, rmw, rcw);=0A=
> >       set_bit(STRIPE_HANDLE, &sh->state);=0A=
> > -     if ((rmw < rcw || (rmw =3D=3D rcw && conf->rmw_level =3D=3D PARIT=
Y_ENABLE_RMW)) && rmw > 0) {=0A=
> > +     if ((rmw < rcw || (rmw =3D=3D rcw && conf->rmw_level =3D=3D PARIT=
Y_PREFER_RMW)) && rmw > 0) {=0A=
> >               /* prefer read-modify-write, but need to get some data */=
=0A=
> >               if (conf->mddev->queue)=0A=
> >                       blk_add_trace_msg(conf->mddev->queue,=0A=
> > @@ -3627,7 +3627,7 @@ static void handle_stripe_dirtying(struct r5conf =
*conf,=0A=
> >                       }=0A=
> >               }=0A=
> >       }=0A=
> > -     if ((rcw < rmw || (rcw =3D=3D rmw && conf->rmw_level !=3D PARITY_=
ENABLE_RMW)) && rcw > 0) {=0A=
> > +     if ((rcw < rmw || (rcw =3D=3D rmw && conf->rmw_level !=3D PARITY_=
PREFER_RMW)) && rcw > 0) {=0A=
> >               /* want reconstruct write, but need to get some data */=
=0A=
> >               int qread =3D0;=0A=
> >               rcw =3D 0;=0A=
> > =0A=
> > The patch looks correct, I'll apply.=0A=
> =0A=
> I'm wondering why original code is in current way. It dosn't work like wh=
at the=0A=
> patch log (d06f191f8ecae) describes. Neil/Markus, is any patch missed?=0A=
=0A=
Hi,=0A=
=0A=
simple reason for usage of PARITY_ENABLE_RMW was the patch order. Option=0A=
PARITY_PREFER_RMW was implemented after all the rest. I guess I missed =0A=
changing that condition.=0A=
=0A=
Thanks for the fix.=0A=
=0A=
Markus=
------=_NextPartTM-000-02e1678a-065d-44ce-8fcf-859a89c0a029
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

------=_NextPartTM-000-02e1678a-065d-44ce-8fcf-859a89c0a029--
