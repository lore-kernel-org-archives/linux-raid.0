Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6814145FE0
	for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 15:36:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731339363; cv=none; b=Mtav73h8Wav5WkQ6tUAoe7kz68212bjaYNjPRxauhf75KsdHKWzJ7hRMBZo4IiiePQIcfrLhcxaTi+iGHdLkpbENWRxsRi0krmSiClJgnCKEIAH+tha+KQNPmE8afIB9mmxwWmh4h4WbfQOgLkivD6lKthEFBjsULLtF0M0wri4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731339363; c=relaxed/simple;
	bh=OBRfdUOhUc18FSDoG4WeOQwkCPsFwRa+ZgkLbMnSqNg=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=aQ2NL0Zm9LQxrodJMz60DiY9I9OxAbnM3xOwH6l/r3BPHXjnO5E+WQcLvW1NlyqX0z3k7JtCBiNSMJ910k8kdLn2nP84/j0kaUUb1adhUDyHX09F52FLqGZtWcoABGBe1Qff1z5zXtGelre+ItUOZFpDULYZLtXEWXtVuWfQCns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=ZyydijVb; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="ZyydijVb"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3e601b6a33aso2684343b6e.0
        for <linux-raid@vger.kernel.org>; Mon, 11 Nov 2024 07:36:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1731339361; x=1731944161; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S46mhgRP3J5A5d+3Z7kJ6fAD51PqjNfpb9mTVeDYByI=;
        b=ZyydijVb8NzYaSCxZwX/2i6atVavIRkfN1HWCHY/alR14B0HLe5/pdb8uOJyCkGhFW
         d+GldpEbCpxyjbF8slihwR4YymWbw8ZuuaM8oA3qG58QJ861lhJSlaO58l7TzAFwQT0v
         wxNIqBXqBIQfkr+rhZwt0ZuLlgGli4n+1Za526aQX4Z8JgVwPbCwIXwyB69AoRk0vy+k
         Rxx96cOer2MLpJ1qXOboNTG32d1XYTnlv54DbUNsn+UfYvXZDkxJboj+Ljfqt9/riCmF
         CsDmF7sF1NlaykDFgwmwipcIuTQcnPc7BMkTaXMin7Ntdip/9Rv6B0IJHklU4uNkMB/V
         x2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731339361; x=1731944161;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S46mhgRP3J5A5d+3Z7kJ6fAD51PqjNfpb9mTVeDYByI=;
        b=NmkdcPWEoERA+6iwpKJExpuMlRIFqS8rrjj27IHp6rnl27TNAH64vUqSl8sgAf74+c
         euHqA6tDBbCazjJ50/u2b03g91G6T5fYtr5oiMuWh7raGcjUvLdFnc39Nbxva6yzqtRZ
         Z+RoYtvX7sWVahT3dlaD5eQ4SsiTyK74+R6+J2tPVH8o7Nc9rylGUVS78IRXb32Jpc13
         HhLAnsd0IhRo8KqASInh83t01mkn0EacdTZfDiVXHbW7BDqMuu9pRomqU/nbbrOKk5Dy
         d79/wMbfXnMdJQAclyk9Ey2Jy3seqIm+6Qd+wPOoAIEeFhSp9ueHj5z37h0YNxeX4JN6
         C6tw==
X-Forwarded-Encrypted: i=1; AJvYcCVwEFO9ctPAOv8O0P9sXXff9CaSuYzd0NfO/fQMNbIhlAZkZqJOMdNVyju1k5dNEsl0Dy+Ww4hk7tRS@vger.kernel.org
X-Gm-Message-State: AOJu0YzconjAeb0ghVlchtRWVcbEuHTuP8CHd8OiYflKugEekeqeO1sb
	sbycd2b6WC9Xq0jyeviLwdXgGexA7rzEK+c7OST64lBzXtA/wCZhXNGfjy2+zXM=
X-Google-Smtp-Source: AGHT+IFvznCtuLrDpkKB0XoerwZtjF/Nue50YwF2kIdZ94QrpZpe7NHwx230HHEdCVWg6u8n84ozaQ==
X-Received: by 2002:a05:6808:f09:b0:3e6:ad7:9a38 with SMTP id 5614622812f47-3e794685550mr10424004b6e.24.1731339360892;
        Mon, 11 Nov 2024 07:36:00 -0800 (PST)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3e78cc678d8sm2116943b6e.7.2024.11.11.07.35.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 11 Nov 2024 07:36:00 -0800 (PST)
From: Jens Axboe <axboe@kernel.dk>
To: song@kernel.org, yukuai3@huawei.com, hch@lst.de, 
 John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, linux-block@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org, hare@suse.de, 
 Johannes.Thumshirn@wdc.com
In-Reply-To: <20241111112150.3756529-1-john.g.garry@oracle.com>
References: <20241111112150.3756529-1-john.g.garry@oracle.com>
Subject: Re: [PATCH v4 0/6] bio_split() error handling rework
Message-Id: <173133935959.1861985.10564315713118419113.b4-ty@kernel.dk>
Date: Mon, 11 Nov 2024 08:35:59 -0700
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.14.2


On Mon, 11 Nov 2024 11:21:44 +0000, John Garry wrote:
> bio_split() error handling could be improved as follows:
> - Instead of returning NULL for an error - which is vague - return a
>   PTR_ERR, which may hint what went wrong.
> - Remove BUG_ON() calls - which are generally not preferred - and instead
>   WARN and pass an error code back to the caller. Many callers of
>   bio_split() don't check the return code. As such, for an error we would
>   be getting a crash still from an invalid pointer dereference.
> 
> [...]

Applied, thanks!

[1/6] block: Rework bio_split() return value
      commit: e546fe1da9bd47a6fddce6b37c17b1aa1811f7d3
[2/6] block: Error an attempt to split an atomic write in bio_split()
      commit: 27b26f09a7e6ae3ecae460299349b31fe0b5452f
[3/6] block: Handle bio_split() errors in bio_submit_split()
      commit: 6eb09685885a4445da31097aa6418ee1875f9cec
[4/6] md/raid0: Handle bio_split() errors
      commit: 74538fdac3e85aae55eb4ed786478ed2384cb85d
[5/6] md/raid1: Handle bio_split() errors
      commit: b1a7ad8b5c4fa28325ee7b369a2d545d3e16ccde
[6/6] md/raid10: Handle bio_split() errors
      commit: 4cf58d9529097328b669e3c8693ed21e3a041903

Best regards,
-- 
Jens Axboe



