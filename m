From: NeilBrown <neilb@suse.de>
Subject: Re: Mdadm, udev and fakeraid?
Date: Sat, 23 Apr 2011 18:45:51 +1000
Message-ID: <20110423184551.7bb437de@notabene.brown>
References: <BANLkTinp3376PV3sJWARXtFnRfoMsg44wA@mail.gmail.com>
	<20110405162008.5f2c48fe@notabene.brown>
	<BANLkTik+xU6K7B9Xomj6+Q-S7_n18+aQqA@mail.gmail.com>
	<20110418103852.2ead1a69@notabene.brown>
	<BANLkTik6qpCx-Y=DXY6U6yu0habSohyiPw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <BANLkTik6qpCx-Y=DXY6U6yu0habSohyiPw@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Dan Williams <dan.j.williams@gmail.com>
Cc: Seblu <seblu@seblu.net>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Fri, 22 Apr 2011 19:37:40 -0700 Dan Williams <dan.j.williams@gmail.c=
om>
wrote:

> On Sun, Apr 17, 2011 at 5:38 PM, NeilBrown <neilb@suse.de> wrote:

> > As has been mentioned elsewhere, mdadm only recognised IMSM arrays =
on
> > machines with IMSM hardware. =A0I'm not entirely happy about this a=
nd may well
> > change it.
>=20
> I have trouble answering the "least surprise" question in this area.
>=20
> Is it more surprising to go into your BIOS, explicitly turn off raid
> support and still see raid devices showing up?

Is the "RAID support has been explicitly turned off" state visible from=
 a
running kernel? or is it indistinguishable from "platform does not have=
 RAID
support"?

>=20
> Or is it more surprising to take a raid array from a raid enabled
> system to raid disabled system and wonder why things won't assemble?
>=20
> For safety I think it is better if mdadm not perform operations that
> might be incompatible with the platform option-rom.  But if you need
> to recover to a usb attached drive, or some other
> platform-incompatible configuration, you can use the environment
> variable in a pinch.

There are 3 interesting cases:  create, assemble, examine.
(grow might be interesting too, but for now it would be confusing).

I am perfectly happy for 'create' to be arbitrarily hard if platform su=
pport
is not available.  One is unlikely to want to create an array in that c=
ase
anyway.
I think 'examine' should always show whatever it can, which is the case=
 for
3.2.1.  Possibly it should also give a warning about  any difficulty th=
at
might be experienced in assembling the array.

Assemble in the interesting case.  The law of least surprise requires i=
t to
either work or give a good error message.  Your suggestion that it poss=
ibly
should not work in some cases seems defensible, so at least a very clea=
r
error message would be good.
As for how to over-ride the default caution - I would prefer --force to
achieve it rather than requiring an environment variable.  I would poss=
ibly
accept --force-platform (or similar) but I think --force should be suff=
icient.

What think you?

Thanks,
NeilBrown
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
