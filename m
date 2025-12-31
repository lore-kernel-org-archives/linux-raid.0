Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71D2E22D78A;
	Wed, 31 Dec 2025 18:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767204557; cv=none; b=TxygUGV/yhvrkRgBSIvqwWSVazTBMiUqybIskI0ZJN1PmeQm1vN6AMqUPFlQ8cSXdg4CSMhJQuzdnuzL8N+0d4NaoBOQE/7j3AKY9GwZChfXp5u3kr5mrjYM0PmQtHga4gLa07fAXbLfJv6k8G/3JebmC5TiNL0o/0vQM0p13TQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767204557; c=relaxed/simple;
	bh=O8tNG6FZcczjY1aLCqiD2JGwY7B7QOhEfT8AsDvZLKM=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=fweAAgvVJ689YQtXhzEdGWGTgHaUv8HrNmHJp6xpfZT0iTJ+BXJ0TMusDBqRhEfAjikhACuMrjI0iwI5qfx1FPLpv1wYQp2nWYtB9dGUmmrlWCNU/LfmGEFbIhckKVio5Fu4MjI8oB2j41PuE4kgLBM2ts59TkXY5Ap6Onj1Ox4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b=lTlF7yBE; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b="lTlF7yBE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stoffel.org;
 i=@stoffel.org; q=dns/txt; s=20250308; t=1767204028; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from :
 to : cc : subject : in-reply-to : references : from;
 bh=O8tNG6FZcczjY1aLCqiD2JGwY7B7QOhEfT8AsDvZLKM=;
 b=lTlF7yBEX+So3fjLXJvI6hg91dlJl4gvd1uIpC0b6FaeApu6uWMfX1W3IfQHJ/ECv/kYI
 FeENpJwpUq8p3mwdEwgBp7fd4Fa5eRyQuXDb2poQnvp15um0FDBCeFDLWL3BjP7vTdHFkue
 v9PJngBBXKTIg04fyH1WVQ+UVsscs6WQwyY9ZttGNwsIdUlaCpmv/Kl21d6JnCrjvnakZMm
 wCGCrH3p+cMXOIhstPoPZJqeWngHuawAI5saeyvztkj+RNeDuiQw9VDSl+XDb7m9NfpGPUt
 7L0+Z/94r7UWlXOuhDg67qN1o7AThCb/SCPeMgKQyh8QpAFiTtXqh21X0OdQ==
Received: from quad.stoffel.org (unknown [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 323F21E6A3;
	Wed, 31 Dec 2025 13:00:28 -0500 (EST)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 5525DA25AD; Wed, 31 Dec 2025 13:00:27 -0500 (EST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26965.25787.328101.504732@quad.stoffel.home>
Date: Wed, 31 Dec 2025 13:00:27 -0500
From: "John Stoffel" <john@stoffel.org>
To: Zheng Qixing <zhengqixing@huaweicloud.com>
Cc: song@kernel.org,
    yukuai@fnnas.com,
    linux-raid@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    yi.zhang@huawei.com,
    yangerkun@huawei.com,
    houtao1@huawei.com,
    zhengqixing@huawei.com,
    linan122@h-partners.com
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [RFC PATCH 4/5] md: introduce MAX_RAID_DISKS macro to replace magic number
In-Reply-To: <20251231070952.1233903-5-zhengqixing@huaweicloud.com>
References: <20251231070952.1233903-1-zhengqixing@huaweicloud.com>
	<20251231070952.1233903-5-zhengqixing@huaweicloud.com>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "Zheng" == Zheng Qixing <zhengqixing@huaweicloud.com> writes:

> From: Zheng Qixing <zhengqixing@huawei.com>

> Define MAX_RAID_DISKS macro for the maximum number of RAID disks.
> No functional change.

> Signed-off-by: Zheng Qixing <zhengqixing@huawei.com>
> ---
>  drivers/md/md.c | 4 ++--
>  drivers/md/md.h | 1 +
>  2 files changed, 3 insertions(+), 2 deletions(-)

> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 9eeab5258189..d2f136706f6c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1888,7 +1888,7 @@ static int super_1_load(struct md_rdev *rdev, struct md_rdev *refdev, int minor_
 
>  	if (sb->magic != cpu_to_le32(MD_SB_MAGIC) ||
sb-> major_version != cpu_to_le32(1) ||
> -	    le32_to_cpu(sb->max_dev) > (4096-256)/2 ||
> +	    le32_to_cpu(sb->max_dev) > MAX_RAID_DISKS ||
>  	    le64_to_cpu(sb->super_offset) != rdev->sb_start ||
>  	    (le32_to_cpu(sb->feature_map) & ~MD_FEATURE_ALL) != 0)
>  		return -EINVAL;
> @@ -2065,7 +2065,7 @@ static int super_1_validate(struct mddev *mddev, struct md_rdev *freshest, struc
mddev-> resync_offset = le64_to_cpu(sb->resync_offset);
>  		memcpy(mddev->uuid, sb->set_uuid, 16);
 
> -		mddev->max_disks =  (4096-256)/2;
> +		mddev->max_disks = MAX_RAID_DISKS;
 
>  		if (!mddev->logical_block_size)
mddev-> logical_block_size = le32_to_cpu(sb->logical_block_size);
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index a083f37374d0..6a4af4a1959c 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -22,6 +22,7 @@
>  #include <trace/events/block.h>
 
>  #define MaxSector (~(sector_t)0)
> +#define MAX_RAID_DISKS ((4096-256)/2)

Looks fine to me, except there's no explanation for the magic numbers
here.  Sure, it's 1916 devices max, but WHY?  Other than that nit,
looks fine. 

