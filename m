Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AC4A3D965
	for <linux-raid@vger.kernel.org>; Thu,  7 Mar 2024 22:39:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709851162; cv=none; b=BRZLcR9/1LEIUKckcRV/usj5OQypv9IPF2+gIUZsh19xXs5sQqbnELOvm6PbmeYZsdlYTs2sHoxyjdGk4EjgsdZz+SQrny5xkxFYAP6Xh/m+Mw7QmkXE7UDYVoaYtSkdhYdjmrhXye7eX92sv6VuLLTZrDAtCIxytBn/i4DPMCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709851162; c=relaxed/simple;
	bh=Ce1D9yJNNKtoqxoO5OnsnIlgMijzSt3nMJtTC8QAmNM=;
	h=Message-ID:Date:MIME-Version:To:From:Subject:Content-Type; b=nHD+GaIcs70mfonEpA43CDMJhjAfIoVzjc6I5Bah6jlp1NH/fyr/oojOcUly1Bo3J3RaYuKLo3uXeAEBQLHIRb3QqulKs8Bqea1u8L/YYBMTe8Me3Umw6c7kMHzmBzaFkCQkUtYtvHaMSn/r+H0NiLRJcgv0PsAZa4d/fhCqq0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=f7uMg5Yw; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="f7uMg5Yw"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-6e55731af5cso198838b3a.0
        for <linux-raid@vger.kernel.org>; Thu, 07 Mar 2024 14:39:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709851159; x=1710455959; darn=vger.kernel.org;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yQz3ifX1SX7VMhiU9zFmr+ZvX1kyDQpuMQgCxdlD0cc=;
        b=f7uMg5Yw6wX1K5hE5Yib4tYy6/YYOmajLGY0aUSIlW7TEEg6wfB0P4C1PfbfnhcvCx
         239O7/sNyofC23ujr+AO6FrxyslX1Q0pRTa+02vGZZ6kmDtV/wh+egNmDQs2wcGGdB6S
         rSoYxY2PgQ4xjP/9ueDkc695EncBTnmSNAV8UVl2+nwe6kiVEVaAxugt+SEfGG9Pb72C
         y/iHvGfF0gKY9Z+c+QwebBDcALOZxLWX/9EqIKOhgT1Z5isE4WZHaH2F7teWiaUgWKVm
         HRJayqTsOCgoOAxEsfZY2YI5PjES3y+zj9eGQbNt2Q9nrSDxzD8/G87+dexzmTITpafL
         8zsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709851159; x=1710455959;
        h=content-transfer-encoding:subject:from:content-language:to
         :user-agent:mime-version:date:message-id:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=yQz3ifX1SX7VMhiU9zFmr+ZvX1kyDQpuMQgCxdlD0cc=;
        b=OC0pSeIqLn4gB4VyJqETHzz9UlqRWZtesBTRTLG+pLLKD5lkg8gKWTw4YTDvIVDG/v
         l+7dJ4YfHVGb2ocH3sKdatwy0ovw8x3jhU9TeVHSCZDLkaKm513kG9qzVtAodcGJA2nc
         BzKqHO9nT/p/WTKgstrUST68Tl1y3Pn59JDDiKPAqkje7IYgJMrwhzkf8RI7h+oTYl2L
         d3Kd73rIkJNDbY6/K6aMHg8uIJzGkf1+XBAgQjo7xK5kZA32nwf4JO7J+OcTOqfi5l9x
         Zu6ZAwAD6RsQ97LEbWplja7JbtvcqUobKE14wwMV3kK+LyxhjJsXA/Mjth74zv5V1XVX
         KJMg==
X-Gm-Message-State: AOJu0Yy7+zLJga3bpKGGpYQ8SnitgyKUHpVfnLZ5xsMhHcrENQHz1+DM
	1a0XatW5mHN8UFEypEdnOyro1MR5ytUSfo8Y3dHhsJmgUkAJ1+iWkDExJu3r
X-Google-Smtp-Source: AGHT+IHcDFLQthmNmfqrxe1RpNxHQ6AqBjZZ2nL8S83V1MYFVUAWjgv7hXbds+DJJw4601LPyROsdA==
X-Received: by 2002:a05:6a20:19a3:b0:1a1:4d10:db95 with SMTP id bz35-20020a056a2019a300b001a14d10db95mr7577151pzb.53.1709851159354;
        Thu, 07 Mar 2024 14:39:19 -0800 (PST)
Received: from [192.168.254.118] ([50.35.216.240])
        by smtp.gmail.com with ESMTPSA id p24-20020a170903249800b001dbcfb4766csm15110909plw.226.2024.03.07.14.39.18
        for <linux-raid@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 07 Mar 2024 14:39:18 -0800 (PST)
Message-ID: <f2737b90-fb63-4909-b2d9-496390d2c199@gmail.com>
Date: Thu, 7 Mar 2024 14:39:17 -0800
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: linux-raid@vger.kernel.org
Content-Language: en-US
From: Stewart Andreason <sandreas41@gmail.com>
Subject: raid1 show clean but md0 will not assemble
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi, I am new to raid, but have many decades in tech.

I have a raid1 array that was working, but now gives conflicting 
information, that I need some help understanding. Searching did not 
answer for my specific situation.

I've put all the required output in a file instead of attaching here.:

http://seahorsecorral.org/bugreport/linux-raid-help-form.txt.gz

What confuses me is both drives report clean with mdadm --examine

so it does not look like a typical degraded situation.

I can not see clearly why they are out of sync. Is it timestamps, last 
unmounted time, superblocks broken, etc. I would think if something was 
altered it would say where that happened. That would get into what I was 
doing when it broke, and make a longer story.

Model numbers specs show CMR, not shingled. Problems with portable 
shingled drives is what moved me into creating a raid.

sdc is inactive, slot 0, (AA), and is out of date. I guess AA is from 
the last time it was written to? So it was turned off in the correct 
condition.

sdd is RO degraded mountable, slot 1, and (.A)

That indicates 0 is Missing. I understand missing from the current 
array, but... it's right there.

I have set SCT Error Recovery Control to 7 seconds today, After the 
problem occurred, so is a detail to be ignored.

I have tried this:

$ sudo mdadm --stop /dev/md0
mdadm: stopped /dev/md0

$ sudo mdadm --assemble --verbose /dev/md0 /dev/sdc1 /dev/sdd1
mdadm: looking for devices for /dev/md0
mdadm: /dev/sdc1 is identified as a member of /dev/md0, slot 0.
mdadm: /dev/sdd1 is identified as a member of /dev/md0, slot 1.
mdadm: added /dev/sdc1 to /dev/md0 as 0 (possibly out of date)
mdadm: added /dev/sdd1 to /dev/md0 as 1
mdadm: /dev/md0 has been started with 1 drive (out of 2).

My questions:

Where are the Last-updated timestamps? Don't they match?

Is the correct way to fix this, to --force  OR  --delete and --add ?

What exactly would force do?

I can find nothing about what exactly that does. Presumably something 
less than a whole disk copy like the 2nd option.

Do I need to --zero-superblock sdc first, without seeing a specific 
error regarding the superblocks?

Thank you

