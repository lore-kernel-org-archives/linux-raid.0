Received: from mx3.molgen.mpg.de (mx3.molgen.mpg.de [141.14.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE5A71CD2C;
	Mon, 20 Jul 2026 04:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=141.14.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784521977; cv=none; b=B20jN6JAY7tuw5kFHN8hdm1A3I1Mc3l/frg0CUavrD0DOWzvP6Jcvha+wTVCDQ+IWzFuz76YtuV2mMSu9TzYq+71AFytr2CaDPbZoJX+tIeqN7Y03X2ksApglBSXWazj1nIDva8PeUWLEw8DzYUeW+sCBL3kdlu7RDKpXPegGvQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784521977; c=relaxed/simple;
	bh=LXaj+nu0eZIl+i2OfDpS8hj5G/abum1C1jQJrEulTXo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=T19Yj1FL73WqQ5y8p7UPOPD/c/cfKQ9meRwMPfb0wW7erAsjSmxHDhkU5CsCf1UCWnP0csLLEm3T7dZev9y6kEc0i0rsnWnurM7z7EHqtkiP5DN1BztrogEEEdfdzTzqGRKT6ml3UpuEL1TTbVeZz3dKp+jqZdtVM/kjpGfytiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de; spf=pass smtp.mailfrom=molgen.mpg.de; arc=none smtp.client-ip=141.14.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=molgen.mpg.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=molgen.mpg.de
Received: from [192.168.2.227] (p57bd989f.dip0.t-ipconnect.de [87.189.152.159])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: pmenzel)
	by mx.molgen.mpg.de (Postfix) with ESMTPSA id 1DEE44C2C37F01;
	Mon, 20 Jul 2026 06:32:12 +0200 (CEST)
Message-ID: <76692ee2-e45a-4728-94cd-f65eabe397c1@molgen.mpg.de>
Date: Mon, 20 Jul 2026 06:32:08 +0200
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] md/raid10: restore still_degraded detection in
 recovery
To: Mykola Marzhan <mykola@meshstor.io>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>,
 Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>,
 Hannes Reinecke <hare@suse.de>, linux-raid@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260719144227.940444-1-mykola@meshstor.io>
 <20260719144227.940444-2-mykola@meshstor.io>
Content-Language: en-US
From: Paul Menzel <pmenzel@molgen.mpg.de>
In-Reply-To: <20260719144227.940444-2-mykola@meshstor.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear Mykola,


Thank you for your patch.

Am 19.07.26 um 16:42 schrieb Mykola Marzhan:
> raid10_sync_request()'s recovery arm passes still_degraded -- "will
> the array still be degraded after this recovery completes?" -- to
> md_bitmap_start_sync(), whose !degraded branch consumes the chunk's
> NEEDED marker, the write-intent record.  That is only safe when the
> recovery restores full redundancy; otherwise the record still
> describes writes an absent member missed.
> 
> Commit fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync()
> into bitmap_operations") turned the detection loop's only assignment
> from "still_degraded = 1" into "still_degraded = false" in its
> int-to-bool styling pass, so the flag has been constant false ever
> since.  raid1 and raid5 were converted to "= true"; only raid10 was
> inverted.
> 
> The result is silent data loss on a classic-bitmap raid10 that stays
> degraded across a recovery.  With mirror pairs {A,B} and {C,D}: lose
> D, keep writing, lose B, add a spare.  The rebuild into B's slot
> strips NEEDED from every chunk -- including chunks whose only
> unsatisfied intent belonged to D -- so a later --re-add of D sees an
> empty intent record, completes instantly, and serves stale data.
> 
> Restore the pre-conversion assignment.  Only the classic-bitmap
> recovery arm is affected: llbitmap ignores the degraded parameter,
> and the resync arm passes mddev->degraded directly.
> 
> Fixes: fe6a19d40ceb ("md/md-bitmap: merge md_bitmap_start_sync() into bitmap_operations")
> Cc: stable@vger.kernel.org # v6.12+
> Assisted-by: Claude-Code:claude-opus-4-8
> Signed-off-by: Mykola Marzhan <mykola@meshstor.io>
> ---
>   drivers/md/raid10.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
> index 0a3cfdd3f5df..54cddb3a98cd 100644
> --- a/drivers/md/raid10.c
> +++ b/drivers/md/raid10.c
> @@ -3365,7 +3365,7 @@ static sector_t raid10_sync_request(struct mddev *mddev, sector_t sector_nr,
>   				struct md_rdev *rdev = conf->mirrors[j].rdev;
>   
>   				if (rdev == NULL || test_bit(Faulty, &rdev->flags)) {
> -					still_degraded = false;
> +					still_degraded = true;
>   					break;
>   				}
>   			}

Reviewed-by: Paul Menzel <pmenzel@molgen.mpg.de>


Kind regards,

Paul
