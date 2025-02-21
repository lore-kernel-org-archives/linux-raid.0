Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A7E9210F5D;
	Fri, 21 Feb 2025 15:19:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740151186; cv=none; b=Dc2p5O67l5eao6nQx8Vn1BOSvGXW4gmyGw9B2a2tM+YXhw1tqJaI3J7AMQpo/0nf8GXmtu9sDAz4wFNTJF43DDmJV7gfQxiNAwL8aX+ogF7C8nCTf2+lWJ6Lo/Wjm+r/c6gjzv5HRIm2uqyFyvgLBl14uJ/L1tjpDtYqlXeIvQI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740151186; c=relaxed/simple;
	bh=636J0L2L57i85Fk1pbRRH32NY1pol6A8kSUF0OXuRvQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AWKPm3WGULSDm6VPl4LlZSE78yJLX3+OxPPeGueQaaZ+mlrhTgeEE2fNDh3rRynrNpa9//QKdY5smv3fU2CKD8PCs/fs4ycXo+pJ/u81ckxqkumh01VyY494LGv5GwiMZhDt1/J2QS7UADQLIZ+ZpZlA9MMJ+t0AzYNO59xZIJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org; spf=pass smtp.mailfrom=morinfr.org; dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b=RfYU+tH6; arc=none smtp.client-ip=212.27.42.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morinfr.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b="RfYU+tH6"
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id AFC3B200406;
	Fri, 21 Feb 2025 16:19:36 +0100 (CET)
Authentication-Results: smtp2-g21.free.fr;
	dkim=pass (1024-bit key; unprotected) header.d=morinfr.org header.i=@morinfr.org header.a=rsa-sha256 header.s=20170427 header.b=RfYU+tH6;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
	Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=emYbpo5GLAv7fQmupNkR79c6pzM8OUd6OqHZnaplvZU=; b=RfYU+tH6iBU9TZdmw/tEFaVT8f
	+7KV23IDFfLNN7DePzO9jJuiKQQWm/n18fn++y32XOrmnZO5yrP0Eqvrrk1FG9KsepfttJAVogWgB
	jaIJBHeo1oNhjcb19XIY4FHey+Oj7HK4DTARIqSitrEtDDkl0lYVm1UvzF5muc6cWt+g=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.96)
	(envelope-from <guillaume@morinfr.org>)
	id 1tlUoR-001F74-2G;
	Fri, 21 Feb 2025 16:19:35 +0100
Date: Fri, 21 Feb 2025 16:19:35 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Guillaume Morin <guillaume@morinfr.org>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, song@kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
Message-ID: <Z7iZh56mykLW82SN@bender.morinfr.org>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
 <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
 <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>
 <Z7alWBZfQLlP-EO7@bender.morinfr.org>
 <1e288eb5-c67b-c9ca-c57e-2855b18785b1@huaweicloud.com>
 <6748f138-ad52-b7c5-ac53-1c7fa6fab9b7@huaweicloud.com>
 <Z7cwexr7tLRIOlNx@bender.morinfr.org>
 <40203778-f217-6789-9c83-ebed3720627b@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <40203778-f217-6789-9c83-ebed3720627b@huaweicloud.com>

On 21 Feb  9:27, Yu Kuai wrote:
> > The issue with the next pointer seems to be fixed with your change.
> > Though I am still unclear how the 2nd potential issue I mentioned -
> > where the current item would be freed concurrently by mddev_free() - is
> > prevented. I am not finding anything in the code that seems to prevent a
> > concurrent call to mddev_free() for the current item in the
> > list_for_each_entry() loop (and therefore accessing mddev after the
> > kfree()).
> > 
> > I understand that we are getting a reference through the active atomic
> > in mddev_get() under the lock in md_notify_reboot() but how is that
> > preventing mddev_free() from freeing the mddev as soon as we release the
> > all_mddevs_lock in the loop?
> > 
> > I am not not familiar with this code so I am most likely missing
> > osmething but if you had the time to explain, that would be very
> > helpful.
> 
> I'm not quite sure what you're confused. mddev lifetime are both
> protected by lock and reference.
> 
> In this case:
> 
> hold lock
> get first mddev
> release lock
> // handle first mddev
> 
> hold lock
> release mddev
> get next mddev
> release lock
> -> mddev can be freed now
> // handle the next mddev
> ...
> 

In my original message, I mentioned 2 potential issues
Let's say md_notify_reboot() is handling mddev N from the all_mddevs
list.

1) The GPF we pasted in the original message happened when mddev_free()
is called concurrently for mddev N+1. This lead to the GPF since the cpu
would try to load the list poisoned values from the 'n' pointer.

Your patch definitely fixes this race and we cannot reproduce the GPF
anymore.

2) Instead of mddev_free() being called for mddev N+1 like in 1, I wonder
what's preventing mddev_free() being called for mddev N (the one we're
iterating about). Something like

CPU1							CPU2
list_for_each_entry(mddev, &all_mddevs, all_mddevs) {
if (!mddev_get(mddev))
    continue;
spin_unlock(&all_mddevs_lock);
						        mddev_free(mddev) (same mddev as CPU1)

mddev_free() does not check the active atomic, or acquire the
reconfig_mutex/md_lock and will kfree() mddev. So the loop execution
on CPU1 after spin_unlock() could be a UAF.

So I was wondering if you could clarify what is preventing race 2?
i.e what is preventing mddev_free(mddev) from being calling kfree(mddev)
while the md_notify_reboot() loop is handling mddev.

-- 
Guillaume Morin <guillaume@morinfr.org>
