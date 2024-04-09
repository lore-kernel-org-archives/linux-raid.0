Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51EBF54BEF
	for <linux-raid@vger.kernel.org>; Tue,  9 Apr 2024 03:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712634602; cv=none; b=smthUncfY19elP9ESwoUrz4SyP5aFBfveFCyM4584Orn9OUPxAcJQjFDFsSxa3zJ8YsVTFtQqG4ZA3PW/hQd3WTfWpiE7NPb3VSTdLYZoT0xaE9N2MGdvzkXgMp7z058sT+nnD8KKile1EqokV4H9CWxzCiyeA8OfnsFyhmj+Pw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712634602; c=relaxed/simple;
	bh=kQvZpHyWC2Z90KODy8X4qTq9A+0xhG/eQRFgVyKmDGA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iC1Cs0YkcvvZJowfQPgKILHzkqgVqP26XcpY2yKUq87Tyj9j4XSWEVUFehb1fVTueuA/iWwbPeQv9P+P193yWfcABXhPjqRr6G5m4TIFcsBgeT6dxj2OVgVdYlMSijZyzUb/51O8XzOEl91QqZE9AklLNdKYtk6xMB8iIbr/+ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=MoE5U60G; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="MoE5U60G"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-1e21db621caso10342465ad.0
        for <linux-raid@vger.kernel.org>; Mon, 08 Apr 2024 20:50:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712634599; x=1713239399; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QT+XbzycfAY1ysH1qRO/ENYbcgk/qt097Dyuw8/47TM=;
        b=MoE5U60G9kCTqEe/RBYzxNSNZBV8twiQe3TAk3IHvmCoGmOoB6eVUqmAU/maVrLUpP
         /Pn+rpFLE94RS7EIhwHaNIgHNM8XjABqFV4dz/dFNqDuTAqs6146nURKH4YDACF9NJee
         as3HdAlb9Jjy99yFmj0FkYlOprcxTmS7fgY4gg1ZCJwD3Dlydew49uV8TiA2aj8skryD
         afwse7uEE3wHZL1Ukt5elOV7uHryIczZE9u1DQUTDCVMLV/7PVDmvUh15jE2MAQHwrlF
         tlRexonnJA9E+50p4N+zujxxY2wwcKlPlX4XH1squPPkC62QfiAgATrNWOlFDRmDZBQu
         YJSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712634599; x=1713239399;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QT+XbzycfAY1ysH1qRO/ENYbcgk/qt097Dyuw8/47TM=;
        b=HjPHYp9BIFuNtSQJBFdqiKDLPEMQZ9iL42zVPgZwSz6hLiTnYZuIH5nVW2PFlbpEBH
         JSLiSINlDj0xJaIkP4ENdC6UyFWQ+q840qa9qsbSTPJ/avwhejprDspQXn/obb14w8WF
         dJBAqyq6rn1RqpOm8Q1uDW7J6TCmE1CmYXP1pZKUnqW75zrj1CUb4CzRnWExhujbVCwi
         40zrcwIG0GeGgbGDp4CuS5CQEKW1IkxikKjR/Mg+4OxfRsULwIXQ1U57Okrz5FrpQsAn
         sjYbp6M+tnwQwh/vM502jbq2FFdFWtsxUEYY57a3489OFV4pvTAmJwh0PrGiTrHtqXM2
         AAKg==
X-Forwarded-Encrypted: i=1; AJvYcCVm60TYcZIol7SjyAHZ8Z82OLGOYBmfuFmcwFrQTJEWT5npcfxExQPpZCvRZqwl1nwUreJ+1ksmwkesp+LdlFlWqglgGhMy+nIWYA==
X-Gm-Message-State: AOJu0Yx/FwpKHVqwSsnJLyVFDA307WuFSstKlkN/05n+DWml0/uyDvJL
	HPMmQpfeX/XH4u4aztksA0Wi3rlpBzSE/gDTmW1bMOt0fdkR1dt9sMZb6mkGtYk=
X-Google-Smtp-Source: AGHT+IHCBKO+OmjQ2cr6bq1Up3tYzN+s8efW5MVoiSgS9jPyNPlpHYSO/USX1M7as6abD1zhHfETnA==
X-Received: by 2002:a17:902:cecf:b0:1dd:85eb:b11 with SMTP id d15-20020a170902cecf00b001dd85eb0b11mr13082144plg.1.1712634599643;
        Mon, 08 Apr 2024 20:49:59 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.194])
        by smtp.gmail.com with ESMTPSA id k12-20020a170902c40c00b001d8edfec673sm7809733plk.214.2024.04.08.20.49.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Apr 2024 20:49:58 -0700 (PDT)
Message-ID: <c71219b4-b22e-41d8-9270-146d327c9c6a@kernel.dk>
Date: Mon, 8 Apr 2024 21:49:57 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-6.9 20240408
Content-Language: en-US
To: Song Liu <songliubraving@meta.com>,
 linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai1@huaweicloud.com>, Yu Kuai <yukuai3@huawei.com>,
 Coly Li <colyli@suse.de>
References: <60F0AE23-EB1E-4EAA-A013-DBA0EBE77E15@fb.com>
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <60F0AE23-EB1E-4EAA-A013-DBA0EBE77E15@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 4/8/24 9:43 PM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following fix on top of your block-6.9
> branch. This change, by Yu Kuai, fixes a UAF in a corner case. 

Pulled, thanks.

-- 
Jens Axboe


