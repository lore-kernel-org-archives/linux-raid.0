Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 782287262D;
	Thu, 15 May 2025 13:38:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747316297; cv=none; b=E97hPtpOfa6NXhvcVSwdsvxtV18JBrH7dUyjKhxIPG5o30JttUvL8o3Y2Ge21bvbF8pHWAKuXq4s6bJKiRm6LLDoiX6RQS0g1Xi/m9bdswoQNtKl7flHc55oVjsvE3FGg4qoqYjD/O7bRD/U6KF/HioCHAHFOELb4Or5+W+0ubk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747316297; c=relaxed/simple;
	bh=PXKxDhViUIcxC3KUkZHCixiArZ3XlYY3kxB+rdl/gio=;
	h=Date:From:To:CC:Subject:In-Reply-To:References:Message-ID:
	 MIME-Version:Content-Type; b=CiPxyqpbqK+85WkTZb51/EkXM2DnkUwKpEWRmo6v4zTEImoM6Bx9dsoDja46W5lX0jgT2CE9g6zRq6wv+M+ly1VHSHTJPoXgA5vbolY5ZRAes3h5o6yvTtZP5L9SPhwEtEj+RprGbr+60iEjjcuAmIgUBRu65foWVSmnOdrb5a4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YK/kYzYh; arc=none smtp.client-ip=209.85.210.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YK/kYzYh"
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-7425bd5a83aso1072163b3a.0;
        Thu, 15 May 2025 06:38:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747316296; x=1747921096; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=qVf819sirg3kVreUfa/4iH86ct1h9QFKS6LDxRK2VpM=;
        b=YK/kYzYhegEvbEmvOI692CA6hY6fZNbQqtg8f2Lr82gBDIGQkEMknOp2wY4oh170qi
         q/t6HJqZXigxGECGmw6VZlK29WvrF4I7NjuOtKVWkP9JdgTtZCA4o2boVNASekrCDUsj
         zBPbvdfcrCfuPJYxoAGn7tGQNNyIGAAzgMs0y1/ET/hzFRNQesfLRvx4a4z4KlJwIR0F
         yLyqunme2pGEcT5CkJyV6rxTpJiMgvtaxFZNULxYmh2ceZEKgIpIgJduVbLcRmijAxq5
         oGIa2tOUc++bXwKcTyja0RunwViY4EPJq5ZB1HbM6phCEtE0WmC6T1D12iUWeFe1VJQX
         9j1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747316296; x=1747921096;
        h=content-transfer-encoding:mime-version:message-id:references
         :in-reply-to:user-agent:subject:cc:to:from:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qVf819sirg3kVreUfa/4iH86ct1h9QFKS6LDxRK2VpM=;
        b=epNqqVcQeB6er6Wvc8uGM1/FCns67vr6yi0qPuEgKML3eF0dOX8DRJbYECCIABZHJ6
         cQv6uF/4NH5SoMKOkI09krrgjm6V/36VIQjcEk3mJMB+mCs+5XUinBEs8X/Y79c3KMgz
         4xeqJ90H/SXtLjgoPdntLM2VQrw4FBPO1iguga78aLq5LQesZypIF4sqoBlWkGoHPaqu
         Hf8Y8/saPK9CLHOdIzaqYldTCWNzv+GcyS5/GVC+xlXmqjOb7rR0uN3VQSUfNzfqKYBu
         KfgiXlah6uoxbp0J0BdeOJd36rZHcOodA8JDzvwbC1S7y3x7h9xgliVW4wkBSkwjS+QN
         POFg==
X-Forwarded-Encrypted: i=1; AJvYcCVVjJKfXD6sy3ZAowj4qu1iNcc7YEuFfI4EZXm7wp1Nhxv5ZlAvTnPI1HaszUIbwHQkodElTYqE8wcnHQ==@vger.kernel.org, AJvYcCVzCH8LCUEd4G1HwVAAa8EVfvOBw3YQquKs4Li5Le2n/H5BqPkZqp6DjT8E+ZmPUvKJ3okyQWCEYlIsoSc=@vger.kernel.org
X-Gm-Message-State: AOJu0Yz5IIWnpZQ9THZHZLmE14Tcjv64IsLPY5ZFANbWzi2RzwJ/ZF8s
	NH7Hf/n3AfUhfKqilgYCnqlc3ZJs99ipyFCl4Ym0ZcIv0GYBq4X+
