From: Michael Evans <mjevans1983@gmail.com>
Subject: Re: Linux mdadm superblock question.
Date: Sun, 14 Feb 2010 12:07:45 -0800
Message-ID: <4877c76c1002141207s7bac4275xd12ed75e46a670c4@mail.gmail.com>
References: <201002140251.59668.volkerarmin@googlemail.com>
	 <4877c76c1002132002s20d942c3i7cee5418cdcf369c@mail.gmail.com>
	 <20100214193406.GA15722@khazad-dum.debian.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20100214193406.GA15722@khazad-dum.debian.net>
Sender: linux-kernel-owner@vger.kernel.org
To: Henrique de Moraes Holschuh <hmh@hmh.eng.br>
Cc: Volker Armin Hemmann <volkerarmin@googlemail.com>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Sun, Feb 14, 2010 at 11:34 AM, Henrique de Moraes Holschuh
<hmh@hmh.eng.br> wrote:
> On Sat, 13 Feb 2010, Michael Evans wrote:
>> I remember hearing that 1.x had /no/ plans for kernel level
>> auto-detection ever. =A0That can be accomplished in early-userspace
>> leaving the code in the kernel much less complex, and therefore far
>> more reliable.
>
> Yes, it is far more reliable kernel side, if only because it doesn't =
do
> anything.
>
> But the userspace reliability is _not_ good. =A0initrds are a source =
of
> problems the moment things start to go wrong, and that's when they ar=
e not
> the problem themselves.
>
> And the end result is a system that needs manual intervention to get =
its
> root filesystem back.
>
> In my experience, every time we moved critical codepaths to userspace=
, we
> ended up decreasing the *overall* system reliability.
>
> --
> =A0"One disk to rule them all, One disk to find them. One disk to bri=
ng
> =A0them all and in the darkness grind them. In the Land of Redmond
> =A0where the shadows lie." -- The Silicon Valley Tarot
> =A0Henrique Holschuh
>

Maybe you'd like a simple, easy to customize initramfs creator.
That's exactly what I was aiming for when I made AEUIO
https://sourceforge.net/projects/aeuio  There are some things that
could use improvement, but if your system can boot without loading
modules it should be more than sufficient even across kernel versions.
