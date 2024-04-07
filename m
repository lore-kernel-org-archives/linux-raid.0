Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244693D576
	for <linux-raid@vger.kernel.org>; Sun,  7 Apr 2024 21:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712526658; cv=none; b=XR4OI/4z1vbh5Kmn3xGIj9DjSmYVmLLFtH/9WUDqz/kPp99cO7kmlJCV+w1zKKKdM3+eXJx8fofSOC725cFDOjWIAJK5i4RBGd6BFQQzZfQJzwQwcFbfNkNz2EJcnk8agNhAWoO0CRfQdWDT4TK8wqjgJXuOfIRfiipmp/EDwbM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712526658; c=relaxed/simple;
	bh=q9bB34yrTrN7+26ZiIknUHb6xnKLyvfXa80njLwq+dY=;
	h=From:To:Cc:In-Reply-To:References:Subject:Message-Id:Date:
	 MIME-Version:Content-Type; b=UC/6KUOZzepK1RpDILAeF4oZcQDojvaGeNrIiiE6WL/EXM5k+/7sGiKxxAQzn0/R6WEgl3x4QBoa78VqFdqI/jU/Q/bUcUo12tVHwuS82NBBhGUVyP/+RNW+BSaeLsp6Eaxb2ovWktxTJVGtXiqjBEUp+lU9syKarwFS8ixW1C8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b=kQb5x1Xy; arc=none smtp.client-ip=209.85.166.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20230601.gappssmtp.com header.i=@kernel-dk.20230601.gappssmtp.com header.b="kQb5x1Xy"
Received: by mail-io1-f42.google.com with SMTP id ca18e2360f4ac-7cc0e831e11so86355739f.1
        for <linux-raid@vger.kernel.org>; Sun, 07 Apr 2024 14:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1712526656; x=1713131456; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IFhGDEXqIbtR+UAjGGiVYjOWq205kUX/iLnpNybBY6E=;
        b=kQb5x1Xya7HsPCheSKbwTi7jUIrmfTS9HZXqG6UwWpK9m7rrU7XoHLe1nly3n7NVol
         8uwSaymdVVX17zEeX805m/wKLAd4hC3wrGo2zpEjn2jFM49GQ/Q6jBJ+KkChVrp4jGM5
         5fPBjrdkysRe2hewkY20JGvfENt36Y2jmtef6db9wpEY/4bkAjGmEX7Pvhds0HV6p2C1
         N0YSrxlOG6ssBgQagfeGc0hHZEU9Bsi/Ra416X3WJmrAH4oItQK3f2PJrK9bIgwvOm6M
         GfwthE7s9vOviAPp7ZIkpy3Muj1xx2MY9L6mFjmI+ZrOBrrsWlnKIfNPAU7ewhXz+2Vx
         8HwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712526656; x=1713131456;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IFhGDEXqIbtR+UAjGGiVYjOWq205kUX/iLnpNybBY6E=;
        b=cVdEo9lL0xbQqHq/cq6FqHmQgZCfkH6VciwTj6MdiD6ARfbTK3H6/6pTV7X0dF7xvS
         blTTtyQha3erbxtyyPJEL4fRQz+98wUvLTFR48ZgXQXdMrvD6eGBGDz0AOqqIPD3PYg6
         0mA8pvF+KFRHZYtmZpVVf4QU1bbGxGit/WTc/A6HtL/LJx/+w3kTBxyF3pCHSoLiFjrm
         LDuhZxhAwrksTDImhcuG0k9XdCtd1+luAvALU1QilX91Zr7iW4XjDkli2kMz4AopV+Nt
         vWj5apTDXS3jniFeaRIRPLlngTy+a0vjkmtEYN2j33NKYsC+ZGFBBa8v1X7g9kQH8PRn
         1YYA==
X-Forwarded-Encrypted: i=1; AJvYcCX5tZoHBNYr1XQgT25S417wT/BBNBi3tlRPmjYNF8GJQjwWy8or7clDzWgebEZit0DikO9DPCSHQI6OATKwOvuiU8yxfrf/h8PLfA==
X-Gm-Message-State: AOJu0YzFhZhG5Wf/iOaN8Ahiqb9Qa8Rc+qB7zv3FFW+ykU+U1Pk7ekJh
	sr4spAo88eEsh55ys6QGo3XQnDx03xc14RBfirnYI5S+YUChM45g7DWNV4ZqaG0=
X-Google-Smtp-Source: AGHT+IGeQLkiyNOEpEcA0eZIatdoZcDvnlZBaLWFYUJxiaD4EhRF1lLJaYaGiFa9TdaHA1ylA8nh+g==
X-Received: by 2002:a05:6602:1644:b0:7d5:cc9e:9d96 with SMTP id y4-20020a056602164400b007d5cc9e9d96mr4771043iow.1.1712526656251;
        Sun, 07 Apr 2024 14:50:56 -0700 (PDT)
Received: from [127.0.0.1] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id o8-20020a05660213c800b007d5d40a4910sm993714iov.5.2024.04.07.14.50.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 07 Apr 2024 14:50:55 -0700 (PDT)
From: Jens Axboe <axboe@kernel.dk>
To: linux-block@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Cc: janpieter.sollie@edpnet.be, Christoph Hellwig <hch@lst.de>, 
 Mike Snitzer <snitzer@kernel.org>, dm-devel@lists.linux.dev, 
 Song Liu <song@kernel.org>, linux-raid@vger.kernel.org
In-Reply-To: <20240407131931.4055231-1-ming.lei@redhat.com>
References: <20240407131931.4055231-1-ming.lei@redhat.com>
Subject: Re: [PATCH] block: allow device to have both virt_boundary_mask
 and max segment size
Message-Id: <171252665540.2536278.16554247338004438050.b4-ty@kernel.dk>
Date: Sun, 07 Apr 2024 15:50:55 -0600
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.12.5-dev-2aabd


On Sun, 07 Apr 2024 21:19:31 +0800, Ming Lei wrote:
> When one stacking device is over one device with virt_boundary_mask and
> another one with max segment size, the stacking device have both limits
> set. This way is allowed before d690cb8ae14b ("block: add an API to
> atomically update queue limits").
> 
> Relax the limit so that we won't break such kind of stacking setting.
> 
> [...]

Applied, thanks!

[1/1] block: allow device to have both virt_boundary_mask and max segment size
      commit: b561ea56a26415bf44ce8ca6a8e625c7c390f1ea

Best regards,
-- 
Jens Axboe



