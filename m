Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48DDA1F543E
	for <linux-raid@vger.kernel.org>; Fri, 27 Dec 2024 17:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735318996; cv=none; b=EcMaBF0QtgHVscApwXuAGEouQ1w3CPxEPQMiyIEAeYjfK3Hb+IbWOdP9l0n6kP0Y/EYiSui9FqPjAglZpMss7ICXzlLrpVesWcHyffGBkjp2FRbyWLKZp86rkXUY58KPjNjcvjlaG7yuCKWI0/c9MKMQUNxLF44KQOlBY6WSfR4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735318996; c=relaxed/simple;
	bh=vKV+URmzof7dG6kMt7fIUNLdEH6UxSBIeco0jNPVseU=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NCLA6HaxClcbR8Ph/zL0w9v1ceOnRyzC3r/ercs+3NabdxHKbN+D6LZXgGSU1mdOE4N6fK0nK21wXYV7E6ho2HEhPTp8D7q+7SsAFnrliipTAyQAjUMmhsKPMQobJcK8R37wHxGnNXXwy24pb9xghg4OY8YSejMKDnKfrz3Aqd8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
Received: from mtkaczyk-private-dev (unknown [31.7.42.13])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPSA id 75182C4CED0;
	Fri, 27 Dec 2024 17:03:13 +0000 (UTC)
Date: Fri, 27 Dec 2024 18:03:09 +0100
From: Mariusz Tkaczyk <mtkaczyk@kernel.org>
To: Tomas Mudrunka <mudrunka@spoje.net>
Cc: linux-raid@vger.kernel.org
Subject: Re: Confused about device counting in MD RAID1
Message-ID: <20241227180114.0e44c7ae@mtkaczyk-private-dev>
In-Reply-To: <13b5f0846272587087a82f9953eaf81c@spoje.net>
References: <13b5f0846272587087a82f9953eaf81c@spoje.net>
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

On Sun, 22 Dec 2024 10:45:02 +0100
Tomas Mudrunka <mudrunka@spoje.net> wrote:

> Hello,
> i am working on implementation of MD RAID1 and i am bit lost
> regarding superblock 1.2 format. Can you please help with following?
> 
> I've created RAID1 like this:
> 
> DEVICE_COUNT = 1
> DEVICE_NUMBER = 0
> ROLES: 0x0000
> 
> mdadm reports it to be correct, used mdadm to grow it like this:
> 
> mdadm --grow /dev/md23 --raid-disks=2 --force
> maddm /dev/md23 --add /dev/sdb1
> 
> Now i've inspected superblocks of both devices and i have following:
> 
> DEVICE_COUNT = 2
> DEVICE_NUMBER = 0
> ROLES: 0x0000 0xFFFF 0x0100
> 
> DEVICE_COUNT = 1
> DEVICE_NUMBER = 2
> ROLES: 0x0000 0xFFFF 0x0100
> 
Hello Tomas,
What is the command you used to get this? I cannot match it with any
mdadm's output.
> 
> First device number is 0, why second device is 2 (while 1 being 
> skipped)? Should the count start at 1?

Blind guess is a "replacements" feature. I know, that MD/mdadm
allocates two slots for same device (n, n+1) to provide replacement
feature i.e. automatically replace old drive when recovery of new
one finished. So, you are still using old drive in this time but you are
preparing replacement drive in the same time.

The behavior may have logical explanation :)

> Why are there 3 roles now, when DEVICE_COUNT is 2 ? If count starts
> at 1, why would there be roles[0]?

First, please note that growing RAID1 to 2 drives is:
- adding one drive;
- extending metadata, new disk is "out-of-sync";
- performing "recovery" (not reshape!) for new disk.

0xFFFF is known to mean "faulty" (empty) in MD/mdadm. As I said, I
think this one to be slot for replacement. IMO it means that
replacement drive is missing. It is fine then.

roles[0] - DEVICE_NUMBER=0
roles[1] - DEVICE_NUMBER=1 (replacement slot for DEVICE_NUMBER=0)
roles[2] - DEVICE_NUMBER=2 (new drive)

> I am bit confused. Obviously i am making some trivial mistake and i 
> don't want to keep guessing anymore.
> Can you please tell me how to correctly handle this?

I'm still not sure where these properties comes from. I looked for
"DEVICE_" in all code with no success..

Anyway, I hope it is helpful. Good luck.

Thanks,
Mariusz
