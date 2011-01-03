From: "Leslie Rhorer" <lrhorer@satx.rr.com>
Subject: RE: Mismatches
Date: Sun, 2 Jan 2011 19:53:00 -0600
Message-ID: <D6.53.07087.CFB212D4@cdptpa-omtalb.mail.rr.com>
References: <AANLkTimqKmegXCyPqeMn=fDVyPtNgyexUrC6QE4vRBzf@mail.gmail.com>
Reply-To: <lrhorer@satx.rr.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <AANLkTimqKmegXCyPqeMn=fDVyPtNgyexUrC6QE4vRBzf@mail.gmail.com>
Sender: linux-raid-owner@vger.kernel.org
To: 'Mark Knecht' <markknecht@gmail.com>
Cc: linux-raid@vger.kernel.org
List-Id: linux-raid.ids

> -----Original Message-----
> From: Mark Knecht [mailto:markknecht@gmail.com]
> Sent: Sunday, January 02, 2011 7:23 PM
> To: lrhorer@satx.rr.com
> Cc: linux-raid@vger.kernel.org
> Subject: Re: Mismatches
>=20
> On Sun, Jan 2, 2011 at 5:10 PM, Leslie Rhorer <lrhorer@satx.rr.com> w=
rote:
> >
> > =A0 =A0 =A0 =A0OK, I asked this question here before, and I got no =
answer
> > whatsoever. =A0I wasn't too concerned previously, but now that I lo=
st the
> > entire array the last time I tried to do a growth, I am truly conce=
rned.
> > Would someone please answer my question this time, and perhaps poin=
t me
> > toward a resolution? =A0The monthly array check just finished on my=
 main
> > machine. =A0For many months, this happened at the first of the mont=
h and
> > completed without issue and with zero mismatches. =A0As of a couple=
 of
> months
> > ago, it started to report large numbers of mismatches. =A0It just
> completed
> > this afternoon with the following:
> >
> > RebuildFinished /dev/md0 mismatches found: 96614968
> >
> > =A0 =A0 =A0 =A0Now, 96,000,000 mismatches would seem to be a matter=
 of great
> > concern, if you ask me. =A0How can there be any, really, when the e=
ntire
> array
> > - all 11T - was re-written just a few weeks ago? =A0How can I find =
out
> what
> > the nature of these mismatches is, and how can I correct them witho=
ut
> > destroying the data on the array? =A0How can I look to prevent them=
 in the
> > future? =A0I take it the monthly checkarray routine (which basicall=
y
> > implements ` echo check > /sys/block/md0/md/sync_action`) does not
> attempt
> > to fix any errors it finds?
> >
> > =A0 =A0 =A0 =A0I just recently found out md uses simple parity to t=
ry to
> maintain
> > the validity of the data. =A0I had always thought it was ECC. =A0Wi=
th simple
> > parity it can be difficult or even impossible to tell which data me=
mber
> is
> > in error, given two conflicting members. =A0Where should I go from =
here?
> =A0Can
> > I use `echo repair > /sys/block/md0/md/sync_action` with impunity?
> =A0What,
> > exactly, will this do when it comes across a mismatch between one o=
r
> more
> > members?
> >
> > RAID6 array
> > mdadm - v2.6.7.2
> > kernel 2.6.26-2-amd64
>=20
> What commands are you running? Is it just the sync_action or other
> things in addition?

	Well, I haven't run anything at all, yet.  The checkarray script
runs once a month as a cron job on all the arrays and reports their hea=
lth.
Until just a few months ago, all 8 arrays on the servers always reporte=
d
complete via e-mail with no reported mismatches.  Then a few months ago=
,
some of the arrays started report8ing mismatches.  I was of the impress=
ion
the checkarray routine would not ony report, but tryto fix mismatches. =
 This
seems to have been incorrect, perhaps.  In any case, while trying to gr=
ow
one of the arrays a couple of weeks or so ago, nearly every large file =
on
the main array of the main server was corrupted.  A few small files wer=
e
also corrupted.  I copied everything back over from the backup array, a=
nd
all seemed well, except that checkarray (during its normal cron run) is
still reporting massive numbers of mismatches on the array.

> It was my understanding when researching RAID6 last week that the two
> parity calculations are actually different. Only one of them is simpl=
e
> parity. The the other is part of an advanced math degree. ;-)
> (According to Wikipedia, not a definitive source for sure...)

	Well, that's encouraging, if true.  It doesn't explain how big
chunks of data in almost every large file got corrupted, though.

--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
