From: "Majed B." <majedb@gmail.com>
Subject: Re: About seting up Raid5 on a four disk box.
Date: Wed, 14 Oct 2009 16:41:49 +0300
Message-ID: <70ed7c3e0910140641x74c12a75k6f00df2ed3cbade0@mail.gmail.com>
References: <hb1udb$6t1$1@ger.gmane.org> <70ed7c3e0910130704l1f1f7f0ar66271d85295c667b@mail.gmail.com>
	<hb2470$rol$1@ger.gmane.org> <70ed7c3e0910130810r58ab391id2fbfdff6200dcd8@mail.gmail.com>
	<hb3qpa$6ep$1@ger.gmane.org> <70ed7c3e0910132340q1c4acdfbxa6938261088acca3@mail.gmail.com>
	<hb4hjp$cg8$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <hb4hjp$cg8$1@ger.gmane.org>
Sender: linux-raid-owner@vger.kernel.org
To: ap23563m@gmx.com
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, Oct 14, 2009 at 3:53 PM, Antonio Perez <ap23563m@gmx.com> wrote=
:
>
> Majed B. wrote:
>
> > I see.
> >
> > Well, whether MD is smart enough to rearrange a queue when the arra=
ys
> > are sharing disks or not, it still means that you can't run your
> > processes in parallel.
>
> Does that means that different processes (treads) can't request reads=
 on
> different places on the disk concurrently?
>
> I am sorry, but it seems that we are speaking different languages.
>
> --
> Antonio Perez

Your applications can request as much files as they want regardless of
their location, but the mechanical heads move together, so they can be
at a single location at a point of time reading a single stream of a
file (or multiple files if they were next to each other on the
physical platter).

--
=C2=A0 =C2=A0 =C2=A0 Majed B.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
