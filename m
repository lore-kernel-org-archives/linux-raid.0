Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC16924BD04
	for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 09:49:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753782563; cv=none; b=IwrZh289yWBg0E6YVCKkEuWtk5fQcCkQtEwue8eTnMkpWrNjPD1BfOTGA4O1S8DUw0uZat+M+/YRm3DxhsfTvLs7zzPEumPhhmuYYd1l0RsA71F17Jr7LX+gBL2XyeKaiktnKdjin3EPc/MxoXJJJFKV3l42T5aK3kjIyZKRpYg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753782563; c=relaxed/simple;
	bh=cUDl6ANNdQzuE0dLF2kpP9C4T/eRac8wpEzzk5YoLrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=EV7JuGBOrS7nmDmqdz7YTp+xBjurKdx5JkFzoYAVwPm4PClBA/IKoa5FWeLKUYCfBY9Il3RCqVYp8HMzyOlgaoB5Kv13o9Z1x8d4VQY7EQX4qIWYNrFRnd+bpSdP/trav7zIRcNl+oSrweZhMX6+IDoTDoMLCYmXN1DuyDVSAj4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=NGnOl2qG; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NGnOl2qG"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753782560;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUDl6ANNdQzuE0dLF2kpP9C4T/eRac8wpEzzk5YoLrQ=;
	b=NGnOl2qGXkYDmBWcF1tV5gN+XQjNe+jq2eKuw5lolXNPWcMJZ1CC1LHETY7VUzRpF7Yrxo
	+qMUXc8PzNf7+WlJil6UNEZxE+dyj0loRDY8K7J6yv57mOANXROvvJGj4XqMibblfAzC6p
	w3byZeskZLaFSzp0X5NyCI0boUwW0Ns=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-522-7ZoX48ZFO1qqN-90F9ZvBg-1; Tue,
 29 Jul 2025 05:49:19 -0400
X-MC-Unique: 7ZoX48ZFO1qqN-90F9ZvBg-1
X-Mimecast-MFC-AGG-ID: 7ZoX48ZFO1qqN-90F9ZvBg_1753782558
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id EFC211800359;
	Tue, 29 Jul 2025 09:49:17 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.36])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 3F17830001B1;
	Tue, 29 Jul 2025 09:49:15 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 04/11] md: add a new mddev field 'bitmap_id'
Date: Tue, 29 Jul 2025 17:49:13 +0800
Message-Id: <20250729094913.59714-1-xni@redhat.com>
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

