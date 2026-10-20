Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792517924;
	b=iZbbbSPl8UCJ8rSIEeNSLP6yxGHjvYFpZt+K3XhNeRm3KWlXtQGbAoKd2f0rLr+UaX+V
	 yIsiVLhPA1TkxE0X7JEEOKVD5c7RqM8ESs6M4zWqda+TJVk+UN2ZzXyClSRppQbgYgbLX
	 AjqdwV++Byy3chPtkbXLYHCEQceg9Lejvs/dCvAfYRvnwlGYc8IHli9/UyA9XcjE40sSX
	 JBCuX2BHbHwJq+HvMh2BRmY/t4AJn29X66uQqbTatHSH5E6zR5sghx8qVvKa23WocNaUT
	 ST274gdo0Pu8cnvObRwH2jl7OoXVGcbu8nf5lkSWanrORPM9/GY+RPr6Egbk45tdTAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792517924;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Date:From:
	 To:Cc:Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=KKzX3tJQs6Sbp53WPYwE15EW54CUA+4pFCf/Bl6hVXU=;
	b=0VFr6hzADZRQ/dlVU6XNwSjVFIJdp8amxnqGrNDiqty0IIeep7cYMip966xe0BjrnWNi
	 3t/K6OByfD3hxPpgmkB1phjszLEc/75NNw7BiAZT6GSiocm0FNl7wHS3JNwhISDsdWZc+
	 cz/BarikenalCo7G5vKWHADF9EQl9klcKgOESbS+k/qiAPkWbof58oZpbA2p04eTpVdIS
	 hXXgmjE4PAckKzUxOvB6aOUkmF5DDydybdIcnrVTXOHgsqS4uJo/J0ZIfTx3Q1X+oi6O7
	 HjIkIVEu/LJry5lW8wh0EA2TeGUUl1lqDggVH2LlMDFqODbcLGhWsu7uvmkr6DfNJ8w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EYBpnqhW;
	dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AmP3D1BQ;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D28B8606A31D
	for <linux-raid@vger.kernel.org>; Tue, 20 Oct 2026 17:38:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D28B8606A31D
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=EYBpnqhW;
	dkim=pass (2048-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=google header.b=AmP3D1BQ
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1792517922;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=KKzX3tJQs6Sbp53WPYwE15EW54CUA+4pFCf/Bl6hVXU=;
	b=EYBpnqhWABn1G7SULNYqdDx0cI5Q8duvlvPhiRU++uhzp0CKKzbcrW/5So57EYxonATsWT
	jz+1Yqt/3EA+G3O6sBY/VJ1ZSyQzV7WqoegMxZYJpMFbdgKt36gEJn3RzHl+c14gHJr5AG
	e8ymBNFElmHYcgH7cTafqrRL3JkFWJE=
Received: from mail-qt1-f199.google.com (mail-qt1-f199.google.com
 [209.85.160.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-365-u3i30dRlP12KDDo5BBkiRw-1; Tue, 20 Oct 2026 17:38:41 +0000
X-MC-Unique: u3i30dRlP12KDDo5BBkiRw-1
X-Mimecast-MFC-AGG-ID: u3i30dRlP12KDDo5BBkiRw_1792517921
Received: by mail-qt1-f199.google.com with SMTP id d75a77b69052e-5365d95f4a1so42898321cf.1
        for <linux-raid@vger.kernel.org>; Tue, 20 Oct 2026 10:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1792517921; x=1793122721; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=KKzX3tJQs6Sbp53WPYwE15EW54CUA+4pFCf/Bl6hVXU=;
        b=AmP3D1BQRwXCStAVpk9MAwEDLJ/4O1y4eCkLfKUzLAWXcmQJPFhtqFhVY2xDjpUvsH
         4UISmNkeiic2bhVFxE8juLfmiZBpPi2U8o5c5lgoHYJUyg+skeyyZUg1vgubE/wKVn3B
         i/WW/4E0e+SrV4GFgdegNYrucnbvBcDiPX9SZLJRi6e0eNt02N2rQhHYSucyTjtqlHFv
         GiEzMH10iNyoS+5NwoZQDBysAdZpnBsmZN4TMEGKrVmLjf3tB3LXXDIpwy5E6xvgv++B
         aUPiTBKcqbsU6bdDS5UQRdwJvkO0AL/bcvffqjFJUs7VlmtSJckRQDMd+xJhstWypini
         +wEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792517921; x=1793122721;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KKzX3tJQs6Sbp53WPYwE15EW54CUA+4pFCf/Bl6hVXU=;
        b=kVUU3Ut6ahqTCpN7rS5fAADgD0DqwgxDTNP/g8aJCXaMoucjf3VaCRdAVvNFyrMuM2
         /4MboOkF5gosswcrgGUYfWmPO+OsjZgeBVyauL54VqKsdzad6X3mM8A5NGX6nYaOxVLn
         lwT5CDrZUjOxnBR5Bx/sgf1bkxz4LdWUvQumFoV7eWPyYCsk9bezMwRfUgHQI3qOott2
         Ab789gr/AjLWRDGkm08EZ7g1aTvl3YmdklxTkt7G169gCbvZLVBNf89/OP/zrrn0VNGt
         4jbI3ysDbnXJA3ZtWJw0gMQp8I5UcNzHiAh0IOV+DjPg3H7dW/tdoOB3akQTYOsItcYq
         gyyg==
X-Gm-Message-State: AFq9FYIaOaSFfjwkUs6Sx/ouAnv2ATonY10docVahEVEOKSgauwqR75r
	/CZPhouKimeB5sQcJmci+tMO10/eKKEUFzRIV6tbzjMU1ch6D/x18hOSLhlVZwF/Rdubb7CwFD2
	b5PxzCM85iG/UwE+F0bY8o1s/xXyUiY+RVcv1eGVjUHIxGfPNKLOYGearmn6rKwQpc7R7vBI=
X-Gm-Gg: AYBFou0foskYx1h7HK4lBVpNucGbCBd5tx11/sMc2ClYgBNH/YoDnRr70OHtJtejA9k
	ImZqJYcsOCr663p6rpCe80lPVHbHmNd59D96STO+pFWbFdL1lNRG4IqX4P38fXdwNrVUjDs+zbB
	G0uYCNmpQxpXGupFIXiAxuiUy/AO5SOOL63znkdeBmmgnvW/RL0XaysmvthnG7uyUMUoqtSzpC+
	Cp6yZEzE61/H8VlxtVokyE04xqbydxvrIWl9fsuv/NuIB+2gLcKsXw6UBmWBf9z1feZ/LdakTBc
	qJChHWafllnzYt3sTQ+RNmTsXkmugN57bbme+MbthLX1MRtKW5j/CM1s4YpNQ8eRJ+PDGtJRx3g
	GGhOQOHt1b0QUuO80yvKyeRh7y/tf/Ju0aQwVPRGu6KGicRkcSK59XDO5mQ==
X-Received: by 2002:a05:622a:138f:b0:536:8f6:6e97 with SMTP id d75a77b69052e-536460fe5bfmr169494141cf.73.1792517920940;
        Tue, 20 Oct 2026 10:38:40 -0700 (PDT)
X-Received: by 2002:a05:622a:138f:b0:536:8f6:6e97 with SMTP id d75a77b69052e-536460fe5bfmr169493721cf.73.1792517920407;
        Tue, 20 Oct 2026 10:38:40 -0700 (PDT)
Received: from vdo-obuilder-bjohnston.permabit.com (nat-pool-rdu-t.redhat.com. [66.187.233.202])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53698972f77sm1355101cf.1.2026.10.20.10.38.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 10:38:39 -0700 (PDT)
Date: Tue, 20 Oct 2026 13:38:38 -0400
From: Bruce Johnston <bjohnsto@redhat.com>
To: Zizhi Wo <wozizhi@huaweicloud.com>
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH V2 0/6] md: fix takeover failure handling and raid0 size
 calculation
Message-ID: <atenHrzZVtzu5YOa@vdo-obuilder-bjohnston.permabit.com>
References: <20261019010827.2922617-1-wozizhi@huaweicloud.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261019010827.2922617-1-wozizhi@huaweicloud.com>

I was wondering how you would feel about splitting up this series
into two separate patch sets. 1 for the takeover failure rework and 
the other for the code cleanup. 

On Mon, Oct 19, 2026 at 09:08:21AM +0800, Zizhi Wo wrote:
> From: Zizhi Wo <wozizhi@huawei.com>
> 
> Patches 1-3 fix the inconsistent mddev state left behind when a takeover
> fails.
> 
> Patch 4 rejects a raid0 takeover whose zones cannot cover the capacity the
> gendisk advertises, fixing a syzbot BUG() in find_zone().
> 
> Patch 5 factors out the member-size rounding. Patch 6 uses it in
> raid0_size(), where the power-of-2 mask is not a round down for a
> non-power-of-2 chunk.
> 
> Changes since v1:
>  - Added 3 patches fixing the inconsistent mddev state left behind by a
>    failed takeover in raid0, raid10 and raid5.
>  - Patch 4: expanded the commit message with a paragraph addressing the
>    issue previously reported by Sashiko.
> 
> v1:
> https://lore.kernel.org/all/20261017005802.2212102-1-wozizhi@huaweicloud.com/
> 
> Zizhi Wo (6):
>   md/raid0: don't leave mddev in an inconsistent state when takeover
>     fails
>   md/raid10: don't leave mddev in an inconsistent state when takeover
>     fails
>   md/raid5: don't leave mddev in an inconsistent state when takeover
>     fails
>   md/raid0: reject a takeover whose zones cannot cover the array
>   md/raid0: factor out raid0_member_sectors()
>   md/raid0: round member size in raid0_size() with sector_div()
> 
>  drivers/md/raid0.c  | 84 +++++++++++++++++++++++++++++++++++----------
>  drivers/md/raid10.c | 11 ++++--
>  drivers/md/raid5.c  | 13 ++++---
>  3 files changed, 84 insertions(+), 24 deletions(-)
> 
> -- 
> 2.52.0
> 
> 

