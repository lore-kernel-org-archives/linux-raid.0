Received: from mail-108-mta24.mxroute.com (mail-108-mta24.mxroute.com [136.175.108.24])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC35F275AF5
	for <linux-raid@vger.kernel.org>; Tue, 14 Apr 2026 14:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=136.175.108.24
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776175840; cv=none; b=ZHJPW5JQASpDzMnC3CUJ0HdQbslaVH39ACbX8rWmfGt1wSGftCLZ6rXp7vVt+soPnTG6XJEKKc0dvE8X5cn5RI2RuN4Qany3sep7myW2/GkRkMNL1uGO3RGnZMDCDknlt+U64enjsvDJ4xAy9CAlNLyfcZ4iFDQ/wRd97CVO0gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776175840; c=relaxed/simple;
	bh=OMe49CQ8VFGwE5edSEP7UuWApy7ts2LpQs7I8fECmvM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=Q2IPOKpb/l+pbyIKFGfEPnE5yY484bD2xu4BY0w21IJ3q4PbjkVEmpf+vlBvuaLR015HuxX96erutNMYSh5v7uQ/J6qvWtkQB2tFrQUyAFiAC9kXpBeeIJj9kRR/nP+Qp4DaRXt+0et4rO529EqXva7IX6I2hf78nF4Yz+LivCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org; spf=pass smtp.mailfrom=damenly.org; dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b=BY31uBrq; arc=none smtp.client-ip=136.175.108.24
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=damenly.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=damenly.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=damenly.org header.i=@damenly.org header.b="BY31uBrq"
Received: from filter006.mxroute.com ([136.175.111.3] filter006.mxroute.com)
 (Authenticated sender: mN4UYu2MZsgR)
 by mail-108-mta24.mxroute.com (ZoneMTA) with ESMTPSA id 19d8c4fa54100032bf.006
 for <linux-raid@vger.kernel.org>
 (version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384);
 Tue, 14 Apr 2026 14:05:23 +0000
X-Zone-Loop: fca705a0c8938c871dfe5b22a11ce1a96a36cfc9591f
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=damenly.org
	; s=x; h=Content-Type:MIME-Version:Message-ID:Date:References:In-Reply-To:
	Subject:Cc:To:From:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=ToGyh3oxvVYg+NQqeqbdwB97E4qhjONyP4wJVRZvJjo=; b=BY31uBrqMaItpakt4jDci59oFf
	q/1c47Kh3CkcjVhYrCkjpA0BYqRn6zUmIr6C9eLsA8NipXaEU9dW2AclMOroBEhbk6I1UH0N8xSFy
	2rKo5zT65P9tj6S2OPYi6v24TbRijskSLtxhf4IT4+gEU6L6HUGWaNaX1abuv/sUqNWH+i0r0J2O0
	fatbNXmCM4aS97wSBAU98Jk87MRIvbNinNoUtwQTGFcv9KuBD5FBEMyTYEbrm7J2MuuL/t82pDYnf
	K709rsVf9pl5ScVWDe+jJX/U7OII1nI5b+y08LknBRQPXyKsQA9lxTn1zHxb2p3UWjTUsK8SVTHRZ
	zJKa+uqA==;
From: Su Yue <l@damenly.org>
To: Guangshuo Li <lgs201920130244@gmail.com>
Cc: Song Liu <song@kernel.org>,  Yu Kuai <yukuai@fnnas.com>,  Greg
 Kroah-Hartman <gregkh@suse.de>,  linux-raid@vger.kernel.org,
  linux-kernel@vger.kernel.org,  stable@vger.kernel.org
Subject: Re: [PATCH v2] md: fix kobject reference leak in md_import_device()
In-Reply-To: <CANUHTR-G1X5OBXQNiw8-mXGiugnuP8ryHcsrMXLKcD4VefuKmw@mail.gmail.com>
	(Guangshuo Li's message of "Tue, 14 Apr 2026 19:32:07 +0800")
References: <20260413141759.2970973-1-lgs201920130244@gmail.com>
	<fr4y8h4f.fsf@damenly.org>
	<CANUHTR-G1X5OBXQNiw8-mXGiugnuP8ryHcsrMXLKcD4VefuKmw@mail.gmail.com>
User-Agent: mu4e 1.12.7; emacs 30.2
Date: Tue, 14 Apr 2026 22:05:12 +0800
Message-ID: <a4v58wo7.fsf@damenly.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; format=flowed
X-Authenticated-Id: l@damenly.org

On Tue 14 Apr 2026 at 19:32, Guangshuo Li 
<lgs201920130244@gmail.com> wrote:

> Hi Su,
>
> Thanks for reviewing.
>
> On Tue, 14 Apr 2026 at 09:29, Su Yue <l@damenly.org> wrote:
>> Why not just:
>>
>> out_blkdev_put:
>>         kobject_put(&rdev->kobj);
>>         fput(rdev->bdev_file);
>> out_clear_rdev:
>>         md_rdev_clear(rdev);
>> out_free_rdev:
>>         kfree(rdev);
>>         return ERR_PTR(err);
>>
>> --
>> Su
>
> I wonder if that ordering might cause a problem.
>
> After kobject_init(&rdev->kobj, &rdev_ktype), 
> kobject_put(&rdev->kobj)
> may immediately drop the last reference and run the release 
> callback
> from rdev_ktype:
>
> static const struct kobj_type rdev_ktype = {
>         .release        = rdev_free,
>         .sysfs_ops      = &rdev_sysfs_ops,
>         .default_groups = rdev_default_groups,
> };
>
> static void rdev_free(struct kobject *ko)
> {
>         struct md_rdev *rdev = container_of(ko, struct md_rdev, 
>         kobj);
>         kfree(rdev);
> }
>
> So in:
>
> out_blkdev_put:
>         kobject_put(&rdev->kobj);
>         fput(rdev->bdev_file);
>
> it seems possible that kobject_put() would already free rdev via
> rdev_free(), and then fput(rdev->bdev_file) would dereference 
> rdev
> after free.
>
> That was why I changed it to:
>
> out_blkdev_put:
>         fput(rdev->bdev_file);
>         md_rdev_clear(rdev);
>         kobject_put(&rdev->kobj);
>         return ERR_PTR(err);
>
> so that the cleanup which still needs rdev is done before
> kobject_put(), and this path returns directly instead of falling
> through to the old kfree(rdev) path.
>
> Please let me know if I overlooked something.
>
Thanks for your detailed explanation. It's totally correct.

--
Su

> Thanks,
> Guangshuo
