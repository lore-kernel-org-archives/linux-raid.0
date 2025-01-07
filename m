Received: from mail-qt1-f181.google.com (mail-qt1-f181.google.com [209.85.160.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485AE188CDB;
	Tue,  7 Jan 2025 20:32:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736281950; cv=none; b=s95VCf/b1Ob/fFeZrkxdJL5pS7SQ4xFzw5nHRXUHg8urd8jtNYefWQ6EI2qtNhbLYsvDhUwW7+TyLm3ZqyXXlLvLAgIFgcIyCy3DJy1ZMQNvrhZsUjZ25kKOpUbC+PM1p2r0zXN3ED6QmLcWKXYAYTevwPlwl1ILBYpEhe3xzKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736281950; c=relaxed/simple;
	bh=nJwzsPsavEOhN9TOvSrKg81oUzkADxes44aS9MqrkUQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=H4cyoj32oz0YmV5AM4mtDH5IKRZpo0wOpqulyJhiGR0dNFtGSo9tsZQVKoxsxv2kqNbh4UlpKO9XqAvItOEDKvRwPlW7jK2U1puZmbimELLxG+rv7rghvkrg9F0rDkKO6FzBJO8qkuC+U6gr+KaqynfGJnRia30pwqFsy/qY9hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jECATSF+; arc=none smtp.client-ip=209.85.160.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jECATSF+"
Received: by mail-qt1-f181.google.com with SMTP id d75a77b69052e-467a3c85e11so101342851cf.2;
        Tue, 07 Jan 2025 12:32:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736281948; x=1736886748; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G8sLGXhHxnytSf4USyTo2JrNZ6IzDXWjNAZ6fRdDqHU=;
        b=jECATSF+TvBIgHcy4H7RSD5tFp63mnJJPCBDb+l4H8cWw7a+ef62WldF+lueeJVti/
         CELmtXQRBPLlfB1JGCVk2+TJzbFzzpP87JBkNwIl+cwHyXnhT1eeBwDI/GwmGfHBBjdh
         dqurGSL4gkHHjUc1zSwmU0ESZmgqcrV5fAQfR3p1YR94dlqCyLaihLRWu2L+43vti5DK
         yfr+fW/Yei4JgDloS+oReVrhwBtWx59eLZb/93bjgyGkUdmSgdJsy245hzCmytzDnD8y
         C8lxQCM+BQkBJn/ZBP92q7mq9yUy2ROAMfI7gHjQOG7KHe1i16J7uSKpd/DVrM+Q+SWA
         ydhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736281948; x=1736886748;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=G8sLGXhHxnytSf4USyTo2JrNZ6IzDXWjNAZ6fRdDqHU=;
        b=IfgRVeGrRChf1HuCzb15hJLmi7DOFDux7WFdSdVoqwG7dg/m0VZoI/VLKSNlH4RHxj
         E0acHXeyH9elHx+O9vzTmVEcQTzRsEWIkDqr8mmW2qFqKYMxU0aGDd2wfP8e0WejwzsL
         JYB6ggADGAdaAh452M+Wrc21iWyY9OAlzq1Kv/TnF2uEnz1qqAgjHXQFrq4eGRO+0I3l
         xuJKZqMvrFlxkEqA7dGooGCkZmpMowk6ukInY3UQqj7Vxe2s5VTircsBWqPmGxjgULHM
         N3pWK3p4PZjwo6BA0/0mbVPcT9kWk6SZ3LdKN643GtZXz7FC4J0Z/ijddiP1cZgKysX/
         BayA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ1ouAmSpowlvb5FklSxJBjXnLkvSdS87BYClCRjys9V8Oy+LaNwJcWKV1PwixDFaCh77QivvyuItNynw=@vger.kernel.org, AJvYcCVuMXcz/dUSm7Q4TZ/JXRp+Nk3p1oI/uhj3t5QzLOdm9X5+EsUulnd0QsY8XIGwundqn8L04Nsr8PKVIw==@vger.kernel.org
X-Gm-Message-State: AOJu0YwQ50Y24xf5K3lbw6WffrLedzTxe7giwzv7uG7wh0Rcy4EwarhI
	94muM4sGUeKrZeQ/0r8U5oid7rXyxRi+UIxXmGdc3yPJa5iGge4r
X-Gm-Gg: ASbGncuJkvNIUgJUO2aLnOwWemCFbguot89hJnEw4OUrI+gnLASkAkgMlTSuVNEzpS/
	rraj+dn6mUjGUWxRNwt1EylsNeqC1u81WUTz3cnaZiP6XlSRu+KiUef7Uw2yTgbB2VkBvWueh1E
	u9NlOID7CnTpcY9KN7h7uTJauQo7tagQSGBkuqCY7Sbt6W2dCOZf8EApDDTgzA1DPHpyM1pIUaP
	JJJWjMIPl58s/dSm3drK+gyOvkiGHEGprCJZv7PHgDY8V50A3vf3Ya0faqq82X0c0+fT5IZ+1eb
	GOzMvRUHPeazZWISNMNIsPDEpu/3THZG
X-Google-Smtp-Source: AGHT+IGNLKDFIwOHygWKlYJ0nrIfpwGkztjqtCphaLCid34CLVz86qpzW6kqkTboRsnfWY6lTiubxw==
X-Received: by 2002:a05:622a:558a:b0:467:7eb6:a007 with SMTP id d75a77b69052e-46c710e1747mr4539521cf.37.1736281947863;
        Tue, 07 Jan 2025 12:32:27 -0800 (PST)
Received: from ?IPV6:2600:4040:5f58:2500:48a3:a7cd:313e:1c7a? ([2600:4040:5f58:2500:48a3:a7cd:313e:1c7a])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-46b2e571dd0sm28345951cf.57.2025.01.07.12.32.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2025 12:32:27 -0800 (PST)
Message-ID: <64e02996-14b4-45ca-9288-4653561c51b1@gmail.com>
Date: Tue, 7 Jan 2025 15:32:26 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC md-6.14] md: reintroduce md-linear
To: Coly Li <colyli@suse.de>, Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, yukuai3@huawei.com, thetanix@gmail.com,
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
 yi.zhang@huawei.com, yangerkun@huawei.com
References: <20250102112841.1227111-1-yukuai1@huaweicloud.com>
 <58F4D954-1EC2-4E79-BE7C-3CB84F31CF49@suse.de>
Content-Language: en-US
From: RIc Wheeler <ricwheeler@gmail.com>
In-Reply-To: <58F4D954-1EC2-4E79-BE7C-3CB84F31CF49@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit


On 1/2/25 10:28 AM, Coly Li wrote:
>
>> 2025年1月2日 19:28，Yu Kuai <yukuai1@huaweicloud.com> 写道：
>>
>> From: Yu Kuai <yukuai3@huawei.com>
>>
>> THe md-linear is removed by commit 849d18e27be9 ("md: Remove deprecated
>> CONFIG_MD_LINEAR") because it has been marked as deprecated for a long
>> time.
>>
>> However, md-linear is used widely for underlying disks with different size,
>> sadly we didn't know this until now, and it's true useful to create
>> partitions and assemble multiple raid and then append one to the other.
>>
>> People have to use dm-linear in this case now, however, they will prefer
>> to minimize the number of involved modules.
>>
>> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> Acked-by: Coly Li <colyli@kernel.org>
>
> I am fully supportive to bring md-linear back. There are still many people/company/products using md-linear, just like the discussion in another thread.
>
> Thanks for doing this.
>
> Coly Li


Bringing it back is very welcome - we have many customers who use it as 
well.

Thanks!

Ric


>
>
>> ---
>> drivers/md/Kconfig             |  13 ++
>> drivers/md/Makefile            |   2 +
>> drivers/md/md-autodetect.c     |   8 +-
>> drivers/md/md-linear.c         | 354 +++++++++++++++++++++++++++++++++
>> drivers/md/md.c                |   2 +-
>> include/uapi/linux/raid/md_p.h |   2 +-
>> include/uapi/linux/raid/md_u.h |   2 +
>> 7 files changed, 379 insertions(+), 4 deletions(-)
>> create mode 100644 drivers/md/md-linear.c
>>
> [snipped]
>
>> 2.39.2
>>
>
