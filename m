Received: from mail.stoffel.org (mail.stoffel.org [172.104.24.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A3A51E4BE;
	Wed, 17 Sep 2025 20:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=172.104.24.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758140053; cv=none; b=QCFXAc5PQ06VwkCK9SVI1bzync3npnD3FtDDPjBIfJIjyF7rTw+C9H6b2GUcS1l+AosegngJsTyHVsiUFmsSOMDLZbYiAXXJBF8Ut2AsgMYWiu+1DfU4ZDhIr8TpHm+Nb0NoOEmfaGQx6Dusbo/orlgIgkgQzhcxNCAZK9qzJP4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758140053; c=relaxed/simple;
	bh=IDTGlRUmqB2Go4CX9rbHbRfo7JDRb+FEBlAcojGXWZo=;
	h=MIME-Version:Content-Type:Message-ID:Date:From:To:Cc:Subject:
	 In-Reply-To:References; b=CnZ4nXY6xYGjeSVZvnAJhkAzpVsUDzcm9RNMhb6yNJN3Rhwm4H4dPhUHS8MsYH7Hd+kVRLiLlOA4Q5GKITQwgHK51VbE0PmEL1wpIQp1QuxBjdvN4W1S5fc3MLGelVFbyjsicF+PYls4YOFZ0uLLx35KCOVMzWzPEsTn4FmGT+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org; spf=pass smtp.mailfrom=stoffel.org; dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b=DvLQiasd; arc=none smtp.client-ip=172.104.24.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=stoffel.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=stoffel.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=stoffel.org header.i=@stoffel.org header.b="DvLQiasd"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=stoffel.org;
 i=@stoffel.org; q=dns/txt; s=20250308; t=1758139537; h=mime-version :
 content-type : content-transfer-encoding : message-id : date : from :
 to : cc : subject : in-reply-to : references : from;
 bh=IDTGlRUmqB2Go4CX9rbHbRfo7JDRb+FEBlAcojGXWZo=;
 b=DvLQiasdSDW1YWNtdTSoGeelhvf7bhp88WLfjCXev4aCwZA/KlrOeTxWRiBf/pEQNusCZ
 Z4ccpC3rXa+svMBUAkz4KzROWEfpBD2POvFdJuwgW2bKo0YrYhA/IBX5EGRd4vez5+isYLX
 zu2fNb/3ayo8TXF+GtsL4T6wJNRec3gEhaUSZO5Yzve95hdMz8BkP4WVMUOdpg87KJ/mTH6
 +QclHXtiO9tygCOCbjjOCl9fwuCyO+V5M6+opSrNQIO0OVdJ+ikBKkCy5ARarg4tJXef+8G
 Ej8qkPDEUDhqopRyv3rMWInT21HvhYXVwhydIxNCOS96+yqOe08jtUm8XI1g==
Received: from quad.stoffel.org (syn-097-095-183-072.res.spectrum.com [97.95.183.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.stoffel.org (Postfix) with ESMTPSA id 59D5E1E69F;
	Wed, 17 Sep 2025 16:05:37 -0400 (EDT)
Received: by quad.stoffel.org (Postfix, from userid 1000)
	id 14001A128B; Wed, 17 Sep 2025 16:05:37 -0400 (EDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Message-ID: <26827.5265.32245.268569@quad.stoffel.home>
Date: Wed, 17 Sep 2025 16:05:37 -0400
From: "John Stoffel" <john@stoffel.org>
To: linan666@huaweicloud.com
Cc: song@kernel.org,
    yukuai3@huawei.com,
    linux-raid@vger.kernel.org,
    linux-kernel@vger.kernel.org,
    yangerkun@huawei.com,
    yi.zhang@huawei.com
X-Clacks-Overhead: GNU Terry Pratchett
Subject: Re: [PATCH] md/raid1: skip recovery of already synced areas
In-Reply-To: <20250910082544.271923-1-linan666@huaweicloud.com>
References: <20250910082544.271923-1-linan666@huaweicloud.com>
X-Mailer: VM 8.3.x under 28.2 (x86_64-pc-linux-gnu)

>>>>> "linan666" == linan666  <linan666@huaweicloud.com> writes:

> From: Li Nan <linan122@huawei.com>
> When a new disk is added during running recovery, the kernel may
> restart recovery from the beginning of the device and submit write
> io to ranges that have already been synchronized.

Isn't it beter to be safe than sorry?  If the resync fails for some
reason, how can we be sure the devices really are in sync if you don't
force the re-write?  

> Reproduce:
>   mdadm -CR /dev/md0 -l1 -n3 /dev/sda missing missing
>   mdadm --add /dev/md0 /dev/sdb
>   sleep 10
>   cat /proc/mdstat	# partially synchronized
>   mdadm --add /dev/md0 /dev/sdc
>   cat /proc/mdstat	# start from 0
>   iostat 1 sdb sdc	# sdb has io, too

> If 'rdev->recovery_offset' is ahead of the current recovery sector,
> read from that device instead of issuing a write. It prevents
> unnecessary writes while still preserving the chance to back up data
> if it is the last copy.


Are you saying that sdb here can continute writing from block N, but
that your change will only force sdc to start writing from block 0?
Your description of the problem isn't really clear.  

I think it's because you're using the word device for both the MD
device itself, as well as the underlying device(s) or component(s) of
the MD device.  



> Signed-off-by: Li Nan <linan122@huawei.com>
> ---
>  drivers/md/raid1.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
> index 3e422854cafb..ac5a9b73157a 100644
> --- a/drivers/md/raid1.c
> +++ b/drivers/md/raid1.c
> @@ -2894,7 +2894,8 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>  		    test_bit(Faulty, &rdev->flags)) {
>  			if (i < conf->raid_disks)
>  				still_degraded = true;
> -		} else if (!test_bit(In_sync, &rdev->flags)) {
> +		} else if (!test_bit(In_sync, &rdev->flags) &&
> +			   rdev->recovery_offset <= sector_nr) {
bio-> bi_opf = REQ_OP_WRITE;
bio-> bi_end_io = end_sync_write;
>  			write_targets ++;
> @@ -2903,6 +2904,9 @@ static sector_t raid1_sync_request(struct mddev *mddev, sector_t sector_nr,
>  			sector_t first_bad = MaxSector;
>  			sector_t bad_sectors;
 
> +			if (!test_bit(In_sync, &rdev->flags))
> +				good_sectors = min(rdev->recovery_offset - sector_nr,
> +						   (u64)good_sectors);
>  			if (is_badblock(rdev, sector_nr, good_sectors,
>  					&first_bad, &bad_sectors)) {
>  				if (first_bad > sector_nr)
> -- 
> 2.39.2


