Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9BA8313525
	for <linux-raid@vger.kernel.org>; Mon, 15 Dec 2025 07:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765785504; cv=none; b=OfoYn0HFI8Gs4m/hFcPGNpPySLolosfxm+yAIznWbWFAQJQ0C6gVstTfiEMN0AHQvuccsqKLcWH2gbqILZ4ExiKB1kOzjcyj20VB/01BI26dIqaLTZvMiCyuhEOhoajIvj5xiAzQpPBAHngCOBJlOo40IBswuVCSzTGVlEwMNJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765785504; c=relaxed/simple;
	bh=lnL7xnVTJM4vdLAS70820Us0HpqUvimUTsy8Q9ssKAQ=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=TnMc1q+gFyZvMHWc3vhcxpYN0YQie/38ryyOzb6iXY+JhsaJx6+Wj33cjcqq1zZUk9VUkjLYxcIDamAl7u6ToVuw2qEbZMhqn7rGbNSii5ag4+8nhyNP0xzUnWsmiheCZxCKPhEXY8Ei1xwQEO5BmaTdNBUC2pokBnFjl789QYM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=S1jzzpO4; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="S1jzzpO4"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42fbab737f5so1253066f8f.1
        for <linux-raid@vger.kernel.org>; Sun, 14 Dec 2025 23:58:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765785501; x=1766390301; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6o3JxY/YyuVqfOTRC7pypNTZ114kCk0kLmZS8eAtwbQ=;
        b=S1jzzpO4G6giKzfdhMx/82oOhGYoLmLu7D4Q6ysgAKmzwlcBSlblVcEOA3ts1j9K2x
         XD6/z6Hxt3k6jOALxFhP3MjfYMTkGUuBtH7Mqt0wH2mYEjxjzblt7Y/WZ4q+zreLqSBb
         PMBfUhXrqStoj976FOBgkYa1N2+5OxDAg5o97iVGxJaECuOObgdnn8B0rRzxH+eAvVFH
         kDiiH3zXdU78qgCqo98cb81Fq8xG0hzrgbpHjXTfEXoPdzcX4xdM3QEpyVWJEP8ztrhb
         a3Ubab4nbsAvgDSdmrKtLz53DZOzeWQqTvdPkgLgFrdtKpmELaKsQG+pHvSOc2u1zFEy
         59KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765785501; x=1766390301;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6o3JxY/YyuVqfOTRC7pypNTZ114kCk0kLmZS8eAtwbQ=;
        b=fbD5EfJoo3Qqu9O0DgngXRKk6Kmgit/dD5o0BvrwgDYkCEcF2JF7rWMHsUQ7dncPN/
         Bx3JkqZbLzf44CigoLn4vyW3ZV3YfkrxKtU/cLYE5s2IL/IFQc9xCNA3yrX9ftm8cG/V
         H16zQMt6NNbkRcsVhgqf0vXL9ZSKz6B2XyVZn0RH4IPboagpTjPFzzs0mYb85RScOCz3
         /xAWpi5ibw85/aIr/eRBQ+fBgQChk5A4Hib4i1lJz2LSG0C8Z5mP4BmBH6q+XPA3Lwh3
         jVoZAXZf4BdCotub5TfR5eLGx//F+0m1358hpXZFgHZ1ygepzVdoykgDcqnPmW/gInCr
         kUuQ==
X-Gm-Message-State: AOJu0YzeNuydJ7pewyFvAp/DX/zgMEwVAuO1LhuXiPVKTiKvq0BVulKj
	a+q70KPa4mQBE2/q323AtJulQdiqX7aPSPyIPFo4E59QE0DvQGbMmG0nLW0+Q7xkvB9YcmpVzfm
	5Lz2t
