Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF0CDF43
	for <linux-raid@vger.kernel.org>; Wed,  5 Jun 2024 18:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717613697; cv=none; b=D4JfjzMCrDUEw4SeQIjoxk9jNkXissAcqCaXe9zRXunkk4hmH7LqEAY9xkvGOG0GcYb41nrVdRL73QQartJGPjju8jX9dUMb+r4qowtwFMB4TNRWoPEpyxc2cpu4eurIbVr94485AeZu13w7lDlvi7M7s6C+2WRQ4aEqXkaISjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717613697; c=relaxed/simple;
	bh=k3Z3DKv75s5pFe9+ENmCP9Q8nErOA3BvZKtPYSmiVCQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O4nU2zOrB6rGk+gRkDMLQYwrfU43i4XFQIV5/52hgcvDXfpo13i+6Bt8qsWqybrJhbt3+FdNVjA/JNR5MbngHbp/X99+sPrAdoLcy9j9W+gYDRsyn0IvWv9FSErzJHaKmxuKAtw604i+hPYtsXA5sWdDKQUURgssHrAmcMjJYCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=aRMTIIOH; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="aRMTIIOH"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1717613695;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=k3Z3DKv75s5pFe9+ENmCP9Q8nErOA3BvZKtPYSmiVCQ=;
	b=aRMTIIOHRzMxZy7fuo7nrwIMAzlGPJmdcn/R786M1C/YhJwzDxZHFYh3uzDPCgj7tLtDe7
	2DaQG6/sHbJK0leVvz69J2IimdNlglfE7O5vD9iQwUr5bPMHWra5Nnro3YHa+UX+vBr/s0
	6SB7F9IE9losIoxrgDWXP7GMG6diok0=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-553-td-bqM2bMFaTmsahuvhPJg-1; Wed, 05 Jun 2024 14:54:53 -0400
X-MC-Unique: td-bqM2bMFaTmsahuvhPJg-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ea95d34474so926911fa.3
        for <linux-raid@vger.kernel.org>; Wed, 05 Jun 2024 11:54:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717613690; x=1718218490;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k3Z3DKv75s5pFe9+ENmCP9Q8nErOA3BvZKtPYSmiVCQ=;
        b=Bkge6qvV1IwehHEOBsLLXNvwWVeMDeEeJOok/Z6oF1LNiFlZiG5NnlEdYq5ySqo+qH
         qon/dUCsFmtsnNS/Jy7qg575etm8y8fblHg2Q2NMXSkVYsxnTbt5UOa5jjd5J7rPg5p5
         YUixSJdIAYzwutbKhdF/eD0Dy3glAbUq5wAwUQzbv85K8hqWh11aaHk36D2QC7aoI3nu
         srgoQWe6NUgKMCMCJKqMSnXzGTX64z7A/AxM4wLyUE1weUHMSta7mK3osENRB9msZCns
         KiwLcvTUwQvWiVc6VT87/IrC00g/ndHZj7CHfq6w43O/l9Y5bjInDHfsUM1fiZXJ0PIO
         qiNg==
X-Forwarded-Encrypted: i=1; AJvYcCWfx/AYZAijUBUvIcZ3/kO+NVJKlbVyfHssSQmElmpVlKfZWTrE1zeRapyWyBkr3vCL3MxxRWzEIZwBviC3A3iHSCzsIBz2e1zzQg==
X-Gm-Message-State: AOJu0YyFEetK6gBqKQXeSFYT06Lrew5ukSU5+dVv3ViRYUDCvmnUnSkn
	9mHuW7RHswn+icPDHsUVelcNKez2ipo9IQpIWyPqAwS3QdCcf/OvoeC4ltt825B7Akmdy8XvOdV
	d5jQeE2L65VXorjlGCRy7P4yNRRVlAHH8/3LETE5vTogC6W3l0CwysqQeESg9sGPHRdWFAzRwzU
	24hBtVQzZ7E0gXlWEXvUB90nN4zSGCR1GQSg==
X-Received: by 2002:a2e:b682:0:b0:2e6:ccfd:fae1 with SMTP id 38308e7fff4ca-2eac79bfd47mr19319811fa.17.1717613690513;
        Wed, 05 Jun 2024 11:54:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGRtAer/gXo+tP1WyS7r5yx6ZXydl1feHR9wjzM39UEmsAgVtJGcDexqkLOSh0vBcQ043XV5KcYE70gD/wSqLs=
X-Received: by 2002:a2e:b682:0:b0:2e6:ccfd:fae1 with SMTP id
 38308e7fff4ca-2eac79bfd47mr19319701fa.17.1717613690120; Wed, 05 Jun 2024
 11:54:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240603215558.2722969-1-aahringo@redhat.com> <20240603215558.2722969-9-aahringo@redhat.com>
In-Reply-To: <20240603215558.2722969-9-aahringo@redhat.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Wed, 5 Jun 2024 14:54:38 -0400
Message-ID: <CAK-6q+i18_oHfdh6Odfidi0y4hWiR9bn_svWf2BwPqnLwdEFGQ@mail.gmail.com>
Subject: Re: [PATCH dlm/next 8/8] md-cluster: use DLM_LSFL_SOFTIRQ for dlm_new_lockspace()
To: teigland@redhat.com, heming.zhao@suse.com, yukuai3@huawei.com, 
	song@kernel.org
Cc: gfs2@lists.linux.dev, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,

On Mon, Jun 3, 2024 at 5:56=E2=80=AFPM Alexander Aring <aahringo@redhat.com=
> wrote:
>
> Recently the DLM subsystem introduced the flag DLM_LSFL_SOFTIRQ for
> dlm_new_lockspace() to signal the capability to handle DLM ast/bast
> callbacks in softirq context to avoid an additional context switch due
> the DLM callback workqueue.
>
> The md-cluster implementation only does synchronized calls above the
> async DLM API. That synchronized API should may be also offered by DLM,
> however it is very simple as md-cluster callbacks only does a complete()
> call for their wait_for_completion() wait that is occurred after the
> async DLM API call. This patch activates the recently introduced
> DLM_LSFL_SOFTIRQ flag that allows that the DLM callbacks are executed in
> a softirq context that md-cluster can handle. It is reducing a
> unnecessary context workqueue switch and should speed up DLM in some
> circumstance.
>

Can somebody with a md-cluster environment test it as well? All I was
doing was (with a working dlm_controld cluster env):

mdadm --create /dev/md0 --bitmap=3Dclustered --metadata=3D1.2
--raid-devices=3D2 --level=3Dmirror /dev/sda /dev/sdb

sda and sdb are shared block devices on each node.

Create a /etc/mdadm.conf with the content mostly out of:

mdadm --detail --scan

on each node.

Then call mdadm --assemble on all nodes where not "mdadm --create ..." happ=
ened.
I hope that is the right thing to do and I had with "dlm_tool ls" a
UUID as a lockspace name with some md-cluster locks being around.

To bring this new flag upstream, would it be okay to get this through
dlm-tree? I am requesting here for an "Acked-by" tag from the md
maintainers.

Thanks.

- Alex

