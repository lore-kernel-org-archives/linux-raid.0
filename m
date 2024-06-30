Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92D4D1EB2C
	for <linux-raid@vger.kernel.org>; Sun, 30 Jun 2024 18:16:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719771407; cv=none; b=LNahvcykhQxknDSBQbnnmpnDv49K4BXhaKihLzc2NnpIKbAxZR7bYtmWBPAwdyIWYtgEil3bf8X60PfOmpJC2pc6wYSo/9LGpBipnBmFnH6ZKgT2KO4mKguDPJkgsaDOtF85cP/SNrM6v40VOttxWEVZaHBJnaMmCgrXOWXznE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719771407; c=relaxed/simple;
	bh=SbEV2fUAeMeHXg6YxzJlI7xz2SFv9yILOxXss94VJBE=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=AU50h/h5+Vftr3NnTpqJZfLaQ9yFFXOuG/QjjAjb5nkKmnmj21zpml1gD1L2xBtUq7whz/aj2mN/3VePZKgU+IhzYXhZAFMo3sQzapUkNzoRMHAVMRxkkhYJVnGwIDhfekr+tRdwHQTkuTzPXmM8CK7C/u4ngDQalRdVJqdsIqA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=SmR67eFw; arc=none smtp.client-ip=209.85.216.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SmR67eFw"
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-2c8c6cc53c7so1519244a91.0
        for <linux-raid@vger.kernel.org>; Sun, 30 Jun 2024 11:16:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719771406; x=1720376206; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=SbEV2fUAeMeHXg6YxzJlI7xz2SFv9yILOxXss94VJBE=;
        b=SmR67eFw0L7+lh1tqOaA39XHSAx6l+G+V0mKe7MmA66v5zz92h26pvPjeoztZYkNKl
         mVjks6OTdJgoYnPYzHmfYlEAeAVonxPdQS+cafFocyY4RS/+f6vnAIYmEty8f6qlTyQb
         mWVPL4MVvA4FOQws+KEyDFfFONsFjCMdE6pf8IBWiFWuMvDj+N9w0FnHn4zOUUq8SAgn
         wUSZX8mwOgL5hyzECTWylZCxKVx8sMOWOXQiPrwJp+FIs5ZuHH5S/f4LoKQnReLgLjT8
         Ix5xNbYWFPQx86zzA2UqT05g2qo2dfdVRCCXiBmKgezGS6OWlESiXV2I4HYVRkgb6S26
         nlqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719771406; x=1720376206;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SbEV2fUAeMeHXg6YxzJlI7xz2SFv9yILOxXss94VJBE=;
        b=kmiOivdq6AhSRZsJnY7UC15cfTPbwxYgoEKgUmWEAhPPpvVvpKZl6M5NKVziK0R/IG
         1CgWXTkY7K1z4Sxo7uU+nw/A5bYzkJhTbGD5jb069xkVxnjAQCA9uKebFd2nThbQHbmt
         bPsjkLxUdXaIiAZeeG2y4t36s7d6iApXFO5uCFUeTGjQcz0IwX3yUFRqCnSA7DFxgu9W
         CyqWAigimCdW1/1Ts+CWSMnSKEhJZZG5pEjVRsrBJKEWSJyFA+pSigJduH6k5r8utbxE
         KUkGQXtYZnaOAstddcvukkouPRZLxq7RhFmnRgWWUYh6STzCuUQxiXrfzntCKnREfq4b
         znWw==
X-Gm-Message-State: AOJu0YwldMXSiK0NG2AQ8IXHcM1PxHX3pOFdjaUa09bXlvVHrqNFIJwQ
	HACR08YmU8pnpRQZIG8qV2i1UYQjllpKoCusRlwLX2P8CPO96A8N+Jvo5WaQ84c9URLjMSS3tRk
	0urh4SzjgdTWIwWAS6IgneFMXHc2bI45QG/Y=
X-Google-Smtp-Source: AGHT+IG0BXYdf3RkXCI8BtIlvfIs6FtbB74anKMg0oGw3G8toMHms4KsOMIPJnuFnzw8+Ro3qW4mCmcEh4jWu2z1jEE=
X-Received: by 2002:a17:90a:c287:b0:2c4:eab5:1973 with SMTP id
 98e67ed59e1d1-2c93d6dff99mr2781703a91.7.1719771405444; Sun, 30 Jun 2024
 11:16:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: MC <darkhat@gmail.com>
Date: Sun, 30 Jun 2024 11:16:34 -0700
Message-ID: <CAF1V9aCeNLS5yiMwhkwtZPbgbpybS0eBxNKtB3p82Lo=WnLkOA@mail.gmail.com>
Subject: NAS RAID configuration overwritten by ransomware
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi everyone,

Is there a way to force mdadm to assemble a certain set of drives into
a particular RAID format? A friend of mine had a NAS that was hit with
ransomware. His setup was a RAID-5, 64kb chunk size, 4x4TB, XFS
filesystem setup, while during the attack, they overwrote the config
to be RAID-0/512kb chunk size (it is a Buffalo NAS, running Linux with
libmd). He pulled the plug while it was in the process of formatting
the XFS filesytem. Much of the data I have been able to recover, but
now it would be a lot nicer for me if I could access a raw /dev device
assembled as RAID-5/64kb chunk (rather than the current RAID-0
mdadm/mdstat currently shows), instead of using a tool like UFS
Explorer to assemble it properly for me. Obviously, minimal
(preferably none) writes to the disk if possible. I was afraid to
start throwing mdadm assemble and create commands around. Could
someone please advise on best path forward?

Thanks in advance,
Mike
