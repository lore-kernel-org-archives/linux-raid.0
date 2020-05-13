From: Song Liu <song@kernel.org>
Subject: Re: Assemblin journaled array fails
Date: Wed, 13 May 2020 09:17:17 -0700
Message-ID: <CAPhsuW70NNozBmt1-zsM_Pk-39cLzi8bC3ZZaNwQ0-VgYsmkiA@mail.gmail.com>
References: <f8c61278-1758-66cd-cf25-8a118cb12f58@yandex.pl>
 <70dad446-7d38-fd10-130f-c23797165a21@yandex.pl> <56b68265-ca54-05d3-95bc-ea8ee0b227f6@yandex.pl>
 <CAPhsuW4WcqkDXOhcuG33bZtSEZ-V-KYPLm87piBH24eYEB0qVw@mail.gmail.com> <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <b9b6b007-2177-a844-4d80-480393f30476@yandex.pl>
Sender: linux-raid-owner@vger.kernel.org
To: Michal Soltys <msoltyspl@yandex.pl>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

> >
> > Are these captured back to back? I am asking because they showed differ=
ent
> > "Events" number.
>
> Nah, they were captured between reboots. Back to back all event fields sh=
ow identical value (at 56291 now).
>
> >
> > Also, when mdadm -A hangs, could you please capture /proc/$(pidof mdadm=
)/stack ?
> >
>
> The output is empty:
>
> xs22:/=E2=98=A0 ps -eF fww | grep mdadm
> root     10332  9362 97   740  1884  25 12:47 pts/1    R+     6:59  |   \=
_ mdadm -A /dev/md/r5_big /dev/md/r1_journal_big /dev/sdi1 /dev/sdg1 /dev/s=
dj1 /dev/sdh1
> xs22:/=E2=98=A0 cd /proc/10332
> xs22:/proc/10332=E2=98=A0 cat stack
> xs22:/proc/10332=E2=98=A0

Hmm... Could you please share the strace output of "mdadm -A" command? Like

strace mdadm -A /dev/md/r5_big /dev/md/r1_journal_big /dev/xxx ...

Thanks,
Song
