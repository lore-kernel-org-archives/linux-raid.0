Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C6E61B812
	for <linux-raid@vger.kernel.org>; Sat,  4 May 2024 11:23:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714821839; cv=none; b=ctsE8M02UXTh40lIw4fin+3wGaMWxmoPnYpxyO28HKzUUe8oIgqVYesMstb/mSq1OcSpdNe0eu2jg5EAM1MX652ISfU6wU+EmJfjrcuArY52dD9nsDYWKC4aPLea4P1P9xaFp1g+MIy53rR0/fUJ/7oCfIuiWiM8ZBIZZXJWA4g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714821839; c=relaxed/simple;
	bh=fU8ML4LzfQdqdThTRc0cQ/4ZTZv4LUoaAc13Umh28YE=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=bNPd0hVUpLLY5e5BIZT51p1KppcEx5lhkLh1AulwllohUNxKczbyhFFSABRi7ABp7fRYkXuaqGhabyG0poEeMzu2smfGA38FO71V//wf13gtQNbHYpwyYR7EV6GXgD5cCUGsipUzqcVXABzudgCVCbVh1/4C6tL9yf1P5RW+/qs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=hfrmzGeu; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="hfrmzGeu"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-41ba1ba5591so3861375e9.1
        for <linux-raid@vger.kernel.org>; Sat, 04 May 2024 04:23:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714821836; x=1715426636; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=XwUnGMTgMrz7EvdPYsKJzkT55JujcXk2FH0kEMH5o8w=;
        b=hfrmzGeuz+BAooc9yjqjbXIsIOR2+ZRZA2x1IyFklOHQMlK+6ZrppWh2je5QoN1HMR
         AhkDuBJGfhOMHLV+ZdRJY9fAsHY1JnbvhFNk6Ckr8oWbmP2zDeYG2XApGZmzbolMnb5+
         J3LmRhQxjc3o3aWk8WsfM9qITJvVDGa3S6r9aVhStMiKY97CiAK9Gn5KYPwj1V35ArJw
         UBL4+GMNMSohh1oXBf61X5UycqhyeUqIgVCzASiOntCFQTtAHkteK4mbqpQ2yiob95BM
         GVXEvRb8O14ua2hJiduC2BDhr2F/33cPnyhj5LNsmDVe6LargBJILwZj862snEOsrmsn
         UfpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714821836; x=1715426636;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=XwUnGMTgMrz7EvdPYsKJzkT55JujcXk2FH0kEMH5o8w=;
        b=v46lplFvnOg1JNkwnwB4mFVup6BQN6SRjUFkzDxj2Q8WTD/bIi8zqDhAe3tAqQr+Yc
         OQeKR9OCVzsMLpSVb6Hb2Itb79MnX4HvWiz7hhT8SHuS5Zd1pFnuuROZkPEm4h8dhqss
         czf3PBmnl5C7eUfV2vZJe093nM4/77Z5dqhGd8jIQv3QJrOcd06VTGfrU6EMSmvf3opw
         3DVbRub7U2aPCLpND8oYHg6zftk8MY2JYLmp/F91S1lLtJxCCOmf/BoRD2aZu8FMGGz5
         5mgj2pId4+saCe1jMUpjBNjfL3Cx2kN2punOYEY7ZjhD7p6MUq4dJ44mfM80Dc86aX0C
         1sXQ==
X-Gm-Message-State: AOJu0Yx/94W4O5JV1jWSebCrFW8JabEERqROFJA4ee5LbYHhcCkfTrsm
	f4R5q+l45MaCDkpC+UFBa4OEO2ThS+tlR2qilFvrFj9ZFDz1u9nyvSdIiEPVaRo=
X-Google-Smtp-Source: AGHT+IHVRpGPKfJ9gA5yWQOD54cioz4XZqYyU9WeW6/O24GvXKChL8DWQDoUEy5uk/8AyCpDP4XxPA==
X-Received: by 2002:a05:600c:354a:b0:418:f991:8ad4 with SMTP id i10-20020a05600c354a00b00418f9918ad4mr3948345wmq.6.1714821836263;
        Sat, 04 May 2024 04:23:56 -0700 (PDT)
Received: from localhost ([102.222.70.76])
        by smtp.gmail.com with ESMTPSA id j12-20020a05600c190c00b0041c120dd345sm8941598wmq.21.2024.05.04.04.23.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 04 May 2024 04:23:55 -0700 (PDT)
Date: Sat, 4 May 2024 14:23:50 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: song@kernel.org
Cc: linux-raid@vger.kernel.org
Subject: [bug report] md: Remove deprecated CONFIG_MD_MULTIPATH
Message-ID: <ededd928-dbaf-46f5-b358-d0a075c9090a@moroto.mountain>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Song Liu,

Commit d8730f0cf4ef ("md: Remove deprecated CONFIG_MD_MULTIPATH")
from Dec 14, 2023 (linux-next), leads to the following Smatch static
checker warning:

	drivers/md/md.c:3862 analyze_sbs()
	warn: iterator 'i' not incremented

drivers/md/md.c
    3861 
--> 3862         i = 0;
    3863         rdev_for_each_safe(rdev, tmp, mddev) {
    3864                 if (mddev->max_disks &&
    3865                     (rdev->desc_nr >= mddev->max_disks ||
    3866                      i > mddev->max_disks)) {
                              ^
There used to be an i++ but that patch deleted it.  Should i just be
deleted?

    3867                         pr_warn("md: %s: %pg: only %d devices permitted\n",
    3868                                 mdname(mddev), rdev->bdev,
    3869                                 mddev->max_disks);
    3870                         md_kick_rdev_from_array(rdev);
    3871                         continue;
    3872                 }
    3873                 if (rdev != freshest) {
    3874                         if (super_types[mddev->major_version].
    3875                             validate_super(mddev, freshest, rdev)) {
    3876                                 pr_warn("md: kicking non-fresh %pg from array!\n",
    3877                                         rdev->bdev);
    3878                                 md_kick_rdev_from_array(rdev);
    3879                                 continue;
    3880                         }
    3881                 }
    3882                 if (rdev->raid_disk >= (mddev->raid_disks - min(0, mddev->delta_disks)) &&
    3883                     !test_bit(Journal, &rdev->flags)) {
    3884                         rdev->raid_disk = -1;
    3885                         clear_bit(In_sync, &rdev->flags);
    3886                 }
    3887         }
    3888 
    3889         return 0;
    3890 }

regards,
dan carpenter
