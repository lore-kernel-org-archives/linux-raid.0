From: "Leon Woestenberg" <leonw@mailcan.com>
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Mon, 22 Dec 2008 14:19:02 +0100
Message-ID: <1229951942.11189.1291310985@webmail.messagingengine.com>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
 <1229225480.16555.152.camel@localhost>
 <18757.4606.966139.10342@tree.ty.sabi.co.uk>
 <200812141912.59649.Martin@lichtvoll.de>
 <18757.33373.744917.457587@tree.ty.sabi.co.uk>
 <494971B2.1000103@tmr.com> <494A07BA.1080008@mailcan.com>
 <18766.38416.161254.375311@tree.ty.sabi.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-raid-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <18766.38416.161254.375311@tree.ty.sabi.co.uk>
Sender: linux-raid-owner@vger.kernel.org
To: Peter Grandi <pg_mh@sabi.co.UK>, Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

Hello,

On Sun, 21 Dec 2008 19:16:32 +0000, "Peter Grandi" <pg_mh@sabi.co.UK>
said:
 
> > The drive itself may still re-order writes, thus can cause
> > corruption if halfway the power goes down. [ ... ] Barriers need
> > to travel all the way down to the point where-after everything
> > remains in-order. [ ... ] Whether the data has made it to the
> > drive platters is not really important from a barrier point of
> > view, however, iff part of the data made it to the platters, then
> > we want to be sure it was in-order. [ ... ]
> 
> But this discussion is backwards, as usual: the *purpose* of any
> kind of barriers cannot be just to guarantee consistency, but also
> stability, because ordered commits are not that useful without
> commit to stable storage.
>
I do not see in what sense you mean "stability"? Stable as in BIBO or
non-volatile?

Barriers are time-related. Once data is on storage, there is no relation
with time.

So I do not see how barriers help to "stabilize" storage.

Ordered commits is a strong-enough condition to ensure consistency in
the sense that
atomic transactions either made it to the disk completely or not at all.

> If barriers guarantee transaction stability, then consistency is
> also a consequence of serial dependencies among transactions (and
> as to that per-device barriers are a coarse and very underoptimal
> design).
>
Of course, the higher level should ensure that between transactions, the
(meta)data is always consistent.

In filesystem design, we see that some FS's decide to split metadata and
data in this regard.

 
> Anyhow, barriers for ordering only have been astutely patented
> quite recently:
> 
>   http://www.freshpatents.com/Transforming-flush-queue-command-to-memory-barrier-command-in-disk-drive-dt20070719ptan20070168626.php
> 
> Amazing new from the patent office.y
> 
Grand. Another case of no prior art. :-)

Leon.
