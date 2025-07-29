Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A282286D57
	for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 09:53:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753782805; cv=none; b=sm2vG5vjtQzclO9boS5IJTtQSLEvyggn6JgEu0MG1niWQHLLGsWYkS8pfC+Vn/ZiIz40Lg3LxXq+XnGtbwqHNH5PNRQtuysZMD5Z8f/eoFpTpmMx9rt1vvwuOBeKOeFlHmQmO3zdIRPvE53edI74LwzHdkXiAZ5zlQFZ55jhOco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753782805; c=relaxed/simple;
	bh=cUDl6ANNdQzuE0dLF2kpP9C4T/eRac8wpEzzk5YoLrQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=ibroxwOe4ZuPH6iO3WhALLUAHPPsQZiOBJBN1a+da+hsYf6YCTjYlrAYCCM0C/sHn8Xu1dXJkH+ob0YTtQhGrjLyVZofqRtUeYk5B/728LTNvSaTJRXCjQQ4SPm7GFYKexZtJ0Vp9Q9doq9iZuy5KaYLw86zEc1Dt3JjbgD9aUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Kr69OF+H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Kr69OF+H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753782803;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=cUDl6ANNdQzuE0dLF2kpP9C4T/eRac8wpEzzk5YoLrQ=;
	b=Kr69OF+H8BVJ4jJ+SnwRhKnPuZ0Nvv89LDfI5fVf3q6mN5An0VQAD/SVFjCzDY7Iw+e/ij
	cvQb4jcZazm1XTqHbLkQDdjleY3mLUC80a79FumFcBww4YPThdjyhiLWSqLONeS29WWvfp
	AtUXiuGFk4WKIAI5YfVfsDsopLMR8uY=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-222-NjGz3tjiMiS27t1u7uWu1g-1; Tue,
 29 Jul 2025 05:53:19 -0400
X-MC-Unique: NjGz3tjiMiS27t1u7uWu1g-1
X-Mimecast-MFC-AGG-ID: NjGz3tjiMiS27t1u7uWu1g_1753782799
Received: from mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.12])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D8397180045B;
	Tue, 29 Jul 2025 09:53:18 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.72.120.36])
	by mx-prod-int-03.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id E716019560A2;
	Tue, 29 Jul 2025 09:53:16 +0000 (UTC)
From: Xiao Ni <xni@redhat.com>
To: yukuai@kernel.org
Cc: linux-raid@vger.kernel.org
Subject: Re: [PATCH v4 05/11] md/md-bitmap: add a new sysfs api bitmap_type
Date: Tue, 29 Jul 2025 17:53:14 +0800
Message-Id: <20250729095314.59893-1-xni@redhat.com>
In-Reply-To: <20250721171557.34587-1-yukuai@kernel.org>
References: <20250721171557.34587-1-yukuai@kernel.org>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.12

The patch looks good to me.
Reviewed-by: Xiao Ni <xni@redhat.com>

