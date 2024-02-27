Received: from mail-lj1-f177.google.com (mail-lj1-f177.google.com [209.85.208.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B11754BFC
	for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 12:29:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709036991; cv=none; b=RIcsRAo3E1w9h00JuRhgFX+cKVQV1tgWSUJaMv2Qg/kxLCSc5QqxhRvf17e6TNdKkQqUkjp+AbFRC0S3hpEAaW+NYioHnnmmvir1q/Dq/WcnBBdO3/hDQM+Fev0WJSyrIXuyIJ24suX2w1XvnPcIeSIIJ8W26GcDrPBuYdzbIBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709036991; c=relaxed/simple;
	bh=nyJ87LYIGycO4ZJxtxggP8jGizvb9vAX1cPQedsFSyk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jdu3XgWBpmV8l9HRN3j5PrrGy38/hfIQ9GTrg5WrOsUJku2Gr8mwbSU/b7LGgYWW48FVHaHNJ4qXqBdAfWwWjMJ5eLLomP1D54KazDcwM5/gLjkkkAj52wwOvkPoOsIeSAUm/m/ChM5wIDlt9RifbNB+RtUKMgu4asACOtqRcP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=K23BX8To; arc=none smtp.client-ip=209.85.208.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="K23BX8To"
Received: by mail-lj1-f177.google.com with SMTP id 38308e7fff4ca-2d094bc2244so49665181fa.1
        for <linux-raid@vger.kernel.org>; Tue, 27 Feb 2024 04:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1709036987; x=1709641787; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xIWTxhADEvKENhuUOdACYaNm4larwPKeM16kosVfYgw=;
        b=K23BX8ToQPCCVwRpV4TsqySd+ZrpgkhHePnFWCzbviIckhPMpW+LnHxBBUl4Whhhp0
         2vR4t5lEkCpVRN839XvrAPBUJFue0BblzN14i58JkdR/xRvQV10kwnLEXVeXNj3GVVst
         W/W3gzaRm/1PDiRm1lAxJoEIH1ESQtWDJiQaOhcnMhzkZzgMxXdarXqzImsOduDtBUTq
         7exPi3ZJIWf2dHRGyQxcwF0P7V86bkGJtkhrv/BeqVpEXYIwthaUZrNAOwpvUGusIV+X
         ExghAmXcnw2zYp+0u4eLbJOH631OqUftdpCDBVYf1tXBO1rOOt3HcxWfy+3gEwdBT2uk
         8SRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709036987; x=1709641787;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xIWTxhADEvKENhuUOdACYaNm4larwPKeM16kosVfYgw=;
        b=Br/CRR/wzCgCtkCtou3aAnHtIcEkeDyJ9PfbMNfgLasZj6OJCSs2QNZyVaGr/XMOo7
         YOY7dJXbVVmO2M7rVme5xg5FkTGxEyuCNYcbsV37ZPQ5KjlOePm2drxgyLo9SNPXzsNU
         itZxbKwn5iTUtFZMXAXuECXv4DG4BLUfErC+5PQiHwXIThen8EZeQc8jniOpUwZG1Fgo
         Kl5B53h1fxYcDkDatHX1hvj5zLI1mvU2WOqMWG2wKtlhJavqx/EsmjeZY7JAhfsYignK
         uu7toIOGgELf6KRu1nqbdSAe8D01jN0RKrYoukow58xuampJXEQAX6+qdQyV1fv75rme
         DiVQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3/95L4zhczDM9fkunbACda4Ko7EQM62Od3beYWrOceO0+NRPmIuVV4y6En1CgRFzODeyorWxwKphR1JE+u7VhurYJFwQ5ernWBQ==
X-Gm-Message-State: AOJu0Yxx7g1p4kSvrRjt+hMRVxjDM1lkZchIGcuqoxX+BUy2/KZWeQc+
	DpP3FrpQR281+HIIhgMHcB8r9J7WlbwbSoWbHrOXrc3SnzUuHm5jf9lTvdiaAh8=
X-Google-Smtp-Source: AGHT+IHldrbvvMSVXazQOGqPQb2opTW8KMYR8ZvP2fgrnP3zj0MOAqX0ydgZPHXDJ0r4m1xbq84fwA==
X-Received: by 2002:a05:651c:2c4:b0:2d2:7580:e220 with SMTP id f4-20020a05651c02c400b002d27580e220mr5354257ljo.15.1709036986721;
        Tue, 27 Feb 2024 04:29:46 -0800 (PST)
Received: from [10.202.32.28] ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id cv17-20020a17090afd1100b00299947ed2efsm6376503pjb.2.2024.02.27.04.29.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 27 Feb 2024 04:29:46 -0800 (PST)
Message-ID: <ef638bac-c031-414d-bcb4-598a72e750d5@suse.com>
Date: Tue, 27 Feb 2024 20:29:43 +0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] md/md-bitmap: fix incorrect usage for sb_index
Content-Language: en-US
To: Christoph Hellwig <hch@lst.de>
Cc: song@kernel.org, guoqing.jiang@linux.dev, linux-raid@vger.kernel.org,
 colyli@suse.de, hare@suse.de
References: <20240223121128.28985-1-heming.zhao@suse.com>
 <20240223153713.GA1366@lst.de>
 <a19824b2-f1c5-460f-9688-35d8c4c1605e@suse.com>
 <20240226110414.GA28930@lst.de>
From: Heming Zhao <heming.zhao@suse.com>
In-Reply-To: <20240226110414.GA28930@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/26/24 19:04, Christoph Hellwig wrote:
> On Sat, Feb 24, 2024 at 04:41:43PM +0800, Heming Zhao wrote:
>> maybe I misunderstood your meaning, do you mean: you don't like the design of the bitmap, and you hope/plan to drop it?
>> bitmap is a journal-like stuff. we could get an idea from filesystem journal, just write data status to the bitmap area, rather than managing it in kernel memory. with this idea, writing data protection may involve more simpler code, the replay will become more complex.
> 
> The main problem with the dm-bitmap code is the way it does I/O.  Using
> ->bmap to try to map blocks ahead is cumbersome, and unsafe in many
> ways.  If you want to keep the MD bitmap code alive someone needs to
> rewrite it to go through the file systems read_iter/write_iter ops
> and do direct I/O.
> 

Thank you for your explanation, I understand your meaning. It looks the
code changes include userspace (mdadm) & kernelspace (md module) changes.
mdadm should open a file with dio, kernel should call read_iter/write_iter
ops for IOs.
 From my experience, I have never seen any SUSE customer using kernel
to manager bitmap under external mode (intel VROC is another topic).
This job has a very low priority from my side.

Thanks,
Heming
