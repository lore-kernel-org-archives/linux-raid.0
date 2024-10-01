Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2F861CF281
	for <linux-raid@vger.kernel.org>; Tue,  1 Oct 2024 22:53:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727823235; cv=none; b=YKdL9zPnzsnzLyrASJ3WbPNjSON8me6I2iIGZEOmAExPnXRlABmks8peMveCsNPnr52JQ+NtCVMeZ2O3zuL+LMQCzotjFB72Khnd5x1tHHfA17CVP8uu+3QfNQ1ZnT/aAg7uzvcN0dYk5YyJjMdk1Sy/zV2zP09EkIbWX1kqMSM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727823235; c=relaxed/simple;
	bh=oJX9Cxm/rlwJO0oi8ZN+9eljmG5v/FcSWtslVNmLINI=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=jT/WiEa/rMPLnZ5gLTj6wrsWjGPkiqIkiz55frI6G4GVz3LrmDQ0lZ2cJCpUvpYxNSEMunpfFxpU5F7LtLx4BodJeKrk95a3wz5tdjgGUXQN+f51V4Qo84YoFoGNSoONHSVeoYJ3428KyDLaiG+YYnDc7pCQf90t7ilIwcdk2tI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XmytI2Uz; arc=none smtp.client-ip=209.85.216.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XmytI2Uz"
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-2e0a5088777so4886057a91.2
        for <linux-raid@vger.kernel.org>; Tue, 01 Oct 2024 15:53:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1727823233; x=1728428033; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=osUnXKuc+8XrLbPJnwtnF5xKwNe6FmKMFD2gAc5sVTg=;
        b=XmytI2UzdinUUt1MeLghOAPkiYMqoZ4RwO6mEv8XhTKq8OWZf4mSDIppq/lzfvuOen
         yiU6VGZrqPDc6ie50eS3zC4U83B5l05SZr7yKBN4+Eh9P5JtwTVFzx5D1hJK3aRhBwKr
         WkQ1jIUe15RZSH+xCmrZdEgsVnJ/Z5BnU3tzy2nFUrBUtREaJZcz5fGxJo+P0vEbYNRb
         MiH7oVb4eJj24hwUlBw7dXReVJzN2PFvyRbsBRzdDu/JGhYedeks/vRl35ye2+Pv7hQJ
         bzidn+XBJeUg6z/Mkokc1R+CtqZ2O4EllIIQrV9Ntax4sU0VXO/SNc0R54hqiGijJc1T
         995g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727823233; x=1728428033;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=osUnXKuc+8XrLbPJnwtnF5xKwNe6FmKMFD2gAc5sVTg=;
        b=m/COMd2sZPkSC5GdvY3QGL8hsPWhf2bG+E0ivGvMvh8DIVkZ0GLCoqJWQ/VDsyAgXX
         hbNUSuILykV5jEGOjBhaPXmwvFRwn/2asJVoA94ybeVaY8iVAdlxEBh6lL8W8zFnSo9k
         swA9H4EyF1Q01vXqAiAJoMMmwMvdmmRlHN56X1eRLyRdXSWM9Wed5cR5Gqxhd507pWL6
         877tXAzSHf/aWQ6M+25ADuuV9JwaPdfbrrw2fyt4J5XbqrHc91PEXm71yCwuVZXImG9g
         CTguXTuXRdFDHPwqkA7UVlGNhqcJRwAfiQDcgPBH3pj++pbtHLOa2kBqiNaMgeMC5Sqk
         5GkA==
X-Gm-Message-State: AOJu0YzlTBN08Tjebl6B1tNaCQH8GTKTzupUzcZh8u5lBFIAuhVn4eSz
	tfFITJ6NhJJDhnGmTDmEfDolBSMACBlFVj7w5mEeYPI0a1sK1x0Ch2jgV0B+
X-Google-Smtp-Source: AGHT+IHdwJagNsgmtUTOJH2RAefLn11dI7wo5sqipOTwXaXIsrClMlUIW0+nj9zShwGL5buOe1seeQ==
X-Received: by 2002:a17:90b:4b43:b0:2da:6812:c1bd with SMTP id 98e67ed59e1d1-2e1846a0532mr1549758a91.15.1727823232615;
        Tue, 01 Oct 2024 15:53:52 -0700 (PDT)
Received: from localhost.localdomain ([2600:8800:1600:140::48])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-2e18f79134csm150666a91.17.2024.10.01.15.53.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Oct 2024 15:53:52 -0700 (PDT)
From: Paul Luse <paulluselinux@gmail.com>
To: linux-raid@vger.kernel.org
Cc: paul.e.luse@intel.com,
	Paul Luse <paulluselinux@gmail.com>
Subject: [PATCH] md: Testing new CI system - do not review
Date: Tue,  1 Oct 2024 15:53:49 -0700
Message-ID: <20241001225349.9161-1-paulluselinux@gmail.com>
X-Mailer: git-send-email 2.46.0
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This is just a test

Signed-off-by: Paul Luse <paulluselinux@gmail.com>
---
 Makefile | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/Makefile b/Makefile
index 8ad55d6e7b60..8f3a96880cef 100644
--- a/Makefile
+++ b/Makefile
@@ -1,4 +1,7 @@
 # SPDX-License-Identifier: GPL-2.0
+
+xxxxxxxxxxxxx
+
 VERSION = 6
 PATCHLEVEL = 11
 SUBLEVEL = 0
-- 
2.46.0

