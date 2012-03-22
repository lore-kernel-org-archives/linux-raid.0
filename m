From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Thu, 22 Mar 2012 21:26:50 +0000
Message-ID: <20331.39194.377610.888636@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com>
	<20120317223454.GQ5091@dastard>
	<20325.17387.216150.45013@tree.ty.sabi.co.UK>
	<20325.50714.237894.328039@tree.ty.sabi.co.UK>
	<4F6624A3.5010206@hardwarefreak.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <4F6624A3.5010206@hardwarefreak.com>
Sender: linux-raid-owner@vger.kernel.org
To: Linux RAID <linux-raid@vger.kernel.org>, Linux fs XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

[ ... ]

>> So in my view 'delaylog' cannot be described boldly and
>> barely described, especially in this thread, as an
>> improvement in XFS performance, as it is an improvement in
>> XFS's unsafety to obtain greater speed, similar to but not as
>> extensive as 'nobarrier'.

> You have recommended in various past posts on multiple lists
> that users should max out logbsize and logbufs to increase
> metadata performance.

Perhaps you confuse me with DaveC (or, see later, the XFS FAQ),
for example:

http://oss.sgi.com/archives/xfs/2010-09/msg00113.html
 =C2=AB> Why isn't logbsize=3D256k default, when it's suggested most
  > of the time anyway?
  It's suggested when people are asking about performance
  tuning. When the performance is acceptible with the default
  value, then you don't hear about it, do you?=C2=BB
http://oss.sgi.com/archives/xfs/2007-11/msg00918.html
 =C2=AB# mkfs.xfs -f -l lazy-count=3D1,version=3D2,size=3D128m -i attr=3D=
2 -d agcount=3D4 <dev>
  # mount -o logbsize=3D256k <dev> <mtpt>
  And if you don't care about filsystem corruption on power loss:
  # mount -o logbsize=3D256k,nobarrier <dev> <mtpt>=C2=BB

> You made no mention in those posts about safety as you have
> here.

As to safety, this thread, by the explicit request of the
original poster, is about safety before speed. But I already
made this point above as in =C2=ABespecially in this thread=C2=BB.

Also, "logbufs" have been known for a long time to have an
unsafety aspect, for example there is a clear mention from 2001,
but also see the quote from the XFS FAQ below:

http://oss.sgi.com/archives/xfs/2001-05/msg03391.html
 =C2=ABlogbufs=3D4 or logbufs=3D8, this increases (from 2) the number
  of in memory log buffers. This means you can have more active
  transactions at once, and can still perform metadata changes
  while the log is being synced to disk. The flip side of this is
  that the amount of metadata changes which may be lost on crash
  is greater.=C2=BB

That's "news" from over 10 years ago...

> Logbufs are in-memory journal write buffers and are volatile.
> Delaylog uses in-memory structures that are volatile. So, why do
> you consider logbufs to be inherently safer than delaylog?

That's a quote from the 'delaylog' documentation: =C2=ABthe potential
for loss of metadata on a crash is much greater than for the
existing logging mechanism=C2=BB.

> Following the logic you've used in this thread, both should be
> considered equally unsafe.

They are both unsafe (at least with applications that do not use
'fsync' appropriately), but not equally, as they have quite
different semantics and behaviour, as the quote above from the
'delaylog' docs states (and see the quote from the XFS FAQ below).

> Yet I don't recall you ever preaching against logbufs in the
> past.

Why should I preach against any of the safety/speed tradeoffs?
Each of them has a domain of usability, including 'nobarrier' or
'eatmydata', or even 'sync'.

> Is it because logbufs can 'only' potentially lose 2MB worth of
> metadata transactions, and delaylog can potentially lose more
> than 2MB?

That's a quote from the 'delaylog' documentation: =C2=ABIn other words,
instead of there only being a maximum of 2MB of transaction
changes not written to the log at any point in time, there may be
a much greater amount being accumulated in memory.=C2=BB =C2=ABWhat it =
does
mean is that as far as the recovered filesystem is concerned,
there may be many thousands of transactions that simply did not
occur as a result of the crash.=C2=BB

