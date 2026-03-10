Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4AA27CCF0
	for <linux-raid@vger.kernel.org>; Tue, 10 Mar 2026 01:15:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773105336; cv=none; b=goSDU2EJQelMjHmi3N4qAbh/H/PhEOvIq/4+jjtUUBaWUAYDZuOP7XGAFFCNFYgisnkh3p/jzn/mizcK5cRfVevuPRKkTbqJXxo4GpKVb9ajtp5Jx22YEHqvE31Ol8sRFeO6DMA7OyfqZ4ZFIXkQO4/8pCWemae/b6XvWW3JIUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773105336; c=relaxed/simple;
	bh=7wrF06tMNqdNnhfEAakD0Muy3T8Fh+S0910Jsdn1iEA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=TcQ/RQoZDHaRIHymWq8zBmx5tUHO5HR29q0a1GcBmBt49acrZE4CvSI7jqriKHQ8TReJf2UlMDeWb5dPxrfGxHj9W2xktxuKAoI28FtpEt0vefKLvHiSfvNGZr3SycGaOK0VxFhJuH+Tw2+frx8/v99vsiGfQxn5n3Fn2NfdRZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Nhb/ZKvy; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=aWPn6RcQ; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Nhb/ZKvy";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="aWPn6RcQ"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773105334;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AeuzWAzKQxgExrZB0lyoCkQxoP+PEP3FNmCEkoiiVXs=;
	b=Nhb/ZKvyJ5C1m3cD5UD43EUCYFPqV2bBwVuxIHxucoiDbXXnfIaHMQgjFlDSThqnyCykV5
	G+hu2rw2UWXssyw2MWAhcAcSSbTkSR1Sm/MwibkX7HEPfTSjNHnOhfT/Up8IvNsmDilLUI
	e+R2pkHT0SZ56wIIr6jIO2jEj2Aiuug=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-577-MIt02yfpOp2wk0YBUzjNZw-1; Mon, 09 Mar 2026 21:15:32 -0400
X-MC-Unique: MIt02yfpOp2wk0YBUzjNZw-1
X-Mimecast-MFC-AGG-ID: MIt02yfpOp2wk0YBUzjNZw_1773105332
Received: by mail-pj1-f72.google.com with SMTP id 98e67ed59e1d1-35842aa350fso57658007a91.0
        for <linux-raid@vger.kernel.org>; Mon, 09 Mar 2026 18:15:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773105332; x=1773710132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AeuzWAzKQxgExrZB0lyoCkQxoP+PEP3FNmCEkoiiVXs=;
        b=aWPn6RcQQxKGv4w23JOVj3ObaPneH05Ei1gJl3MeKpvaZDaCIJWCNl+oRNNQt0l9Hn
         +6ms7OkMgScMQAvxJQEPoLWyqdDbFZCHonbbAGG70ZdCpsJHp/uGL2tttjLqkB3KL3d1
         uTjinidL99/j3886dteQJ8dZ+ceg87zdDvwqbaibBOy+C9olR4ohyzXxIbk78YfjaHi1
         BZtdANn/7vMcOAcrAIDibLmaKYHMq3WeQ3xwYcbhKUhOySp8V5OHjhzx6Zz5C4fGXKDu
         JPhj2/HLx/lBtNof/M6RRh+musR9VBYj91VDistUFzNKtr7M3jmAJr4PFdKX0AKIY1Z2
         weUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773105332; x=1773710132;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to:subject
         :user-agent:mime-version:date:message-id:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AeuzWAzKQxgExrZB0lyoCkQxoP+PEP3FNmCEkoiiVXs=;
        b=vJnfLJmFu7q6J+ANCZFrwz2ihv1YewkFJVBi87DG3ddUamAMhTBr06awPg9B402zYj
         UZkh2wnJ7UnKYvQzyKgzpdTKDRx79FiM3ax5nucub+uzXstii6djmscoj4FktUatRLfa
         gDSF7uj/mOtptYorwj1eSSoyPPAd6WdlnmfYzsb1iRgeaceazZgaTU62Sm5f3cQ93EWs
         nppsbXduTLrh9R/CZwteththZOhakcqKOcYBM0FAlyStdm4mnuJArOEy5izF4TawNsri
         VqErmN2gYlIHYhYcoXrgdwcVuXxX6Wb06OBI+kWm2mG9l3zPS0ptj/aXgUbBTvf6mH+W
         ZVmA==
