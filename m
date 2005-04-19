From: Frank Wittig <fw@weisshuhn.de>
Subject: Re: Questions about software RAID
Date: Tue, 19 Apr 2005 18:53:52 +0200
Message-ID: <426537A0.6020007@weisshuhn.de>
References: <200504191100.NAA01462@node130.rhm.de> <20050419144011.GI3103@eychenne.org> <42652352.3050706@dgreaves.com> <20050419155447.GJ3103@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20050419155447.GJ3103@eychenne.org>
Sender: linux-raid-owner@vger.kernel.org
To: rv@eychenne.org
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

Herv=E9 Eychenne wrote:

>>And those who do can type:
>>  fdisk -l /dev/sda | grep -i fd | cut -f1 -d' ' | xargs -n1 mdadm -r
>=20
>=20
> I really don't like kludgy things like that...
[...]
> Isn't the insertion/removal of a disk common enough to justify the
> addition of a simple and clean mdadm option?

have you thought about the idea that there is a certain clue behind the
actual behaviour of the mdadm tool?
is it so annoying to you to mark a disk/partition as faulty before
removing it?

do you think it makes sense to implement every single case in an extra
command line option?

did you ever thought about switching to a hardware where you can remove
and add disks without having to do anything else than pull the old one
out and push teh new one in?

i run several raid arrays on many machines and i find the tools quite
useful. if you mind such command lines like the one above you should
think about switching to a microsoft product where you can push your
mouse arround and tell everyone that you can do what you want without
those kludgy command lines which no one really understands.

so please ask and learn.
there are many people on this list which are pleased to answer your
questions.
the idea behind *n?x systems is to combine simple functionality through
pipes and redirects to gain unlimited complexy and power. so if you wan=
t
to use the full power of *n?x systems you have to get used to this
"kludgy" command lines.

the more you get used to it, the less "kludgy" they will be.

SCNR

-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
