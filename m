From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
Date: Tue, 18 May 2010 07:45:32 +1000
Message-ID: <20100517214532.GL8120@dastard>
References: <20100510022033.GB7165@dastard>
 <4BF1B4FE.7020503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BF1B4FE.7020503@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 17, 2010 at 05:28:30PM -0400, Doug Ledford wrote:
> On 05/09/2010 10:20 PM, Dave Chinner wrote:
> > On Sun, May 09, 2010 at 08:48:00PM +0200, Rainer Fuegenstein wrote:
> >>
> >> today in the morning some daemon processes terminated because of
> >> errors in the xfs file system on top of a software raid5, consisti=
ng
> >> of 4*1.5TB WD caviar green SATA disks.
> >=20
> > Reminds me of a recent(-ish) md/dm readahead cancellation fix - tha=
t
> > would fit the symptoms of (btree corruption showing up under heavy =
IO
> > load but no corruption on disk. However, I can't seem to find any
> > references to it at the moment (can't remember the bug title), but
> > perhaps your distro doesn't have the fix in it?
> >=20
> > Cheers,
> >=20
> > Dave.
>=20
> That sounds plausible, as does hardware error.  A memory bit flip und=
er
> heavy load would cause the in memory data to be corrupt while the on
> disk data is good.

The data dumps from the bad blocks weren't wrong by a single bit -
they were unrecogni=D1=95able garbage - so that it very unlikely to be
a memory erro causing the problem.

> By waiting to check it until later, the bad memory
> was flushed at some point and when the data was reloaded it came in o=
k
> this time.

Yup - XFS needs to do a better job of catching this case - the
prototype metadata checksumming patch caught most of these cases...

Cheers,

Dave.
--=20
Dave Chinner
david@fromorbit.com
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
