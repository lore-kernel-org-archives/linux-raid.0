From: "Dan Williams" <dan.j.williams@gmail.com>
Subject: Re: 2.6.23.1: mdadm/raid5 hung/d-state
Date: Mon, 5 Nov 2007 11:35:13 -0700
Message-ID: <e9c3a7c20711051035m78ba90ck68f4fbc10480462a@mail.gmail.com>
References: <Pine.LNX.4.64.0711040658180.30831@p34.internal.lan>
	 <18222.16003.92062.970530@notabene.brown>
	 <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.64.0711041651250.23496@p34.internal.lan>
Content-Disposition: inline
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Neil Brown <neilb@suse.de>, linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, =?ISO-8859-1?Q?BERTRAND_Jo=EBl?= <joel.bertrand@systella.fr>
List-Id: linux-raid.ids

On 11/4/07, Justin Piszcz <jpiszcz@lucidpixels.com> wrote:
>
>
> On Mon, 5 Nov 2007, Neil Brown wrote:
>
> > On Sunday November 4, jpiszcz@lucidpixels.com wrote:
> >> # ps auxww | grep D
> >> USER       PID %CPU %MEM    VSZ   RSS TTY      STAT START   TIME C=
OMMAND
> >> root       273  0.0  0.0      0     0 ?        D    Oct21  14:40 [=
pdflush]
> >> root       274  0.0  0.0      0     0 ?        D    Oct21  13:00 [=
pdflush]
> >>
> >> After several days/weeks, this is the second time this has happene=
d, while
> >> doing regular file I/O (decompressing a file), everything on the d=
evice
> >> went into D-state.
> >
> > At a guess (I haven't looked closely) I'd say it is the bug that wa=
s
> > meant to be fixed by
> >
> > commit 4ae3f847e49e3787eca91bced31f8fd328d50496
> >
> > except that patch applied badly and needed to be fixed with
> > the following patch (not in git yet).
> > These have been sent to stable@ and should be in the queue for 2.6.=
23.2
> >
>
> Ah, thanks Neil, will be updating as soon as it is released, thanks.
>

Are you seeing the same "md thread takes 100% of the CPU" that Jo=EBl i=
s
reporting?
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
