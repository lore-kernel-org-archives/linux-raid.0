From: "Lelsie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: RAID halting
Date: Sun, 5 Apr 2009 00:34:19 -0500
Message-ID: <20090405053422.LCZN19140.cdptpa-omta03.mail.rr.com@Leslie>
References: <87f94c370904041749j318b577dr663ef0bd3b4ad717@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <87f94c370904041749j318b577dr663ef0bd3b4ad717@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> >=A0Also, it doesn't take a drive 40 seconds,
> > let alone 2 minutes, to mark a sector bad.
>=20
> Just for info, with Enterprise class sata drives, you're right.

On this system, with consumer class drives, with the faulty RAID enclos=
ure,
the system marked well over a million sectors bad.  Except when the ent=
ire
drive was faulted and taken offline, it never caused a halt of this
magnitude, and every single block of sectors marked bad was reported in=
 the
kernel log.  I can't guarantee this is not what is happening, but I am
highly skeptical, to say the least.  You're also going to have to expla=
in to
me why 5 drives stop reading and 5 do not, and why it is always the sam=
e 5
drives.  One flaky drive I can believe.  Five I can't.  You're also goi=
ng to
have to explain to me why there are no reports of sectors marked bad in=
 the
kernel log when these events occur, although at long intervals (months)=
,
occasionally a block of bad sectors will be reported.

> For consumer grade sata, they have extended auto retry logic as an
> effort not to fail a read from a bad sector.  It can easily take time=
s
> like your seeing.  I think the standard drive timeout is on the order
> of 30 seconds and then libata sometimes has retry logic of its own.
I have never seen any of the marked failures take that long.  As I said=
,
there were well over a million marked bad, usually in chunks of 128 sec=
tors.

> Especially with PATA drives a 2 minute issue is not out of the
> question, since the kernel will step down the i/o speed and retry eac=
h
> speed as it goes.  And PATA (IDE) has a lot of speeds to try.

In my original message I already said these are 1T SATA drives spread a=
cross
three different port multipliers.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
