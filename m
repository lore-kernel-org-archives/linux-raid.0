Received: from sg-1-22.ptr.blmpb.com (sg-1-22.ptr.blmpb.com [118.26.132.22])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ECD335CBA4
	for <linux-raid@vger.kernel.org>; Tue, 13 Jan 2026 06:11:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.22
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768284710; cv=none; b=IzChh13IE+wQ6NUhpHasn+Zt/Mk050eg1TCLNAa32MmeGiBou9nyr2AUwDjLFpsVtKELIAJiumRZfqMVnZp8xcZVMryz9Mxebxeg48ua6lmZaANOzjHtvbyx+Iou8T9fnRCQg6WpvxFizN4mMFVZjtN0cZKV8NwAUBP0sC/Jbtc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768284710; c=relaxed/simple;
	bh=u4rQpEr6bqpAUJiVuqn5Z9nnYY2HdiHfmJmnJ8TA0BI=;
	h=Subject:Mime-Version:Content-Type:To:References:From:In-Reply-To:
	 Message-Id:Cc:Date; b=jJ8EiVHyybyENJGRP3BEkIDPd57bd3YOj2UCasZ6YU7uflw9+CitR0muFH6LOWZIWTKoDX7RzxBkr2WPfpvHT+9jMT5GOmFuSyefTuPgI/5WJp/DXhCJ1oh6DTz4APCMAiEgTKihfZQnS+sMpcfEqjaD8mUHtUL54FicE73Y3PY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=u/bmHEkY; arc=none smtp.client-ip=118.26.132.22
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="u/bmHEkY"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1768284694;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=mLOgn3Nm6iKwO5Yi/JaLxxTsEFmI+8DgjMxIR9z9xjI=;
 b=u/bmHEkYqdrMe9850eO8nnxqk5ru6gTeDuc8S7Czkc3IH4fW38rG/QQ80Oq9XJaTSKL6kG
 TBv521paWaZuUZIrnxapfQu+4wg0e8NBpgezZGBE8Pvs9uOihi8TpHkKNn8unzNfsiuz+9
 yd5N/drmYw7rntAiCQNzED+gTjP4Xaa7iMRqGpVvX5W9utD6zmMpHQ4+nQNqTYZS/Xwv1z
 0m2ucyzqAzbEkNIgmkiWEd2emDqNr4E7inoXcd4N2D7mj87Dw6XxYoGTqnhLdsnCue+o9n
 X7/5RTCCxIdtnMpIbs9dugZcsLZIIkoRJwWGsUArSiw6OrDjuvjHlHe54bkVNQ==
Subject: Re: [PATCH v4 05/11] md/raid5: make sure max_sectors is not less than io_opt
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Language: en-US
To: "Dan Carpenter" <dan.carpenter@linaro.org>, <oe-kbuild@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <linan122@huawei.com>, <yukuai@fnnas.com>
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+26965e214+e8787e+vger.kernel.org+yukuai@fnnas.com>
References: <202601130531.LGfcZsa4-lkp@intel.com>
Received: from [192.168.1.104] ([39.182.0.185]) by smtp.feishu.cn with ESMTPS; Tue, 13 Jan 2026 14:11:31 +0800
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <202601130531.LGfcZsa4-lkp@intel.com>
Message-Id: <0b615af0-e545-4017-99ca-22c14477da7b@fnnas.com>
Cc: <lkp@intel.com>, <oe-kbuild-all@lists.linux.dev>
Date: Tue, 13 Jan 2026 14:11:29 +0800
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Reply-To: yukuai@fnnas.com

Hi,