X-Gm-Gg: AY/fxX650Bdv5IokoBXIgRG60XBXciI6O8iwD5bZN0xfTZ/uywzBrOYuuyBS+uQymt9
	UxUO9XTRbxmFoGIfk8HKbW8vaDsrqe34XBgzynCWD0N9kN9UWZCinBK7XncN+iWs0CZ9owNZhmm
	hvEFyzMLwmzt1Bn4kgcANUKe+YV6y8c0C8+upN6NizTWLI2LH15wWm9hT2A1kxkRXf0F1MGv00o
	A3gwRzYpBDm0nZBJoBDjjgXZzXobpmMKe3ghnlZMAamosE+qPqfji13z1x7gMYiW7h/Q0GqD5xp
	oXd08bIajJpuKm43FwYgjnh7RfdqtezmF3A0/73ncnUwVZTV2o8cpTnca9oTrwqXx7FcASYbaaz
	eRM72Esx0ITI2cB8xwtzdXKJ0BCnHIjrtg1LYeW49XqooFc8yPE1eOCU7TxgjiBTyl9nG6lQdrY
	Cm8hPzR0Xtd9uj47EH
X-Google-Smtp-Source: AGHT+IGuOVvLsBNJK41jDf5mOvEUQkdxOJ8C3xx7Hx4pH+m1QnSok1PVSQimmsuBtKngbzybD/vB4g==
X-Received: by 2002:a05:6000:2888:b0:430:a803:e49f with SMTP id ffacd0b85a97d-430a8132a34mr8923115f8f.15.1765785500950;
        Sun, 14 Dec 2025 23:58:20 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430f7c3040esm8375493f8f.37.2025.12.14.23.58.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Dec 2025 23:58:20 -0800 (PST)
Date: Mon, 15 Dec 2025 10:58:17 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Song Liu <song@kernel.org>
Cc: linux-raid@vger.kernel.org
Subject: [bug report] md: Remove deprecated CONFIG_MD_MULTIPATH
Message-ID: <aT-_mc1MEKdpqkdZ@stanley.mountain>
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

	drivers/md/md.c:3912 analyze_sbs()
	warn: iterator 'i' not incremented

drivers/md/md.c
    3883 static int analyze_sbs(struct mddev *mddev)
    3884 {
    3885         int i;
    3886         struct md_rdev *rdev, *freshest, *tmp;
    3887 
    3888         freshest = NULL;
    3889         rdev_for_each_safe(rdev, tmp, mddev)
    3890                 switch (super_types[mddev->major_version].
    3891                         load_super(rdev, freshest, mddev->minor_version)) {
    3892                 case 1:
    3893                         freshest = rdev;
    3894                         break;
    3895                 case 0:
    3896                         break;
    3897                 default:
    3898                         pr_warn("md: fatal superblock inconsistency in %pg -- removing from array\n",
    3899                                 rdev->bdev);
    3900                         md_kick_rdev_from_array(rdev);
    3901                 }
    3902 
    3903         /* Cannot find a valid fresh disk */
    3904         if (!freshest) {
    3905                 pr_warn("md: cannot find a valid disk\n");
    3906                 return -EINVAL;
    3907         }
    3908 
    3909         super_types[mddev->major_version].
    3910                 validate_super(mddev, NULL/*freshest*/, freshest);
    3911 
--> 3912         i = 0;
    3913         rdev_for_each_safe(rdev, tmp, mddev) {
    3914                 if (mddev->max_disks &&
    3915                     (rdev->desc_nr >= mddev->max_disks ||
    3916                      i > mddev->max_disks)) {
                              ^^^^^^^^^^^^^^^^^^^^
The patch deleted the i++ so i is always zero.

    3917                         pr_warn("md: %s: %pg: only %d devices permitted\n",
    3918                                 mdname(mddev), rdev->bdev,
    3919                                 mddev->max_disks);
    3920                         md_kick_rdev_from_array(rdev);
    3921                         continue;
    3922                 }
    3923                 if (rdev != freshest) {
    3924                         if (super_types[mddev->major_version].
    3925                             validate_super(mddev, freshest, rdev)) {
    3926                                 pr_warn("md: kicking non-fresh %pg from array!\n",
    3927                                         rdev->bdev);
    3928                                 md_kick_rdev_from_array(rdev);
    3929                                 continue;
    3930                         }
    3931                 }
    3932                 if (rdev->raid_disk >= (mddev->raid_disks - min(0, mddev->delta_disks)) &&
    3933                     !test_bit(Journal, &rdev->flags)) {
    3934                         rdev->raid_disk = -1;
    3935                         clear_bit(In_sync, &rdev->flags);
    3936                 }
    3937         }
    3938 
    3939         return 0;
    3940 }

regards,
dan carpenter