X-Forwarded-Encrypted: i=1; AJvYcCVvwEK7nkxaUUmDQkDPZug9AxIZeattTm0AkdS1XBOF+hDOxtckARySa66yXoShNtX3IF1avRV5iXib@vger.kernel.org
X-Gm-Message-State: AOJu0YyJwc/6+HEu3O2UIvzC/0kHOFg8Wawi/b/c+Hgz+/D3xQJRSASr
	UyTyKEqz5jcrTk+Ym6nMIOCGBfCMXWSNWU/1y3r+AzM1859Y1v+0bo64Pcq0j26ghUGYNku3GQ8
	CDwdHAr5LKRCaqCoP/fPmdj5laDvvKvVJDlvPweSTswWm3cphhyiXxaBdSDCHW6w=
X-Gm-Gg: ATEYQzy9fWotEokr+p5kikbouvxx5phgHScuWSR8FeNJ2HwhzEapgf/h948QxYDmsXe
	w3uNNoG+XVTYFO4hqGNe8Ld6MFNIVdw/lR2/bMtLlMd5m5Km/c2SDQf1QZzRRRnjbNZG7RJENYt
	HdF6Bp0Tjz3ZuuAqdij87efOn4OGV0N1RApCqOF0N9yrFaMosj78yxYLf0G/BkagdTvu86dzucW
	3wx05mjjXWuWoiLvbnhNNC8yy8Et4+d+8wzAEZPxnWDDVRCg29iVL3RPJsNun2/NYXjELF3RPtn
	MsKCbp71A6pgN+zjAIOF8bQ2uc7ObECz0tZd+rrUpuUryR6p3xrziAMP3EBwk9+T6LM/o1U6kjI
	+SMNiEh5QpIJz7C9Xd94VyCii9V+oLmHzUIhQi9zCZ8LznVOzZ1bPkcrrfAwY0WXNn7ehE1h0GO
	blsBW/MP6ksWxXTgvqXXP+tG0D8hOGO52P
X-Received: by 2002:a17:90b:2507:b0:359:c770:9f46 with SMTP id 98e67ed59e1d1-359c770a2c1mr6398594a91.10.1773105331753;
        Mon, 09 Mar 2026 18:15:31 -0700 (PDT)
X-Received: by 2002:a17:90b:2507:b0:359:c770:9f46 with SMTP id 98e67ed59e1d1-359c770a2c1mr6398580a91.10.1773105331299;
        Mon, 09 Mar 2026 18:15:31 -0700 (PDT)
Received: from [10.72.112.96] ([209.132.188.88])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-359f05ee152sm1173460a91.2.2026.03.09.18.15.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Mar 2026 18:15:30 -0700 (PDT)
Message-ID: <cd987627-5255-4d43-918e-a59e2237d188@redhat.com>
Date: Tue, 10 Mar 2026 09:15:26 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] md: add fallback to correct bitmap_ops on version
 mismatch
To: Su Yue <l@damenly.org>, Yu Kuai <yukuai@fnnas.com>
Cc: song@kernel.org, linan122@huawei.com, colyli@fnnas.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260214061013.2335604-1-yukuai@fnnas.com>
 <20260214061013.2335604-4-yukuai@fnnas.com> <h5rf7nsv.fsf@damenly.org>
 <d8598163-f684-4a88-bde7-bef795a3a584@fnnas.com> <bjhe7vsu.fsf@damenly.org>
