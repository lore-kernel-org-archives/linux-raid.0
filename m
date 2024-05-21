Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D982A7F
	for <linux-raid@vger.kernel.org>; Tue, 21 May 2024 07:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716275176; cv=none; b=SSa3XpKKX0WF+UryWmlGLg5nDm5bq6AF5bRvR8ytvyCn50rFHVJmEKUYISELpsobU+msptOPw35+l0sCPMM+H4A6DwGJJPsJ4aM8KeVfDejE/Z25EoFxxfJjMeGrC4pmgoj0XM7jbsvAEanx32g1vKmqf7KyvZwhdN5iGO4SPiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716275176; c=relaxed/simple;
	bh=IL66pPd+ZaOQP3wALn5K+ry7M6JFPW1e1kOkqHcd178=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=ts0xto06ZcHQ/eLLquwyDc+kxlAK33VcXLOnaVFjK3/Zm2RItbAXKdeefOzlSHiwgIMADvJH9sJ08oFti3vL9dOSJqtXYDbD4RBI9/0Vb43y1GqinvjX3drqLPiy3QamSalVN09XL5konEJVan4AnxZet98k7dcDINkuJ5Haiz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Tdf7WFMB; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Tdf7WFMB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1716275173;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ygeGEdecc51DHtiLK6Fn9CViaiJJbaR0wcyNvhUw+zc=;
	b=Tdf7WFMBPSg75+6pmJo7JGVjsi5BXjyLWVeIhd36WI65nJNsqONo95dmRmL1z8F6MEoxpB
	cF3L+Li/vvZbxH3eHugCEPYiKiIXIcPkCzywq/Zj2T/D+Tp0isP69P7NuhmsQvWcCtcCO0
	cJ4CNrQ+ocA/7bwBaCKoq+uoRz6mcng=
Received: from mail-pj1-f71.google.com (mail-pj1-f71.google.com
 [209.85.216.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-245-EU_oujnnMEWHQHgEZ1fW3Q-1; Tue, 21 May 2024 03:06:09 -0400
X-MC-Unique: EU_oujnnMEWHQHgEZ1fW3Q-1
Received: by mail-pj1-f71.google.com with SMTP id 98e67ed59e1d1-2b2a8bd5ee0so10985960a91.2
        for <linux-raid@vger.kernel.org>; Tue, 21 May 2024 00:06:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716275167; x=1716879967;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ygeGEdecc51DHtiLK6Fn9CViaiJJbaR0wcyNvhUw+zc=;
        b=cNVRdPSiGx0J5Us04bIyZZ/26g8IfcYI3APW/A0h3Ef3uyDdij1V1o+eDGeuwGj/GO
         E9BGl1oo8ncPQR96u1SN9WoDXN5COb37xczyODwBx85GHU6Dxdn5CgcbeydN/y4tgyPa
         nX3erNyAFZa2p3c2mZwURsbpm7Eg8wM4ICAzosgJSKLfRKNGB+5h43fR+FHf/jKL6Pbv
         cqD1YuXjDkJNniVqfb2rxZtGFfxyln5ttkjZK3WugVnQVbNusku3tstgweiXAaWDmu45
         KcJ+uTNtDwODU66NhIWthoaONGM2Lf2nO34ekH9oryDVPwfXZbmR6soRjrLJTBgBbcOq
         1w4A==
X-Gm-Message-State: AOJu0YypMiLUKdLgl19f4AP7WJppRWW/95wJTksN9SrUZU/3K5/bh7YF
	9s5bsPAOfBQxmSkDqun3BDlfi3hGPM+nHCiuIYVR+WG4cgbn7amZXLnRIcAbqcvdcZaYbBthZ4X
	dS3s+MLEeIS8Gj/ZdjJRWiagcvAe9Qd71lIVi+BY9K/wpo1UaZs/0zTguxXtCTYInO3lS6jo8MA
	1YsIyIDJMUNCgNPzHWh1oOZ0FmKM4G0i8Q36acsSbPvuge+a/wSg==
X-Received: by 2002:a17:90a:ad92:b0:2ad:ec71:b7e5 with SMTP id 98e67ed59e1d1-2b6ccd76dbemr27595610a91.33.1716275167348;
        Tue, 21 May 2024 00:06:07 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGCMiDSnBduoNnPZ2HRsQ2OmtqyoY0EiVRMFPclR1/ZthYtr2Uxo5+l8qgBe7IJ02wyeEv7ZQ9geeZvRovbJUU=
X-Received: by 2002:a17:90a:ad92:b0:2ad:ec71:b7e5 with SMTP id
 98e67ed59e1d1-2b6ccd76dbemr27595596a91.33.1716275166975; Tue, 21 May 2024
 00:06:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xiao Ni <xni@redhat.com>
Date: Tue, 21 May 2024 15:05:55 +0800
Message-ID: <CALTww28qp4d=mvdXvLqHPTrt0FAJihdMOQMrAyL44urstSdznQ@mail.gmail.com>
Subject: mdadm/Create wait_for_zero_forks is stuck
To: Logan Gunthorpe <logang@deltatee.com>
Cc: linux-raid <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi Logan

I'm trying to fix errors of mdadm regression failures. There is a
failure in 00raid5-zero sometimes. I added some logs:

In function write_zeroes_fork:
                if (fallocate(fd, FALLOC_FL_ZERO_RANGE | FALLOC_FL_KEEP_SIZE,
                              offset_bytes, sz)) {
                        pr_err("zeroing %s failed: %s\n", dv->devname,
                               strerror(errno));
                        ret = 1;
                        break;
                } else
                        printf("zeroing good\n");

In function wait_for_zero_forks:
                if (fdsi.ssi_signo == SIGINT) {
                        printf("\n");
                        pr_info("Interrupting zeroing processes,
please wait...\n");
                        interrupted = true;
                        break;
                } else if (fdsi.ssi_signo == SIGCHLD) {
                        printf("one child finishes, wait count %d\n",
wait_count);
                        if (!--wait_count)
                                break;
                }

while [ 1 ]; do
  /usr/sbin/mdadm -CfR /dev/md0 -l 5 -n3 /dev/loop0 /dev/loop1
/dev/loop2 --write-zeroes --auto=yes -v
  mdadm --wait /dev/md0
  mdadm -Ss
  sleep 1
done

zeroing good
zeroing good
zeroing good
one child finishes, wait count 3
one child finishes, wait count 2

It looks like the farther process misses one child signal.

root      174247  0.0  0.0   3628  2552 pts/0    S+   02:52   0:00  |
             \_ /usr/sbin/mdadm -CfR /dev/md0 -l 5 -n3 /dev/loop0
/dev/loop1 /dev/loop2 --write-zeroes --auto=yes -v
root      174248  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
                 \_ [mdadm] <defunct>
root      174249  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
                 \_ [mdadm] <defunct>
root      174250  0.0  0.0      0     0 pts/0    Z+   02:52   0:00  |
                 \_ [mdadm] <defunct>

]# cat /proc/174247/stack
[<0>] signalfd_dequeue+0x14d/0x170
[<0>] signalfd_read_iter+0x7b/0xd0
[<0>] vfs_read+0x201/0x330
[<0>] ksys_read+0x5f/0xe0
[<0>] do_syscall_64+0x7b/0x160
[<0>] entry_SYSCALL_64_after_hwframe+0x76/0x7e

Any ideas for this?

Best Regards
Xiao