=E5=9C=A8 2026/1/13 13:06, Dan Carpenter =E5=86=99=E9=81=93:
> Hi Yu,
>
> kernel test robot noticed the following build warnings:
>
> https://git-scm.com/docs/git-format-patch#_base_tree_information]
>
> url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Kuai/md-merge-m=
ddev-has_superblock-into-mddev_flags/20260112-123233
> base:   linus/master
> patch link:    https://lore.kernel.org/r/20260112042857.2334264-6-yukuai%=
40fnnas.com
> patch subject: [PATCH v4 05/11] md/raid5: make sure max_sectors is not le=
ss than io_opt
> config: i386-randconfig-141-20260113 (https://download.01.org/0day-ci/arc=
hive/20260113/202601130531.LGfcZsa4-lkp@intel.com/config)
> compiler: gcc-14 (Debian 14.2.0-19) 14.2.0
> smatch version: v0.5.0-8985-g2614ff1a
>
> If you fix the issue in a separate patch/commit (i.e. not just a new vers=
ion of
> the same patch/commit), kindly add following tags
> | Reported-by: kernel test robot <lkp@intel.com>
> | Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
> | Closes: https://lore.kernel.org/r/202601130531.LGfcZsa4-lkp@intel.com/
>
> New smatch warnings:
> drivers/md/raid5.c:8100 raid5_run() warn: missing error code 'ret'
>
> vim +/ret +8100 drivers/md/raid5.c
>
> cc6167b4f3b3ca NeilBrown            2016-11-02  8064  	pr_info("md/raid:%=
s: raid level %d active with %d out of %d devices, algorithm %d\n",
> cc6167b4f3b3ca NeilBrown            2016-11-02  8065  		mdname(mddev), co=
nf->level,
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8066  		mddev->raid_disks=
-mddev->degraded, mddev->raid_disks,
> e183eaedd53807 NeilBrown            2009-03-31  8067  		mddev->new_layout=
);
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8068
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8069  	print_raid5_conf(c=
onf);
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8070
> fef9c61fdfabf9 NeilBrown            2009-03-31  8071  	if (conf->reshape_=
progress !=3D MaxSector) {
> fef9c61fdfabf9 NeilBrown            2009-03-31  8072  		conf->reshape_saf=
e =3D conf->reshape_progress;
> f67055780caac6 NeilBrown            2006-03-27  8073  		atomic_set(&conf-=
>reshape_stripes, 0);
> f67055780caac6 NeilBrown            2006-03-27  8074  		clear_bit(MD_RECO=
VERY_SYNC, &mddev->recovery);
> f67055780caac6 NeilBrown            2006-03-27  8075  		clear_bit(MD_RECO=
VERY_CHECK, &mddev->recovery);
> f67055780caac6 NeilBrown            2006-03-27  8076  		set_bit(MD_RECOVE=
RY_RESHAPE, &mddev->recovery);
> ad39c08186f8a0 Yu Kuai              2024-02-01  8077  		set_bit(MD_RECOVE=
RY_NEEDED, &mddev->recovery);
> f67055780caac6 NeilBrown            2006-03-27  8078  	}
> f67055780caac6 NeilBrown            2006-03-27  8079
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8080  	/* Ok, everything =
is just fine now */
> a64c876fd35790 NeilBrown            2010-04-14  8081  	if (mddev->to_remo=
ve =3D=3D &raid5_attrs_group)
> a64c876fd35790 NeilBrown            2010-04-14  8082  		mddev->to_remove =
=3D NULL;
> 00bcb4ac7ee7e5 NeilBrown            2010-06-01  8083  	else if (mddev->ko=
bj.sd &&
> 00bcb4ac7ee7e5 NeilBrown            2010-06-01  8084  	    sysfs_create_g=
roup(&mddev->kobj, &raid5_attrs_group))
> cc6167b4f3b3ca NeilBrown            2016-11-02  8085  		pr_warn("raid5: f=
ailed to create sysfs attributes for %s\n",
> 5e55e2f5fc95b3 NeilBrown            2007-03-26  8086  			mdname(mddev));
> 4a5add49951e69 NeilBrown            2010-06-01  8087  	md_set_array_secto=
rs(mddev, raid5_size(mddev, 0, 0));
> 7a5febe9ffeecd NeilBrown            2005-05-16  8088
> 176df894d79741 Christoph Hellwig    2024-03-03  8089  	if (!mddev_is_dm(m=
ddev)) {
> f63f17350e5373 Christoph Hellwig    2024-03-03  8090  		ret =3D raid5_set=
_limits(mddev);
> f63f17350e5373 Christoph Hellwig    2024-03-03  8091  		if (ret)
> f63f17350e5373 Christoph Hellwig    2024-03-03  8092  			goto abort;
> 9f7c2220017771 NeilBrown            2010-07-26  8093  	}
> 23032a0eb97c8e Raz Ben-Jehuda(caro  2006-12-10  8094)
> 585d578974395f Yu Kuai              2026-01-12  8095  	ret =3D raid5_crea=
te_ctx_pool(conf);
> 585d578974395f Yu Kuai              2026-01-12  8096  	if (ret)
> 01fce9e38c0e92 Yu Kuai              2026-01-12  8097  		goto abort;
> 01fce9e38c0e92 Yu Kuai              2026-01-12  8098
> 845b9e229fe071 Artur Paszkiewicz    2017-04-04  8099  	if (log_init(conf,=
 journal_dev, raid5_has_ppl(conf)))
> 5aabf7c49d9ebe Song Liu             2016-11-17 @8100  		goto abort;
>
> Presumably we should propagate the error code from log_init()?

Yes we should, but this problem looks already exist before this patch.

>
> 5c7e81c3de9eb3 Shaohua Li           2015-08-13  8101
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8102  	return 0;
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8103  abort:
> 7eb8ff02c1df27 Li Lingfeng          2023-08-03  8104  	md_unregister_thre=
ad(mddev, &mddev->thread);
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8105  	print_raid5_conf(c=
onf);
> 95fc17aac45300 Dan Williams         2009-07-31  8106  	free_conf(conf);
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8107  	mddev->private =3D=
 NULL;
> cc6167b4f3b3ca NeilBrown            2016-11-02  8108  	pr_warn("md/raid:%=
s: failed to run raid set.\n", mdname(mddev));
> f63f17350e5373 Christoph Hellwig    2024-03-03  8109  	return ret;
> ^1da177e4c3f41 Linus Torvalds       2005-04-16  8110  }
>
--=20
Thansk,
Kuai
