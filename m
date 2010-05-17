From: Dave Chinner <david@fromorbit.com>
Subject: Re: xfs and raid5 - "Structure needs cleaning for directory open"
Date: Tue, 18 May 2010 09:04:53 +1000
Message-ID: <20100517230453.GM8120@dastard>
References: <20100510022033.GB7165@dastard>
 <4BF1B4FE.7020503@redhat.com>
 <20100517214532.GL8120@dastard>
 <4BF1C0B4.5090009@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4BF1C0B4.5090009@redhat.com>
Sender: linux-raid-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Rainer Fuegenstein <rfu@kaneda.iguw.tuwien.ac.at>, xfs@oss.sgi.com, linux-raid@vger.kernel.org
List-Id: linux-raid.ids

On Mon, May 17, 2010 at 06:18:28PM -0400, Doug Ledford wrote:
> On 05/17/2010 05:45 PM, Dave Chinner wrote:
> > On Mon, May 17, 2010 at 05:28:30PM -0400, Doug Ledford wrote:
> >> On 05/09/2010 10:20 PM, Dave Chinner wrote:
> >>> On Sun, May 09, 2010 at 08:48:00PM +0200, Rainer Fuegenstein wrot=
e:
> >>>>
> >>>> today in the morning some daemon processes terminated because of
> >>>> errors in the xfs file system on top of a software raid5, consis=
ting
> >>>> of 4*1.5TB WD caviar green SATA disks.
> >>>
> >>> Reminds me of a recent(-ish) md/dm readahead cancellation fix - t=
hat
> >>> would fit the symptoms of (btree corruption showing up under heav=
y IO
> >>> load but no corruption on disk. However, I can't seem to find any
> >>> references to it at the moment (can't remember the bug title), bu=
t
> >>> perhaps your distro doesn't have the fix in it?
> >>>
> >>> Cheers,
> >>>
> >>> Dave.
> >>
> >> That sounds plausible, as does hardware error.  A memory bit flip =
under
> >> heavy load would cause the in memory data to be corrupt while the =
on
> >> disk data is good.
> >=20
> > The data dumps from the bad blocks weren't wrong by a single bit -
> > they were unrecogni=D1=95able garbage - so that it very unlikely to=
 be
> > a memory erro causing the problem.
>=20
> Not true.  It can still be a single bit error but a single bit error
> higher up in the chain.  Aka a single bit error in the scsi command t=
o
> read various sectors, then you read in all sorts of wrong data and
> everything from there is totally whacked.

I didn't say it *couldn't be* a bit error, just it was _very
unlikely_.  Hardware errors that result only in repeated XFS btree
corruption in memory or causing other errors in the system is
something I've never seen, even on machines with known bad memory,
HBAs, interconnects, etc. Applying Occam's Razor to this case
indicates that it is going to be caused by a software problem.

Yes, it's still possible that it's a hardware issue, just very, very
unlikely. And if it is hardware and you can prove that it was the
cause, then I suggest we all buy a lottery ticket.... ;)

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
