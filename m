Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A99FC7603F
	for <linux-raid@vger.kernel.org>; Tue, 22 Apr 2025 05:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745301075; cv=none; b=Nm3ID7IdlYmHWgPtTZGBbSpII5DQpmRY6jAxdXkHsJdFvUpwpuiKBUr/E25eBKzg4HJwp7p8wXNrBZfDXZtHc6RSwHBBRz6afKSQswTEQ4pefVHT5mKJ7pUc9v+3UZVQl6DqGBgcY94j6vTz5RpTbuSpgcD3Uba4IVXR5TfnOXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745301075; c=relaxed/simple;
	bh=MnZTBk6kmgcUzF6ZQjEROkCosbJ0+9oR0ExJVxdsHHU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XAtpIsliLbpUnbVsg2O9o5uHStC9mHNO9ddgm0ZRtD32io1R/MrhngpNEv4jCjup2Q7a/UpTKjkbK/q11O7JnNwbUm6NGsyrUuzjqlPTIoDtN1TcFS54IW8wRCPi28CO0umkLuNLohIf5ri5o8I9heU9eropld+BpwUX4/7EVvM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 140A068C4E; Tue, 22 Apr 2025 07:51:09 +0200 (CEST)
Date: Tue, 22 Apr 2025 07:51:08 +0200
From: Christoph Hellwig <hch@lst.de>
To: Xiao Ni <xni@redhat.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai1@huaweicloud.com,
	hch@lst.de, ming.lei@redhat.com, ncroxon@redhat.com
Subject: Re: [RFC PATCH 1/1] md: delete gendisk in ioctl path
Message-ID: <20250422055108.GA29356@lst.de>
References: <20250422032403.63057-1-xni@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250422032403.63057-1-xni@redhat.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Tue, Apr 22, 2025 at 11:24:03AM +0800, Xiao Ni wrote:
> Now del_gendisk and put_disk are called asynchronously in workqueue work.
> del_gendisk deletes device node by devtmpfs. devtmpfs tries to open this
> array again and it flush the workqueue at the bigging of open process. So
> a deadlock happens.
> 
> The asynchronous way also has a problem that the device node can still
> exist after mdadm --stop command returns in a short window. So udev rule
> can open this device node and create the struct mddev in kernel again.
> 
> So put del_gendisk in ioctl path and still leave put_disk in
> md_kobj_release to avoid uaf.

The md lifetime rules are complicated enough as-is.  So while I won't
object to this change per-see I'd rather have it reviewed by the md
maintainers independently.

In the meantime this should ensure devtmpfs doesn't call into
blkdev_get_no_open and thus put_disk:

diff --git a/block/bdev.c b/block/bdev.c
index 6a34179192c9..97d4c0ab1670 100644
--- a/block/bdev.c
+++ b/block/bdev.c
@@ -1274,18 +1274,23 @@ void sync_bdevs(bool wait)
  */
 void bdev_statx(const struct path *path, struct kstat *stat, u32 request_mask)
 {
-	struct inode *backing_inode;
 	struct block_device *bdev;
 
-	backing_inode = d_backing_inode(path->dentry);
-
 	/*
-	 * Note that backing_inode is the inode of a block device node file,
-	 * not the block device's internal inode.  Therefore it is *not* valid
-	 * to use I_BDEV() here; the block device has to be looked up by i_rdev
-	 * instead.
+	 * Note that d_backing_inode() returnsthe inode of a block device node
+	 * file, not the block device's internal inode.
+	 *
+	 * Therefore it is *not* valid to use I_BDEV() here; the block device
+	 * has to be looked up by i_rdev instead.
+	 *
+	 * Only do this lookup if actually needed to avoid the performance
+	 * overhead of the lookup, and to avoid injecting bdev lifetime issues
+	 * into devtmpfs.
 	 */
-	bdev = blkdev_get_no_open(backing_inode->i_rdev);
+	if (!(request_mask & (STATX_DIOALIGN | STATX_WRITE_ATOMIC)))
+		return;
+
+	bdev = blkdev_get_no_open(d_backing_inode(path->dentry)->i_rdev);
 	if (!bdev)
 		return;
 