From: Xiao Ni <xni@redhat.com>
In-Reply-To: <bjhe7vsu.fsf@damenly.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


在 2026/2/24 09:52, Su Yue 写道:
> On Mon 23 Feb 2026 at 10:22, "Yu Kuai" <yukuai@fnnas.com> wrote:
>
>> Hi,
>>
>> 在 2026/2/17 16:54, Su Yue 写道:
>>> On Sat 14 Feb 2026 at 14:10, Yu Kuai <yukuai@fnnas.com> wrote:
>>>
>>>> If default bitmap version and on-disk version doesn't match, and mdadm
>>>> is not the latest version to set bitmap_type, set bitmap_ops based on
>>>> the disk version.
>>>>
>>> Why not just let old version mdadm fails  since llbitmap is a new
>>> feature.
>>
>> The original use case is that we found llbitmap array fails to 
>> assemble in
>> some corner cases, and with the respect I'm not quite familiar with 
>> mdadm
>> code, so I think this patch is the best solution for now.
>>
> Would you please elaborate which corner cases that llbitmap array 
> fails to assemble
> in? Do they happen in mdadm <= 4.5?
>
>> On the other hand, this should also be helpful if we decide to make 
>> llbitmap
>> the default option in the future.
>>
> But it's so far, right? llbitmap support is still on the way(mdadm 4.6 
> is not released).
>
> I am not opposed to the patch. It just looks strange to me that 
> changing kernel code to
> let old userspace work with *new* feature.
> Maybe the mdadm maintainers have words in another angles?


Yes. Is it better to upgrade mdadm to the version which supports llbitmap?


Regards

Xiao

