From: =?UTF-8?B?SsOpcsO0bWUgUG91bGlu?= <jeromepoulin@gmail.com>
Subject: Re: Rotating RAID 1
Date: Mon, 22 Aug 2011 23:45:53 -0400
Message-ID: <CALJXSJqYXmvfoperm10XCLnGNA4WgMt_y7UoUSgPv3xjqScNcg@mail.gmail.com>
References: <CALJXSJq6bDoWhSY3jQa8scpMo4QzHPzUvVPnHbox=xXYPm877w@mail.gmail.com>
 <4E497FB5.3030109@ivitera.com> <CALJXSJoexP9XKMqJSnJ7VFKu_6+j_k8b18G=KAtF8nEOuW6ytw@mail.gmail.com>
 <4E49849E.4030604@ivitera.com> <20110816084251.2d8e7831@notabene.brown>
 <CALJXSJqVD9ibB9LAM7jU5aJFbyEssCuf2QMai+K=8xk6=pfRew@mail.gmail.com> <20110816095517.757afc07@notabene.brown>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20110816095517.757afc07@notabene.brown>
Sender: linux-raid-owner@vger.kernel.org
To: NeilBrown <neilb@suse.de>
Cc: linux-raid <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Mon, Aug 15, 2011 at 7:55 PM, NeilBrown <neilb@suse.de> wrote:
> Yes, add another one later would be difficult. =C2=A0But if you know =
up-front that
> you will want three off-site devices it is easy.
>
> You could
>
> =C2=A0mdadm -C /dev/md0 -l1 -n2 -b internal /dev/A missing
> =C2=A0mdadm -C /dev/md1 -l1 -n2 -b internal /dev/md0 missing
> =C2=A0mdadm -C /dev/md2 -l1 -n2 -b internal /dev/md1 missing
> =C2=A0mdadm -C /dev/md3 -l1 -n2 -b internal /dev/md2 missing
>
> =C2=A0mkfs /dev/md3 ; mount ..
>
> =C2=A0So you now have 4 "missing" devices.

Alright, so I tried that on my project, being a low-end device is
resulted in about 30-40% performance lost with 8 MDs (planning in
advance), I tried disabling all bitmap to see if it helps and I get
minimal performance gain. Is there anything I should tune in this
case?
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
