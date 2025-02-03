Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E3162036FE;
	Mon,  3 Feb 2025 11:43:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738583032; cv=none; b=WppuDrMrURZeb0Lb3BzggGVlOY7FRKg5pDTqrmmDJnkgybyS3rfGVYu8QdOArCqo6UvyXb2hZdahoer5A4YkOWaIrbTiOv4qEMMiwWBupZGL0Xh+2vivSwfscJQW2O/eDWDsZbyi5p4xFpk8ojgP+8szxfcjch8FJOzvGHAuvEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738583032; c=relaxed/simple;
	bh=SqHiUPedpUqenqDH6nwEO3s85eth7EdQW7SIOQbKefs=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JREXds/1rjAy9nERwXJz4waZ50tn1XTRt6gWwiUJhSy4YmqOcNd3ZUJqO4C017eozz5K7nuMcHNvqRM4F9AJA/p5VXMLNXvA/Qbklp6hyllDjwVY1ht0Emhx6f2yo3DRSBg5hCCnttbHLsXS+rIO9GM1SeqCJg88/hBWyp4oa3E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 97241C4CED2;
	Mon,  3 Feb 2025 11:43:49 +0000 (UTC)
Date: Mon, 3 Feb 2025 12:43:45 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai3@huawei.com>,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
Message-ID: <20250203124326.66217544@mtkaczyk-private-dev>
In-Reply-To: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
References: <20241231030929.246059-1-tomas.mudrunka@gmail.com>
Organization: Linux development
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.34; x86_64-suse-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 31 Dec 2024 04:09:27 +0100
Tomas Mudrunka <tomas.mudrunka@gmail.com> wrote:

> When working on software that manages MD RAID disks from
> userspace. Currently provided headers only contain MD superblock.
> That is not enough to fully populate MD RAID metadata.
> Therefore this patch adds bitmap superblock as well.
> 
> Signed-off-by: Tomas Mudrunka <tomas.mudrunka@gmail.com>
> ---

Hello Tomas,
Jumping here again.. I tried to build mdadm against your patch.
In mdadm we used copied headers for years. I submitted PR for review:
This simple one to remove legacy ifdef:
https://github.com/md-raid-utilities/mdadm/pull/148

And this one to start using kernel provided headers:
https://github.com/md-raid-utilities/mdadm/pull/149

Going back to you change, to integrate it with mdadm well I need:
/* Notify that kernel provides it */
#define MD_BITMAP_SUBERBLOCK_EXPORTED 1 

Probably I can use any define to check it, but for clarity I would like
to keep clear differentiation. I hope it is not a problem.

And missing defines used by mdadm:

#define BITMAP_MAJOR_LO 3
/* version 4 insists the bitmap is in little-endian order
 * with version 3, it is host-endian which is non-portable
 */
#define BITMAP_MAJOR_HI 4
#define	BITMAP_MAJOR_CLUSTERED 5

see:
https://github.com/md-raid-utilities/mdadm/blob/main/bitmap.h


After that, I should be able to compile mdadm.

Thanks,
Mariusz
