From: NeilBrown <neilb@suse.de>
Subject: Re: RAID6 write I/O amplification?
Date: Thu, 26 Feb 2015 11:55:31 +1100
Message-ID: <20150226115531.0df57e08@notabene.brown>
References: <20150224045835.14e40dcb@natsu>
	<12EF8D94C6F8734FB2FF37B9FBEDD1735F9E168E@EXCHANGE.collogia.de>
	<CAB-428mPydqGoku-RnhZUDVyHVnzb73Yz=5bL7DOd+G88siDtg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/L_LOD/Q7xSUIbTAkQ/OycR4"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAB-428mPydqGoku-RnhZUDVyHVnzb73Yz=5bL7DOd+G88siDtg@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: Alireza Haghdoost <alireza@cs.umn.edu>
Cc: Markus Stockhausen <stockhausen@collogia.de>, Roman Mamedov <rm@romanrm.net>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/L_LOD/Q7xSUIbTAkQ/OycR4
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Wed, 25 Feb 2015 18:40:46 -0600 Alireza Haghdoost <alireza@cs.umn.edu>
wrote:

> On Tue, Feb 24, 2015 at 12:29 AM, Markus Stockhausen
> <stockhausen@collogia.de> wrote:
> >> Von: linux-raid-owner@vger.kernel.org [linux-raid-owner@vger.kernel.or=
g]&quot; im Auftrag von &quot;Roman Mamedov [rm@romanrm.net]
> >> Gesendet: Dienstag, 24. Februar 2015 00:58
> >> An: linux-raid@vger.kernel.org
> >> Betreff: RAID6 write I/O amplification?
> >>
> >> Hello,
> >>
> >> Got a bit of a "how does it actually work" question...
> >>
> >> Suppose I have an MD RAID6 of 8 drives, with 64KB chunk size.
> >>
> >> I am rewriting a 4KB filesystem sector somewhere on that RAID (not cro=
ssing
> >> the stripe boundary).
> >>
> >> What's the amount of disk I/O in total this will result in?
> >>
> >> I assume the RAID will need to read data from all drives, recompute pa=
rity,
> >> then write to the data stripe where the updated piece happened to be, =
and also
> >> write to two parity stripes.
> >>
> >> Is this done at a stripe granularity, so 6x64KB reads, 3x64KB writes?
> >> Or down to individual sectors (pages), i.e. 6x4KB reads, 3x4KB writes?
> >> Or am I describing this algorithm correctly at all?
> >
> > Implementation will work on "internal" stripe granularity and that is 4K
> > So your case will be 6x4KB read + 3x4KB write.
>=20
> Having said that, does it mean that following description of "chunk
> size"  is wrong:
> '[chunk size] is the smallest "atomic" mass of data that can be
> written to the devices'
> since in this case chunk size is 64KB but 4KB is written atomically (?).
> I have find it in the kernel.org wiki page [1]

I think that when it says "atomic" it means in space, not time.

i.e. one (properly aligned) chunk of data will not be split up and=20
written to different devices, it will all be written to one device.
If you write more than a chunk, it will be split up and parts of if written
to different devices.

You can still write less than a chunk.

So the intent is correct I think, but the word "atomic" doesn't really conv=
ey
the right meaning.  Probably it should be re-written to avoid that term and
just spell out what is happening.

NeilBrown


--Sig_/L_LOD/Q7xSUIbTAkQ/OycR4
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVO5vAznsnt1WYoG5AQLCtw//SyJv+mMoCT4qu0L0JXJE/mDbuvTZ2Ctk
TursLAADH01vl33rZSfFZdn/rWIvmC6lx6Xwbsay7dva20o0WZTpR8wpbJ6EB5us
zFW7+aQvljVTAggZe7BmxurzTWRXTaXwbo+NrmQpWJx5Aat2VMOA2En9kZPju3b6
Zs818rDYvGEwbqrIUsrrtOPUOfrSPhGV3RXoR5yTM3ym/ZUGeiuEjPuk8JXNWM3/
B73qnLIitP0W/hOLD38aTYDg1/7SiLGFdF6SqnA+5iV17EoJVSfAqfmy7ergdlc/
0D/eUcgE7koYQPN2lpFlMedX+9lGyniE2t0kKAVn+XXS5GTqiy6ObovR4eQnhLU4
jyrNmJIa7HrEBlD9JWZ19VbfPoQzSw3ZRzlU5jdyzZ10HJPHaQwI0I7hcZYG5EX9
1jYYQqTYfQOP2rTT/Db0legen7he763oRA2mUNcrEjHmAsadMz7KAoS+Ga+MDGA7
3knQkbsWZuJdbtz7UgnCTvOL428IcgiiD60Vc3wU9pn7UdfVWwnSn6+X6mzqx4R+
lwSL4D4OacwnRfnQYA4KZHO/xyQdwEW00k98lLvjenmWotOuXwKuUro7e+ArXPIb
mzh8xUtANfUibfUhCRSBEhkM9ak0/oxiezDKnouD0sz8aNCkka978BTHpRfZRVCx
hbKIlgtenUM=
=mXkB
-----END PGP SIGNATURE-----

--Sig_/L_LOD/Q7xSUIbTAkQ/OycR4--
