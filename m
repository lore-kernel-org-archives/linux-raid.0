Received: from harvie.cz (harvie.cz [77.87.242.242])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8921B87FA
	for <linux-raid@vger.kernel.org>; Fri,  3 Jan 2025 11:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=77.87.242.242
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735905280; cv=none; b=HUgOdNg8wshg+BIhPOfUuTPGz9f1RchBwMYdaihOxO5M8bD9ZFPfAYdDMhiukQW9SQYjaGhnRgIImSSA6zFKrVHZhRdKjHjHmwPhrG2Dc3ys0QBMIunXsY8RAwE3UGF7PqmtIxXUdrrdOnn2G/loFb4JTKN+W/eM34run5JpUnM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735905280; c=relaxed/simple;
	bh=eD+AT3adBAwfvdG0vpG2lHM19icdRnIJQAM30c9vbaI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q98gkAfMwXGhn+W3PP4xKZ3tLqJglVoA0Y1Z8J7EComkCle9BtbcnqLRxy37xR03BrAt/relLwqRKa5n0w2zkdBciNDu0OTBRakFuDJJNkLA1PGSnlJ9p5bz9X1wJ9FajOHIgfRuboipw3YuAc7mdBQVDjrwa1GUH4EHx/4ZLYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com; spf=fail smtp.mailfrom=gmail.com; arc=none smtp.client-ip=77.87.242.242
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=gmail.com
Received: from anemophobia.amit.cz (unknown [31.30.84.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by harvie.cz (Postfix) with ESMTPSA id C44A41800F6;
	Fri,  3 Jan 2025 12:54:30 +0100 (CET)
From: Tomas Mudrunka <tomas.mudrunka@gmail.com>
To: mtkaczyk@kernel.org
Cc: linux-raid@vger.kernel.org,
	song@kernel.org,
	tomas.mudrunka@gmail.com,
	yukuai1@huaweicloud.com,
	yukuai3@huawei.com,
	yukuai@kernel.org
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header file
Date: Fri,  3 Jan 2025 12:54:22 +0100
Message-ID: <20250103115422.20508-1-tomas.mudrunka@gmail.com>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250103103801.1420d5d5@mtkaczyk-private-dev>
References: <20250103103801.1420d5d5@mtkaczyk-private-dev>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

> The problem is that system service will recognize raid disks and
> assemble the array automatically, you might what to disable them.

Actualy user is forced to work with MD device from the get go.
This is how you would typicaly use mdadm to write metadata to disk:

$ truncate -s 1G test.img
$ mdadm --create /dev/md0 --level=1 --bitmap=internal --raid-devices=2 test.img missing
mdadm: must be super-user to perform this action
mdadm: test.img is not a block device.

Following is unfit for my usecase:
* It requires me to reference /dev/md0 (i don't want to involve kernel at all)
* It requires super-user (no need, i just want to write bytes to my own file)
* Refuses to work on regular file (once i run it as super-user)

> I don't think we need to care. They goal is to not have and use MD
> module so mdadm will fail to load personalities.

No it is not the goal. Goal is not to rely on kernel. It has to work on any kernel
including the ones that have MD module loaded. Possibly even on non-Linux OS.

> I agree. The right way is to incorporate it with mdadm.
> We should create a volume image (data) without MD internals.

In that case i would still need headers with structs to parse the metadata
and get offsets where to load actual data (filesystem) into the array images.

But to be honest, i am pretty happy with how the genimage code works now,
i don't need any help with its functionality. I don't even need those headers
to be fixed. I can leave them copypasted. But i think it would be right thing
to consolidate them, therefore i've proposed the patch.

I just didn't wanted to hardcode definitions that are already in kernel,
because i don't like duplicit code that can be included from somewhere else.

> If you are looking for challenges this software is full of them!

Haha. I feel you. Maybe lets tackle them step by step.
Consolidating headers to provide complete ondisk format seems
as a good start to me. Especialy if the mdadm could benefit from that as well.

Tom
