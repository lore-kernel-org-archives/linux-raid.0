Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9B5A182
	for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 11:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753788315; cv=none; b=tPlio5CU9l6v6nX5tf57NBphS495+9z8PXYs6DzKPJuWQFfonAwIsjwkYbbswsc5m1PGWw811z/5tbHCfvHWhVDOT5YdDxKyI1c5C1CDyVPyffPXEhnkuXJ8hGbB+eMR4og1seqOeo8gQ4U1sO3EPWNpm90EBYlAGpkrl4SBZMA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753788315; c=relaxed/simple;
	bh=cUDl6ANNdQzuE0dLF2kpP9C4T/eRac8wpEzzk5YoLrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=oeVYlDBJazyd6iCMR2Rr/epLdwAE75O/JpmHy4IbO7TkogP3QxrBkeNQYn96bYqsBW2Wh8L1LSscN8YPIdIrTg2oElpdEYYqBsvOfR3xOahkO13rqi3co5e19FGH2UY7CL0vaTdgccb+xalbfJGXUd3s3zeBk0dIQWXdns8SY3o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=BXEquhxT; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="BXEquhxT"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753788312;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUDl6ANNdQzuE0dLF2kpP9C4T/eRac8wpEzzk5YoLrQ=;
	b=BXEquhxTuhW4/cc0D6PILIEWnrkH26VmyF3cQz1mCAMtoyfO0ACL7QEEwd4KAUCQqM2ozL
	NkNciQfboJ2ib9uOoK1V/PpJcGAevRUl3U0wsWj5vaFPM4wRHurcNjccGFxdBtPgtDlPp1
	8wlbSDF5kOYXLewxnyButUkxk3JsDe4=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-684-FFqfCLtePjqth72YbGD5bA-1; Tue,
 29 Jul 2025 07:25:09 -0400
X-MC-Unique: FFqfCLtePjqth72YbGD5bA-1
X-Mimecast-MFC-AGG-ID: FFqfCLtePjqth72YbGD5bA_1753788308
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id A4A111800773;
	Tue, 29 Jul 2025 11:25:08 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.36])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id D45D530001B1;
	Tue, 29 Jul 2025 11:25:06 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 08/11] md/md-bitmap: add a new method blocks_synced() in bitmap_operations
Date: Tue, 29 Jul 2025 19:25:03 +0800
Message-Id: <20250729112503.62099-1-xni@redhat.com>
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
References: <20250721171557.34587-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

The patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

