Received: from mail-ot1-f49.google.com (mail-ot1-f49.google.com [209.85.210.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8109631F980
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 04:41:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782276081; cv=none; b=Bt0x62ozRaWyMESNpYymDn5oeb02GCi3/oMdCelRLr/71/aIycsemSFdWiijhcB6+5/Zs9kTr1PRQcezw2CQSVbcrHb7lftJb3cBbWgsLdfqCWZQhJXxrxXsDFn1DKN7UttNiGj8SE0OkInZLqGta+iWmuYenvtsrRpQBfSv3+c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782276081; c=relaxed/simple;
	bh=HLVy3TH9ZBdUC9IImCHUkld1iGj1Bi82eoMFoRdb5ZQ=;
	h=Mime-Version:Content-Type:Date:Message-Id:Subject:From:To:Cc:
	 References:In-Reply-To; b=jtt0xzxOuGsyj/wfVoUk+aPguQvcjjIoM9y59utH5hMNTliMNjfSKBcPjO/m5I88Kx7bj/HKYzJSpPnR/T4H+D1WFZOt6GzmqNjkpiLu5uKmzb/i2acFH5jWaHUhBB0H6eOE/sufYim37iFD21AZX/Wh3f9fOSHjpTJu9CvHhgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brighamcampbell.com; spf=pass smtp.mailfrom=brighamcampbell.com; dkim=pass (2048-bit key) header.d=brighamcampbell.com header.i=@brighamcampbell.com header.b=dFdW+1KB; arc=none smtp.client-ip=209.85.210.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=brighamcampbell.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=brighamcampbell.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=brighamcampbell.com header.i=@brighamcampbell.com header.b="dFdW+1KB"
Received: by mail-ot1-f49.google.com with SMTP id 46e09a7af769-7e9784666b3so462261a34.1
        for <linux-raid@vger.kernel.org>; Tue, 23 Jun 2026 21:41:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=brighamcampbell.com; s=google; t=1782276079; x=1782880879; darn=vger.kernel.org;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HLVy3TH9ZBdUC9IImCHUkld1iGj1Bi82eoMFoRdb5ZQ=;
        b=dFdW+1KBYGjXfylBMsWb0NFdBjvzcNg3F1lAnM6D9EBrnEHkDGJ9iQXiLimgvmztRt
         cq5yv5ICYjIe0QBXgZg7yPbT7/Mp3mGNWPKV4S1VR5bTLlLsIjoSWSQd1Q8H9WqHTTBZ
         TN3dErlJW0rCdrg1utmYkqxUkso8DkxfHscLTdbXrdlPqS6mk+GbPQsVBAmPm0SJlTdL
         NogSLv2skFm/bz9Uh2fU6WnterWssxngIkrAGZfAO1HYuLgliL683TAMuxYLf5NYuaoK
         WAyeCzxX+V2uYDfGVIupSS/VKvJCcVT2EJaaLK95G3vT62IDSlgvX3o3sBFwZDhBc5J2
         EKuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782276079; x=1782880879;
        h=in-reply-to:references:cc:to:from:subject:message-id:date
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HLVy3TH9ZBdUC9IImCHUkld1iGj1Bi82eoMFoRdb5ZQ=;
        b=DUvPJaZk9ZsBTTV+yhTdWPbvwDxNgTUFSaGsEoYUs1Lwb5FOHJL+X3c/M7O5EGB7z0
         7HCZUJd70fBd1wzWPzVdMF4ODVysvXJ318doiE5kBVbVrIC4d6glQIIfZyWhRsHslfAk
         shIHJzVWDdXXzVorxjuJGz7RSz8IIXtfNRAmx3bU/el8ulN79oAeH1pRj1z2KCXTtpgT
         dhSYu54Ve38JDavqrvkoYrqbBsfm4yvU4ctVHRuSC7AxXZmWqIu08F+xfGEu9uEGTB+S
         gzND5DLrSNOwhzfZmcb3x+yAKhk3ww1MN8arkjBMY8TX3dk5jKxlka9GSdnbSg6CwHmJ
         r73w==
X-Forwarded-Encrypted: i=1; AFNElJ/iTFmxGFgWDz6Le8LdygU7qSvGszSWEusPLVNUTX8yFrc0j6Hcc2K8L+ZElsRHuFNDTClMU91ZGBMn@vger.kernel.org
X-Gm-Message-State: AOJu0Yz0o3ZK8c0RQ1+kn/Sydib28mPH+kmY8ngwBQX/XljzstmHbI5m
	XMXsuDXcCM3PKpMVxdiMoWY9qFYSyw/y+ORhWQRxtQ2KdEhWSZN4xghftjsSQHAMPUc=
X-Gm-Gg: AfdE7ck5J4T4uVpekymzzjbZuyDFjl1hf6WPnqdpI100e3ViVL1p+bxCVwHXMZQOYTY
	D+ijSfFYGrlQsyM0uiRCtzpRfHSWGeOylF0TaarS135MveQqcmqvud8cpJwVwgNrfEZyiKkfMFw
	lP8Wl5CiEmAiPIW5Ch4n9g695w/qWgd14ebvJ5V+OeFxw9E73XTDdPGfj+rS5DAiB4VXc3FlQx2
	YGtr2lbNtFqzSYpoUcOjFnTGtaqI9TCqGg7xVkM3i+OmjllwUZg6yBASK5wTHAYWz69dXlmijiv
	voTHYPGgcDmD8enmLzTTcM+0/WtTYjuJ+q6fDGTGe6MK5Axpu3npTVdLuyxUubrDTuO3CSI1kAv
	CmeRj71jhGBV3KdPUMlJN3gzk8Zei99frk855fYx3pV1Sj4awi5KlhlSmztynu3eKf++GrlxWyD
	KrtzQg1LvXJJvj9jGtkalXZpGTmVxZyHv9hr3EXdCGavuBF/YksfrW6+fXEmZX7wXZkOgU
X-Received: by 2002:a05:6830:6508:b0:7dd:9b19:a875 with SMTP id 46e09a7af769-7e94083e3b9mr14683547a34.2.1782276079546;
        Tue, 23 Jun 2026 21:41:19 -0700 (PDT)
Received: from brighamcampbell.com ([2605:fb40:0:c09:9ca9:e0fd:b7cd:be76])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e944068bb7sm10280395a34.9.2026.06.23.21.41.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 21:41:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Tue, 23 Jun 2026 22:42:47 -0600
Message-Id: <DJH0687PNY2P.1WOW0ATJ2KZA9@brighamcampbell.com>
Subject: Re: [PATCH v2] md/raid5-ppl: fix use-after-free in ppl_do_flush()
From: "Brigham Campbell" <me@brighamcampbell.com>
To: "Sajal Gupta" <sajal2005gupta@gmail.com>, <linux-raid@vger.kernel.org>,
 <song@kernel.org>
Cc: <yukuai3@huawei.com>, <tomasz.majchrzak@intel.com>,
 <linux-kernel@vger.kernel.org>, <error27@gmail.com>,
 <skhan@linuxfoundation.org>, <me@brighamcampbell.com>,
 <linux-kernel-mentees@lists.linux.dev>
X-Mailer: aerc 0.21.0-0-g5549850facc2
References: <20260622142146.56637-1-sajal2005gupta@gmail.com>
In-Reply-To: <20260622142146.56637-1-sajal2005gupta@gmail.com>

On Mon Jun 22, 2026 at 8:06 AM MDT, Sajal Gupta wrote:
> Compile tested only.

It looks like you're on the right track, but this could use some
testing. My analysis here may be incorrect, but it looks like it should
be pretty easy to test this patch by compiling and running on a system
with a RAID5 array, PPL enabled, and no RAID journal. I expect the call
stack would look something like the following (feel free to correct me,
anyone...):

ppl_do_flush
ppl_stripe_write_finished
log_stripe_write_finished
handle_stripe
...

To be sure, you can add a tracepoint[^1] inside ppl_do_flush.

Dan was probably reluctant to make the change himself, opting to instead
submit a KTODO because the change is relatively straightforward, but
testing is a little more involved. Testing is particularly important
with respect to subsystems pertaining to the filesystem because latent
regressions could mean permanent data loss.

Cheers,
Brigham

[1]: https://docs.kernel.org/trace/tracepoints.html
