From: NeilBrown <neilb@suse.de>
Subject: Re: Breaks LSI RAID on C600 chipset
Date: Thu, 21 May 2015 10:29:59 +1000
Message-ID: <20150521102959.3b9760ed@notabene.brown>
References: <CAGRSmLtoCz+wff+F=xnnusc5_bUYxWYT5V5iTncTnRfgRnTqtg@mail.gmail.com>
	<21791.17074.357416.218211@quad.stoffel.home>
	<CAGRSmLu5kEXA34mmHb5Q9+Fjmh5NFtRw2hrOrCDiOS4NR=5fvQ@mail.gmail.com>
	<21792.11560.92731.222551@quad.stoffel.home>
	<CAGRSmLt+1KJJHmMgoUHG0Dq0qg+38q5PRWnMNCRFg6qTa9s7gQ@mail.gmail.com>
	<21795.3296.846489.199118@quad.stoffel.home>
	<CAGRSmLtrp6Rh3pALL2Rr62jRRZQKFg-3SaV_AxubaHNhkeb0UA@mail.gmail.com>
	<20150410105001.171d6683@notabene.brown>
	<CAGRSmLvoj-UhV+8hSESQ+RRyzMHZ68QuBdRZzVU0PWEztZWeOw@mail.gmail.com>
	<CAGRSmLsxN_oGm9LQmDJSUVcTvVP7DzSAeWG+aaR+Td-OFc=c=A@mail.gmail.com>
	<CAGRSmLvdP8y1=KzG0j7Q9oc9HDGDgNGkSnhNLRUU1YXmLq3KDg@mail.gmail.com>
	<20150513103557.1df6036d@notabene.brown>
	<CAGRSmLvS3kFFGwEWGE8H7smi+uN-EowPGYJxS-dM4+tezFUuVw@mail.gmail.com>
	<CAGRSmLsRr6dHKjOuZB5oy+BALKatJ96P3PMGB9r+oVcft75Z4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
 boundary="Sig_/D6/dy68UlUD82WKqrC.i0lS"; protocol="application/pgp-signature"
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <CAGRSmLsRr6dHKjOuZB5oy+BALKatJ96P3PMGB9r+oVcft75Z4A@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: "David F." <df7729@gmail.com>
Cc: John Stoffel <john@stoffel.org>, "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

--Sig_/D6/dy68UlUD82WKqrC.i0lS
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

On Mon, 18 May 2015 10:58:19 -0700 "David F." <df7729@gmail.com> wrote:

> Do you think the latest version at
> http://git.neil.brown.name/?p=3Dmdadm.git;a=3Dsummary is stable enough to
> use?   It definitely fixes the major issue (losing the raid config)
> from the prior version.

It should be OK.  I'll probably make a 3.3.3 in a little while to make it
official.

NeilBrown



>=20
> On Wed, May 13, 2015 at 7:26 AM, David F. <df7729@gmail.com> wrote:
> > Thanks.
> >
> > 1) The update did fix the broken RAID.  I can reboot and the RAID
> > mirror still exists after reboots.
> >
> > 2) I do want to report that on the first test, the reboot was clean.
> > On the second reboot there was a warning message about the BIOS
> > detecting "Inconsistent Timestamps" on one of the drives and something
> > about which CONFIG the BIOS would use.  I didn't have time to get it
> > all jotted down.  Whatever it used was still okay since the RAID
> > mirror was still there after that message.
> >
> >
> > On Tue, May 12, 2015 at 5:35 PM, NeilBrown <neilb@suse.de> wrote:
> >> On Mon, 11 May 2015 09:31:26 -0700 "David F." <df7729@gmail.com> wrote:
> >>
> >>> any progress or more information needed on this?
> >>>
> >>> On Mon, Apr 20, 2015 at 10:39 PM, David F. <df7729@gmail.com> wrote:
> >>> > If you need access to the system, a network kvm is available - or if
> >>> > you have a C600 based system, you should see the same problem there.
> >>> >
> >>> > On Fri, Apr 10, 2015 at 1:07 PM, David F. <df7729@gmail.com> wrote:
> >>> >> Okay, and to confirm, this is happening on other C600 based system=
s.
> >>> >> Boot to Linux with MDADM raid support and the raid is gone after
> >>> >> reboot.
> >>> >>
> >>> >> On Thu, Apr 9, 2015 at 5:50 PM, NeilBrown <neilb@suse.de> wrote:
> >>> >>> On Thu, 9 Apr 2015 14:13:05 -0700 "David F." <df7729@gmail.com> w=
rote:
> >>> >>>
> >>> >>>> Hello,
> >>> >>>>
> >>> >>>> I built a new system, installed new drives (no partitioning, jus=
t raw
> >>> >>>> new drives), configured RAID 1, boot to linux, created reports
> >>> >>>> attached.  Rebooted and the system doesn't see any configured ra=
id
> >>> >>>> drives (just the two raw drives).
> >>> >>>
> >>> >>> Thanks.  I might take a look, but I would greatly prefer it if yo=
u kept the
> >>> >>> linux-raid list on the Cc.....
> >>> >>>
> >>> >>> NeilBrown
> >>> >>>
> >>
> >> I must confess that I haven't even looked at it.
> >> But I just saw and email on linux-raid from Martin Wilck:
> >>
> >>  Subject: [PATCH] DDF: _write_super_to_disk: fix anchor header type
> >>
> >> which very likely fixes your problem.  I've applied it and pushed out =
to
> >>    git://neil.brown.name/mdadm/
> >>
> >> NeilBrown


--Sig_/D6/dy68UlUD82WKqrC.i0lS
Content-Type: application/pgp-signature
Content-Description: OpenPGP digital signature

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2

iQIVAwUBVV0nBznsnt1WYoG5AQK2Pg//e/DEgNAuKggaUuEolC0JS2/MawAgJCbZ
an4t51F6R7vbTWfOD9lvn2gJUhvpuEJlWk3MqRzwmZUBmXZxdr4pAWQZSLwMnvqK
SPgc538aUUjBDgKLl7HRo21s+oMraTJMpdf/y7RjrvXEhRvN4sESGqcc034LGJ6n
5LM7w6W+6uzRz0tfb6gD8D2/D2t0aO91Ayrc40335FDQvvFdxBkur/YWAdr8p18D
N5cEvYJp/cwil1zMen9eJUwN8dstDd9vbk3Y0Ll+XZGodbCdHoPjtOedNTRdBGNz
mD0uKLUDKRLciGi2ltFpv7b/qyZmh8HHL4DIe2LcUUuBfXvH/C0gsDuygTZe1drx
68X7x8bLUGLCFBntAz/yzNd7bppFZLxp8xpsaQc3tFix5PJcLyGjV+nxlQ+/indE
0opV9LfvbYx6j1DtV0joOMt4v1eKHJJkWxANQsQoO6mvriNhnH86e1FId8wx6bxw
X6L77+PSTGB6BP5BmerP701UAYXwPz0dd55z0hqr7Mf14zjcFQvDc1l+dRucxJof
KOZthGUH4ebeE9Zf8Df2BHKn5s/wjGqua5751EIg00z+s1qOvvaoktwOT/KEr6sn
k3NlPi7aDqCvkrm5z/L4sEjAmRWZx6cgrRBsaVA0T7yBTbs9vusjrkDnfSfqnXc1
xvthwMdsYdg=
=Q6c5
-----END PGP SIGNATURE-----

--Sig_/D6/dy68UlUD82WKqrC.i0lS--
