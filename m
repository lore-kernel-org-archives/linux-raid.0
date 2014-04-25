From: "L. M. J" <linuxmasterjedi@free.fr>
Subject: Re: Corrupted ext4 filesystem after mdadm manipulation error
Date: Fri, 25 Apr 2014 13:43:17 +0200
Message-ID: <2ecef7f1-fde7-48c9-87bf-47ff617956b3@email.android.com>
References: <20140424070548.445497dd@netstation> <20140424194832.2d0a867f@netstation> <CAK_KU4a+Ep7=F=NSbb-hqN6Rvayx4QPWm-M2403OHn5-LVaNZw@mail.gmail.com> <20140424203506.5fdee0d3@netstation> <CAK_KU4Zh-azXEEzW4f1m=boCZDKevqaSHxW0XoAgRdrCbm2PkA@mail.gmail.com> <CAK_KU4aDDaUSGgcGBwCeO+yE0Qa_pUmMdAHMu7pqO7dqEEC71g@mail.gmail.com> <20140424215654.0447d300@netstation> <CAK_KU4YUejncX9yQk4HM5HE=1-qPPxOibuRauFheo3jaBc8SaQ@mail.gmail.com> <20140425071340.1ac35ded@netstation> <alpine.DEB.2.02.1404250802070.19744@uplift.swm.pp.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <alpine.DEB.2.02.1404250802070.19744@uplift.swm.pp.se>
Sender: linux-raid-owner@vger.kernel.org
To: Mikael Abrahamsson <swmike@swm.pp.se>
Cc: Scott D'Vileskis <sdvileskis@gmail.com>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On 25 avril 2014 08:04:13 CEST, Mikael Abrahamsson <swmike@swm.pp.se> w=
rote:
>On Fri, 25 Apr 2014, L.M.J wrote:
>
>> Well, what should I do now ? mkfs everything and restart from scratc=
h
>?
>
>Most likely this is your only option. First you overwrote the
>superblocks=20
>so the drives came in the wrong order (most likely) and then you ran a=
=20
>read/write fsck on it.
>
>The thing to do is to make sure md is read only and use fsck in=20
>readonly-mode as a diagnostics tool to see if everything is right. If
>you=20
>get it wrong and do fsck in read/write mode it's going to change thing=
s
>
>destructively.

I haven't done a R/W fuck yet, only on LVM snapshot to test, never on r=
eal data.=20
Does it change anything?=20
--=20
May the open source be with you my young padawan.=20

Envoy=C3=A9 de mon t=C3=A9l=C3=A9phone, excusez la bri=C3=A8vet=C3=A9.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
