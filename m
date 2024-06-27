Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B229F196DB1
	for <linux-raid@vger.kernel.org>; Thu, 27 Jun 2024 14:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719500101; cv=none; b=TUhiktgiKpBkvU8OKnfNIK1RuLLD+iOSREcl+z67zh8wo4SSJxK+Y9M5zMugePAfcjxi+cRNZ7GQ4liBkAqlqIYN8ParTiyYWGDwhCfHfkdcPiU/EbPt8q+TOvUfrUVP6Ly30qVxJs9zdFjbFy78CwujvzKjLjWhArgM5tZ5CWM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719500101; c=relaxed/simple;
	bh=rFmxIOvu3F8vOrdh92agk1gCVZsSrZs78rcLm7Nsz8s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=LMRi4yVOxspfb+LMnLSIhEvhn3D0Wji0yhUi6eAhJE29eqGjNLt2dsJek65fVWFfZuFJoldUaznFY8A3DQqFUEqLnlMLWI5+y4P2W9Bz5Rrxq1HNx2b8MxPbkvM1PYnBi+qV3wXhImq0CvBw8uXf4UjOZ/ME0xEN1/ETvpmHJic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JG5NuSP8; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JG5NuSP8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1719500098;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Xnp3ioVC7Bwfgyoh757R0y7MXnS+YBruIVq3vAaIXNs=;
	b=JG5NuSP8oIf6CHr0KY88z0hWlUCDd2/jU9vFpLMxxygD5QvhMTCVoEM152xmCKXaNIZCvZ
	kMJZ7hVCBoBGTYl7ErlNpAA6dU0bRsFjbgOtKF6CYRzGot2BRlvQUyob8DKceJWeVran33
	8Y8BRHSmXo6nwvktAqplKfawvsvQBKA=
Received: from mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-661-KxqBpeXQOpy40-C0H3gM3g-1; Thu,
 27 Jun 2024 10:54:54 -0400
X-MC-Unique: KxqBpeXQOpy40-C0H3gM3g-1
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id DC8E519560AB;
	Thu, 27 Jun 2024 14:54:52 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (bmarzins-01.fast.eng.rdu2.dc.redhat.com [10.6.23.12])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 2CFF2300022A;
	Thu, 27 Jun 2024 14:54:51 +0000 (UTC)
Received: from bmarzins-01.fast.eng.rdu2.dc.redhat.com (localhost [127.0.0.1])
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.1) with ESMTPS id 45REso4V1452501
	(version=TLSv1.3 cipher=TLS_AES_256_GCM_SHA384 bits=256 verify=NOT);
	Thu, 27 Jun 2024 10:54:50 -0400
Received: (from bmarzins@localhost)
	by bmarzins-01.fast.eng.rdu2.dc.redhat.com (8.17.2/8.17.2/Submit) id 45REsoYv1452500;
	Thu, 27 Jun 2024 10:54:50 -0400
Date: Thu, 27 Jun 2024 10:54:50 -0400
From: Benjamin Marzinski <bmarzins@redhat.com>
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: Song Liu <song@kernel.org>, Heinz Mauelshagen <heinzm@redhat.com>,
        Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org,
        "yukuai (C)" <yukuai3@huawei.com>
Subject: Re: [PATCH] md/raid5: recheck if reshape has finished with
 device_lock held
Message-ID: <Zn19OhZ5ykV0b7-T@redhat.com>
References: <20240627053758.1438644-1-bmarzins@redhat.com>
 <60e07bf5-dd1d-5eeb-d9a8-1488ab729798@huaweicloud.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <60e07bf5-dd1d-5eeb-d9a8-1488ab729798@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

On Thu, Jun 27, 2024 at 08:17:51PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2024/06/27 13:37, Benjamin Marzinski 写道:
> > When handling an IO request, MD checks if a reshape is currently
> > happening, and if so, where the IO sector is in relation to the reshape
> > progress. MD uses conf->reshape_progress for both of these tasks.  When
> > the reshape finishes, conf->reshape_progress is set to MaxSector.  If
> > this occurs after MD checks if the reshape is currently happening but
> > before it calls ahead_of_reshape(), then ahead_of_reshape() will end up
> > comparing the IO sector against MaxSector. During a backwards reshape,
> > this will make MD think the IO sector is in the area not yet reshaped,
> > causing it to use the previous configuration, and map the IO to the
> > sector where that data was before the reshape.
> > 
> > This bug can be triggered by running the lvm2
> > lvconvert-raid-reshape-linear_to_raid6-single-type.sh test in a loop,
> > although it's very hard to reproduce.
> > 
> > Fix this by rechecking if the reshape has finished after grabbing the
> > device_lock.
> > 
> > Fixes: fef9c61fdfabf ("md/raid5: change reshape-progress measurement to cope with reshaping backwards.")
> > Signed-off-by: Benjamin Marzinski <bmarzins@redhat.com>
> > ---
> >   drivers/md/raid5.c | 18 ++++++++++--------
> >   1 file changed, 10 insertions(+), 8 deletions(-)
> > 
> 
> Thanks for the patch, it looks correct. However, can you factor out a
> helper and make the code more readable? The code is already quite
> complicated.

Sure.
 
> Thanks,
> Kuai
> 
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > index 547fd15115cd..65d9b1ca815c 100644
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -5923,15 +5923,17 @@ static enum stripe_result make_stripe_request(struct mddev *mddev,
> >   		 * to check again.
> >   		 */
> >   		spin_lock_irq(&conf->device_lock);
> > -		if (ahead_of_reshape(mddev, logical_sector,
> > -				     conf->reshape_progress)) {
> > -			previous = 1;
> > -		} else {
> > +		if (conf->reshape_progress != MaxSector) {
> >   			if (ahead_of_reshape(mddev, logical_sector,
> > -					     conf->reshape_safe)) {
> > -				spin_unlock_irq(&conf->device_lock);
> > -				ret = STRIPE_SCHEDULE_AND_RETRY;
> > -				goto out;
> > +					     conf->reshape_progress)) {
> > +				previous = 1;
> > +			} else {
> > +				if (ahead_of_reshape(mddev, logical_sector,
> > +						     conf->reshape_safe)) {
> > +					spin_unlock_irq(&conf->device_lock);
> > +					ret = STRIPE_SCHEDULE_AND_RETRY;
> > +					goto out;
> > +				}
> >   			}
> >   		}
> >   		spin_unlock_irq(&conf->device_lock);
> > 

