Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1338285C86
	for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 08:59:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753779546; cv=none; b=J6HmaVcvLmixX/0GkzAXj9iOr4Q1RrVW8Rqlswu7OKQXzvT1eWg9qwE5AjyLljJ3usvtDL/L0e6hSBsANH5ULzWHMCWRGm8PURDlhTfT4yXkVZUBOwzsKpdJVUEQ5vedfmDcjEkPoXViNwaZuxMcCTULYfx6i5gtIJExVWh6bUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753779546; c=relaxed/simple;
	bh=nLaVWqasTGmHO0hYla6Su0l/R5bX2yCx+H21tIpx+p4=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=XHTvZ7VjbET8jdGWZgU7R783R5hGIJTVxN4Elbn3NSRU5epmUOt/lbS6ssUubAyEZVOT3leE/N377OjbI0rMe4YnunPe6YFVX0RCVr3t9CUmP2Q+HQQtSvnA5pw3rb3xzWupIWgChW+S0CRB6wrBg6xEjyrWTpXDsz5cCWYP85E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=AGxJEHdt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="AGxJEHdt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753779543;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=nLaVWqasTGmHO0hYla6Su0l/R5bX2yCx+H21tIpx+p4=;
	b=AGxJEHdthO+LOiWfeKbWP/aCcsfR+O738vAu3f1/26GL7GuV5JrK8LsY/13w/E24vGGzRi
	FqsfkvnonK1DBo9+ND26mKHsLSaB3k1COgDcO9/xKWqSre/3Jje5oKO9/Gc9NlsCWjvcPp
	tMlBd7sOHzaSBxB4riqj2qOkR5A9CcY=
Received: from mail-lf1-f72.google.com (mail-lf1-f72.google.com
 [209.85.167.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-400-40rCt40KNZGKE3RcyEJqfQ-1; Tue, 29 Jul 2025 04:59:02 -0400
X-MC-Unique: 40rCt40KNZGKE3RcyEJqfQ-1
X-Mimecast-MFC-AGG-ID: 40rCt40KNZGKE3RcyEJqfQ_1753779541
Received: by mail-lf1-f72.google.com with SMTP id 2adb3069b0e04-553b94b73d6so3283947e87.2
        for <linux-raid@vger.kernel.org>; Tue, 29 Jul 2025 01:59:01 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753779539; x=1754384339;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nLaVWqasTGmHO0hYla6Su0l/R5bX2yCx+H21tIpx+p4=;
        b=aGe8a2xRdywkzHCLCzM326Ax28V4uFEZOsZZ+3UbPB4/yA88p2B3WTHqdYzAG/Zx9Y
         HJSseSLVS+x1UCleFuzbAXPsLOISId9TDOHw0gwRUcOQ51vOre0kr5EcQCOwVv/zBHDE
         SsErXLrB0qyu5jAXbUG1fYbeeMnjFGIEd49T03WZ2ZEAf9LmHJbMQCgmRjzpSkwoBd//
         ZW3XVuKeiEpJG6pU7UtcZydwXI3PgstZevYUxX0X3UfEL2TIVIHhsUahpvWQpjUWndnk
         rhzCFzA6vD+pf+lZYJANIhG5xur1yPlhSCF1zYBEfcpd1V4kYRtfOXssSHpEHHG+LHiD
         ZsZw==
X-Forwarded-Encrypted: i=1; AJvYcCUwgchODxzorQLDhrQMvuXCoRoi3Q0uvIv3CVvQQL420oLcZQNiLsKIuDEGKPux0pTibLVzLiet1gRe@vger.kernel.org
X-Gm-Message-State: AOJu0YzLmeI26Wsvewh3jxYf3Cn6lmaGmGRQt2nAYGUQ5bzmAyt2Bd3k
	zlTgg9JOV58F2IMwZIJmwX6NxSl3BDHCpyGbvhqJkD89zVt24iVR4bMQWDj99lnHXm/if5rOW4I
	Z3+MIO9fbVADe+AoHq3w/peUYwC9rvkbOoGEdyytkg72Cl2eAUhYMF7yvZvU99dW3fEjzjAQtRL
	yVUNokd5us79P6yEF8/NSod7IgyByi/XTtlspVp2ZwApAL+iWl
X-Gm-Gg: ASbGncs64eHQK5SYTvTTzyN4UDKzCmAjprwOjknF392m7+81cq42Ij/IeyCwIprmPbZ
	huc6sePr8MQ0WSN3TMBd1mx3/qrYipxtYsXAUOVV+MPuTWoo7RjsFHxqg2qSWutB8/A+DKINRxu
	sM8LjO4XeQ+ZGSwXPPzG0Hxw==
X-Received: by 2002:a05:6512:b8e:b0:553:25b2:fd28 with SMTP id 2adb3069b0e04-55b5f4a4415mr3704434e87.42.1753779539462;
        Tue, 29 Jul 2025 01:58:59 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFpIQjuLXRpgPF0yLooUSxkd9LfFsZxa8Tm+5xDoGImr42HXsvJTVkPcKay4BvjSeqmiGT82OAwwTRuGityQkU=
X-Received: by 2002:a05:6512:b8e:b0:553:25b2:fd28 with SMTP id
 2adb3069b0e04-55b5f4a4415mr3704424e87.42.1753779539037; Tue, 29 Jul 2025
 01:58:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xiao Ni <xni@redhat.com>
Date: Tue, 29 Jul 2025 16:58:47 +0800
X-Gm-Features: Ac12FXyFh9kKZ6GM4BpNLAhH8pRPs4Z5gvvvOGut4rrudG1P2QuBzQFU7agUi5A
Message-ID: <CALTww29FRuGzMWiQmzSc=LTnAO4DjJ_buaSZ8h6BGozhvagBFQ@mail.gmail.com>
Subject: Re: [PATCH v4 05/11] md/md-bitmap: add a new sysfs api bitmap_type
To: Yu Kuai <yukuai@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"

I don't receive the patch, so reply by email id
20250721171557.34587-1-yukuai@kernel.org

The patch looks good to me.

Reviewed-by: Xiao Ni <xni@redhat.com>

