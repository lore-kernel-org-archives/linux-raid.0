From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Sun, 18 Mar 2012 02:09:47 +0000
Message-ID: <20325.17387.216150.45013@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com>
	<20120317223454.GQ5091@dastard>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20120317223454.GQ5091@dastard>
Sender: linux-raid-owner@vger.kernel.org
To: Linux fs XFS <xfs@OSS.SGI.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> Just ignore the troll, Stan.

It is noticeable that Stan and you have chosen to write offtopic
"contributions" that contain purely personal attacks in reply to a
technical point about =ABguidance on write-cache/barrier=BB, but I'll
try to keep ontopic:

> [ ... ] irrelevant semantic arguments about the definition of
> "performance optimisation" [ ... ]

Oops, here is instead a (handwaving) technical argument, I
partially retract the above.

  Note: I have 'grep'ed for =AB"performance optimisation"=BB and it
    seems to me a made-up quote for this thread, and no argument
    has been made by me about the =ABdefinition of "performance
    optimisation"=BB, and the above point seem to me a strong
    misrepresentation.

The (handwaving) technical argument above seems to me a laughable
attempt to attribute respectability to the disregard for how
important is the difference between improving speed at the same
(implicit) safety level vs. doing so at a lower one, even more so
as (implicit) safety is an important theme in this thread, and my
argument (quite different from the above misrepresentation) was in
essence:

 =ABThere have been decent but no major improvements in XFS metadata
  *performance*, but weaker implicit *semantics* have been made an
  option, and these have a different safety/performance tradeoff
  (less implicit safety, somewhat more performance), not "just"
  better performance.=BB

The relevance of pointing out that there is a big tradeoff is is
demonstrated by the honest mention in 'delaylog.txt' that =ABthe
potential for loss of metadata on a crash is much greater than for
the existing logging mechanism=BB, which seems far from merely
=ABsemantic arguments=BB as the potential for =ABmany thousands of
transactions that simply did not occur as a result of the crash=BB is
not purely a matter of =ABsemantic arguments=BB, and indeed mattered a
lot to the topic of the thread, where the 'Subject:' is:

  =ABraid10n2/xfs setup guidance on write-cache/barrier=BB
                      =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

It seems to me that http://packages.debian.org/sid/eatmydata could
also be described boldly and barely as making a =ABsignificant
difference in [XFS] metadata performance=BB because its description
says =ABThis has two side-effects: making software that writes data
safely to disk a lot quicker=BB even if continues =ABand making this
software no longer crash safe.=BB

If considering both the speed and safety aspect is irrelevant
semantics, then it seems to me that:

  http://sandeen.net/wordpress/computers/fsync-sigh/

would be about =ABirrelevant semantic arguments=BB too, instead od
being a sensible discussion of tradeoffs between speed and safety.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
