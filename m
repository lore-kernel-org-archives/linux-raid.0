Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 989A92DCF43
	for <linux-raid@vger.kernel.org>; Tue, 13 Jan 2026 05:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768280774; cv=none; b=t/06N1iUIzycZwSdF6kWF67VmalroRujKmOVsVLZewreYrqjp3+bTVtUxW4/cTZcAYquNOHUOnZzM6K6BWDaWmsMKYVgZa/w20vHY7jsUkTWzl1WAYs5WSxaRXObsd/u6pVnaqpvbIt2YRfXxKh6loo1FsV6qvjzKQCBqLnpLl4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768280774; c=relaxed/simple;
	bh=ZRs7nOjpbmPf2i/oYubJ7/RTrssGnlbR35UjhHIKHOM=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To; b=k/eI4B6IgwzyKZ1xZAMjl/X3NNMEwhQl6NsKUA1mlRBIwWOCJ8dLPdevsYc5MmTSIUpSd2lqf2mXhhZZreVc4wDr3tOYLWr3jDsVbHPoINeWnYHUXdQNYiAwbCmeLevNoO8IZEItUjBeASoT1AOsznSVUQa/W8V2m4IU/d+P3OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v7vY4Uzv; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v7vY4Uzv"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-47a95efd2ceso61378115e9.2
        for <linux-raid@vger.kernel.org>; Mon, 12 Jan 2026 21:06:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1768280770; x=1768885570; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PXsXC2ZWqdZ05RwRyvB7Fu40TmpP1HJZeKqUVJy6PqE=;
        b=v7vY4Uzve3NuRfxBsVbkocGUez7l7CCDfhxg5VOZTYqDuPG6WFIk3FgI/wg0m3wA9n
         X5/me0KGSt9kwzb/cWIoNOxxKwWa16a48zWVDCaTWC/XCwus2e/pGuoZhprSgXpTTXt9
         qYDfmZak2ybRaYE6fzNv6+ji7y11TfY3LhmMKLJJd9Bq5SZJ58JFYgx/t5bs+6QAT+Wu
         BMZ6wiPZuLLcjPRpBP17I5ywYcBoBjd+mOscQeYEELCU6XasS55PoQMvkUko6Ke3r5Yx
         ufVzrMQVlxnX6dRzn9Ess6caf17shKM1O8uxfh/qNCKTwS+9BqzlAI0iiVW1zeqEuMtf
         696Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768280770; x=1768885570;
        h=in-reply-to:content-disposition:mime-version:message-id:subject:cc
         :to:from:date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PXsXC2ZWqdZ05RwRyvB7Fu40TmpP1HJZeKqUVJy6PqE=;
        b=Xhneuvq+0tn/kTHzo1RyzOdtN8VEPM6LkgftzGZa/wBsZ98vGyyRI/TV3kllwJmDeJ
         XC8TCe/E/QTn/9m4ZRlvQkjjI94TxG7eBfDuf4RZ5U06N5mM3OpG1NS4joDYMctwibvL
         cEjkkzkvpvAk11yFmpeLlcb3x8Bmz0QjfCBY98kpfTXeMSYpPCVFeCF9JnmuXrlrL9Pg
         J99Zm7ZgKG943C2ulQU5gv8bASymaVNYcSgcFxHxRTOWV927xi8AkCPgOkvmwue3Udei
         P5jBZnHzRwo0rQis7r0CNOiFiVe4efADJlgkd552ie3JUXItxJO9KqeVRRyJRWf3S4pq
         G6LQ==
X-Forwarded-Encrypted: i=1; AJvYcCUeF9emKu+c791Csuvud3epprC2QMNdyTK1KdnglGumOCW9dN6Fqn9daPzWdn7eGmosgz9jH2Pf4wxa@vger.kernel.org
X-Gm-Message-State: AOJu0YyPKJlr0CRVht/kJfspiC65wy2t02DCAy+SR22XikHPybB3lvS1
	vF7U1/bBlv+OHeZ109aRX+KCwPuYiCM25RW0Wl8dXr8Dd8u/i8hWxaYJ15JF5+aIDd8=
