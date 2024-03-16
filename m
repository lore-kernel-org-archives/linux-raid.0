Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FDC317C9
	for <linux-raid@vger.kernel.org>; Sat, 16 Mar 2024 08:57:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710579462; cv=none; b=IAxWK1KzUJULqmMA5ifiVhU2s5zsLuIyb+t+zKjUxXXTLjAN3sWqlytLT4NCt5U90xLorcYk+4dkLX3zJERArpLCQlCSOL1ZMKtzBX0CIyDIdYpB19KfsAHkLjR4RO8IACsSEZbCW3NnVOYoXRJiBh88yiOyiRC67ZqJYD/+yuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710579462; c=relaxed/simple;
	bh=7BlonYSwL07hETbDEDzH2hrW+73OjS35oQGo6AA+dik=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=Od+JjzG/2YXTSkQBjhXoFbvZsVnqozu6nx1j0uEXhtMLLoTXYS16/Jt5B1yadKbTx+UfT4NKgvdT38wA7VplbsGpcBPjntKcaIgmNVIj8wmKKkPDxr6N/p0BJhMUA29nHkZPcgyMUq1lPvR4R+bmSkHeXF9hy7VMmEAZfq6NeQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ishafoundation.org; spf=pass smtp.mailfrom=ishafoundation.org; dkim=pass (1024-bit key) header.d=ishafoundation.org header.i=@ishafoundation.org header.b=lOpDhJHL; arc=none smtp.client-ip=209.85.208.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=ishafoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ishafoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=ishafoundation.org header.i=@ishafoundation.org header.b="lOpDhJHL"
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-56899d9bf52so3769673a12.2
        for <linux-raid@vger.kernel.org>; Sat, 16 Mar 2024 01:57:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ishafoundation.org; s=google; t=1710579459; x=1711184259; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=ALC6GP9dkOMSTGJXgRXolLDrSPcSd+Jr57yrob9ITZQ=;
        b=lOpDhJHLqMxut9+dH/C52hYP7cwcFH5IkJLcyMTsxXjJnrpEvmF4i6W6mSoAHYSIX6
         APY7jvHQ0OsrI827LknAXp6XTozuw+3HHf9xVSN9RqlUHc1oOy9dwHbrxzqzmAkUuD1Z
         RuctjZWk5Jd2xEIwrOhVPbzyZ01JIEgsrunEE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1710579459; x=1711184259;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ALC6GP9dkOMSTGJXgRXolLDrSPcSd+Jr57yrob9ITZQ=;
        b=Kk4XZLXANpTRaLnVJqNTmlAPhsJmpTZpRfF0J3UGoG+mmZTSPfZuSo5wRI5GKi5ppL
         ZMVgz2Io86cvdLNeZ08ogiX7CJ0Sk7uf1ykkJu8nbhQwOTckBI1eL3r59OJxyQ3P/frZ
         XZVdQbmv3psUIwX7w9blbGLoklPdx8HltHXVN6yKhCPdZEtKLMBvugQIHy9y1baNDMSY
         tSoYu+TNfvyP57exVD8fHvsoodySn5z4oReL9bsIaC6vcMu3CAcYdcV75+7ZBCWulL7o
         6ph2WtOH5O13SoWs0I+GWd4HXUI+wKX/zKrjfAAYt/XzyuC1lXy3ls+T2kOEcPO9XHPY
         lA4g==
X-Gm-Message-State: AOJu0YwteQB7m514+sEVY52DPtxPpQ7w6jJhBpqzLG1a376jatbYrBuX
	mrQdC0xhXsFfvMbx4ApwW1cvUzDtWk2iKVr/68BwXwglomZ5yrIHBc2yEjhUVehHqMSfTDf9QZo
	SuhqIoTA6Fh374hDUM5int6NHIw4OKjtZUoEnYVnErrEareeCit2vHko2D6BF6jeihLC/RJZYS7
	7VErIwBUQRX3LHhbxHHHr8run413hTw7+KXujw6GDi
X-Google-Smtp-Source: AGHT+IE5HgrK+M6SV/TyC8b1AJycP/VXowZIEakVIDbYkyIN3yyliVQCC9kb5RQ2Q9C9nXb++I1MBgilwmM3+zPnaDY=
X-Received: by 2002:a05:6402:3222:b0:568:b4b5:4609 with SMTP id
 g34-20020a056402322200b00568b4b54609mr2584331eda.1.1710579458805; Sat, 16 Mar
 2024 01:57:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Swami Kevala <swami.kevala@ishafoundation.org>
Date: Sat, 16 Mar 2024 14:27:02 +0530
Message-ID: <CAAOcTUhwOPtyyoK4uP02rC0hgrZN1kzLvBY8YM6-1QUN5nELAw@mail.gmail.com>
Subject: fstrim on full stripes
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

I have a RAID6 array made up of 8 NVMe SSD drives. I have noticed that
the write speed for the array is slower than the write speed for an
individual drive!

It is not possible for me to use trim on my array since my drives (WD
SN650) report "Write Zeroes Not Supported"

As per my understanding, the reason why trim on raid is complex to
implement is due to the need to recalculate the parity blocks whenever
data blocks are discarded.

My question is: Would it be possible (or a good idea), to make a
version of fstrim (e.g. fstrimraid) that could discard at the stripe
level? i.e. Discard only those blocks for which all blocks in the
stripe can be discarded.

I guess this would need to call the md api to know which file system
blocks are stored on which stripes.

Our server is used for editing large video files, so I would expect
that a significant percentage of discard operations would result in
entire stripes being discarded at once. So I wonder if this would be a
relatively simple and effective way of improving write performance on
SSD RAIDs without having to worry about parity.

Would be interested to know what people think.

-- 
- 9442504660

-- 
The information contained in this electronic message and any attachments to 
this message are intended for the exclusive use of the addressee(s) and may 
contain proprietary, confidential or privileged information. If you are not 
the intended recipient, you should not disseminate, distribute or copy this 
e-mail. Please notify the sender immediately and destroy all copies of this 
message and any attachments. WARNING: Computer viruses can be transmitted 
via email. The recipient should check this email and any attachments for 
the presence of viruses. The Organisation accepts no liability for any 
damage caused by any virus transmitted by this email. 
www.ishafoundation.org <http://www.ishafoundation.org>

-- 

