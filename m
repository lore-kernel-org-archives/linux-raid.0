From: pg_xf2@xf2.for.sabi.co.UK (Peter Grandi)
Subject: Re: 12x performance drop on md/linux+sw raid1 due to barriers [xfs]
Date: Sat, 20 Dec 2008 14:06:47 +0000 (UTC)
Message-ID: <18757.33373.744917.457587__35706.2151575976$1229782081$gmane$org@tree.ty.sabi.co.uk>
References: <alpine.DEB.1.10.0812060928030.14215@p34.internal.lan>
	<1229225480.16555.152.camel@localhost>
	<18757.4606.966139.10342@tree.ty.sabi.co.uk>
	<200812141912.59649.Martin@lichtvoll.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xfs-bounces@oss.sgi.com>
Date: Sun, 14 Dec 2008 22:02:05 +0000
	X-Face:	SMJE]JPYVBO-9UR%/8d'mG.F!@.,l@c[f'[%S8'BZIcbQc3/">GrXDwb#;
	fTRGNmHr^JFb SAptvwWc,
	0+z+~p~"Gdr4H$(|N(yF(wwCM2bW0~U?HPEE^fkPGx^u[*[yV.gyB!hDOli}EF[\cW*S
	H<GG"+i\3#fp@@EeWZWBv;
	]LA5n1pS2VO%Vv[yH?kY'lEWr30WfIU?%>&spRGFL}{`bj1TaD^l/"[
	msn( /TH#THs{Hpj>)]f><W}Ck9%2?H"AEM)+9<@D; 3Kv=^?4$1/+#Qs:-aSsBTUS]iJ$6
	X-Mailing-List:	linux-raid@vger.kernel.org
In-Reply-To: <200812141912.59649.Martin@lichtvoll.de>
List-Unsubscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=unsubscribe>
List-Archive: <http://oss.sgi.com/pipermail/xfs>
List-Post: <mailto:xfs@oss.sgi.com>
List-Help: <mailto:xfs-request@oss.sgi.com?subject=help>
List-Subscribe: <http://oss.sgi.com/mailman/listinfo/xfs>,
	<mailto:xfs-request@oss.sgi.com?subject=subscribe>
Sender: xfs-bounces@oss.sgi.com
Errors-To: xfs-bounces@oss.sgi.com
To: Linux XFS <xfs@oss.sgi.com>, Linux RAID <linux-raid@vger.kernel.org>
List-Id: linux-raid.ids

[ ... ]

> But - as far as I understood - the filesystem doesn't have to
> wait for barriers to complete, but could continue issuing IO
> requests happily. A barrier only means, any request prior to
> that have to land before and any after it after it.

> It doesn't mean that the barrier has to land immediately and
> the filesystem has to wait for this. At least that always was
> the whole point of barriers for me. If thats not the case I
> misunderstood the purpose of barriers to the maximum extent
> possible.

Unfortunately that seems the case.

The purpose of barriers is to guarantee that relevant data is
known to be on persistent storage (kind of hardware 'fsync').

In effect write barrier means "tell me when relevant data is on
persistent storage", or less precisely "flush/sync writes now
and tell me when it is done". Properties as to ordering are just
a side effect.

That is, the application (file system in the case of metadata,
user process in the case of data) knows that a barrier operation
is complete, it knows that all data involved in the barrier
operation are on persistent storage. In case of serially
dependent transactions, applications do wait until the previous
transaction is completed before starting the next one (e.g.
creating potentially many files in the same directory, something
that 'tar' does).

  "all data involved" is usually all previous writes, but in
  more sophisticated cases it can be just specific writes.

When an applications at transaction end points (for a file
system, metadata updates) issues a write barrier and then waits
for its completion.

If the host adapter/disk controllers don't have persistent
storage, then completion (should) only happen when the data
involved is actually on disk; if they do have it, then multiple
barriers can be outstanding, if the host adapter/disk controller
does support multiple outstanding operations (e.g. thanks to
tagged queueing).

The best case is when the IO subsystem supports all of these:

* tagged queueing: multiple write barriers can be outstanding;

* fine granule (specific writes, not all writes) barriers: just
  metadata writes need to be flushed to persistent storage, not
  any intervening data writes too;

* the host adapter and/or disk controller have persistent
  caches: as long as those caches have space, barriers can
  complete immediately, without waiting a write to disk.

It just happens that typical contemporary PC IO subsystems (at
the hardware level, not the Linux level) have none of those
features, except sometimes for NCQ which is a reduced form of
TCQ, and apparently is not that useful.

Write barriers are also useful without persistent caches, if
there is proper tagged queueing and fine granularity.
--
To unsubscribe from this list: send the line "unsubscribe linux-raid" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

_______________________________________________
xfs mailing list
xfs@oss.sgi.com
http://oss.sgi.com/mailman/listinfo/xfs