> So you're comparing delaylog's volatile buffer architecture to
> software that *intentionally and transparently disables fsync*?

They are both speed-enhancing options. If 'delaylog' can be
compared with 'nobarrier' or 'sync' as to their effects on
performance, so can 'eatmydata'.

The point of comparing 'sync' or 'delaylog' to 'nobarrier' or to
'eastmydata' is to justify why I think that 'delaylog' =C2=ABcannot be
described boldly and barely described, especially in this thread,
as an improvement in XFS performance=C2=BB. because if the only thing
that matters is the improvement in speed, then 'nobarrier' or
'eatmydata' can give better performance than 'delaylog', and to me
that is an absurd argument.

> So do you believe a similar warning should be attached to the
> docs for delaylog?

You seem unaware that a similar warning is already part of the doc
for 'delaylog', and I have quoted it prominently before (and above).

> And thus to the use of logbufs as well?

You seem unaware that the XFS FAQ already states:

http://www.xfs.org/index.php/XFS_FAQ#Q:_I_want_to_tune_my_XFS_filesyste=
ms_for_.3Csomething.3E
 =C2=ABFor mount options, the only thing that will change metadata
  performance considerably are the logbsize and delaylog mount
  options.

  Increasing logbsize reduces the number of journal IOs for a
  given workload, and delaylog will reduce them even further.

  The trade off for this increase in metadata performance is
  that more operations may be "missing" after recovery if the
  system crashes while actively making modifications.=C2=BB

> How about all write buffers/caches in the Linux kernel?

Indeed it would be a very good idea given the poor level of
awareness of the downsides of more buffering/caching (not just
less safety, also higher latency and even lower overall
throughput in many cases).

But that discussion has already happened a few times, in the
various 'O_PONIES' discussions, as to that I have mentioned this
page for a weary summary of the story at some point in time:

http://sandeen.net/wordpress/computers/fsync-sigh/

 =C2=ABSo now we are faced with some decisions.  Should the filesystem
  put in hacks that offer more data safety than posix guarantees?
  Possibly. Probably. But there are tradeoffs. XFS, after giving
  up on the fsync-education fight long ago (note; fsync is pretty
  well-behaved on XFS) put in some changes to essentially fsync
  under the covers on close, if a file has been truncated (think
  file overwrite).=C2=BB

Note the sad =C2=ABXFS, after giving up on the fsync-education fight
long ago=C2=BB statment. Also related to this, about defaulting to
safer implicit semantics:

 =C2=ABBut now we=E2=80=99ve taken that control away from the apps (did=
 they
  want it?) and introduced behavior which may slow down some
  other workloads. And, perhaps worse, encouraged sloppy app
  writing because the filesystem has taken care of pushing stuff
  to disk when the application forgets (or never knew). I dunno
  how to resolve this right now.=C2=BB

> Where exactly do you draw the line Peter, between unsafe/safe
> use of in-memory write buffers?

At the point where the application requirements draw it (or
perhaps a bit safer than that, "just in case").

=46or some applications it must be tight, for others it can be
loose. Quoting again from the 'delaylog' docs: =C2=ABThis makes it even
more important that applications that care about their data use
fsync() where they need to ensure application level data integrity
is maintained.=C2=BB which seems a straight statement that the level of
safety is application-dependent.

=46or me 'delaylog' is just a point on a line of tradeoffs going
from 'sync' to 'nobarrier', it is useful as different point, but
it cannot be boldly and barely described as giving better
performance, anymore than 'nobarrier' can be boldly and barely
described as giving better performance than 'sync'.

Unless one boldly ignores the very different semantics, something
that the 'delaylog' documentation and the XFS FAQ don't do.

Overselling 'delaylog' with cheeky propaganda glossing over the
heavy tradeoffs involved is understandable, but quite wrong.

Again, XFS metadata performance without 'delaylog' was pretty
decent, even if speed was slow due to unusually safe semantics.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
