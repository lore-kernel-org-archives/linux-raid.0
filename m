Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 430801EA7C4
	for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 07:20:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752736853; cv=none; b=ZdH0b/o2vf6gMtWzxm8qJ2CGwRDHql/B356Qhpg+G0vktgJNb9bSQjJXzHnoOlJcX+EFeH7v8bJQtBTxSCFbSRdnuYKM+eH7xNHHXVl4OumAKvVgM6ez4W016OUQ+JP37pMrp+ib27WYO57zjv3EHItS/Vp3yzP7/R3fE74vnWc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752736853; c=relaxed/simple;
	bh=BnVTI5IWmkYb64d8ClKjXQD5FfTg+jbU2ZRDVVyZcTY=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=O7c4L2XL2mlHd47cmd5De9+Y67jNmnKq6pX+vTutgw9L+XqO11cpdW+hquxmybsPhRGHAevL0byi7GEApGAjnQ5pP3aGXB+vB5jQ5/PPhcO3T+/Ir4pE4y1FfLywgRcPfxXUU1Z46PnobJ177jdyNbZHaSQSLrc5ORhizsxOnJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=bIbzyQ5a; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="bIbzyQ5a"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752736849;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type;
	bh=ACVwW5MpE8yc20tQvFWdOafzGoHO3/7OpxtRWjnsE6s=;
	b=bIbzyQ5aJ6lN+EnOm5vG1ndkzLtbjG4OFeff8OhenqjDXDXVvKm/c/x5Nz2zfge/xuzCk3
	+TI5xrXJKDrHSmaDKH2HuP1rpRLDAtxurMDiMTy6n21ey9chL259AWO/z6L8Ozyp8ig2Vs
	Luna3PtQ65Jt+gjMdPDoYa1UARx3jjk=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-398-b24Z1cmWNyCQej8-Wobu-g-1; Thu, 17 Jul 2025 03:20:48 -0400
X-MC-Unique: b24Z1cmWNyCQej8-Wobu-g-1
X-Mimecast-MFC-AGG-ID: b24Z1cmWNyCQej8-Wobu-g_1752736847
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-32e0bb64d99so1112351fa.0
        for <linux-raid@vger.kernel.org>; Thu, 17 Jul 2025 00:20:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752736845; x=1753341645;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ACVwW5MpE8yc20tQvFWdOafzGoHO3/7OpxtRWjnsE6s=;
        b=mqwUeY7S3s3N3EOy+SoOZ9/PD85LyJYSsZVVUNNEybACl8qtydPSgiWzJRVrwukvKm
         c074v6dTLeTrpMOa2s/TOVZ/bSgjdxQPzFU9IWLAm9vqZtL3KzZZZHwvLJoSYjA21wYp
         0DOUIiZMJtVskDNzakuNyRXC16IR4MwpeAjGjE9kUCFeoa++zxzJpYHgWU/h/XcWMAa7
         5r7QIXszlrr/YnMYQXeWGg+QBdV65aH1kVH6M4a3D7OYt9WUUUSJX5uKH1DTDrsSRm1D
         I6hgv7gAfLDlM91vEBOjg+MOwR5+yR5sQB0elwUU8PLhy0YrLNJCOV59E8xlsKK0gcLR
         a/vQ==
X-Gm-Message-State: AOJu0YwhvqqzMLYKiVrHREBJgSOLA8DRZHFPVKx/NmqSBjV81iznlJ06
	Z766oYl+vcB5T7ww5xyqYs3A/k1+wPbtJmn7/lbt+fbqLFbIZQles/z/1KYUxxzHQC86HoSL565
	jq4rgh0Df+KoCqy51cchx/RE1Q1Uq0XSn4jaDDf/UKOm+A2xcrCOADg9ARu/1u3n4E7FSnGGh8i
	nsytRudQgAjfAmlhIyzaI+8vAr+cCwH3/1f0M7xrOKdTzwgRww
X-Gm-Gg: ASbGnctXpNWyGuLgf9IsXZLHAjUfP9XX1Ud20VRHgiLA1ZHqqoQG1s5DrtUnLESn2BA
	N+a8BxuUugA7nwtaFpv2dn58QCEkF3luQ/wrxYU1BbNcZ/jb3yR+xYxbqpGQ+4aENgYxRkjHRfn
	UaQZKyHVVhs09SIamRxZ4oGA==
X-Received: by 2002:a05:651c:2117:b0:330:8c4a:4749 with SMTP id 38308e7fff4ca-3308f6519damr16011031fa.37.1752736845068;
        Thu, 17 Jul 2025 00:20:45 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGkOedYfw5ltLulMAyHRR5GkHQGxPhN0D96vxoP/IOAWeaICtbjmcS/DkLzrjIOgiXDZYXPjTgc/7I4Ynl2wIA=
X-Received: by 2002:a05:651c:2117:b0:330:8c4a:4749 with SMTP id
 38308e7fff4ca-3308f6519damr16010941fa.37.1752736844605; Thu, 17 Jul 2025
 00:20:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Yi Zhang <yi.zhang@redhat.com>
Date: Thu, 17 Jul 2025 15:20:32 +0800
X-Gm-Features: Ac12FXyO1Bie3QxqedyWvPdhKWVg0eEmhrZRapS6HemxeqIZocNvF91Sgk9owqI
Message-ID: <CAHj4cs9wqRvxxTVMYxPcaCQoedeRNn6CHJ_K5GsqS6YKMHeXiA@mail.gmail.com>
Subject: [bug report] blktests md/001 failed with "buffer overflow detected"
To: linux-raid@vger.kernel.org
Cc: Xiao Ni <xni@redhat.com>, Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>, 
	linux-block <linux-block@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"

Hi
I reproduced this failure on the latest linux-block/for-next, please
help check it and let me know if you need any infor/test, thanks.

Environment:
mdadm-4.3-7.fc43.x86_64
linux-block/for-next: 522390782310 (HEAD -> for-next, origin/for-next)
Merge branch 'for-6.17/io_uring' into for-next

Reproducer steps
# ./check md/001
md/001 (Raid with bitmap on tcp nvmet with opt-io-size over bitmap
size) [failed]
    runtime  3.511s  ...  5.924s
    --- tests/md/001.out 2025-07-15 06:27:41.496610277 -0400
    +++ /root/blktests/results/nodev/md/001.out.bad 2025-07-17
03:10:50.718820367 -0400
    @@ -1,3 +1,9 @@
     Running md/001
    ++ mdadm --quiet --create /dev/md/blktests_md --level=1
--bitmap=internal --bitmap-chunk=1024K --assume-clean --run
--raid-devices=2 /dev/nvme0n1 missing
    +*** buffer overflow detected ***: terminated
    +tests/md/001: line 69:  1835 Aborted                 (core
dumped) mdadm --quiet --create /dev/md/blktests_md --level=1
--bitmap=internal --bitmap-chunk=1024K --assume-clean --run
--raid-devices=2 /dev/"${ns}" missing
    ++ mdadm --quiet --stop /dev/md/blktests_md
    +mdadm: error opening /dev/md/blktests_md: No such file or directory
    ++ set +x
    ...
    (Run 'diff -u tests/md/001.out
/root/blktests/results/nodev/md/001.out.bad' to see the entire diff)

-- 
Best Regards,
  Yi Zhang

