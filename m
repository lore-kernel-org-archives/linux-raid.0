From: pg_mh@sabi.co.UK (Peter Grandi)
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sun, 21 Dec 2008 19:16:32 +0000
Message-ID: <18766.38416.161254.375311@tree.ty.sabi.co.uk>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<1229225480.16555.152.camel@localhost>
	<18757.4606.966139.10342@tree.ty.sabi.co.uk>
	<200812141912.59649.Martin@lichtvoll.de>
	<18757.33373.744917.457587@tree.ty.sabi.co.uk>
	<494971B2.1000103@tmr.com> <494A07BA.1080008@mailcan.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
In-Reply-To: <494A07BA.1080008@mailcan.com>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux RAID <linux-raid@vger.kernel.org>, Linux XFS <xfs@oss.sgi.com>
List-Id: linux-raid.ids

[ ... ]

>> What really bothers me is that there's no obvious need for
>> barriers at the device level if the file system is just a bit
>> smarter and does it's own async io (like aio_*), because you
>> can track writes outstanding on a per-fd basis,

> The drive itself may still re-order writes, thus can cause
> corruption if halfway the power goes down. [ ... ] Barriers need
> to travel all the way down to the point where-after everything
> remains in-order. [ ... ] Whether the data has made it to the
> drive platters is not really important from a barrier point of
> view, however, iff part of the data made it to the platters, then
> we want to be sure it was in-order. [ ... ]

But this discussion is backwards, as usual: the *purpose* of any
kind of barriers cannot be just to guarantee consistency, but also
stability, because ordered commits are not that useful without
commit to stable storage.

If barriers guarantee transaction stability, then consistency is
also a consequence of serial dependencies among transactions (and
as to that per-device barriers are a coarse and very underoptimal
design).

Anyhow, barriers for ordering only have been astutely patented
quite recently:

  http://www.freshpatents.com/Transforming-flush-queue-command-to-memory-barrier-command-in-disk-drive-dt20070719ptan20070168626.php

Amazing new from the patent office.y

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
