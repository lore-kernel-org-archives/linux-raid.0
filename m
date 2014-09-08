From: Markus Stockhausen <stockhausen@collogia.de>
Subject: AW: raid5: direct IO and md_wakeup_thread
Date: Mon, 8 Sep 2014 07:24:55 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD17358644B61@EXCHANGE.collogia.de>
References: <12EF8D94C6F8734FB2FF37B9FBEDD1735864357D@EXCHANGE.collogia.de>,<20140908164615.0a7eb26d@notabene.brown>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-1c863075-380b-43a1-982c-40cac74147c1"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20140908164615.0a7eb26d@notabene.brown>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-1c863075-380b-43a1-982c-40cac74147c1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

> Von: NeilBrown [neilb@suse.de]=0A=
> Gesendet: Montag, 8. September 2014 08:46=0A=
> An: Markus Stockhausen=0A=
> Cc: linux-raid@vger.kernel.org=0A=
> Betreff: Re: raid5: direct IO and md_wakeup_thread=0A=
> =0A=
> On Fri, 5 Sep 2014 17:52:53 +0000 Markus Stockhausen=0A=
> <stockhausen@collogia.de> wrote:=0A=
> =0A=
> > Hi Neil,=0A=
> >=0A=
> > I hope you are doing better after the flu. Maybe you find some time=0A=
> > to explain the following codings in raid5.c to me. At least one of=0A=
> > the patchs seems to be signed off by you. The RAID5 I'm using has=0A=
> > default settings.=0A=
> >=0A=
> > 1) Generally speaking of md_wakup_thread() calls. Does it make=0A=
> > any sense to call them the from within raid5d()? Or when being=0A=
> > implemented at locations that might be called from the=0A=
> > make_request() path too - for simplicity no further caller destinction=
=0A=
> > was programmed.=0A=
> =0A=
> I doesn't make sense to all md_wakeup_thread() from somewhere that is *on=
ly*=0A=
> called within raid5d().  However most of raid5d() is handle_stripe() and=
=0A=
> handle_stripe() is called from other places.  So it could make sence to c=
all=0A=
> md_wakeup_thread from within handle_stripe().=0A=
> =0A=
> make_request() very likely wants to call md_wakeup_thread().... though I'=
m=0A=
> wondering if I understand that part of the question properly.=0A=
> =0A=
> >=0A=
> > 1) In case of a single direct I/O writer to the /dev/md0 device the=0A=
> > following coding will always fire the md_wakeup_thread(). That=0A=
> > is one reason for alternating raid5d loops one with data to=0A=
> > process and the next without. Is that corner case wanted?=0A=
> =0A=
> Is this a problem?  We often do things just in case they are needed,=0A=
> providing the cost isn't too great.=0A=
> =0A=
> If there was a measurable cost it might make sense to=0A=
> =0A=
>     clear_bit(THREAD_WAKEUP, &mddev->thread->flags);=0A=
> =0A=
> in raid5d() at the top of the while loop in raid5d().  We would need to m=
ove=0A=
> the md_check_recovery() call to the end of the function then.=0A=
> =0A=
> >=0A=
> > static void handle_stripe(struct stripe_head *sh)=0A=
> >         ...=0A=
> >         ops_run_io(sh, &s);=0A=
> >=0A=
> >         if (s.dec_preread_active) {=0A=
> >                 /* We delay this until after ops_run_io so that if make=
_request=0A=
> >                  * is waiting on a flush, it won't continue until the w=
rites=0A=
> >                  * have actually been submitted.=0A=
> >                  */=0A=
> >                 atomic_dec(&conf->preread_active_stripes);=0A=
> >                 if (atomic_read(&conf->preread_active_stripes) <=0A=
> >                     IO_THRESHOLD)=0A=
> >                         md_wakeup_thread(conf->mddev->thread); */=0A=
> >         }=0A=
> >=0A=
> > 2) The wakeup_thread() in the following preread path seems=0A=
> > to be unnecesary or will a double call wake the thread twice?=0A=
> =0A=
> Unnecessary in some cases, necessary in others.  Tracking exactly when it=
 is=0A=
> necessary would be complex and error prone.=0A=
> =0A=
> Are you just trying to understand the code, or is there something that yo=
u=0A=
> think is a problem that could be fixed?=0A=
=0A=
HI Neil,=0A=
=0A=
thanks for the explanations. I tried to understand the reason for the=0A=
"bad" benchmark numbers during my direct IO write tests for my rmw=0A=
patch. I only choose it to avoid caching side effects. Even with 64 =0A=
threads there is still a large gap to the theoretical maximum. So I =0A=
reduced the test to 1 writer and took some time to have a look how =0A=
raid5.c handles sync/direct writes. See my other post with only 5MB/s=0A=
4K direct writes to ramdisk backed raid5 md. =0A=
=0A=
With that insight I started to compare it to raid1.c. After some =0A=
iterations it came to my mind that the empty raid5d() runs between=0A=
two sync writes might give extra latency and so I looked for corners =0A=
where md_wakeup_thread() might be unnecessary. The result are=0A=
the questions above.=0A=
=0A=
I'll give the clear_bit(THREAD_WAKEUP,...) a try.=0A=
=0A=
Markus=
------=_NextPartTM-000-1c863075-380b-43a1-982c-40cac74147c1
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

------=_NextPartTM-000-1c863075-380b-43a1-982c-40cac74147c1--
