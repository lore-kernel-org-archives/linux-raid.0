Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AEE023B0
	for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 14:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718029100; cv=none; b=iAf7vjsGdMcaNW8VdFAR3fAaLO2VO1ZqsLQO1GTkY6iSvtgCvn76TVioRcFlkboiz6uz8YQZJhkWnc3eYhMbNIcyGCGNQyOLp9rMqvcVfVem/28HBnXcG9R3TEVXc8F9lr6kSwXicFEjdFxJ9IDlF70vihjEOFt/XZSaodsMvL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718029100; c=relaxed/simple;
	bh=witgDr4/dJHGtjNydpq7rvXtrgLEr20TZ9umaz90Scc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=maGvbvCu0vaeKJj3CR5HXIBzevpF2s23c9tf21z+BtWqoP02CwTvw0mxzTzDNBqKkztWVl1IJgfi9zgjZ+/5HO+rSTOaGQon2c5CRLHJPH7YbgwV0KTzZbu0dEs2kR3NyFPxHJYWn7LTnvo/kdBZTG8nblu3Vql85e3W+9u4pHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KI8AAP5B; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KI8AAP5B"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1718029095;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=witgDr4/dJHGtjNydpq7rvXtrgLEr20TZ9umaz90Scc=;
	b=KI8AAP5BDTSVe+gZ/HXyQ6jkEedPPO8JjrsakBxIbeRNbAy9t+15G7nFIgeWuzGxeEn3Uk
	rSloCAFtDf0N59hXpvuRbcvDoZv7iH5f4y6mT3lDORcxF6SbmGYgy3+/1nFZvyuv13L8Tt
	EsEcP5pH+t7FHqEy37zTg6PLDK+Tn8A=
Received: from mail-lj1-f200.google.com (mail-lj1-f200.google.com
 [209.85.208.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-481-eT-YNf92OgWlYMcJ7CP5BQ-1; Mon, 10 Jun 2024 10:17:24 -0400
X-MC-Unique: eT-YNf92OgWlYMcJ7CP5BQ-1
Received: by mail-lj1-f200.google.com with SMTP id 38308e7fff4ca-2ea892f8441so32410521fa.1
        for <linux-raid@vger.kernel.org>; Mon, 10 Jun 2024 07:17:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718029043; x=1718633843;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=witgDr4/dJHGtjNydpq7rvXtrgLEr20TZ9umaz90Scc=;
        b=lEn1N/ob6CJdGyiFtOObXgNWVsqWBQIlzQtQBf+cdsmQz7wMmkLg0oFOHVz8WlXhdA
         xc5XmzzMnuPYihFacmFTMP2/tK2B357DMyzJ+peu7+xgZorEA5eB2q0EuWFphNXEtNNd
         +/MzmVf8XjVw1t/LxBGWKFX6HuM32duncLD/tEhGWDNGbf6+mNvQJguiVfKNS86ebjdq
         goQ//XPysdAWVT7JCDVsYLQEdqJ1WlIfvLLEVxJgeNo7+jfykLBhEnvlJuLUswvmcCP3
         75qbQoZt99vhAz1+q6iL+48rf4LViDh7DxPqrrdNZLE4u89tryXDuj4DJN4reZ6AbBi4
         +Wdw==
X-Forwarded-Encrypted: i=1; AJvYcCVqw0PN07jX2tSV7wb5wWqEF7gCgziWLnrQkNWseXwX3iQtk1ySxR1KhqSP2W68xqd0hWpdeCD7bP6E8FasKR5JqXuCIKMfR3DwFQ==
X-Gm-Message-State: AOJu0YwkcsEwQ2WigZ46EX0lctoB1NHlsNvAt0c5BssheqK07qWHjWuR
	8rgJ2ctBkPLlCewFCLwpEv4JNApo7moGK5Cai9NLMHtmFpprSGCKEIDO/PP3j+NkFbhAaBtJKHX
	P6RPmDOk/IhBtiuZ0EaZt6uge7kqq7Zco/iLjkIAfpl9JePty91KqWwZbf8yWBvNmtmc8CcdOW+
	ZZKCIqhCjcyOrOnF0lsYNfdMsDJApmq6G9Cw==
X-Received: by 2002:a2e:9216:0:b0:2eb:d92c:58f8 with SMTP id 38308e7fff4ca-2ebd92c5b1emr31516381fa.19.1718029042790;
        Mon, 10 Jun 2024 07:17:22 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHwmgL9HRoSiNinc9IFG7zhtdoItvWRDTikkFEM4XBA388KgAHS+Ve9n6NSjG9HsrZgeQrp1X7tWOrZR/zT4aI=
X-Received: by 2002:a2e:9216:0:b0:2eb:d92c:58f8 with SMTP id
 38308e7fff4ca-2ebd92c5b1emr31516141fa.19.1718029042405; Mon, 10 Jun 2024
 07:17:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240603215558.2722969-1-aahringo@redhat.com> <20240603215558.2722969-3-aahringo@redhat.com>
In-Reply-To: <20240603215558.2722969-3-aahringo@redhat.com>
From: Alexander Aring <aahringo@redhat.com>
Date: Mon, 10 Jun 2024 10:17:10 -0400
Message-ID: <CAK-6q+gCkJyDhqxpRw_TKO1fHshnx5+oRjQrB_LeY+RE7SuKRA@mail.gmail.com>
Subject: Re: [PATCH dlm/next 2/8] dlm: remove struct field with the same meaning
To: teigland@redhat.com
Cc: gfs2@lists.linux.dev, song@kernel.org, yukuai3@huawei.com, 
	linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi,


On Mon, Jun 3, 2024 at 5:56=E2=80=AFPM Alexander Aring <aahringo@redhat.com=
> wrote:
>
> There is currently "res_nodeid" and "res_master_nodeid" fields in
> "struct dlm_rsb". At some point a developer does not know when to use
> which one or forget to update one and they are out of sync. This patch
> removes the "res_nodeid" and allows "res_master_nodeid" only. They have
> different representation values about their invalid values, the
> "res_master_nodeid" seems to be the modern way of represent the actual
> master nodeid and actually use the nodeid value when the own nodeid is
> the master (on res_nodeid the 0 represented this value). Also the modern
> nodeid representation fits into a "unsigned" range as this avoids to
> convert negative values over the network. The old value representation
> is still part of the DLM networking protocol that's why the conversion
> functions dlm_res_nodeid() and dlm_res_master_nodeid() are still
> present. On a new major DLM version bump protocol the nodeid representati=
on
> should be updated to the modern value representation. These conversion
> functions also applies for existing UAPI and the user space still
> assumes the old "res_nodeid" value representation.
>
> The same arguments applies to "lkb_nodeid" and "lkb_master_nodeid"
> wheras this is also only a copied value from another lkb related field
> "lkb_resource" and it's "res_master_nodeid" value. In this case it
> requires more code review because "lkb_resource" is not set sometimes.
>
> This patch so far makes the code easier to read and understandable
> because we don't have several fields with the same meaning in some
> structs. In case of the previously "res_nodeid" value, sometimes an
> additional check on our_nodeid() is required to set the value to 0 that
> represents in this value representation that we are the master node.
>
> Signed-off-by: Alexander Aring <aahringo@redhat.com>

__dlm_master_lookup() returns "-1" (the old value representation for
invalid nodeid) and it should return 0 for invalid now.
Also we forgot dlm_send_rcom_lookup()/receive_rcom_lookup() to update
using the conversion functions.

- Alex

