Received: from zandbergen.org (zandbergen.org [136.144.204.219])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 68B1D48A8D0
	for <linux-raid@vger.kernel.org>; Tue, 25 Aug 2026 17:24:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.144.204.219
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787678648; cv=none; b=cY8BHOM7gJhTKsIlzx31qNctQgG/RcGkbflZxJmubFzkgyIlYuhLOL2KaTTyRLLBp56xhHC977ZLoqowObSuZs6P+n5wxYbBfqWC/EqbqRkmernk/+IENSawhuC7ZNrGwU2ym1tOvvhG6qvzOMaDXW/Q7lLW9bu35kNX6DCG/KQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787678648; c=relaxed/simple;
	bh=SFfqZnYADrNPifhYRuFdSz2Wwck0SLU8Q2Eim/YqOxc=;
	h=From:Date:Message-ID:MIME-Version:Content-Type:To:Cc:Subject; b=CHNX32GqWwgt3uIYF9S4svisHDiYVFQsW9fgw3arnRfGYnXKjLjB+2DuWXuQZpPmNWp9EbuCjt11gvAHYj0K3S2Ugjf+cpCLPIarQxVqqLteR79KNYhh/V0oEYb7GVcmBWDpuWun3onjFC58fkhypoMZ0Yr00ytcNbnA6Y2N3Rw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zandbergen.org; spf=none smtp.mailfrom=arp.pim.zandbergen.org; dkim=pass (1024-bit key) header.d=zandbergen.org header.i=@zandbergen.org header.b=QyciN+67; arc=none smtp.client-ip=136.144.204.219
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=zandbergen.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=arp.pim.zandbergen.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=zandbergen.org header.i=@zandbergen.org header.b="QyciN+67"
Received: from arp.pim.zandbergen.org (2a02-a46e-c56e-99-92e2-baff-fe27-d44.fixed6.kpn.net [IPv6:2a02:a46e:c56e:99:92e2:baff:fe27:d44])
	by zandbergen.org (Postfix) with ESMTPSA id DF92210BF44;
	Tue, 25 Aug 2026 19:14:34 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 zandbergen.org DF92210BF44
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zandbergen.org;
	s=default; t=1787678076;
	bh=0w3HYVGtQ7Rgmw7MqAAVccCzk+VtMbKRGnazLqau5Q8=;
	h=From:Date:To:Cc:Subject:From;
	b=QyciN+67DGYU8MzepWx4/MXq0ViS1wG/tigSWAor8HKoDQVX+Ws+xfFOZsXXelK6S
	 uN7ssreJNh+Kk6KSZtIimmbSxRTUFUzyKNZhgKgf/T4z6WJNCXENH/BGzC/ZDi4Fvv
	 XGGPTN9MrctRrbCy4mfrwCS7zmue/jrqYKFAys7Q=
X-Virus-Status: Clean
X-Virus-Scanned: clamav-milter 1.4.6 at zandbergen.org
Received: by arp.pim.zandbergen.org (Postfix, from userid 1000)
	id C8C03242099C; Tue, 25 Aug 2026 19:14:34 +0200 (CEST)
From: Pim Zandbergen <pim@zandbergen.org>
Date: Tue, 25 Aug 2026 19:14:28 +0200
Message-ID: <20260825T171428.247977.raid5-discard-reshape@zandbergen.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: linux-raid@vger.kernel.org
Cc: song@kernel.org, yukuai@fygo.io, magiclinan@didiglobal.com,
    xiao@kernel.org, regressions@lists.linux.dev
Subject: [REGRESSION] md/raid5: discard submitted during reshape is never
 completed, submitter hangs in D state forever

Hi,

