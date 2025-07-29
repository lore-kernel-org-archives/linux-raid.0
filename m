Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BE62222A0
	for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 10:35:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753785333; cv=none; b=d46rwD3hFaR74SFbuRHURy7fNAZhzxu6gElltHV10feNMuD8GHWnGygb3bn6hCnX85Q9EIC8GxMQtQ2hBJKWZl8oPatBshtH7iWKyulTvAJ7ychf0QERS8Qw373W846hGemlIFZ/7ogmAxTV0Ejm7n1Y9OxJkjvrZRI+du3vRN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753785333; c=relaxed/simple;
	bh=cUDl6ANNdQzuE0dLF2kpP9C4T/eRac8wpEzzk5YoLrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=F+HNLbeLgzxOVydsG9jsivLX+8/gY0z9rxiX2WO/H5iVauN8rWcBcuMvNB0zXr8tpN6J6VP2QvP3S1IGqpGtcKISEdodpV+asGEihLtw3tMb4JDtbtuNyKslHMi83aKZ+xK4Tp02bRq2e3rfn7rG0erLDLDC0Fbm/fUZgcBT6X8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=C5t+VBnV; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="C5t+VBnV"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753785331;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUDl6ANNdQzuE0dLF2kpP9C4T/eRac8wpEzzk5YoLrQ=;
	b=C5t+VBnV/2I2glffBTkAcxO95hKsjtHXClco+uGnXchEIthLaRTPteDkv+WCm2dVKM6/e/
	6S0NuRqWRRyC3Q0srrYWlVvk0ZF4pplVV23fSUo6iRE74QFsHnCe5TrMZrxdxSElhHmsO4
	AMwEHcILSKwueCjhPqSqQjgC4Q6+3FE=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-665-4E3tCRmqO-2dLVWfTzh83A-1; Tue,
 29 Jul 2025 06:35:27 -0400
X-MC-Unique: 4E3tCRmqO-2dLVWfTzh83A-1
X-Mimecast-MFC-AGG-ID: 4E3tCRmqO-2dLVWfTzh83A_1753785327
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 098A419560B0;
	Tue, 29 Jul 2025 10:35:27 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.36])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 4E9061955F21;
	Tue, 29 Jul 2025 10:35:24 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 06/11] md/md-bitmap: delay registration of bitmap_ops until creating bitmap
Date: Tue, 29 Jul 2025 18:35:22 +0800
Message-Id: <20250729103522.60945-1-xni@redhat.com>
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
References: <20250721171557.34587-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17

The patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