>
> -- 
> Su
>>
>>>
>>>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>>>> ---
>>>>  drivers/md/md.c | 103 
>>>>  +++++++++++++++++++++++++++++++++++++++++++++++-
>>>>  1 file changed, 102 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/drivers/md/md.c b/drivers/md/md.c
>>>> index 59cd303548de..d2607ed5c2e9 100644
>>>> --- a/drivers/md/md.c
>>>> +++ b/drivers/md/md.c
>>>> @@ -6447,15 +6447,116 @@ static void md_safemode_timeout(struct
>>>> timer_list *t)
>>>>
>>>>  static int start_dirty_degraded;
>>>>
>>>> +/*
>>>> + * Read bitmap superblock and return the bitmap_id based on disk
>>>> version.
>>>> + * This is used as fallback when default bitmap version and on-disk
>>>> version
>>>> + * doesn't match, and mdadm is not the latest version to set
>>>> bitmap_type.
>>>> + */
>>>> +static enum md_submodule_id md_bitmap_get_id_from_sb(struct mddev
>>>> *mddev)
>>>> +{
>>>> +    struct md_rdev *rdev;
>>>> +    struct page *sb_page;
>>>> +    bitmap_super_t *sb;
>>>> +    enum md_submodule_id id = ID_BITMAP_NONE;
>>>> +    sector_t sector;
>>>> +    u32 version;
>>>> +
>>>> +    if (!mddev->bitmap_info.offset)
>>>> +        return ID_BITMAP_NONE;
>>>> +
>>>> +    sb_page = alloc_page(GFP_KERNEL);
>>>> +    if (!sb_page)
>>>> +        return ID_BITMAP_NONE;
>>>> +
>>>>
>>> Personally I don't like the way treating error as ID_BITMAP_NONE.
>>> When wrong things happen everything looks fine, no error code, no
>>> error message.
>>
>> Ok, sounds reasonable.
>>
>>>
>>>> +    sector = mddev->bitmap_info.offset;
>>>> +
>>>> +    rdev_for_each(rdev, mddev) {
>>>> +        u32 iosize;
>>>> +
>>>> +        if (!test_bit(In_sync, &rdev->flags) ||
>>>> +            test_bit(Faulty, &rdev->flags) ||
>>>> +            test_bit(Bitmap_sync, &rdev->flags))
>>>> +            continue;
>>>> +
>>>> +        iosize = roundup(sizeof(bitmap_super_t),
>>>> +                 bdev_logical_block_size(rdev->bdev));
>>>> +        if (sync_page_io(rdev, sector, iosize, sb_page, REQ_OP_READ,
>>>> +                 true))
>>>> +            goto read_ok;
>>>> +    }
>>>>
>>> And here.
>>>
>>>> +    goto out;
>>>> +
>>>> +read_ok:
>>>> +    sb = kmap_local_page(sb_page);
>>>> +    if (sb->magic != cpu_to_le32(BITMAP_MAGIC))
>>>> +        goto out_unmap;
>>>> +
>>>> +    version = le32_to_cpu(sb->version);
>>>> +    switch (version) {
>>>> +    case BITMAP_MAJOR_LO:
>>>> +    case BITMAP_MAJOR_HI:
>>>> +    case BITMAP_MAJOR_CLUSTERED:
>>>>
>>> For BITMAP_MAJOR_CLUSTERED, why not ID_CLUSTER ?
>>
>> Because there is no optional bitmap_ops for md-cluster, it's still
>> the old bitmap, and llbitmap does not support md-cluster for now.
>>
>>>
>>> -- 
>>> Su
>>>> +        id = ID_BITMAP;
>>>> +        break;
>>>> +    case BITMAP_MAJOR_LOCKLESS:
>>>> +        id = ID_LLBITMAP;
>>>> +        break;
>>>> +    default:
>>>> +        pr_warn("md: %s: unknown bitmap version %u\n",
>>>> +            mdname(mddev), version);
>>>> +        break;
>>>> +    }
>>>> +
>>>> +out_unmap:
>>>> +    kunmap_local(sb);
>>>> +out:
>>>> +    __free_page(sb_page);
>>>> +    return id;
>>>> +}
>>>> +
>>>>  static int md_bitmap_create(struct mddev *mddev)
>>>>  {
>>>> +    enum md_submodule_id orig_id = mddev->bitmap_id;
>>>> +    enum md_submodule_id sb_id;
>>>> +    int err;
>>>> +
>>>>      if (mddev->bitmap_id == ID_BITMAP_NONE)
>>>>          return -EINVAL;
>>>>
>>>>      if (!mddev_set_bitmap_ops(mddev))
>>>>          return -ENOENT;
>>>>
>>>> -    return mddev->bitmap_ops->create(mddev);
>>>> +    err = mddev->bitmap_ops->create(mddev);
>>>> +    if (!err)
>>>> +        return 0;
>>>>
>>>> +
>>>> +    /*
>>>> +     * Create failed, if default bitmap version and on-disk version
>>>> +     * doesn't match, and mdadm is not the latest version to set
>>>> +     * bitmap_type, set bitmap_ops based on the disk version.
>>>> +     */
>>>> +    mddev_clear_bitmap_ops(mddev);
>>>> +
>>>> +    sb_id = md_bitmap_get_id_from_sb(mddev);
>>>> +    if (sb_id == ID_BITMAP_NONE || sb_id == orig_id)
>>>> +        return err;
>>>> +
>>>> +    pr_info("md: %s: bitmap version mismatch, switching from %d to
>>>> %d\n",
>>>> +        mdname(mddev), orig_id, sb_id);
>>>> +
>>>> +    mddev->bitmap_id = sb_id;
>>>> +    if (!mddev_set_bitmap_ops(mddev)) {
>>>> +        mddev->bitmap_id = orig_id;
>>>> +        return -ENOENT;
>>>> +    }
>>>> +
>>>> +    err = mddev->bitmap_ops->create(mddev);
>>>> +    if (err) {
>>>> +        mddev_clear_bitmap_ops(mddev);
>>>> +        mddev->bitmap_id = orig_id;
>>>> +    }
>>>> +
>>>> +    return err;
>>>>  }
>>>>
>>>>  static void md_bitmap_destroy(struct mddev *mddev)
>

