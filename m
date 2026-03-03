Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 425A937418D
	for <linux-raid@vger.kernel.org>; Tue,  3 Mar 2026 03:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772509065; cv=none; b=OeoRiG4gZ1r3hVzX+2VUrVXVAFSjcREBr1MwKQjia5NTr61HjpQNdDDBGLC2XyLf6C3a+Ob741otxKjslSkjew8Gds4Xos2DZxf7gLz9cAYiA+o+nlEcJV68+mQyMBOtJ5V1+Gep0WS0l8D4PrE8pJpRZQvdpatH1kJ+XnBoCyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772509065; c=relaxed/simple;
	bh=bWxk2lg/e5Bf5LmwZs/nIl1gufWVFi59zHdnExpXU30=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=k4kl/Z2adtZPi8TekBkixa75h4BOEkz4gI53hN3Sr7wTi+fOXqi4cU+nmediTGul/qLyfRRy3HOWfeFqImpW8h0rBtBMII19jY9vL1g0qr2fnkaxGTFsaGPSo5Kg7arxG7a2TEYo0I6ay0uy8d20S/3P7Ea3rLy90cbMQGKBhXA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Qs2BnBbW; arc=none smtp.client-ip=209.85.128.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Qs2BnBbW"
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-483703e4b08so45844715e9.1
        for <linux-raid@vger.kernel.org>; Mon, 02 Mar 2026 19:37:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1772509062; x=1773113862; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=+cF6oeTVhL8JCqKujm1jkmhguX1wHzhziEaJdKNaNIk=;
        b=Qs2BnBbWvNmJrH/lDVxGGbn13hUgxl4wVVE07pR4+qL0Opq5HiZ4X+UsHJKI3v4mby
         Cre3LmkZPGCaK/+t5qP9GBrR6kKuMDZEjV7EHKGMCYJduUGA4vw+wyTGGDYSOGEHPZVB
         gGtUBuGq5+yy7jfKucYPJvGxUHUS5giG6WwEW8qKQ8Z1nMYDm9oxmZp5UI8tm0qKrZXR
         eD/lLCeQ26oksKbTYPTltyZG11e3skR3/0+jmhyAWr6k2fbvH36+o5LAKSFJ4cioL31F
         HFsQ0rjrawE6PGdC7qisI4xllfX2v0AUhUpLb6v8XVul3eStaQa/PqHxw3l0fllSJI7z
         sZ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772509062; x=1773113862;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+cF6oeTVhL8JCqKujm1jkmhguX1wHzhziEaJdKNaNIk=;
        b=p0dUtysnNJZ9eEqjE4J+//eBv8SALoCt39wpb2KyMYUzQxW60sZ0SxWsaZDo2wOrkd
         3R+AQ1IpFWyOWko20m1FOFcnpIw4T/05Hd9UweMANLyZPrcoYn0i/Ktf3pRKlW2QUZLu
         SOGcWXXhW/ohpV6yXSppQGcSFfcVx2s6VPUwZEpR2dLisOOSizYYwWfXwaDfcQ7825EI
         HOufGEaVabxOKF2mOtYScGQbTO/437I7xEgGhLIY3smy4W+S501Tcy3dDSNuBciQ39IC
         UTLzWhIM2CtTqkIjNZsg3LxwM158W215OvRuqrzmpCDviG9JbjLaMAlXA7jaWdjCfmaG
         JKjQ==
X-Gm-Message-State: AOJu0Yx3WcP3jOidwmHk73nKfLEcV8ybHYrKqFk2bAL7CBvxgGvITZOY
	pSGlSiFQlTAenabBiFcA79lXS80VtUZ6wU8hnsO6el048FhYg4AuVvcoQlDZmRcJ3jZUDmGhHaE
	lJhrnkHGbHOZO
X-Gm-Gg: ATEYQzzeS89wU9ADK83z80i2M7tKN+4oRpOBJt7/hVH8h9/2F2jKPUUASNGlH76yXbI
	+7JeDzDyhMJvnfvDS+dk9jFfOF5eWFrzWemLZXqvGeQ6pmo9RYt0jYir7K31RTZFlNpJk4DlRBb
	x5LQeXdFVfALVYq/X60moHzVfmDJBrTRSF8hwOA28LnBDkKrE7buhEP6asH4+XUAAcGbpL4jUjx
	m8wXvRwAofTe0NxeAl88kxAk4sc+xhJ120chljkfaoPc9dnfc5HpH/qj3K2JAgrB/arbGJgwDNA
	aJ1kFuEgp+KALjOUMWR1ZEtShb5jmyq4byZHotPdhv5HqZOC8AkTTF9Lch+dkHP0iG4r4efASmZ
	T4jj4DMJd3eVxwgcj4Wt5Oh7BmxzDxDzR9HXCNS6I/9Q4HLe0G3eCoIhhqH3nYgQaY/tR4iki/d
	hjIhZATBfv0uVhAZKmnhbFmETH675IS1eq0U/9raA=
X-Received: by 2002:a05:600c:8206:b0:483:fbe:23dd with SMTP id 5b1f17b1804b1-48513e9b44amr9693405e9.12.1772509062358;
        Mon, 02 Mar 2026 19:37:42 -0800 (PST)
Received: from MacBookPro.lan ([202.127.77.110])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-2be16992009sm3929104eec.3.2026.03.02.19.37.38
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Mon, 02 Mar 2026 19:37:40 -0800 (PST)
From: Su Yue <glass.su@suse.com>
To: linux-raid@vger.kernel.org
Cc: song@kernel.org,
	xni@redhat.com,
	linan122@huawei.com,
	yukuai@fnnas.com,
	heming.zhao@suse.com,
	l@damenly.org,
	Su Yue <glass.su@suse.com>
Subject: [PATCH 0/3] md: bitmap grow fixes 
Date: Tue,  3 Mar 2026 11:37:28 +0800
Message-ID: <20260303033731.83885-1-glass.su@suse.com>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi, This series is to fixes bugs exposed by mdadm/clustermd-autotest.
The bugs are not cluster md only but also bitmap related.

I'll find time to add test cases to mdadm. Thanks.

Su Yue (3):
  md: restore bitmap/location to fix wrong bitmap offset while growing
  md: call md_bitmap_create,destroy in location_store
  md: remove member group from bitmap_operations

 drivers/md/md-bitmap.c   | 45 +++++++++++++++++++++++++++++++++++-----
 drivers/md/md-bitmap.h   |  5 ++++-
 drivers/md/md-llbitmap.c | 13 +++++++++++-
 drivers/md/md.c          | 20 ++++++++++++------
 drivers/md/md.h          |  2 ++
 5 files changed, 72 insertions(+), 13 deletions(-)

-- 
2.53.0

