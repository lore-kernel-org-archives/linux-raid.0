Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B558F54
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 19:48:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725565687; cv=none; b=llPIpMxxLC+Hv6gCm5tZFNQym+L3REwVRi1f/fdLqLf88X6+3eDCe7EOozg+2cBIMsUEbBpfyWPQ4f54MuR4G3W38t1ij8zpkpNU5Z88kvhB0G71FpdHU+V2Cj4x6P4OPcrv7+nQ/WyYsRYhSlhmr0SQ7dXuefGnxTuAACURcN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725565687; c=relaxed/simple;
	bh=c4aUB2v5wVXYvDi87rgycEaKLApaL1/CXy2nybx0fmo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RgeHYWKOyaLLypOHtVRymKHDR6Enrhv1d6p+3NjAw9MgEI4C0nJoC6Z0stLGWrfnIWU2LLKeD9rxnrrtwSQe0ce9VhcNzbLmWP4gHDWjDPH6KC21weIlXeZKVbgJmJzVATHx150WEkGfmuGq6duYsTNTKJEFDmwz/oL1bkpj2No=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=SsSsAGnh; arc=none smtp.client-ip=209.85.166.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="SsSsAGnh"
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-82a1abff760so49615939f.0
        for <linux-raid@vger.kernel.org>; Thu, 05 Sep 2024 12:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1725565683; x=1726170483; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=97KLY8+UPzbMAsCweMLyjRoWOPZLIkAzFwOlxuKXLNM=;
        b=SsSsAGnhLIcynhWZV0OYODdsRAeMhmZ2lkksSC7vZ0TDCesif206URqNJK53LulXEk
         8h4vE5lhGLa9ywPh6fEOntXubCiSNHxs0nBR9cYhPW2J6ewST2FlvJtttfeFlp81OKBE
         DH+rnL/FB0ocX5Bk4qv07/8QlMw5RnPCiLrx4mPsmch1fFa3+ef/KGn6uT1mq8unvjfw
         vQm/gjOFpKEOei1kJt3UccLZHEbdi+/161xvNCCeKFWxY2XpBH5vEXitA87G2m2xtlqi
         Uh2y1O4f/Ia30/AiGDI6YJDVKaNHEOHvgZp2NfBXQ16CMijEZN0yEFxHEhTMvGoR9JSh
         jDAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725565683; x=1726170483;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=97KLY8+UPzbMAsCweMLyjRoWOPZLIkAzFwOlxuKXLNM=;
        b=DKYMHbGNuNWe66plSC7AKEpaanxhpht5sT43zRFYUtK2Tl/kqeVeVFJoM3nzz1p1F2
         oskFJjpgkxVsDK8NDePJEHgOYASLLkBJtgX3Elo1cBPI2sKKjZ4XwEX2aCTlCB7ELpoO
         tMaj8HfJtDbCieHDZO5354xP63rrnsx51+CzibZz+pJ2oE2iGLVMZf0FwUEwZawyZPOU
         1kb9x+a8UCx3SPAuHUxK8HmFemv/RBjMnsMdDv61epG9ZAGpAu28L5YGCG7vqe3QVSYf
         Chc3BdksT/+gcvplbAift/KNViEK0FD2h7+aa7FGM6KDyL2aGulK7EDqvLD1CDF5Ph++
         zfHw==
X-Forwarded-Encrypted: i=1; AJvYcCXRsym3PyCXjKTgsXrEIpc2y08+s0v85zK+yPahqqcSP3S1htj2BGAcNPULIUYfOaSdCfvUAlM+ws7Y@vger.kernel.org
X-Gm-Message-State: AOJu0YyL0/ohXHeHxx95+kxes06eZa3F+V8StPRhKjJvdXcgyYtCaAcw
	7T3bj148XfscZ6ioxBOoc8TfCLKLlyGat1f46TC55QCrA73AmnaQLB/+iD2KkIL/h4wiZ60lcuI
	W
X-Google-Smtp-Source: AGHT+IH4J/X6m4Y+A+Vh8j7YmRFRhszu5JjWujI3QqFnDscFY1R19ZLBnMfL5ydMNHLDe183jspXMQ==
X-Received: by 2002:a05:6602:26cd:b0:804:f2be:ee33 with SMTP id ca18e2360f4ac-82a10e12cf8mr3443059739f.2.1725565683306;
        Thu, 05 Sep 2024 12:48:03 -0700 (PDT)
Received: from [192.168.1.116] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-82a1a498a75sm427183439f.42.2024.09.05.12.48.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Sep 2024 12:48:02 -0700 (PDT)
Message-ID: <9feb024a-2de2-4688-9997-beee2cfb75c5@kernel.dk>
Date: Thu, 5 Sep 2024 13:48:01 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.12 20240905
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Mateusz Kusiak <mateusz.kusiak@intel.com>,
 Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Song Liu <song@kernel.org>
References: <3C49640C-030D-4AF6-9F11-9C44E38B1FE0@fb.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <3C49640C-030D-4AF6-9F11-9C44E38B1FE0@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/5/24 1:38 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following change for md-6.12 on top of your 
> for-6.12/block branch. 
> 
> This patch, from Mateusz Kusiak, improves the information reported in 
> /proc/mdstat. 

Pulled, thanks.

-- 
Jens Axboe


