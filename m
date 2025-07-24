Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A92F5225779
	for <linux-raid@vger.kernel.org>; Thu, 24 Jul 2025 07:07:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753340828; cv=none; b=fGmU+9JYbKBmSUscUyc+8Zi2YdeD3Z+MdgOJao47GsFJHYngbu58/NIYF/lJQg+LzhL7jRCUU+4Grm4L9V6Ny0cC2cYfqXZ5yYUHZXH+TQpK9pmdBMOzt70+cE23W0bCtO+D9XWQlgWkUtIORotBS7Wul4+NMwDxrZsHMp1yQw4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753340828; c=relaxed/simple;
	bh=iWK+A0yndAcCi87CdgUDVZ42kgSv/Ah+s40XKuWQn+I=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=FI1DXN0eJ2QkYLqCqNukh7Totrqs91gyRAuAO8eOpkL/b5ffBi9A++phqZ+i0Yh3a5FMVzPd925yElogilGoVVK2f+PfLzqnP2Nk1pk4Abz8sLCdeFhS4mjzXxkxXEFuYvwFQ9kH4Ivo6m3jVn0rEXcs1QSVE959wtd9FhTCbjY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GaqeahZn; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GaqeahZn"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753340825;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=qhRjed6D5yywdnqVu+M//WAdRaN5hUsBxAof5Q7IU8o=;
	b=GaqeahZntEkYuYhejO9EpuEgrrm40cJgcpXJXgcnuB1JRkpBOglOJ3d9ovKSS5zLMwts2Z
	XWi13TDm3ySSfFsx+nVovsNac0THC9xBEe71IXTgSemq0e9NgI18TMkaCHrLZe7ZvR5Q73
	eApZZORignecdZ+QFfjprs2iAsx5sCY=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-691-caoRrz_nPZq6U4Ac3RsNRA-1; Thu, 24 Jul 2025 03:07:04 -0400
X-MC-Unique: caoRrz_nPZq6U4Ac3RsNRA-1
X-Mimecast-MFC-AGG-ID: caoRrz_nPZq6U4Ac3RsNRA_1753340823
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-3132c8437ffso1180597a91.1
        for <linux-raid@vger.kernel.org>; Thu, 24 Jul 2025 00:07:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753340823; x=1753945623;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qhRjed6D5yywdnqVu+M//WAdRaN5hUsBxAof5Q7IU8o=;
        b=oVzG8Ogn3G6FOvtUfQFOHJKg3GqrO1ar1UtE8KLzZLk8Rcvd5SHf3oYWlz9b6E/ZsJ
         RCZNDvhTLsQm5yLa8M+27C/EpRkOWL2d33TCqj7RhIWnPf5kKbHMSAjbtP1TJNuTj/yH
         A6O/g/DzlXLzkCPGrX2+/LiHJaocxNvRChEYIoUQZ5B48rPGwnIO68TOCW1vzT4otiB2
         bPugqrkqVXVyP4kcZ8fi/ol4MTS6arfYvOxYMHvJg3IYreSgFfslaORV8/Yux45yFHwt
         Aea9b234JTi3pS+T7IjGvajpS4vWwVT7MMA2UeXj4bpS/aIVu2nMmpcgV9Gv72sST+Zt
         npQw==
X-Forwarded-Encrypted: i=1; AJvYcCVizPLV5H81EDAZRniaVTTZCGBkEU2AR6K8xQ9qPH3rnF7ZcVIMlgwz8Pbl7LtMRF0sOUxKeChYAjKP@vger.kernel.org
X-Gm-Message-State: AOJu0YwTlCi4nxEplVAxXmK/QNIyPSn2mPnQcae54gEj8blDaWTUVbaz
	QHHxJlP9mIRfaIfqVDwt+h6gIGCRbzQrlMhtO8ZA35yacAbeOQsRJ6okAGyGjUFIbqvtmsNlhPj
	EXW1C47uzUaTCK4kYn33+ax3dk14ZKmLpoA/CB3EonX6eN+bJBJEVddglbh2HNzDNMZovnJXHJF
	c9x20YNV1DI+XtJ+K9EooycFue2HZHDYcAECvzXw==
X-Gm-Gg: ASbGnct61gQ0EIcvMVHhCbJE9CzwwvzPDq4gW1WQpC+MmYXkmysou2bkwEXQ4pz7Lg4
	E16w6pOeK2X1uRWq9ldfMwWj4XQYtuLaDn6sOCQCj7edaSeUO4gSimSYEKPiohBT/rJ4eEhoMMT
	jBCLPbkZPki9qw9XS0IWGr5g==
X-Received: by 2002:a17:90b:1dcd:b0:311:baa0:89ce with SMTP id 98e67ed59e1d1-31e506fcaefmr8748872a91.12.1753340822878;
        Thu, 24 Jul 2025 00:07:02 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHsmkCwqD0jVfuCRMThIvqqKSimGvVlrkXKRaXUXNS9QyAlhTLIiGKNTHsEEsFUUaFB6NjrzlgDmrfEKKEzRAM=
X-Received: by 2002:a17:90b:1dcd:b0:311:baa0:89ce with SMTP id
 98e67ed59e1d1-31e506fcaefmr8748850a91.12.1753340822497; Thu, 24 Jul 2025
 00:07:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Changhui Zhong <czhong@redhat.com>
Date: Thu, 24 Jul 2025 15:06:50 +0800
X-Gm-Features: Ac12FXxqPnaU8Nv7QqwLfAJm5zSb3CC_n2SYuAR3EBnwy9SGK6fyqb9qTVvZz-E
Message-ID: <CAGVVp+X8GYS7yKkq-qxJ5hpTL=vHMBgG=wuSsNJZ0VrjQeMA6w@mail.gmail.com>
Subject: [bug report] mdadm: Unable to initialize sysfs
To: Linux Block Devices <linux-block@vger.kernel.org>, linux-raid@vger.kernel.org
Cc: Xiao Ni <xni@redhat.com>
Content-Type: text/plain; charset="UTF-8"

Hello,

mdadm fails to initialize the sysfs interface while attempting to
assemble a RAID array,
please help check and let me know if you need any info/test, thanks.

repo: https://git.kernel.org/pub/scm/linux/kernel/git/axboe/linux-block.git
branch: for-next
INFO: HEAD of cloned kernel
commit a8fa1731867273dd09125fd23cc1df4c33a7dcc3
Merge: b41d70c8f7bf 5ec9d26b78c4
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Jul 22 19:10:37 2025 -0600

    Merge branch 'for-6.17/block' into for-next

reproducer:
# mdadm -CR /dev/md0 -l 1 -n 2 /dev/sdb /dev/sdc -e 1.0
mdadm: array /dev/md0 started.
# mdadm -S /dev/md0
mdadm: stopped /dev/md0
# mdadm -A /dev/md0 /dev/sdb /dev/sdc
mdadm: Unable to initialize sysfs
# rpm -qa | grep mdadm
mdadm-4.4-2.el10.x86_64

and not hit this issue with upstream kernel
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git


Best Regards,
Changhui

