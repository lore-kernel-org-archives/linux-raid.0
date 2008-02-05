From: Keld =?iso-8859-1?Q?J=F8rn?= Simonsen <keld@dkuug.dk>
Subject: Re: which raid level gives maximum overall speed? (raid-10,f2 vs. raid-0)
Date: Tue, 5 Feb 2008 21:04:23 +0100
Message-ID: <20080205200423.GB17621@rap.rap.dk>
References: <20080130192133.17b254bf@szpak> <20080130220007.GG20173@rap.rap.dk> <20080130233639.5d46b044@szpak> <20080131015506.GB6617@rap.rap.dk> <20080205161036.GA30326@rap.rap.dk> <alpine.DEB.1.00.0802051152500.9790@p34.internal.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.DEB.1.00.0802051152500.9790@p34.internal.lan>
Sender: linux-raid-owner@vger.kernel.org
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Cc: Janek Kozicki <janek_listy@wp.pl>, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Tue, Feb 05, 2008 at 11:54:27AM -0500, Justin Piszcz wrote:
>=20
>=20
> On Tue, 5 Feb 2008, Keld J=F8rn Simonsen wrote:
>=20
> >On Thu, Jan 31, 2008 at 02:55:07AM +0100, Keld J=F8rn Simonsen wrote=
:
> >>On Wed, Jan 30, 2008 at 11:36:39PM +0100, Janek Kozicki wrote:
> >>>Keld J=F8rn Simonsen said:     (by the date of Wed, 30 Jan 2008 23=
:00:07=20
> >>>+0100)
> >>>
> >>
> >>All the raid10's will have double time for writing, and raid5 and r=
aid6
> >>will also have double or triple writing times, given that you can d=
o
> >>striped writes on the raid0.
> >
> >For raid5 and raid6 I think this is even worse. My take is that for
> >raid5 when you write something, you first read the chunk data involv=
ed,
> >then you read the parity data, then you xor-subtract the data to be
> >changed, and you xor-add the new data, and then write the new data c=
hunk
> >and the new parity chunk. In total 2 reads and 2 writes. The read/wr=
ites
> >happen on the same chunks, so latency is minimized. But in essence i=
t is
> >still 4 IO operations, where it is only 2 writes on raid1/raid10,
> >that is only half the speed for writing on raid5 compared to raid1/1=
0.
> >
> >On raid6 this amounts to 6 IO operations, resulting in 1/3 of the
> >writing speed of raid1/10.
> >
> >I note in passing that there is no difference between xor-subtract a=
nd
> >xor-add.
> >
> >Also I assume that you can calculate the parities of both raid5 and
> >raid6 given the old parities chunks and the old and new data chunk.
> >If you have to calculate the new parities by reading all the compone=
nt
> >data chunks this is going to be really expensive, both in IO and CPU=
=2E
> >For a 10 drive raid5 this would involve reading 9 data chunks, and
> >making writes 5 times as expensive as raid1/10.
> >
> >best regards
> >keld
> >-
> >To unsubscribe from this list: send the line "unsubscribe linux-raid=
" in
> >the body of a message to majordomo@vger.kernel.org
> >More majordomo info at  http://vger.kernel.org/majordomo-info.html
> >
>=20
> On my benchmarks RAID5 gave the best overall speed with 10 raptors,=20
> although I did not play with the various offsets/etc as much as I hav=
e=20
> tweaked the RAID5.

Could you give some figures?=20

best regards
keld
-
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
