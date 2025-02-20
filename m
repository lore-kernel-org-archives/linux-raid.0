Received: from smtp2-g21.free.fr (smtp2-g21.free.fr [212.27.42.2])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 234042BD11;
	Thu, 20 Feb 2025 13:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.27.42.2
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740058757; cv=none; b=r0FNdm8BNPLK2EfHCYzHSYWJLNmjxwvsk/1zzOVKo+HtvvDl3UMWZlbTX3/rztAxxXvvqsPXg5eZem6vUAvxckZzyj5dmSun2fUNu3QRgp+UBH43xbW95xLYqkVgj0pwxPjqXHOBWfqTcP2EaCUIXJF+FcX+kJG0K5Qlfxc1964=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740058757; c=relaxed/simple;
	bh=YibU4l09oQ0cBy5bOULHM03Q9PG0lJqJ+yPiZD47Z1Q=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=OTFITpxZwnpH2eht284/cd3gMzWJKHjj7T+KxAOfgs3nBxdA8on0OmYt3FfYx8ZH2P81PC1fnLoT4JkyM1elNxpnxhVicO9A8hoUP4iGwc3YXO2eprkPCTmpQSOnSQNASIcGMcZAgSEiTg/a6xsM71wAks8dMG9WHKDZS6TimzQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org; spf=pass smtp.mailfrom=morinfr.org; dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b=38DJmyHV; arc=none smtp.client-ip=212.27.42.2
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=morinfr.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=morinfr.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=morinfr.org header.i=@morinfr.org header.b="38DJmyHV"
Received: from bender.morinfr.org (unknown [82.66.66.112])
	by smtp2-g21.free.fr (Postfix) with ESMTPS id C65E72003D3;
	Thu, 20 Feb 2025 14:39:07 +0100 (CET)
Authentication-Results: smtp2-g21.free.fr;
	dkim=pass (1024-bit key; unprotected) header.d=morinfr.org header.i=@morinfr.org header.a=rsa-sha256 header.s=20170427 header.b=38DJmyHV;
	dkim-atps=neutral
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=morinfr.org
	; s=20170427; h=In-Reply-To:Content-Transfer-Encoding:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
	Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
	List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=tP0xUA71E6t13/H71gor9nmgC4liU5He56BGwdR3E2k=; b=38DJmyHVst/MyirFhzuDsp+KHc
	tqkroceK6gvoCgO3Uq0bMz2WiVATAG3MRVjFCEJ3RcZgXY3psS0JHV+FiRrsa3JXPxAIoEmMeF4t1
	vth6vd2Sw+ARZ9LHpP/gUqj2EaPEHqMUIAG+t3TXsHumVF5dbM5Vd63+Ezt3Zm+dLSAY=;
Received: from guillaum by bender.morinfr.org with local (Exim 4.96)
	(envelope-from <guillaume@morinfr.org>)
	id 1tl6lf-000VRF-0I;
	Thu, 20 Feb 2025 14:39:07 +0100
Date: Thu, 20 Feb 2025 14:39:07 +0100
From: Guillaume Morin <guillaume@morinfr.org>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Guillaume Morin <guillaume@morinfr.org>, linux-raid@vger.kernel.org,
	linux-kernel@vger.kernel.org, song@kernel.org,
	"yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [BUG] possible race between md_free_disk and md_notify_reboot
Message-ID: <Z7cwexr7tLRIOlNx@bender.morinfr.org>
References: <ad286d5c-fd60-682f-bd89-710a79a710a0@huaweicloud.com>
 <82BF5B2B-7508-47DB-9845-8A5F19E0D0E5@morinfr.org>
 <53e93d6e-7b73-968b-c5f2-92d1b124ecd5@huawei.com>
 <Z7alWBZfQLlP-EO7@bender.morinfr.org>
 <1e288eb5-c67b-c9ca-c57e-2855b18785b1@huaweicloud.com>
 <6748f138-ad52-b7c5-ac53-1c7fa6fab9b7@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6748f138-ad52-b7c5-ac53-1c7fa6fab9b7@huaweicloud.com>

On 20 Feb 19:55, Yu Kuai wrote:
>
> > I just take a quick look, the problem looks obviously to me, see how
> > md_seq_show() handle the iteration.
> > 
> > diff --git a/drivers/md/md.c b/drivers/md/md.c
> > index 465ca2af1e6e..7c7a58f618c1 100644
> > --- a/drivers/md/md.c
> > +++ b/drivers/md/md.c
> > @@ -9911,8 +9911,11 @@ static int md_notify_reboot(struct notifier_block
> > *this,
> >                          mddev_unlock(mddev);
> >                  }
> >                  need_delay = 1;
> > -               mddev_put(mddev);
> > -               spin_lock(&all_mddevs_lock);
> > +
> > +               spin_lock(&all_mddevs_lock)
> > +               if (atomic_dec_and_test(&mddev->active))
> > +                       __mddev_put(mddev);
> > +
> >          }
> >          spin_unlock(&all_mddevs_lock);
> 
> While cooking the patch, this is not enough, list_for_each_entry_safe()
> should be replaced with list_for_each_entry() as well.
> 
> Will send the patch soon, with:
> 
> Reported-by: Guillaume Morin <guillaume@morinfr.org>

Thank you! I just saw the patch and we are going to test it and let you
know.

The issue with the next pointer seems to be fixed with your change.
Though I am still unclear how the 2nd potential issue I mentioned -
where the current item would be freed concurrently by mddev_free() - is
prevented. I am not finding anything in the code that seems to prevent a
concurrent call to mddev_free() for the current item in the
list_for_each_entry() loop (and therefore accessing mddev after the
kfree()).

I understand that we are getting a reference through the active atomic
in mddev_get() under the lock in md_notify_reboot() but how is that
preventing mddev_free() from freeing the mddev as soon as we release the
all_mddevs_lock in the loop?

I am not not familiar with this code so I am most likely missing
osmething but if you had the time to explain, that would be very
helpful.

TIA

Guillaume.

-- 
Guillaume Morin <guillaume@morinfr.org>
