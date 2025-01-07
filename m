Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECBDA13B58D
	for <linux-raid@vger.kernel.org>; Tue,  7 Jan 2025 08:36:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736238976; cv=none; b=CswwSjzUfIUPCJ/v0yAUlzoEmezCJd48CWejUkscBI/RPGJQ7E/yGSMHUGnbsPSjDTdpurH84vRAo7/rJTBZ4L5WmyMu7xQC+mbOk8wNVL4LjX/WMBpcKzi9ZRGH7HNi1IQUTILBZX2/NYeIXRemaladM3RSJTB7iAoOlnaRVwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736238976; c=relaxed/simple;
	bh=3SXQsei+k3SDKkvik9AbGedmzn65mwtm4NRKhKGCXZ4=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MwWJnNzd+fiwRS08GaQmUUquZAw8LOv42XD03xVD2347PaBbBmliQqB56hcZjVjbZsbIscfoFM+X+6Azhkv4Nni8d6n2K7eKcWWTGfsikGPsxQtG7PN2IaqS22mlApBw2gT7VJK1n6e5oW7+SVBNqqQWrmVqnBtx1ZqkKyLYODI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 3B046C4CED6;
	Tue,  7 Jan 2025 08:36:13 +0000 (UTC)
Date: Tue, 7 Jan 2025 09:36:03 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Tomas Mudrunka <tomas.mudrunka@gmail.com>
Cc: linux-raid@vger.kernel.org, song@kernel.org, yukuai1@huaweicloud.com,
 yukuai3@huawei.com, yukuai@kernel.org
Subject: Re: [PATCH] Export MDRAID bitmap on disk structure in UAPI header
 file
Message-ID: <20250107093603.106f5bef@mtkaczyk-private-dev>
In-Reply-To: <20250103115422.20508-1-tomas.mudrunka@gmail.com>
References: <20250103103801.1420d5d5@mtkaczyk-private-dev>
	<20250103115422.20508-1-tomas.mudrunka@gmail.com>
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

On Fri,  3 Jan 2025 12:54:22 +0100
Tomas Mudrunka <tomas.mudrunka@gmail.com> wrote:

> > The problem is that system service will recognize raid disks and
> > assemble the array automatically, you might what to disable them.  
> 
> Actualy user is forced to work with MD device from the get go.
> This is how you would typicaly use mdadm to write metadata to disk:
> 
> $ truncate -s 1G test.img
> $ mdadm --create /dev/md0 --level=1 --bitmap=internal
> --raid-devices=2 test.img missing mdadm: must be super-user to
> perform this action mdadm: test.img is not a block device.

In this case it should be something like --create --no-start (you don't
want to start raid volume therefore you will not need MD stuff).

--raid-devices option requires a disks. mdadm cannot guess them, you
have to pass them. typically: --raid-devices=2 /dev/sda /dev/sdb

in your case you would need new options like: --write-image=<file>
> 
> Following is unfit for my usecase:
> * It requires me to reference /dev/md0 (i don't want to involve
> kernel at all)

If we start supporting just writing metadata to chosen members
then /dev/md0 reference will gone.

> * It requires super-user (no need, i just want to write bytes to my
> own file)

What do you want to write to this file? I thought that you want to
write content of the file to member disks accordingly to raid layout?

Am I wrong here? wouldn't genimage generate raid array using
pre-prepared image file?

> * Refuses to work on regular file (once i run it as super-user)
mdadm requires super user at all actions. We can challenge that in
reasonable cases. Patches are welcomed.
> 
> > I don't think we need to care. They goal is to not have and use MD
> > module so mdadm will fail to load personalities.  
> 
> No it is not the goal. Goal is not to rely on kernel. It has to work
> on any kernel including the ones that have MD module loaded. Possibly
> even on non-Linux OS.

if mdadm is not available case is simple - no possibility to activate MD
arrays, unless v0.9 autostart but it is not a case here.

If MD module is not available then mdadm will not try to
start arrays (missing personality, no possibility.

but if MD is there and genimage (or mdadm) will close
descriptors after writing metadata to disks- raid volume may
automatically be assembled (processing of change event).
Just FYI.

Kuai was concerned that volume may appear even if you don't want it.
Theoretically it could happen.

> 
> > I agree. The right way is to incorporate it with mdadm.
> > We should create a volume image (data) without MD internals.  
> 
> In that case i would still need headers with structs to parse the
> metadata and get offsets where to load actual data (filesystem) into
> the array images.

Yes.
> 
> But to be honest, i am pretty happy with how the genimage code works
> now, i don't need any help with its functionality. I don't even need
> those headers to be fixed. I can leave them copypasted. But i think
> it would be right thing to consolidate them, therefore i've proposed
> the patch.

It is fine. I mean it would be perfect to implement something like that
for mdadm because other people may have a chance to use it but it is up
to you. If this implementation satisfies your need then you are good to
go. I will not handle this feature myself in mdadm and I don't
see anyone else interested in having this that I would ask to support.

> 
> I just didn't wanted to hardcode definitions that are already in
> kernel, because i don't like duplicit code that can be included from
> somewhere else.

For me it is a right change. As I said, please care to fix mdadm
because people are looking into mdadm as a source of truth.

> 
> > If you are looking for challenges this software is full of them!  
> 
> Haha. I feel you. Maybe lets tackle them step by step.
> Consolidating headers to provide complete ondisk format seems
> as a good start to me. Especialy if the mdadm could benefit from that
> as well.

You have my ack!
FYI, you can develop mdadm patches through github:
https://github.com/md-raid-utilities/mdadm

Thanks,
Mariusz