Since commit 90573092673c ("md/raid5: validate discard support at
request time", v7.2-rc1), a discard bio submitted to a raid5/raid6
array while a reshape is running is dropped without ever being
completed. The submitting task hangs in uninterruptible sleep
indefinitely, and only a reboot clears it. On my machine this turned
the weekly systemd fstrim.timer run into a day-long filesystem-wide
stall that ended in a hard reset.

Mechanism
---------

Before 90573092673c, an array whose members do not support discard
(or without devices_handle_discard_safely set) advertised
max_hw_discard_sectors = 0, so FITRIM and blkdev discards never
reached raid5 at all. Since that commit the array always advertises
UINT_MAX and member support is validated at request time in
raid5_discard_limits(), which correctly completes unsupported bios
with BLK_STS_NOTSUPP and bio_endio().

However, make_discard_request() still contains the reshape guard
that predates request-time validation (620125f2bf8f, "MD: raid5
trim support", v3.7):

	if (mddev->reshape_position != MaxSector)
		/* Skip discard while reshape is happening */
		return;

(drivers/md/raid5.c:5726 in v7.2, still present in current master.)

This returns without calling bio_endio(). The caller treats the bio
as handled:

	if (unlikely(bio_op(bi) == REQ_OP_DISCARD)) {
		make_discard_request(mddev, bi);
		md_write_end(mddev);
		return true;
	}

so nothing ever completes the bio. blkdev_issue_discard() waits in
submit_bio_wait() forever and the submitter is stuck in D state.
Nothing re-queues the bio when the reshape finishes, so reshape
completion does not recover it.

Note that the reshape check runs before raid5_discard_limits(), so
this hits any raid5/6 array under reshape, including arrays whose
members have no discard support at all and which would otherwise be
correctly rejected with BLK_STS_NOTSUPP. That is exactly my case:
before v7.2 the same fstrim run was a silently skipped no-op for
years; the kernel upgrade made it reachable, and the first time it
fired during a reshape it wedged the machine.

Real-world impact observed
--------------------------

Timeline on the affected machine (arm64, v7.2, raid6 of 10 SATA
HDDs, at the time mid-grow from 8 to 10 members, XFS on LVM on top):

- Fri 19:59: mdadm grow/reshape starts.
- Mon 00:40: weekly fstrim.timer fires. fstrim reaches the XFS
  filesystems on the array and hangs in D state on the first
  discard. It stays there for at least the next 21 hours (verified
  via ps; last check was about 21h in).
- While stuck, the FITRIM ioctl holds XFS allocation group / busy
  extent state, so writeback workers and eventually every writer on
  those filesystems pile up behind it. A DVR service wedged
  completely; the machine (also serving as router) later became
  unresponsive and had to be hard-reset.
- md's sync throttling sees the array as idle the whole time (the
  parked bio never generates member I/O), so the stall is invisible
  in /proc/mdstat and cannot be influenced with sync_speed_min/max.

Sample stack of one victim writer (blocked on the inode lock behind
the writeback chain that is itself stuck behind fstrim):

  [<0>] xfs_ilock+0x15c/0x1c0 [xfs]
  [<0>] xfs_vn_update_time+0x1e8/0x268 [xfs]
  [<0>] file_update_time_flags+0x7c/0x140
  [<0>] kiocb_modified+0x3c/0x58
  [<0>] xfs_file_write_checks+0x1ac/0x388 [xfs]
  [<0>] xfs_file_buffered_write+0x13c/0x390 [xfs]
  [<0>] xfs_file_write_iter+0x170/0x308 [xfs]
  [<0>] do_iter_readv_writev+0x110/0x250
  [<0>] vfs_writev+0x12c/0x2c0
  [<0>] do_writev+0x78/0x160
  [<0>] __arm64_sys_writev

I did not capture the fstrim task's own kernel stack before the
machine had to be hard-reset, so the mechanism above is from code
inspection of the discard path rather than a captured stack. I have
a scripted loop-device reproducer (loop-backed raid6, start a grow,
mount XFS, run fstrim; expected result is fstrim permanently in D)
which I have not run yet because the affected machine is a
production box. I am happy to run it in a VM on request, and to
test patches.

The kernel is the v7.2 stable tag plus two local patches for arm64
platform/PCIe bringup that touch nothing in block/ or drivers/md/.

Suggested direction
-------------------

Discards are advisory, so completing the bio instead of dropping it
seems sufficient: bio_endio() with BLK_STS_OK (treat discard as a
no-op during reshape) or BLK_STS_NOTSUPP, mirroring what
raid5_discard_limits() already does three lines below. Waiting for
the reshape to pass, as regular writes do, would also fix the hang
but keeps FITRIM blockable for hours or days on a slow reshape. I
will leave the choice to you.

#regzbot introduced: 90573092673c

Thanks,
Pim Zandbergen
