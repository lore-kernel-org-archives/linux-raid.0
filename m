Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41B438172D
	for <linux-raid@vger.kernel.org>; Sat, 16 Nov 2024 15:40:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731771649; cv=none; b=lVY+zqSg/TP4O7ieHbkHUjtNVLNOjbCodUWVl6+thbg8S4EtaZLGIYH++j3Q3xLbxRJ8Iy15c7DYTJHB6//ykrMXVRKrVDcvlY3cbaMTE3hnZykrQ88klp5T/NV9QIYsOAmmwQ81gmgMy9TtS6Xpmw2UUhC15/zLPRXIAKT2KKk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731771649; c=relaxed/simple;
	bh=Wd+7kLQISUZlzyPvYmSUTVOb8NV4Vyd3OpsFXw6X7a0=;
	h=From:Message-ID:To:Subject:Date:MIME-Version:Content-Type; b=YFCdyMelDJjd6PBzD4ab+wFAIN8DjR2GgdGno+Li2r3TWFWh6/o9sdNpnJvdj2q5jdOKFUD03pZgs5GmgYn4WU/KHhzSOu3YQ7UuYTLR6CsaCkDJAPRnVq7o3jKRD9mXGgUUcJ4cC7uv9QNrzL845WeBIR4ZXYKcPckRBgMBSRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=M4ZagV0q; arc=none smtp.client-ip=209.85.210.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="M4ZagV0q"
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-71e4e481692so569423b3a.1
        for <linux-raid@vger.kernel.org>; Sat, 16 Nov 2024 07:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1731771647; x=1732376447; darn=vger.kernel.org;
        h=mime-version:date:subject:to:reply-to:message-id:from:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XHEOkgJ64rwJ+cv0sVIqPUmbc8l+iTifR7HzGzNced0=;
        b=M4ZagV0qUonm0r2+C7cKISF0etnfYKBBzi/0Is1vJR2HKC6SxY9nySVVA8a7atHnvi
         8YCCsLa7fDPtPyNlpy9MP/sDiTDk3dymrZKsER8hDlxce3BIpbG3QOTS3NshO8ytWXWl
         MefxWHbocO7hHj4xxvV/HiY+c5193ElqcRZZVTJf5a9kKjG8UvurGgIVwB5tChB7xsU7
         a4uxX2Cj7DBXJOWAfIhfibrg+CQwDosQU0V245HzIQK7Vddq3aK42CwWY1mOqoJP5Q6Q
         CkZw61vLTZJpQK7Nsg6GqQv7JFw2NcL7yzOv94P3VgpDmSA387o7H9k3d21wQE/+YL/M
         lNyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731771647; x=1732376447;
        h=mime-version:date:subject:to:reply-to:message-id:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XHEOkgJ64rwJ+cv0sVIqPUmbc8l+iTifR7HzGzNced0=;
        b=KK49JpMCDbyxE7M6QZGgpzpPg5Ar07dizwewmKEjWu2pVIDY1qQzM4FJuudXvWp8sv
         xwO/9g2qeW/rcFA6cV13cS0jrLILqA5ORbO3amRIj6VzxsbqkWup8k07DofI3uAskKns
         0xI+HNQBKYAsA6nCBs1OplhjZP/g4F4FjXke/p+mCwOaYqk/7V9WF/1f1H00POW4qJYN
         N2/CfngnrNwk9HF3OxWUFC5EFNItB9oho74F25QPBhEyt34ZGpsYMb403qX14ojEB2ZL
         qVzlHgH6noo8S9Rzv+YhEdGYfg/RdnjZybbJdV87ZRlDouVloT+s9a5i+TbsM8Z7b+JD
         8Gfw==
X-Gm-Message-State: AOJu0YzxbHqX/felqtTxLDKXWF3YGRq7NiRQkdb/aGnLqjd/k2vhwqtj
	EJjA/fTfmy3rwH0pe+jlmL8kxp+Qrwtm1A/mF3cY5wcm2mG6rWVROptnCg==
X-Google-Smtp-Source: AGHT+IFsyXQxkpE6Vc53hjGCEr6fEI+2tY79zBMeEZujmwBUkl41+PlEe7rA22tjhfmPh7z7/njWMw==
X-Received: by 2002:a05:6a00:1413:b0:71e:1201:636a with SMTP id d2e1a72fcca58-72476b7228dmr8375959b3a.1.1731771647050;
        Sat, 16 Nov 2024 07:40:47 -0800 (PST)
Received: from [103.67.163.162] ([103.67.163.162])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-724770ee895sm3209829b3a.10.2024.11.16.07.40.46
        for <linux-raid@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 16 Nov 2024 07:40:46 -0800 (PST)
From: "Van. HR" <khatijabanoo7886@gmail.com>
X-Google-Original-From: "Van. HR" <infodesk@information.com>
Message-ID: <9d47eedb4397c10c284425a1e0f11ebba5c33c1bd4ccca12f274ec7d2fd4d589@mx.google.com>
Reply-To: dirofdptvancollin@gmail.com
To: linux-raid@vger.kernel.org
Subject: Nov:16:24
Date: Sat, 16 Nov 2024 10:40:44 -0500
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii

Hello,
I am a private investment consultant representing the interest of a multinational  conglomerate that wishes to place funds into a trust management portfolio.

Please indicate your interest for additional information.

Regards,

Van Collin.

