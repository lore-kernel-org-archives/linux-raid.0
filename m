Received: from mail-wm2-f5.google.com (mail-wm2-f5.google.com [74.125.225.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72294390CB9
	for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 10:53:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784458420; cv=none; b=eBBJNuJdc8lbUkej9hW2rPYu+4x88QhylhNxw4cs9VF5ZrF+G7g24wRfFiFFnEIBpiYwikB7MGiEWouKkuUyx8IEE2ICM4d0/a+C4y11FIhZBrA9sIXyD+7wnHgdkhpVUHOnwqZS89/rgpfMlXp6JH23VpZLAo02y6XVyIA30R0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784458420; c=relaxed/simple;
	bh=/F44cJwGwvD3KJqM7PuByqNY4t72DFlWMyqeZdEcoV4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=r84siY/3HGFS95Y6/QUB6TBd5OsOZy6vhikBlNd+elgKQQewhBovSWCmkx04ZXwUidZyuVNMOgRtAAH2F1WEmWoYoopcwXQp1KcHhij1YL64cd9jQJMUT+UAlEYhUJmDT7TXZ7yW925iXV8AuMuFydm0RdwbAjHuNPLiFENpuUQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io; spf=pass smtp.mailfrom=meshstor.io; dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b=b7KSwtPc; arc=none smtp.client-ip=74.125.225.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=meshstor.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=meshstor.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=meshstor.io header.i=@meshstor.io header.b="b7KSwtPc"
Received: by mail-wm2-f5.google.com with SMTP id 5b1f17b1804b1-4955060c214so4719835e9.0
        for <linux-raid@vger.kernel.org>; Sun, 19 Jul 2026 03:53:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=meshstor.io; s=google; t=1784458416; x=1785063216; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OtVNRyXgZ3+RL4yiGXcejIrCkaAlEMOcMS0RlQFV+sM=;
        b=b7KSwtPc8Af+ple+ey6WpVg/wQf+7DU/GaBD464veh11jJ+ufTGNiWBVn4MxMFujYW
         IbOq5+D3Q+kDuO0sTxRd3eerqsZ9y0sM7Ov4EuX3xfztul6HOTIZ9vTOmKrYVDZfmEHX
         7DUOfKcLqAZuW7sWMYg7GK1058poiWSow0Xw0gB1D4wp81lyZFq6pOTz6+PHrSbknkLC
         Ecd0R9bcJGNb6R4WsCfGPxP+ndW3P7xA2HoRyWiXGWq2s8ClcwoyucQKEN1f3RNsqqnY
         x92qLpLLHFMBPh5Woj4t5fGnnBzZlGM9UuaOXNCV376F6WjPVoayagErKBaTqHkxMo3/
         EgmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784458416; x=1785063216;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OtVNRyXgZ3+RL4yiGXcejIrCkaAlEMOcMS0RlQFV+sM=;
        b=ikrm9yx1X5dm7fa5XJT/elze8BwVVZMc8ahKEwfjmDTU+ssxUuyifV0AFMi9REaC5U
         XUGavs9Be0sAGhWf+gKGGGaQaE4XlZQGgqcvAMab/Ks33PC9oBkdiacT66QvqkoTW+m/
         B7bpyZ8tUQ2eD+/kiSkrhISGjrIDEAKyA0NfyJia/42GekLWV2WcmfS6NDr+KxqtwY0G
         YAnTVl3vrIx4m4fBDCixLBZaQrznm1tuQsrzXsdK2Ps0bCeQbrOmNTXFXxXjYmcKgt97
         D2YFc5zWi9BoM34f5Qbt3/dvFm/MR917wDMwigiO0RcmGxQkzXPRwXLcxBT3JIf41IyM
         TH2g==
X-Forwarded-Encrypted: i=1; AHgh+RrpTGA08dD2ZaEOQTYmWUzL+S0PFoA1Hl/mIrhQ0BLUM9ywhVzPNN6WpLTg2cXQtDeY/EU6Mhgmjybc@vger.kernel.org
X-Gm-Message-State: AOJu0YxW4CmP92mjVwQr5xhfeAriCzDfO6yzXkbXrUpd8AGd5vN2ZByo
	4pzT+VNbUnG9u1XT38KQpev7r833olIzKeXwlNiDODtmAeAS6YWJCjVrnV9lmwSOyA==
X-Gm-Gg: AfdE7ckD+UHXaGtCV+3501wpCUzaykLagMXoGGMqEqbfB2UOkv/v0HFqieCIaH9m6ZO
	UBOLWfoqogizUBsUjwURI0IqjKUsaJAobWkXPLX1xvjNLDE4GE7ntNy0NBRx+WeSoyFNJQ8TtYg
	o8lZkZN2qJ862ZJ3XMMsH9cHbiq0v1ZnpqeDSdhbzDHRDAi9U051PZvq+fMIrvr8g+Ya5ZD66bY
	krukbxuCTcxHDtuoQpxLJRfHQpeIv/Bf+gn3c0P8E14vJvLjh3t8FHFFjbCptqz17xzUNTEg57Z
	LC+jxFGzf924BrwDapxmDVe7Pw1rEf1Ug7Fs+JCl8aIQ7GWCBi81q2VQsn3iHZpdtWYarhf9MHi
	89y31gatMEQ26WkUzzlIoNOwYSWTYF9wLXZQjzClvlxM0gBfYLnKxPXbKae5fZA==
X-Received: by 2002:a05:600c:42c6:b0:495:4182:4456 with SMTP id 5b1f17b1804b1-4954a4104e1mr65164425e9.29.1784458414698;
        Sun, 19 Jul 2026 03:53:34 -0700 (PDT)
Received: from mf-00-01.. ([194.220.239.180])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4954a2a24b6sm197679575e9.3.2026.07.19.03.53.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 19 Jul 2026 03:53:34 -0700 (PDT)
From: Mykola Marzhan <mykola@meshstor.io>
To: Jens Axboe <axboe@kernel.dk>,
	Song Liu <song@kernel.org>,
	Yu Kuai <yukuai@fygo.io>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	linux-block@vger.kernel.org,
	linux-raid@vger.kernel.org,
	linux-nvme@lists.infradead.org
Cc: Li Nan <magiclinan@didiglobal.com>,
	Xiao Ni <xiao@kernel.org>,
	Guoqing Jiang <guoqing.jiang@linux.dev>,
	Leon Romanovsky <leon@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	Kiran Kumar Modukuri <kmodukuri@nvidia.com>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Logan Gunthorpe <logang@deltatee.com>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Shivaji Kant <shivajikant@google.com>,
	Pranjal Shrivastava <praan@google.com>,
	Henrique Carvalho <henrique.carvalho@suse.com>,
	linux-kernel@vger.kernel.org,
	linux-rdma@vger.kernel.org,
	linux-pci@vger.kernel.org
Subject: [PATCH v2 0/7] block,md,nvme: correct handling of unsupported P2PDMA transfers
Date: Sun, 19 Jul 2026 10:53:20 +0000
Message-ID: <20260719105327.864949-1-mykola@meshstor.io>
X-Mailer: git-send-email 2.43.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Driving peer-to-peer I/O (NVMe CMB source) through md arrays and
nvme-rdma legs on asymmetric PCIe topologies -- where the peer device
reaches some members/paths but not others -- turns up two failures on
v7.2-rc, both rooted in how an unsupported-P2PDMA mapping failure is
reported. On md: silent data loss -- an unreachable-leg P2PDMA write
counts as written, mirrors silently diverge, and where no member is
reachable the write reports success with zero copies on stable
storage; reads picked to an unreachable leg fail with EIO and are
never retried on the mirror that holds the data. On nvme-rdma: the
transport swallows the DMA layer's mapping errno into a path error,
which under the default multipath configuration livelocks the I/O (a
stacked md mirror hangs) and with nvme_core.multipath=N surfaces as
retryable BLK_STS_TRANSPORT.

The root cause is a block-layer status-code regression, not an md or
nvme bug. Commit 91fb2b6052f7 ("nvme-pci: convert to using
dma_map_sgtable()") deliberately mapped unsupported P2PDMA transfers
to BLK_STS_TARGET ("... return BLK_STS_TARGET so the request isn't
retried"). Commit 858299dc6160 ("block: add scatterlist-less DMA
mapping helpers") silently changed that to BLK_STS_INVAL, and since
commit 7ce3c1dd78fc ("nvme-pci: convert the data mapping to
blk_rq_dma_map") in v6.17 the failure surfaces to direct NVMe
consumers as EINVAL instead of the documented -EREMOTEIO, with
blk_path_error() now classifying it as retryable. md/raid1,raid10
ignore BLK_STS_INVAL leg failures per commit f7b24c7b41f2
("md/raid1,raid10: don't fail devices for invalid IO errors"), where
it means a request-shaped error that fails identically on every
member -- hence the silent divergence. The md leg of the regression
became reachable when md started advertising BLK_FEAT_PCI_P2PDMA in
v7.2-rc1 (commit 02666132403a ("md: propagate BLK_FEAT_PCI_P2PDMA
from member devices to RAID device")).

Patch 1 restores BLK_STS_TARGET at the source. md then handles an
unreachable leg like any other per-device error: badblocks on the
affected member, the master bio succeeds while an In_sync leg holds
the data, and reads are redirected to the other mirror.

Patches 2, 4 and 5 fix independent md-side P2PDMA bugs of the same
vintage: md_submit_bio() strips REQ_NOMERGE (the only request-level
protection against merging P2PDMA segments across pgmaps); raid1
write-behind CPU-copies device BAR memory via bio_copy_data(); and
narrow_write_error()'s retry clones reset bi_opf, dropping the
REQ_NOMERGE protection exactly on the error-retry path.  Patch 3 is
a standalone raid1 fix for a pre-existing ordering hole the
write-behind bypass in patch 4 would otherwise widen: writes that
skip write-behind (queue saturation, a waiting reader, allocation
failure, discards -- and now P2PDMA bios) never serialized against
in-flight write-behind I/O to overlapping sectors.

Patch 6 stops the restored device-error machinery from misfiring
where its medium-error assumptions don't hold. A mapping failure is a
property of the peer/member pairing: retrying the same peer pages
against the same member cannot succeed, and there is nothing on the
medium to repair. Without it, narrow_write_error() serializes hundreds
of guaranteed-to-fail chunk retries per failed write; on reads each
unreachable-leg pick costs a full freeze_array() quiesce plus a tick
of the read-error budget -- measured below, a mixed host/P2P read
workload on an asymmetric topology kicks the perfectly healthy far
leg after ~20 failed picks, in under a second; and on FailFast
members a single unroutable I/O evicts a healthy mirror outright.
Because BLK_STS_TARGET is also produced for transient device
conditions md cannot distinguish from bi_status alone, writes probe
the whole range once instead of predicting futility: a real mapping
failure is recorded in one call, a cleared transient recovers with
nothing recorded. Patches 1 and 6 belong in the same release: with
patch 1 alone, restoring the error surfaces the retry storms and
read-path evictions above on 7.2's newly reachable md path.

Patch 7 closes the same hole in the rdma transport. nvme-rdma maps
the data scatterlist with ib_dma_map_sg(), which returns 0 on a
peer-unreachable failure, discarding the -EREMOTEIO that
dma_map_sgtable() documents for exactly this case; the driver reports
it as a path error. Because the multipath head node advertises
BLK_FEAT_PCI_P2PDMA (commit fb0eeeed91f3 ("nvme-multipath: enable PCI
P2PDMA for multipath devices"), v7.2-rc1) and the mapping failure is
deterministic, nvme_failover_req() requeues the bios with a fresh
retry budget every cycle and the I/O never completes -- a hot requeue
livelock that hangs a stacked md mirror instead of failing over; with
nvme_core.multipath=N it burns nvme_max_retries requeues and
completes as retryable BLK_STS_TRANSPORT. Patch 7 maps with
ib_dma_map_sgtable_attrs() to preserve the errno and returns
BLK_STS_TARGET, matching nvme-pci so patch 6's handling covers rdma
legs too, and starts the request only after the map succeeds so
nvme_mpath_start_request() accounting cannot leak on the direct
blk-mq completion. nvme-rdma stays on the scatterlist DMA API: its
fast-reg MR path (ib_map_mr_sg()) consumes scatterlists, so a
blk_rq_dma_map conversion is separate modernization, out of scope for
a fix.

Behavior on v7.2-rc2, QEMU rig (one CMB provider, two NVMe members,
q35 PCIe topologies), 90 8KiB peer-memory reads under concurrent
host reads for the read rows:

  topology     op          v7.2-rc2                patched (md set)
  symmetric    write+read  ok                      ok
  asymmetric   write       "ok", silent diverge    ok + badblocks on
                                                   far leg (1 probe)
  asymmetric   read        41/90 EIO, no mirror    90/90 ok, no
               under load  retry, no eviction      eviction
  unreachable  write       "ok", NO data copied    EIO + badblocks
  unreachable  read        EIO                     EIO, no members
                                                   kicked

Also verified on the same rig: a transient injected TARGET recovers
through the single probe with nothing recorded; P2P MEDIUM keeps the
chunked path; host-page TARGET/INVAL handling is unchanged; FailFast
survives mapping failures but still evicts on genuine errors;
write-mostly legs are written directly (no write-behind CPU copy); a
degraded array whose only leg is unreachable gets plain EIO -- no
budget charge, no eviction; an exhausted badblocks table fails the
member as described below. The write/read/injection rows repeat
identically on raid10.

Validation of patch 7: the mechanism -- ib_dma_map_sg() returning 0
where ib_dma_map_sgtable_attrs() preserves -EREMOTEIO -- was
confirmed on a real mlx5 HCA with a map-only probe. The
start-after-map reorder ran over an rxe nvmet-rdma loopback under fio
with crc32c verification; multipath inflight and nr_active accounting
drain to zero, matching the pre-reorder kernel. rxe cannot produce
-EREMOTEIO, so the failure paths were driven by injecting that exact
mechanism at the map call site: unpatched, one 4KiB write livelocked
(132 failover requeues in 8s, a stacked raid1 hung; multipath=N:
retryable BLK_STS_TRANSPORT); patched, it failed immediately as
BLK_STS_TARGET with zero requeues, and the stacked raid1 badblocked
the leg without evicting it.

Known trade-offs of routing through the stock md write machinery:
an unroutable P2P write records badblocks and sets WriteErrorSeen
(which gates the write-path badblocks consult), so later writes
overlapping those ranges skip the member -- host writes do not clear
the entries and repair skips known-bad ranges -- leaving them
single-copy until a re-add rebuild (host memory, so it succeeds)
rewrites and clears them.  WantReplacement is deliberately not set
for mapping failures: replacing a member cannot fix a topology
property, and would burn a spare per unreachable member.  A member
whose badblocks table is exhausted or disabled is failed on the
first unroutable P2P write, as with any write error md cannot
record. FailFast members are exempted from md_error() for
mapping failures only (nothing reached the wire, so the error says
nothing about device health); genuine I/O errors keep their
immediate-eviction semantics. raid10 additionally fails a
replacement device outright on a P2P write mapping failure (its
stock replacement-write policy), and an IO_BLOCKED slot excludes
that slot's replacement from the read retry -- both pre-existing
raid10 behaviors with a new trigger. On reads, read_balance() keeps
no memory of unreachability, so each far-leg pick still costs one
failed submission before the redirect.

Routing: patch 1 is block-tree material and fixes a v6.17-rc1 status
regression (hence its Cc: stable); patches 2-6 are md (patch 3 fixes
a pre-existing raid1 ordering bug and carries its own Cc: stable;
the rest address exposure that only became reachable with v7.2-rc1);
patch 7 is nvme-rdma and also carries Cc: stable -- the transport
misreport predates the head-node change (Fixes: 23528aa3320a, v7.1)
and is reachable on v7.1 with multipath=N. Patch 7 sources the errno
from dma_map_sgtable() in rdma.c and does not depend on patch 1,
which fixes the separate blk_rq_dma_map path. Patches 1 (block) and
7 (nvme) are independently applicable bug fixes; a maintainer can
take them even if the md discussion runs longer -- if the md side
slips a release, patch 1 turns the silent divergence into loud
per-leg errors, which we consider the right interim behavior.
Single-cycle routing through the relevant trees with acks works for
us: patch 1 block, 2-6 md, 7 nvme.

Per Documentation/process/coding-assistants.rst: the patches were
developed with AI assistance (see the Assisted-by trailers); all code
was human-reviewed and tested as described above.

Series is against v7.2-rc2.

Changes in v2 (after Sashiko AI review of v1 and further internal
review):
 - new patch 3: writes that bypass write-behind (including discards)
   never serialized against in-flight write-behind I/O to overlapping
   sectors; gate the non-behind path on CollisionCheck so host
   fallback writes, discards and P2PDMA bios (patch 4) all order
   correctly.  Verified with an overlap scenario that hangs if the
   completion-side removal is missing.
 - patch 6: track P2PDMA masters with an r1bio/r10bio state bit set
   at submission instead of sniffing bvec pages at completion time;
   stop setting WantReplacement for mapping failures (a spare cannot
   fix a topology property; verified that a genuine write error
   still sets it); document why raid10 replacement legs keep their
   stock fail-on-error policy and why the read path charges no
   read-error budget.
 - patch 7: also convert the metadata scatterlist to
   ib_dma_map_sgtable_attrs() -- bio_integrity_map_user() accepts
   P2P pages when the queue advertises P2PDMA, so integrity buffers
   are not always host memory; state the asymmetric-multipath
   failover trade-off explicitly.
 - patch 1: version-annotate the stable Cc.
 - patches 2, 5: unchanged.

Link: https://lore.kernel.org/linux-raid/20260718162547.448892-1-mykola@meshstor.io/

Mykola Marzhan (7):
  blk-mq-dma: restore BLK_STS_TARGET for unsupported P2P transfers
  md: ensure REQ_NOMERGE is set on P2PDMA bios
  md/raid1: serialize non-write-behind writes on CollisionCheck rdevs
  md/raid1: don't use write-behind for P2PDMA bios
  md/raid1,raid10: keep REQ_NOMERGE on narrow_write_error() retry clones
  md/raid1,raid10: skip futile retries on P2PDMA mapping failures
  nvme-rdma: return BLK_STS_TARGET for unsupported P2P transfers

 block/blk-mq-dma.c       | 10 +++++-
 drivers/md/md.c          | 14 ++++++--
 drivers/md/md.h          | 18 ++++++++++
 drivers/md/raid1.c       | 78 ++++++++++++++++++++++++++++++++++------
 drivers/md/raid1.h       |  2 ++
 drivers/md/raid10.c      | 72 +++++++++++++++++++++++++++++++------
 drivers/md/raid10.h      |  2 ++
 drivers/nvme/host/rdma.c | 42 +++++++++++++---------
 8 files changed, 198 insertions(+), 40 deletions(-)


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
2.43.0

