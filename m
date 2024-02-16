Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 114FB2CCBA
	for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 22:43:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708123429; cv=none; b=sryTf1MDzD+FEL7nV2d6efMnXOkFL+gskgp9hoUADcsKTVUA0txxuBEVrSe8nDLBG+zKyCcqv7zQDoBCzMWJgz/PCJ5qCaL+Wq32HI0M1nInL5Zr2EM6zuSkLt0zsvNFZhiArQ/i4bIGsfuyJo5cSoTM3zNqX4GzCAFCQasydFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708123429; c=relaxed/simple;
	bh=oUZiKefv9Qmx3t7BCL3NHtpyK3+Zxh1Yy9eaDs6++ik=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tGD8n7zMBZWXOQHlNA5kVU8ihC6TlqLg/ztRIA273J7S6gZT7K0mjz3wcY3xLXy5ffgBkwqKwP/teYv8xOxZn/y+Cs3csz0bJTXelh3DvB4KLc99BHkBxWsIvbH8LzsV5zuBXYmJ45agEAG8QTM3ex9DcEEQrm6M4hY7jjWDS2Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=qMkNpdKw; arc=none smtp.client-ip=209.85.166.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="qMkNpdKw"
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-35d374bebe3so1783035ab.1
        for <linux-raid@vger.kernel.org>; Fri, 16 Feb 2024 14:43:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1708123426; x=1708728226; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=jbLNO9CBjXaULrlNAyQEwwX7KLlQnYYw7p8b8Qb2UuM=;
        b=qMkNpdKwo5u5kA2nkhBEzAcsj1E+E2pJYxDrFftBp5QfGZU9uzt5B3a1oobn6FMG8m
         DIKLBCAHnvq+QcKLlv6OSlCeqpC8OqrPX622PzyOLuZngxtriSNu+QQ37eOTGR74yGO1
         0USYrXFLIGf+YD0rY2UPiUSHos7wJ9Rr4UfMxxiW2eLhc91YWAfiMOQde+fEc9tmGQtu
         sXVR2qy1NgW9c9JgX7P/++wYJy4eLqaCcxiLY/3y8GsW4fUFzVnxKh76pc+C3JNHsJhi
         pDRkpdgoqDlmOBldxol8quNSNxn0uEzNand/hlYe8uueXc/ihvfsWD8eW//LBAZxJP5R
         WUEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708123426; x=1708728226;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jbLNO9CBjXaULrlNAyQEwwX7KLlQnYYw7p8b8Qb2UuM=;
        b=H7mGMz+xlGCxrqdT+okHhLVUNAtkr3Lh4RXRnQRG9l7W3nUt/elzurVFIT1qE/Am+7
         pCuSaRI9GCnwarz5Z1upOUGPxGcgsIm673iBNRhUD8fpivrQfDLLPWPCl3aM5C8KtvrU
         I7MfiV1NvVPu+bu4B+9PjkaywxQXI9/hJkSnBIeLY0Zn5FvUDgkj6FHegm0RYQgGcO1D
         PFinXQsLBLj+Oi4xG5+C0Ih/Xfzqb9qWxjXsSD3zbBQM6Ane8t3Yl9wk3eUlLl/XBfK8
         S80rKLSMLhITNRQDUnG1sDTjm06A9trsoK6z1kdJl9FTx+UdtEFOLlb78yYk5CEAALLl
         T5mg==
X-Forwarded-Encrypted: i=1; AJvYcCXnLYzdIXPtltCyFqKes3cX8uyyBtWL8SAEraFULhcvk95wSACdbXjom73Htuh867W9ZsFzy+vgmfg42CL7+sKa0INa250FQsN2DA==
X-Gm-Message-State: AOJu0YxtN8fnVyMWXwl/buqp3WR/Gu47cGbjQ+AvaRvQfyKhAUbpGm5t
	1F07ljWsnj26SCfYIV6WGWLez5gIZrjz3uzh9kJ0DW74NKneQ2Sg9lwbLMuwgMQ=
X-Google-Smtp-Source: AGHT+IEr8Vs109zOL/1EN7dKlgnJKX2hTYW+h1T8GE6hzjBs2twGeAkrSnTPob171cKfWKsldJBPuA==
X-Received: by 2002:a5e:970a:0:b0:7c4:9ed9:8e7c with SMTP id w10-20020a5e970a000000b007c49ed98e7cmr3555583ioj.0.1708123426071;
        Fri, 16 Feb 2024 14:43:46 -0800 (PST)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id c19-20020a6b4e13000000b007c47e7e549bsm181736iob.27.2024.02.16.14.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Feb 2024 14:43:45 -0800 (PST)
Message-ID: <e993344c-e9da-4263-8a03-075ddcaebdb8@kernel.dk>
Date: Fri, 16 Feb 2024 15:43:44 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.8 20240216
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>,
 "dm-devel@lists.linux.dev" <dm-devel@lists.linux.dev>
Cc: Mikulas Patocka <mpatocka@redhat.com>, Yu Kuai <yukuai1@huaweicloud.com>,
 Li Nan <linan122@huawei.com>, Yu Kuai <yukuai3@huawei.com>,
 Xiao Ni <xni@redhat.com>, Benjamin Marzinski <bmarzins@redhat.com>
References: <2D753D1A-F9A6-4196-88A3-91C7596C17DD@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <2D753D1A-F9A6-4196-88A3-91C7596C17DD@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 2/16/24 1:13 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fixes for md-6.8 on top of your 
> block-6.8 branch. The major changes in this set are:
> 
> 1. Fix issues reported for dm-raid [1], by Yu Kuai. Please note that 
>    this PR only contains the first half of the set [2]. We still need 
>    more fixes in dm and md code (the rest of the set, or alternative
>    fixes).
> 2. Fix active_io leak, by Yu Kuai. The fix was posted in the same set 
>    [2]. But it actually fixes a separate issue [3].  
> 
> I still hope to ship another fix for 6.8, which is discussed in [4], and 
> fixes bugzilla report [5]. For this fix, I would like to get review/ack
> from Yu Kuai and Li Nan. We will get this one queued ASAP. 

Pulled, thanks!

-- 
Jens Axboe

