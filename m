Received: from mail-yx1-f50.google.com (mail-yx1-f50.google.com [74.125.224.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C31603D9029
	for <linux-raid@vger.kernel.org>; Tue, 14 Apr 2026 11:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.224.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776166337; cv=pass; b=GItsIAzWUT9FjDd0Ar6uWSIJoUKsxGSd6D/AurBca32RuGYe4L/IEQZs8liTTV/3lkwmrGtLKoo/eeYUWjLOt3YiwtFnazFXl2W0GtAF+jOXBdDJoTcrexG9yCfK9XCBFawIE/HorwICms2c4govqpPbZNeqMhJ+xp+Dzk8KqvA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776166337; c=relaxed/simple;
	bh=lKY/EklFM+5be35Y3m02myuR6oeB0yZ/lLUv0J2WmQc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qJ2qJbREQd9gCppwEe98twiua9BYtJs9x1Md2ZAXIbugLrN++vjHHekf/UWjMOCo2C+syTsRiGMsoYpKsuwlhyO9lnjaUFn4nGbLYLlx4q4jQMGlUdC4MwfGa5c8GXgoAmKemgCerKRK2MsvxBxwkaDDY0/V+SnuHjVm002htWA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JfUlFGtV; arc=pass smtp.client-ip=74.125.224.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JfUlFGtV"
Received: by mail-yx1-f50.google.com with SMTP id 956f58d0204a3-6501725d888so4154454d50.0
        for <linux-raid@vger.kernel.org>; Tue, 14 Apr 2026 04:32:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776166335; cv=none;
        d=google.com; s=arc-20240605;
        b=JXpy3CQ78WD447ZinCT8RcWZb04/Vd877E8vz6rsEI+K2G1H902L66BxnsyolcxKlr
         l+EgwtKAGJce8adWNygy4waH/x2xUbc8toN0s8jF+bK+Grnc++MsOrljx8Umepfp6MEG
         0uEvbaebWYIAoUyPU6h8wnTSDOHAWb49uPBFSjO3CTphMXfXmsm5Msg3CQjHK84vp8il
         hsPE7SUosoLYzGJEzEmPZksJD9gPZYfbzFwc1zW1Vh5CTgYmvRJVBwVrEZH79IY5Wl0a
         BLGHsgmN+VQY4s54z3KZQn2//0uj69kV0CDswoTIGjo+V1dqI+tM97B7xLaEg94h4eqU
         4GFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=+bTIS9Ff7oNz+BUqaUlih568fHReftNV88TLzUyJwng=;
        fh=BJ/smICKtedYH8DIczlxnyMAllwexL2oREdMn4R3vS0=;
        b=ClJ77ShFd9gPH+xKBZoNEa+R3RmEETG2KjgDrjU4JxqkioUccU7V56F+m3JvxH241p
         IYKh8KDhzwS14QQSfwds5D3ChkzL7u9y/5SslotKYoUENH9ShTtK4ud3LnpguJfUyghX
         QQIWJBLf1Ywy6Rk+HZF7xVNcJrIQA8Kvz+kosoA+5uZAQ0rBtAodTG6QKCxC1MccKubv
         mPzrFkS+zmRZsu+QOjYZ5To3bbI/MbHxLHkf0IcTfVYmB/3Q0if7a1Pq4CPPk2n7J8Y3
         Y61lhuZOFTscv68j+mtkjOAtI9VkXbE1CWFZ0ZefrHUuT0OrVJfJiOSR0+5zXcxhoeuy
         5xAw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776166335; x=1776771135; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+bTIS9Ff7oNz+BUqaUlih568fHReftNV88TLzUyJwng=;
        b=JfUlFGtVj0ePoHtdAWBPfZHKVD3ckwKg+n9gZtlljLGffGWsVHaoxC13jqetyWgBi/
         ktkTg+tub7CRzGMjt0Y+BswfhuhMxVYdUINYbPQUR7MBnwwZEJk27LT312PGaR4GhM/E
         0639cbyoWB8SB7riu5U1HBG3v2scxDOK/P/OXhEhoUd6pU9PF03R7LA4RP0+k0ZCm0cO
         xPHFZ+7PqXfFyttf5Rc/r6IOuvdu4xmudq4cVsa3vnN2adzrWdozqhY3kKB9XZqdhys8
         WIIpISfVOEyBYojqFeGBlVazBVoZyc6NABwgwZ/AmlO3Mzyl7vZFwGi1pq0kYCx12dvn
         DTAA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776166335; x=1776771135;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+bTIS9Ff7oNz+BUqaUlih568fHReftNV88TLzUyJwng=;
        b=pRU3Euli81cGrjyuO6+cWYkniFFSq9P66G8TAbX3n+oivt3E7qsSf/EvL9jdXVE17R
         nAxkrC/7RdhU28kaaSc4fx+A+kGPuCuJCTZd8o2p3yJMzLE5+n6lBiZKyWTqquOz88mm
         fVDw3/2MUt7c4Olp0os2XCMZnRF5dpn1AawHUBx8wdRWCTPwR6U8vVPWkz6e5wkRp1IN
         dI8J31GLPlm/lhpk5BUkCGA9ElbdSxylPjAv3Xp/2h3KCp+gU3dsHywpNkCYAfxUXikU
         gTIe9fg2TCXBcX0ywkB+Jj4B8cF43J9xpfwMtJsjbJtrk4Jz7nWIbWF1yJZvbUZjt4BJ
         seQA==
X-Forwarded-Encrypted: i=1; AFNElJ95poO8qE/lzVn2V75s+spi+1/Z13Vf/VDkJ2GdvD920P+qrpxjX+xqhqYpEaBsJbCv1ObtLJErwRec@vger.kernel.org
X-Gm-Message-State: AOJu0Yz1VGcHh9yvVP7iAMS19K6lPe2YDDRWzsa9GNkM9QUpz8RCsPYo
	1hxgO4pM+OhfLBMIOjfm5f85FIar60ocxZpoa0xeczZiJ7enB334VmRcE3XYgPJyDRP3mt8p/+Q
	v7dmFM+ZOMtReALKWjHBThrRHZx2BhoZ7Jp7wQkMSuQ==
X-Gm-Gg: AeBDieu4/mgd2RO/lXDvXLxNvtOmHnj/m3HCKAqOZyHuvNvPfmAZRsn0VmHZY70r4Dn
	oP3mI02YtXLVlxWbGgRpV8KQJe1/jRM4ur8OPE9NVPklCaVhjUifR9r9OvFWnOXAbHSwSiWWjOf
	Xcccb0+2Tw5MUtgP9SOjv/Zszjd1QoGtOtkPoMjYGdSADj04uaXy+1mS8MBXi7nFT0HTMmNCqum
	dVpOeyB1ixO8zckSMR94qJcRL/vIKwmbSEaLYQNQKJ4Bb6prNYtYnxj1QLcUy15zpNxBMCyshxu
	wVbIQK/MIQ==
X-Received: by 2002:a05:690e:480b:b0:651:8a68:fb78 with SMTP id
 956f58d0204a3-65198b424c6mr11727973d50.42.1776166334829; Tue, 14 Apr 2026
 04:32:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260413141759.2970973-1-lgs201920130244@gmail.com> <fr4y8h4f.fsf@damenly.org>
In-Reply-To: <fr4y8h4f.fsf@damenly.org>
From: Guangshuo Li <lgs201920130244@gmail.com>
Date: Tue, 14 Apr 2026 19:32:07 +0800
X-Gm-Features: AQROBzCy8qvUI8vREcwULIsW07vz8KcvpopsqIhu_hpiQ_vDXUWtaN1qguAj5A4
Message-ID: <CANUHTR-G1X5OBXQNiw8-mXGiugnuP8ryHcsrMXLKcD4VefuKmw@mail.gmail.com>
Subject: Re: [PATCH v2] md: fix kobject reference leak in md_import_device()
To: Su Yue <l@damenly.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, 
	Greg Kroah-Hartman <gregkh@suse.de>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

Hi Su,

Thanks for reviewing.

On Tue, 14 Apr 2026 at 09:29, Su Yue <l@damenly.org> wrote:
> Why not just:
>
> out_blkdev_put:
>         kobject_put(&rdev->kobj);
>         fput(rdev->bdev_file);
> out_clear_rdev:
>         md_rdev_clear(rdev);
> out_free_rdev:
>         kfree(rdev);
>         return ERR_PTR(err);
>
> --
> Su

I wonder if that ordering might cause a problem.

After kobject_init(&rdev->kobj, &rdev_ktype), kobject_put(&rdev->kobj)
may immediately drop the last reference and run the release callback
from rdev_ktype:

static const struct kobj_type rdev_ktype = {
        .release        = rdev_free,
        .sysfs_ops      = &rdev_sysfs_ops,
        .default_groups = rdev_default_groups,
};

static void rdev_free(struct kobject *ko)
{
        struct md_rdev *rdev = container_of(ko, struct md_rdev, kobj);
        kfree(rdev);
}

So in:

out_blkdev_put:
        kobject_put(&rdev->kobj);
        fput(rdev->bdev_file);

it seems possible that kobject_put() would already free rdev via
rdev_free(), and then fput(rdev->bdev_file) would dereference rdev
after free.

That was why I changed it to:

out_blkdev_put:
        fput(rdev->bdev_file);
        md_rdev_clear(rdev);
        kobject_put(&rdev->kobj);
        return ERR_PTR(err);

so that the cleanup which still needs rdev is done before
kobject_put(), and this path returns directly instead of falling
through to the old kfree(rdev) path.

Please let me know if I overlooked something.

Thanks,
Guangshuo