X-Gm-Gg: AY/fxX76ZJ/jM1nZThJBJYRlpfiolkDkY7iFpSaelnqSp3QwR6rtYeHld4aYhuG4V61
	SGDjtIGgxJGYcG//d4Z+5A/M/slFzh8/YLvQGlgy4xUBXrlczS0qgoe/W6nyEjBlG/mYXUcw/+r
	BgKNM5pNOgdf6dFyUwBgL6ftbdVEb+6l7On28vll8bpolyeAYwbv0LyzQ25QFneFq+eO7I1h1l0
	avSA8sNR+chbsJqrfWZDgpscC3qXjqEKMGYdP9m2jBhyVPcqm0CIHy95/zGnQ/j4Q3zqY0cfuJc
	8Nx7298unMIBm2OriDC1UtHdk263mLa2Z7hTrUQl44v4Io+O/ZcmlMBGCATVYBnY217wKnC4Mrf
	ljnmOeCxd+3Z32rXUs+uyKR8dye0rwArNN1pJnkSCbsICzSqzadAXFKMYKFUPMUq4/nWTapcdrA
	rH7AawBBoEKRGrz9r4
X-Google-Smtp-Source: AGHT+IFNpkwV3j4miP//2DleZDjCdvG1hsMO5y0qYpkeSRibSBP4A7EuJNtf2C1Yrzp7b1z3gUPIfA==
X-Received: by 2002:a05:600c:4ed3:b0:47d:6140:3284 with SMTP id 5b1f17b1804b1-47d88fc1df4mr211374195e9.37.1768280769725;
        Mon, 12 Jan 2026 21:06:09 -0800 (PST)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47ed9eb73d8sm6881695e9.3.2026.01.12.21.06.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 21:06:09 -0800 (PST)
Date: Tue, 13 Jan 2026 08:06:05 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: oe-kbuild@lists.linux.dev, Yu Kuai <yukuai@fnnas.com>,
	linux-raid@vger.kernel.org, linan122@huawei.com
Cc: lkp@intel.com, oe-kbuild-all@lists.linux.dev, yukuai@fnnas.com
Subject: Re: [PATCH v4 05/11] md/raid5: make sure max_sectors is not less
 than io_opt
Message-ID: <202601130531.LGfcZsa4-lkp@intel.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260112042857.2334264-6-yukuai@fnnas.com>

Hi Yu,

kernel test robot noticed the following build warnings:

