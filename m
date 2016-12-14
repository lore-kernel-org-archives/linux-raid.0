From: Thomas Fjellstrom <thomas@fjellstrom.ca>
Subject: Re: What is the solution for USB HDs
Date: Wed, 14 Dec 2016 13:59:58 -0700
Message-ID: <1712888.Wbb50rTSOS@natasha>
References: <13e51316a11df7b0c9f5ab89392361de@juan-carlos.info> <9481982b-bfda-644e-e160-74b94bbbec0c@turmel.org> <CAMQE2N47aUPkW4s8juNWLm7TmRhkk6B4UOo9TbGm1ZoujgokCQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAMQE2N47aUPkW4s8juNWLm7TmRhkk6B4UOo9TbGm1ZoujgokCQ@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "Juan Carlos Carvajal B." <juca@juan-carlos.info>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wednesday, December 14, 2016 12:08:47 PM MST you wrote:
> Hi Phil,
>=20
> usbcore.autosuspend=3D-1
>=20
> This might be the solution! I'll test it and let you know.
>=20
> And regarding power issues:
>=20
> - this was the first thing I notices and I bought a powered usb-hub to
> provide enough current to the HDs.
>=20
> Using USB drives is kind of a home user scenario. I understand that
> MDADM might be more focused on large data centers, but would be great
> to have such a great tool also available for the average joe.

I don't know if I'd call linux md-raid a "home user" senario. home user is=
=20
more just not having any kind of backup or at most a single usb stick or us=
b=20
hdd.=20

Now, I use md-raid but I am not typical. I have a little self built NAS box=
,=20
with 5x5 TB disks in raid 5. (I had thought I did raid 6, but I think I=20
skipped it cause I have a full backup of the array on another box using a=20
bunch of my older drives). Nice litle box using the Lian-Li PC Q25 case.=20
Though I'd like to upgrade to the PC Q26, but its hard to find in canada fo=
r a=20
decent price :(

Most of my friends use synology or drobo NAS boxes so they don't have to ca=
re=20
about all the inner-workings most of the time.

I find USB disks too finicky for any real use. Also many are rather slow. I=
 do=20
however use them on occasion, especially usb3/3.1 ssds for quick backup or =
re-
image work when a usb stick won't cut it.

> Best!
> Juan Carlos Carvajal Berm=FAdez
> +43 650 477 0005
> juca@juan-carlos.info
> Beingasse 17/2/3
> AT 1150, Wien
> www.juan-carlos.info
>=20
> On 12 December 2016 at 04:17, Phil Turmel <philip@turmel.org> wrote:
> > On 12/11/2016 05:14 PM, Adam Goryachev wrote:
> >> On 12/12/16 04:14, juca@juan-carlos.info wrote:
> >> If you are still having problems after that, then please try to post
> >> more details on what happens when the drives vanish (eg, kernel logs,
> >> system logs, etc).
> >>=20
> >> Also, you might consider an alternative SBC, some have SATA ports
> >> already available (RPi are the only SBC's I've used, but there are many
> >> other options/variations).
> >=20
> > There's also a kernel boot parameter that can cut off all USB
> > auto-suspend, which I suspect is part of the problem.  It has been known
> > for a long time that USB is not robust enough to be trusted in MD array=
s.
> >=20
> > { looking around..... }
> >=20
> > usbcore.autosuspend=3D-1
> >=20
> > is what you need in your bootloader or builtin to the kernel.
> >=20
> > Phil
>=20
> --
> To unsubscribe from this list: send the line "unsubscribe linux-raid" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


=2D-=20
Thomas Fjellstrom
thomas@fjellstrom.ca
