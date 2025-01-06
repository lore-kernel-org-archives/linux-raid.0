Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF219156886;
	Mon,  6 Jan 2025 15:25:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177136; cv=none; b=NnyjZFpy8ixh9faU+smEaQLeDhx0+Uc8Utf9CrLeCxxJbjEPyIWX86ZW5N/bsXc6QEseL3mBlhfZ7RiIdgXrtneBKVMEh3Fj9SQFwwNIrgkP1hq0mqV+G1JdJlNff9HMrJjUa09CPLqyuMKDhVHih6OjIqX+J2Dok0aTgR/0gwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177136; c=relaxed/simple;
	bh=ip4/e7s1i7IZaT8urM4VYXkmRUlHnmCrJ3igUJHG5oE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b02RSqklAV0wZDgLpCkP05hDyHPXWamz+OdEeGzp8nf8vryzgX8sKOXwzJ0I7yTKiY/nUU/cigEQhuc8GTR3Rlz7b6nxlrpE9nhdUnkL39CT0xrKrHEJlVzq7JvyHu7sFhqXacqeyrMifboOkcss3FiHykVrV16hRYPUvLJxlm8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=cWQ8/Jp7; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=bombadil.srs.infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cWQ8/Jp7"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=o5KbA9W/6qG+My66QdFjwAdHKofto+/PUdw3R820eFk=; b=cWQ8/Jp7QmXgRtdAXlGiuWDvUk
	zVdiIOHQvWUsZaMP56zKOL0PsNsIvKtfsWx6aotktMc40Yfs10jWnB9wHBmu+LftePupApjoOYd2v
	YtJ5ylSbeYFXQbKMFAPxNT/AosRbaKSYifKP8s9+AmS9u/cCM1T6Bb19tEeMv8mPwrvgil4whlAKZ
	prUnvli2gfbJMCPOwhraGANRPl4d54fvP1dtgwia64SSw7t+/Ey0PqZxeUGCXR3DvVxwcIsVg6xSX
	Lurk38M1s+VQwwkJMYFtFCIh0zMOEHiu5jwdHWgCXUdfavNjeCnKahbdNMqZ2n/O0ob+/eHEV3+id
	fYVgumTQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98 #2 (Red Hat Linux))
	id 1tUoz0-00000001l4m-1uph;
	Mon, 06 Jan 2025 15:25:34 +0000
Date: Mon, 6 Jan 2025 07:25:34 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
Message-ID: <Z3v17kZYZnvYPpsl@infradead.org>
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html

On Tue, Dec 31, 2024 at 04:09:27AM +0100, Tomas Mudrunka wrote:
> When working on software that manages MD RAID disks from
> userspace. Currently provided headers only contain MD superblock.
> That is not enough to fully populate MD RAID metadata.
> Therefore this patch adds bitmap superblock as well.

the bitmap format is not a userspace ABI, it is an on-disk format.
As such it does not belong into the uapi.  It might make sense to
create a clean standalone header just for the on-disk format that
you could copy, though.

