Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E72A233713
	for <linux-raid@vger.kernel.org>; Thu,  7 Aug 2025 12:57:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754571443; cv=none; b=XisuzApcE/qz4Oxu9MzAh5HLc+dt9eCp1zXbLLr8fZ0f94k79NeLKg7WDvKyt3xSTsg5qq+QfVpflyqFZrLQoTJa3E0RrouSswqcDjtb/XrK5c8AIfeJHshSUTlR7FFCXDEWy77mon7C/ezmMAoT/zhqUVXPbVWXwe/URLLgIqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754571443; c=relaxed/simple;
	bh=6nhHJRkzs08geDm3z1jvgQLLZmAh0z0Z7NK1SK7MHpU=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=hl740IV5Nwh9+iWp9LYgXXf4+PrfEhHQ8Boj1XSyr3pILS8lfZmvjzbkzSDyiK8Ir90kVnSRjNVYpz6cs/gu1UWuuiI/Db8yvXIZ0SutjpTVV5PZJ6BfqvgSg50C6urXUTnHksGUhDU20wgi3RMJVm/RAw5B0EQguHqrj9h8XWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DkQXAfPH; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DkQXAfPH"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-31ecd1f0e71so1172251a91.3
        for <linux-raid@vger.kernel.org>; Thu, 07 Aug 2025 05:57:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754571439; x=1755176239; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=iSUtDM1+FjHEMMk9sa0BRdq4ktrzXJh8SjFRaEtxAVI=;
        b=DkQXAfPHryQvkW7ErHZoT2LkfQlx1wDLgwQdkRvZ8/0bWaUqYvX922en42qvG8V7R2
         1NAphneBDstdNlRgjwh64M00T0SDVlR8xzsTFtMAOQlEMglyQZIRzVjks/VTmyuz9KjY
         jPglLZcziPGb7L4gWlHq8KSXCbcU3H9I6EuJdMelYFieipT6I3jBZCbbNPY1b7fw5qrr
         CphwznrgO/cmjnZat7Lic8GoYA7OtxwV9deiShhbJI2YKwAWdvCxTB1kBbRAT9mH5nZt
         j0MuCd1YV2RB58e+45GSdAnbcP/BIXE0wmYMshrJJ9OOa3HrhidTlGrWgzv2nUpfHoPY
         ORww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754571439; x=1755176239;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iSUtDM1+FjHEMMk9sa0BRdq4ktrzXJh8SjFRaEtxAVI=;
        b=F1Z7YgDdbZnKHNeCI2ms9LTF58IcEfRZvj8sQGjIS6f1aoiYPMfklKh+OqCFBVzmMl
         bfddINKPZXr4EFKoRzQrZt5P+hlZXk820Wd5AEpR31hYzKBv9iMAMIwnGVE3osysSgBu
         e3gAu5XwOKuK6r0v1433Z7cgrn8hrmkmud3H+MxiSA/ahsevbQ+0ug+CfA038FZaPxAB
         GN2IrMSXzzxvd10rqISLPiWjuHZsZ2ZgjNsU/+CSO419k7jBnd8iN8EJZBf855YEBqj4
         JNRprNzvS83Z/ZVFDt1tiuHXFv47LBoNb/AJW7zk1UfTiokKbA4FFGsyguWc/JLcCAyi
         iNpA==
X-Gm-Message-State: AOJu0Yz1hGgMStMhxv9Ppi2nay+dPtfnWPiEyThdvxi/VLT/iJDPCGrZ
	iUgoBsl6t3CvMFls8FUxmsBZojHIU0xkRtzsQ0PwNBHkkUEQF1pHuGLFSfc5oEuTLVjRlD9MLrL
	H11XxWnywgV4e+cHUQo7afm/4wt3aQdOQKZlE
X-Gm-Gg: ASbGncsa8+D1UDG9nSjYjLZuI6l2TYVsruX/p48CTMBpNDFrQmbsbr9EK3bGKHd9QOX
	0iG4r0R4A0chTzG8lp6Y46P2xhENtpg/iea9r/K4VkhObVSJr+38rT4cuLUUOHCvSk6ztjTFkS0
	r/0cgktL/clE+N2KV+Kgqg8a/IHflryMBwsAuNQKFGNPPQiCdu2FEytVqA+e77m9Yx/BhHHRnAS
	Cc8WcFHSg==
X-Google-Smtp-Source: AGHT+IEUb0wWaYqaM5kqBpgK9aVVKG1pMlQYSzWmT86Y+c9HRHIJ1jiVhozgvYKGm5nW3LhJsrXwSl0lDSn5aYze0/Y=
X-Received: by 2002:a17:90b:3910:b0:313:62ee:45a with SMTP id
 98e67ed59e1d1-32167105931mr8787860a91.13.1754571439428; Thu, 07 Aug 2025
 05:57:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: chen cheng <chenchneg33@gmail.com>
Date: Thu, 7 Aug 2025 20:57:08 +0800
X-Gm-Features: Ac12FXxUnE_7p2HletrQxnsNCzuIXlWAm-LnRXo31BbOosJCIPVIrHnFUA2GyEM
Message-ID: <CAD8sxFKbdvqruUGv-mr=AOCTyf_s778dqMMdDdNi9nTdgR5F+Q@mail.gmail.com>
Subject: md: In raid1_write_request(), when WriteErrorSeen and first_bad <=
 r1_bio->sector , why max_sectors is updated?
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

if (test_bit(WriteErrorSeen, &rdev->flags)) {
        ...
        if (is_bad && first_bad <= r1_bio->sector) {
                bad_sectors -= (r1_bio->sector - first_bad);
                if (bad_sectors < max_sectors)
                        max_sectors = bad_sectors;
                rdev_dec_pending(rdev, mddev);
                continue;
        }

        ...
}


When the condition "is_bad && first_bad <= r1_bio->sector" is true,
this rdev device will be skipped and will no participate in io, so I
think the following code snippet is unnecessary:

bad_sectors -= (r1_bio->sector - first_bad);
if (bad_sectors < max_sectors)
    max_sectors = bad_sectors;

So I am confused why we need to update max_sectors in this case?