https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-merge-mddev-has_superblock-into-mddev_flags/20260112-123233
base:   linus/master
patch link:    https://lore.kernel.org/r/20260112042857.2334264-6-yukuai%40fnnas.com
patch subject: [PATCH v4 05/11] md/raid5: make sure max_sectors is not less than io_opt
config: i386-randconfig-141-20260113 (https://download.01.org/0day-ci/archive/20260113/202601130531.LGfcZsa4-lkp@intel.com/config)
compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
smatch version: v0.5.0-8985-g2614ff1a

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
| Closes: https://lore.kernel.org/r/202601130531.LGfcZsa4-lkp@intel.com/

New smatch warnings:
drivers/md/raid5.c:8100 raid5_run() warn: missing error code 'ret'

vim +/ret +8100 drivers/md/raid5.c

cc6167b4f3b3ca NeilBrown            2016-11-02  8064  	pr_info("md/raid:%s: raid level %d active with %d out of %d devices, algorithm %d\n",
cc6167b4f3b3ca NeilBrown            2016-11-02  8065  		mdname(mddev), conf->level,
^1da177e4c3f41 Linus Torvalds       2005-04-16  8066  		mddev->raid_disks-mddev->degraded, mddev->raid_disks,
e183eaedd53807 NeilBrown            2009-03-31  8067  		mddev->new_layout);
^1da177e4c3f41 Linus Torvalds       2005-04-16  8068  
^1da177e4c3f41 Linus Torvalds       2005-04-16  8069  	print_raid5_conf(conf);
^1da177e4c3f41 Linus Torvalds       2005-04-16  8070  
fef9c61fdfabf9 NeilBrown            2009-03-31  8071  	if (conf->reshape_progress != MaxSector) {
fef9c61fdfabf9 NeilBrown            2009-03-31  8072  		conf->reshape_safe = conf->reshape_progress;
f67055780caac6 NeilBrown            2006-03-27  8073  		atomic_set(&conf->reshape_stripes, 0);
f67055780caac6 NeilBrown            2006-03-27  8074  		clear_bit(MD_RECOVERY_SYNC, &mddev->recovery);
f67055780caac6 NeilBrown            2006-03-27  8075  		clear_bit(MD_RECOVERY_CHECK, &mddev->recovery);
f67055780caac6 NeilBrown            2006-03-27  8076  		set_bit(MD_RECOVERY_RESHAPE, &mddev->recovery);
ad39c08186f8a0 Yu Kuai              2024-02-01  8077  		set_bit(MD_RECOVERY_NEEDED, &mddev->recovery);
f67055780caac6 NeilBrown            2006-03-27  8078  	}
f67055780caac6 NeilBrown            2006-03-27  8079  
^1da177e4c3f41 Linus Torvalds       2005-04-16  8080  	/* Ok, everything is just fine now */
a64c876fd35790 NeilBrown            2010-04-14  8081  	if (mddev->to_remove == &raid5_attrs_group)
a64c876fd35790 NeilBrown            2010-04-14  8082  		mddev->to_remove = NULL;
00bcb4ac7ee7e5 NeilBrown            2010-06-01  8083  	else if (mddev->kobj.sd &&
00bcb4ac7ee7e5 NeilBrown            2010-06-01  8084  	    sysfs_create_group(&mddev->kobj, &raid5_attrs_group))
cc6167b4f3b3ca NeilBrown            2016-11-02  8085  		pr_warn("raid5: failed to create sysfs attributes for %s\n",
5e55e2f5fc95b3 NeilBrown            2007-03-26  8086  			mdname(mddev));
4a5add49951e69 NeilBrown            2010-06-01  8087  	md_set_array_sectors(mddev, raid5_size(mddev, 0, 0));
7a5febe9ffeecd NeilBrown            2005-05-16  8088  
176df894d79741 Christoph Hellwig    2024-03-03  8089  	if (!mddev_is_dm(mddev)) {
f63f17350e5373 Christoph Hellwig    2024-03-03  8090  		ret = raid5_set_limits(mddev);
f63f17350e5373 Christoph Hellwig    2024-03-03  8091  		if (ret)
f63f17350e5373 Christoph Hellwig    2024-03-03  8092  			goto abort;
9f7c2220017771 NeilBrown            2010-07-26  8093  	}
23032a0eb97c8e Raz Ben-Jehuda(caro  2006-12-10  8094) 
585d578974395f Yu Kuai              2026-01-12  8095  	ret = raid5_create_ctx_pool(conf);
585d578974395f Yu Kuai              2026-01-12  8096  	if (ret)
01fce9e38c0e92 Yu Kuai              2026-01-12  8097  		goto abort;
01fce9e38c0e92 Yu Kuai              2026-01-12  8098  
845b9e229fe071 Artur Paszkiewicz    2017-04-04  8099  	if (log_init(conf, journal_dev, raid5_has_ppl(conf)))
5aabf7c49d9ebe Song Liu             2016-11-17 @8100  		goto abort;

Presumably we should propagate the error code from log_init()?

5c7e81c3de9eb3 Shaohua Li           2015-08-13  8101  
^1da177e4c3f41 Linus Torvalds       2005-04-16  8102  	return 0;
^1da177e4c3f41 Linus Torvalds       2005-04-16  8103  abort:
7eb8ff02c1df27 Li Lingfeng          2023-08-03  8104  	md_unregister_thread(mddev, &mddev->thread);
^1da177e4c3f41 Linus Torvalds       2005-04-16  8105  	print_raid5_conf(conf);
95fc17aac45300 Dan Williams         2009-07-31  8106  	free_conf(conf);
^1da177e4c3f41 Linus Torvalds       2005-04-16  8107  	mddev->private = NULL;
cc6167b4f3b3ca NeilBrown            2016-11-02  8108  	pr_warn("md/raid:%s: failed to run raid set.\n", mdname(mddev));
f63f17350e5373 Christoph Hellwig    2024-03-03  8109  	return ret;
^1da177e4c3f41 Linus Torvalds       2005-04-16  8110  }

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

