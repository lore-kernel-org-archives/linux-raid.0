Received: from out30-99.freemail.mail.aliyun.com (out30-99.freemail.mail.aliyun.com [115.124.30.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3136D33F582;
	Tue,  4 Aug 2026 03:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=115.124.30.99
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785815729; cv=none; b=PG7rtQSa9gUghOP/MYzRt7uL0NULJ5rm0vT4b7YmDkDEyhfJFRwtpdljjh36ORBVa/r5gfpbdDNiTYWOXzwFP35wEfOmCtawqCxgWDSqvg7sG2V8y83OoJkB5RX81K8cslyRh6m+R/Y6ZgeKuGHrnhREAKY7g8cvpuhAuK/V6QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785815729; c=relaxed/simple;
	bh=SlIaYLmz1hkcZHe+X9iLtf/YhoPEAmYJzoZGqegLXWM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=VWC2bqINXaXFVcDn1xfuK5U1NiJB1Mse1Lp+fKdbiUEw7wONc25B6RplC+kau6Q6ybWaunXyArmeMwUVuaXn4lcFj/y7mmJFqbzJzRGsDVO4WJmgHhqEgAgsASfD8JuORBbD8Vi6o9shN6k42F+zRt0lrVJhyJqgCBDVt60jny8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com; spf=pass smtp.mailfrom=linux.alibaba.com; dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b=mjTv+Jwm; arc=none smtp.client-ip=115.124.30.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.alibaba.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.b="mjTv+Jwm"
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1785815717; h=From:To:Subject:Date:Message-Id:MIME-Version;
	bh=4iBGQHRMT31JLxpnMUn+1Gzw2DYAUemAjfouiqEsnkY=;
	b=mjTv+JwmE62VQCtw5pHF9gCUXBEi/hK27LCYtzW8Piq4n8JHnZy0BUjHPI4Ut2XAVcrurGmsWQSY73MgnsTGdf7LTOSkICPXIDfhWT6nJ0B1qi3y0WarcllNxw3VPpR804Gd475oFt6E90qUx4XhINN5M8yecHXQ9i6yQDqqQ+Q=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R511e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=yunye.zhao@linux.alibaba.com;NM=1;PH=DS;RN=9;SR=0;TI=SMTPD_---0X8MVHk2_1785815716;
Received: from j66c13357.sqa.eu95.tbsite.net(mailfrom:yunye.zhao@linux.alibaba.com fp:SMTPD_---0X8MVHk2_1785815716 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 04 Aug 2026 11:55:17 +0800
From: Yunye Zhao <yunye.zhao@linux.alibaba.com>
To: yukuai@fygo.io
Cc: joseph.qi@linux.alibaba.com,
	linux-kernel@vger.kernel.org,
	linux-raid@vger.kernel.org,
	magiclinan@didiglobal.com,
	song@kernel.org,
	xiao@kernel.org,
	yunye.zhao@linux.alibaba.com,
	sashiko-bot@kernel.org
Subject: Re: [PATCH v2 3/3] md/raid10: skip clean regions in bulk during recovery
Date: Tue,  4 Aug 2026 11:55:16 +0800
Message-Id: <20260804035516.98652-1-yunye.zhao@linux.alibaba.com>
X-Mailer: git-send-email 2.19.1.6.gb485710b
In-Reply-To: <0650db8f-14d2-4f80-949f-82553fd8485b@fygo.io>
References: <0650db8f-14d2-4f80-949f-82553fd8485b@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Kuai,

On Thu, 31 Jul 2026 at 17:46, Yu Kuai wrote:
> I'm confused, recovery means replace a new disk ... the whole new disk
> have to rebuild ... there is nothing to skip
>
> So are you talking about the case that the array is already broken?

The recovery target here is a *re-added existing member*, not a fresh
spare.

Right, for a fresh spare: saved_raid_disk != slot sets conf->fullsync=1,
this skip is bypassed, and the whole disk rebuilds. This patch does not
touch that.

The case I fix is a member transiently removed and re-added:

  - a member drops out; its mirror partner stays online, so the array is
    still redundant and readable (not broken);
  - nothing is written while it is gone, so the write-intent bitmap
    stays clean;
  - the same disk is re-added: valid superblock, saved_raid_disk == old
    slot, so conf->fullsync stays 0 and md does a bitmap-based recovery
    (MD_RECOVERY_RECOVER; /proc/mdstat shows "recovery").

The bitmap is fully clean, every chunk returns must_sync == false,
biolist stays NULL, and we hit the existing "*skipped=1; return
max_sync;" path. Only its step size is wrong.

Reproducer (near=2, 4 disks, nothing written while degraded, each pair
keeps a live copy):

  mdadm --create /dev/md0 -l10 -n4 -p n2 --bitmap=internal \
        --bitmap-chunk=512M --assume-clean --run <4 x 8T>
  mdadm /dev/md0 --fail /dev/loop1 --remove /dev/loop1
  mdadm /dev/md0 --fail /dev/loop3 --remove /dev/loop3
  # no writes here
  mdadm /dev/md0 --re-add /dev/loop1
  mdadm /dev/md0 --re-add /dev/loop3

Thanks,
Yunye
