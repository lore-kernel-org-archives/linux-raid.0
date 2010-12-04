From: "Majed B." <majedb@gmail.com>
Subject: Re: Degraded Array
Date: Sat, 4 Dec 2010 07:26:36 +0300
Message-ID: <AANLkTikd91t=aHK-CkV8TfqctA-np0YzDu79AtzAtZnK@mail.gmail.com>
References: <83.63.13137.69AA9FC4@cdptpa-omtalb.mail.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <83.63.13137.69AA9FC4@cdptpa-omtalb.mail.rr.com>
Sender: linux-raid-owner@vger.kernel.org
To: lrhorer@satx.rr.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

You have a degraded array now with 1 disk down. If you proceed, more
disks might pop out due to errors.

It's best to backup your data, run a check on the array, fix it then
try to resume the reshape.

On Sat, Dec 4, 2010 at 5:42 AM, Leslie Rhorer <lrhorer@satx.rr.com> wro=
te:
>
> Hello everyone.
>
> =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 I =
was just growing one of my RAID6 arrays from 13 to 14
> members.=C2=A0 The array growth had passed its critical stage and had=
 been
> growing for several minutes when the system came to a screeching halt=
=2E=C2=A0 It
> hit the big red switch, and when the system rebooted, the array assem=
bled,
> but two members are missing.=C2=A0 One of the members is the new driv=
e and the
> other is the 13th drive in the RAID set.=C2=A0 Of course, the array c=
an run well
> enough with only 12 members, but it=E2=80=99s definitely not the best=
 situation,
> especially since the re-shape will take another day and a half.=C2=A0=
 Is it best
> I go ahead and leave the array in its current state until the re-shap=
e is
> done, or should I go ahead and add back the two failed drives?
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid"=
 in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at =C2=A0http://vger.kernel.org/majordomo-info.ht=
ml



--
=C2=A0 =C2=A0 =C2=A0=C2=A0 Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
