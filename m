From: Markus Stockhausen <stockhausen@collogia.de>
Subject: raid5: direct IO and md_wakeup_thread
Date: Fri, 5 Sep 2014 17:52:53 +0000
Message-ID: <12EF8D94C6F8734FB2FF37B9FBEDD1735864357D@EXCHANGE.collogia.de>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----=_NextPartTM-000-e13bc510-7475-4ee2-a3eb-a971e7a5c1b1"
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Language: de-DE
Sender: linux-raid-owner@vger.kernel.org
To: "neilb@suse.de" <neilb@suse.de>
Cc: "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids


This is a multi-part message in MIME format.

------=_NextPartTM-000-e13bc510-7475-4ee2-a3eb-a971e7a5c1b1
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Hi Neil,=0A=
=0A=
I hope you are doing better after the flu. Maybe you find some time =0A=
to explain the following codings in raid5.c to me. At least one of=0A=
the patchs seems to be signed off by you. The RAID5 I'm using has =0A=
default settings.=0A=
=0A=
1) Generally speaking of md_wakup_thread() calls. Does it make=0A=
any sense to call them the from within raid5d()? Or when being =0A=
implemented at locations that might be called from the =0A=
make_request() path too - for simplicity no further caller destinction =0A=
was programmed.=0A=
 =0A=
1) In case of a single direct I/O writer to the /dev/md0 device the =0A=
following coding will always fire the md_wakeup_thread(). That=0A=
is one reason for alternating raid5d loops one with data to =0A=
process and the next without. Is that corner case wanted?=0A=
=0A=
static void handle_stripe(struct stripe_head *sh)=0A=
        ...=0A=
        ops_run_io(sh, &s);=0A=
=0A=
        if (s.dec_preread_active) {=0A=
                /* We delay this until after ops_run_io so that if make_req=
uest=0A=
                 * is waiting on a flush, it won't continue until the write=
s=0A=
                 * have actually been submitted.=0A=
                 */=0A=
                atomic_dec(&conf->preread_active_stripes);=0A=
                if (atomic_read(&conf->preread_active_stripes) <=0A=
                    IO_THRESHOLD)=0A=
                        md_wakeup_thread(conf->mddev->thread); */=0A=
        }=0A=
=0A=
2) The wakeup_thread() in the following preread path seems=0A=
to be unnecesary or will a double call wake the thread twice?=0A=
=0A=
void do_release_stripe(struct r5conf *conf, struct stripe_head *sh,=0A=
                              struct list_head *temp_inactive_list, int mst=
wake)=0A=
{=0A=
        BUG_ON(!list_empty(&sh->lru));=0A=
        BUG_ON(atomic_read(&conf->active_stripes)=3D=3D0);=0A=
        if (test_bit(STRIPE_HANDLE, &sh->state)) {=0A=
                if (test_bit(STRIPE_DELAYED, &sh->state) &&=0A=
                    !test_bit(STRIPE_PREREAD_ACTIVE, &sh->state)) {=0A=
                        list_add_tail(&sh->lru, &conf->delayed_list);=0A=
                        if (atomic_read(&conf->preread_active_stripes)=0A=
                            < IO_THRESHOLD)=0A=
                                md_wakeup_thread(conf->mddev->thread);=0A=
                } else if (test_bit(STRIPE_BIT_DELAY, &sh->state) &&=0A=
                        ...=0A=
                }=0A=
                md_wakeup_thread(conf->mddev->thread);=0A=
                ...=0A=
=0A=
Thanks in advance.=0A=
=0A=
Markus=
------=_NextPartTM-000-e13bc510-7475-4ee2-a3eb-a971e7a5c1b1
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

------=_NextPartTM-000-e13bc510-7475-4ee2-a3eb-a971e7a5c1b1--