X-Gm-Gg: ASbGncsYcbhBTsxdOdjbZOHAeszOJa9VkMv4s7fWM7apkEmTRkHWmvjkIRRiYcreExj
	tyAQG5TA8q3cD1ISpXhMZ0eif1+r/eRgv36IEpykDsK+ZrkGkpsNwMu+A9Vb6iDE231xUOTfS0j
	RZwshpDo5TZlu5deJA3q2cikX8TRzuxFMpqMlLqFlfXfs/9nsfi6GSL6CokP5eeJJW+JHsMJpdI
	EnJ2SkSELaLuxy1NMMH0L5zx1djNaOQWTXtutdJq6R+O65sMKDRXFsXbNReZKa6sy8c0JykMUrq
	mdvD00eSYm9gLjByiVtoj9FnNTqeNYDVrpltm+zH70BkZZ6B5v8=
X-Google-Smtp-Source: AGHT+IHmq4AYLXRLdQqbBREfC/3/3V7ZOrM9bmoGqUjVhH9gyGLkXnYBF9r5Lq+r6xdwPiaWMnweUw==
X-Received: by 2002:a05:6a20:1611:b0:215:dfd0:fd21 with SMTP id adf61e73a8af0-215ff191342mr12229403637.34.1747316295630;
        Thu, 15 May 2025 06:38:15 -0700 (PDT)
Received: from [127.0.0.1] ([103.56.52.49])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-74237a3dbfesm11552273b3a.138.2025.05.15.06.38.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 May 2025 06:38:15 -0700 (PDT)
Date: Thu, 15 May 2025 21:38:06 +0800
From: Yu Kuai <yukuai1994@gmail.com>
To: Christoph Hellwig <hch@lst.de>, Yu Kuai <yukuai1@huaweicloud.com>
CC: xni@redhat.com, colyli@kernel.org, agk@redhat.com, snitzer@kernel.org,
 mpatocka@redhat.com, song@kernel.org, linux-kernel@vger.kernel.org,
 dm-devel@lists.linux.dev, linux-raid@vger.kernel.org, yi.zhang@huawei.com,
 yangerkun@huawei.com, johnny.chenyi@huawei.com,
 "yukuai (C)" <yukuai3@huawei.com>
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_RFC_md-6=2E16_v3_15/19=5D_md/md-llbitma?=
 =?US-ASCII?Q?p=3A_implement_APIs_to_dirty_bits_and_clear_bits?=
User-Agent: Thunderbird for Android
In-Reply-To: <20250514051747.GA24503@lst.de>
References: <20250512051722.GA1667@lst.de> <0de7efeb-6d4a-2fa5-ed14-e2c0bec0257b@huaweicloud.com> <20250512132641.GC31781@lst.de> <20250512133048.GA32562@lst.de> <69dc5ab6-542d-dcc2-f4ec-0a6a8e49b937@huaweicloud.com> <03f64fc7-4e57-2f32-bffc-04836a9df790@huaweicloud.com> <20250513064803.GA1508@lst.de> <87a53ae0-c4d6-adff-8272-c49d63bf30db@huaweicloud.com> <20250513074304.GA2696@lst.de> <d5ae7af0-dd73-7d6b-f520-c25e411f8f06@huaweicloud.com> <20250514051747.GA24503@lst.de>
Message-ID: <7B4FF58E-BCF5-4997-8006-CEC5A3EDEB85@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable

Hi

=E4=BA=8E 2025=E5=B9=B45=E6=9C=8814=E6=97=A5 GMT+08:00 13:17:47=EF=BC=8CCh=
ristoph Hellwig <hch@lst=2Ede> =E5=86=99=E9=81=93=EF=BC=9A
>On Tue, May 13, 2025 at 05:32:13PM +0800, Yu Kuai wrote:
>> I was thinking about record a stack dev depth in mddev to handle the
>> weird case inside raid=2E Is there other stack device have the same
>> problem? AFAIK, some dm targets like dm-crypt are using workqueue
>> to handle all IO=2E
>
>I guess anything that might have to read in metadata to serve a
>data I/O=2E  bcache, dm-snapshot and dm-thinkp would be candidates for
>that, but I haven't checked the implementation=2E
>
>> I'm still interested because this can improve first write latency=2E
>>
>>>
>>> So instead just write a comment documenting why you switch to a
>>> different stack using the workqueue=2E
>>
>> Ok, I'll add comment if we keep using the workqueue=2E
>
>Maybe do that for getting the new bitmap code in ASAP and then
>revisit the above separately?
>
>

Sure, sorry that I am in a business travel suddenly=2E I will get back to
 this ASAP I return=2E

Thanks
Kuai
