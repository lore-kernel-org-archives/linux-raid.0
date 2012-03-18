From: Christoph Hellwig <hch@infradead.org>
Subject: Re: raid10n2/xfs setup guidance on write-cache/barrier
Date: Sun, 18 Mar 2012 10:00:51 -0400
Message-ID: <20120318140051.GA2594@infradead.org>
References: <CAA8mOyDKrWg0QUEHxcD4ocXXD42nJu0TG+sXjC4j2RsigHTcmw@mail.gmail.com>
 <4F61803A.60009@hardwarefreak.com>
 <CAA8mOyCzs36YD_QUMq25HQf8zuq1=tmSTPjYdoFJwy2Oq9sLmw@mail.gmail.com>
 <20321.63389.586851.689070@tree.ty.sabi.co.UK>
 <4F64115D.50208@hardwarefreak.com>
 <20120317223454.GQ5091@dastard>
 <20325.17387.216150.45013@tree.ty.sabi.co.UK>
 <20325.50714.237894.328039@tree.ty.sabi.co.UK>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20325.50714.237894.328039@tree.ty.sabi.co.UK>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg@lxra2.to.sabi.co.UK>
Cc: Linux fs XFS <xfs@oss.sgi.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

On Sun, Mar 18, 2012 at 11:25:14AM +0000, Peter Grandi wrote:
> >  ?There have been decent but no major improvements in XFS metadata
> >   *performance*, but weaker implicit *semantics* have been made an
> >   option, and these have a different safety/performance tradeoff
> >   (less implicit safety, somewhat more performance), not "just"
> >   better performance.?
> 
> I have left implicit a point that perhaps should be explicit: I
> think that XFS metadata performance before 'delaylog' was pretty
> good, and that it has remained pretty good with 'delaylog'.

For many workloads it absolutely wasn't.

> People who complained about slow metadata performance with XFS
> before 'delaylog' were in effect complaining that XFS was
> implementing overly (in some sense) safe metadata semantics, and
> in effect were demanding less (implicit) safety, without
> probably realizing they were asking for that.

No, they weren't, and as with most posts to the XFS and RAID lists
you are completely off the track.

Plese read through Documentation/filesystems/xfs-delayed-logging-design.txt
and if you have any actual technical questions that you don't understand
feel free to come back and ask.

But please stop giving advise taken out of the thin air to people on the
lists that might actually believe whatever madness you just dreamed up.
