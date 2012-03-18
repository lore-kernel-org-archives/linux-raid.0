From: pg@lxra2.to.sabi.co.UK (Peter Grandi)
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Sun, 18 Mar 2012 11:25:14 +0000
Message-ID: <20325.50714.237894.328039@tree.ty.sabi.co.UK>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
	<4F61803A.60009@hardwarefreak.com>
	<CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
	<20321.63389.586851.689070@tree.ty.sabi.co.UK>
	<4F64115D.50208@hardwarefreak.com>
	<20120317223454.GQ5091@dastard>
	<20325.17387.216150.45013@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-raid-owner@vger.kernel.org>
In-Reply-To: <20325.17387.216150.45013@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Linux fs XFS <xfs@OSS.SGI.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

>  =ABThere have been decent but no major improvements in XFS metadata
>   *performance*, but weaker implicit *semantics* have been made an
>   option, and these have a different safety/performance tradeoff
>   (less implicit safety, somewhat more performance), not "just"
>   better performance.=BB

I have left implicit a point that perhaps should be explicit: I
think that XFS metadata performance before 'delaylog' was pretty
good, and that it has remained pretty good with 'delaylog'.

People who complained about slow metadata performance with XFS
before 'delaylog' were in effect complaining that XFS was
implementing overly (in some sense) safe metadata semantics, and
in effect were demanding less (implicit) safety, without
probably realizing they were asking for that.

Accordingly, 'delaylog' offers less (implicit) safety, and it is
a good and legitimate option to have, in the same way that
'nobarrier' is also a good and legitimate option to have.

So in my view 'delaylog' cannot be described boldly and barely
described, especially in this thread, as an improvement in XFS
performance, as it is an improvement in XFS's unsafety to obtain
greater speed, similar to but not as extensive as 'nobarrier'.
In the same way that 'eatmydata':

> The relevance of pointing out that there is a big tradeoff [ ... ]
> It seems to me that http://packages.debian.org/sid/eatmydata
> could also be described boldly and barely as making a
> =ABsignificant difference in [XFS] metadata performance=BB [ ... ]

is a massive improvement in unsafety as the name says.

Since the thread is about maximizing safety and implicit safety
too, technical arguments about changes in operational semantics
as to safety are entirely appropriate here, even if there are
those who don't "get" them.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
