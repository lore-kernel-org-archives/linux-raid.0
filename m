Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A08B746BF
	for <linux-raid@vger.kernel.org>; Sat, 23 Nov 2024 03:55:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732334152; cv=none; b=kZKnNkx175GI1VhiwsHXz+sZUMkdKTxzv8Cgvo8K4wAKAxNmTYbpGkr92Dx80ZoDb70jecyz/zB0l2kV/qlhXGtBcnONAvs7xyZjqpT+qMzCMEv9sDK0yf6tnxixWqrwGCiZlFYSg2ukc7LmGYKT84p728bAqm4KIwj1yD+W2uY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732334152; c=relaxed/simple;
	bh=X5hu1MVm7T9lclXS5IawjFTKT7MQBuEM+MdzJtoFJeE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jpRlGQxs3C00fTFa+9kwXCUtqObVaJi4DXW4oSItrAC3EIohVrAk7HgWgYVp8YTq14um94/w1e+bu1cZddluwsOqZAzXKwXeP6kQHvNziIGVb/hzMnX9Asiyuo2wEPfSXOpaVcCZ3sWmZ5RFPtBCL5HL4B8he+SueFHa26JF6W4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=btQJll/q; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="btQJll/q"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1732334149;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=X5hu1MVm7T9lclXS5IawjFTKT7MQBuEM+MdzJtoFJeE=;
	b=btQJll/qeEEdcNCgEoWSo4i5Md65ooFzqishPo1B0V9w7xcJJu+Apm6PtZwyrgXkZM1tTw
	xg4I0mLtflBDAjGZTlSc9cvd+rCFAHQb58NgjoOjZ4HFzhl7agDRitVxDTe8jG0UtOFJgq
	hvm7HlPLvyqpKVv3VzoEBWjEn9DzOvw=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-21-jJsKmvgCPU67i7baLGFcdQ-1; Fri, 22 Nov 2024 22:55:41 -0500
X-MC-Unique: jJsKmvgCPU67i7baLGFcdQ-1
X-Mimecast-MFC-AGG-ID: jJsKmvgCPU67i7baLGFcdQ
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-539f7ed336bso1916207e87.2
        for <linux-raid@vger.kernel.org>; Fri, 22 Nov 2024 19:55:41 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732334140; x=1732938940;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X5hu1MVm7T9lclXS5IawjFTKT7MQBuEM+MdzJtoFJeE=;
        b=tde6KwloFA6hw66qQuAIpd42jhfne2LKdB9ahhVKyX60+BXKZY5ZCl+cYMTrOiAkWz
         tpMRHYtEA5zKAq71OJwzZFwyENe4B55XnhoynR2shGVKbIlKnBXDM+uM3OGpTXyZYYEw
         8u9/l7xkoPW5TnIywXXqdWOTElPDGuUJvuH0MHjyH+XrCKV5PZcx6Swidk3b5KYAglUE
         uWSYN7PMIscNCz7B/RI5Y39XwYldu8wF8raVZPdhEpTbVCnnpaQ514q84eAO1WVZfRkh
         w8CRXL0ABIArHWlDAoVtJdhm5mxy/dRFLWLOKo7sjIwGmgQT5xOF6uqFVaP6U7e9JFM3
         tyXg==
X-Forwarded-Encrypted: i=1; AJvYcCVbi6i8n+jd1bIhV6iMtQtrlaxEHdDXl7rq/ydMwX5DFsu+I2aNRSmkmAME0rUWJUSz77pCnScWDcwZ@vger.kernel.org
X-Gm-Message-State: AOJu0YwgeekyiS7DO0aMcKYvgfeb6RsYX49vDtXe6xEedCu5jLu0cWyq
	qt8ACnj57m5CrjnOiVujTbwdklPG0Kst3SGg7bJgf5bBGK7Jvw6S09poC/pelw/ImK3yoqw/Fj3
	21tf0kfXz4Reyy4jUG+WSvE6SEcifTyeGpdak/4hQYaouGowODww9B15gRkywSHUnaBbpdAJnfA
	ezPZK3Par8grdA+fFxMdf2ZNxMQSJrhJi8GA==
X-Gm-Gg: ASbGncvMSi7ITXgUrN03+BhTLeoeluo0+5DHd84YBuOVBZVpAN0BLf2hbZGH8P4cQX9
	NLu5j4kaQ0Als8iDaqeF99IMPsWxwM+yi
X-Received: by 2002:a05:6512:b93:b0:539:fd10:f07b with SMTP id 2adb3069b0e04-53dd3aafefemr3243574e87.55.1732334140032;
        Fri, 22 Nov 2024 19:55:40 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGenoTOZDbDMjzO/mQJh3mBNjX4OIQpj51uXIgG+SecnhLJy4tqKW2g1ksKPMca0C9DJw4hVhPMJl+Tb7V7zzk=
X-Received: by 2002:a05:6512:b93:b0:539:fd10:f07b with SMTP id
 2adb3069b0e04-53dd3aafefemr3243565e87.55.1732334139666; Fri, 22 Nov 2024
 19:55:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20241118114157.355749-1-yukuai1@huaweicloud.com>
 <20241118114157.355749-6-yukuai1@huaweicloud.com> <CALTww28JrdXoNXQNPxx2Sg9L2iL20jZZ80Y-qZzqcyF780M1fg@mail.gmail.com>
 <e6843d53-c7f4-2e38-0a15-91b49afec8f1@huaweicloud.com> <CALTww28ZRFo6BwqzriVpoOuqbfygKrU0HuOhhUxLe9cBBDY-ZQ@mail.gmail.com>
 <e3319ea0-f9aa-6048-c620-4e72f2b10b31@huaweicloud.com>
In-Reply-To: <e3319ea0-f9aa-6048-c620-4e72f2b10b31@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Sat, 23 Nov 2024 11:55:26 +0800
Message-ID: <CALTww28kr5TzWoeMrS-W_etfhwQGQHDQ-DeakTEALUGDE9FNVA@mail.gmail.com>
Subject: Re: [PATCH md-6.13 5/5] md/md-bitmap: move bitmap_{start, end}write
 to md upper layer
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: song@kernel.org, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yi.zhang@huawei.com, yangerkun@huawei.com, "yukuai (C)" <yukuai3@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Nov 22, 2024 at 4:32=E2=80=AFPM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> Hi,
>
> =E5=9C=A8 2024/11/22 11:14, Xiao Ni =E5=86=99=E9=81=93:
> >> Ok, one place that I found is that raid5 can do extra end write while
> >> stripe->dev[].towrite is NULL, the null checking is missing. I'll
> >> mention that in the next version.
> > Does this can cause the deadlock?
>
> Not deadlock, the bit counter will underflow and reach COUNTER_MAX, and
> bitmap_startwrite() can wait forever for the counter.

Hi Kuai

For normal io, endwrite is called in function
handle_stripe_clean_event when sh->dev[i].written has value.
For failed io, endwrite is called when bitmap_end has value.
bitmap_end is set when sh->dev[i].to_write is not NULL.
Which place does extra endwrite?

Regards
Xiao
>
> Thanks,
> Kuai
>

