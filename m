From: Jure =?ISO-8859-2?Q?Pe=5Far?= <pegasus@nerv.eu.org>
Subject: Re: ext3 journal on software raid (was Re: PROBLEM: Kernel 2.6.10
 crashing repeatedly and hard)
Date: Wed, 5 Jan 2005 02:19:53 +0100
Message-ID: <20050105021953.5ae4c717.pegasus@nerv.eu.org>
References: <l1nna2-e9i.ln1@news.it.uc3m.es>
	<20050104024108.GK99565@caffreys.strugglers.net>
	<895qa2-0qa.ln1@news.it.uc3m.es>
	<200501042002.32292.maarten@ultratux.net>
	<j6dra2-9vs.ln1@news.it.uc3m.es>
	<16859.6326.605501.431357@cse.unsw.edu.au>
	<mdora2-n0n.ln1@news.it.uc3m.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <mdora2-n0n.ln1@news.it.uc3m.es>
Sender: linux-raid-owner@vger.kernel.org
To: "Peter T. Breuer" <ptb@lab.it.uc3m.es>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Wed, 5 Jan 2005 01:19:34 +0100
ptb@lab.it.uc3m.es (Peter T. Breuer) wrote:

> Neil Brown <neilb@cse.unsw.edu.au> wrote:
> > On Tuesday January 4, ptb@lab.it.uc3m.es wrote:
> > > Bits flip on our client disks all the time :(. =20
> >=20
> > You seem to be alone in reporting this.  I certainly have never
> > experienced anything quite like what you seem to be reporting.
>=20
> I don't feel the need to prove it to you via actual evidence.  You
> already know of mechanisms which produce such an effect:
>=20
> > Certainly there are reports of flipped bits in memory.=20
>=20
>  .. and that is all the same to your code when it comes to resyncing.
>  You don't care whether the change is real or produced in the cpu, on=
 the
> bus, or wherever. It still is what you will observe and copy.

You work with PC servers, so live with it.=20

If you want to have the right to complain about bits being flipped in
hardware randomly, go get a job with IBM mainframes or something.=20


And since you like theoretic approach to problems, I might have a sugge=
stion
for you: pick a linux kernel subsystem of your choice, think of it as a
state machine, roll out all the states and then check which states are =
not
covered by the code.
I think that will keep you busy and the result might have some value fo=
r the
community.=20


--=20

Jure Pe=E8ar
http://jure.pecar.org/
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
