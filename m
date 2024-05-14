Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 038641802E
	for <linux-raid@vger.kernel.org>; Tue, 14 May 2024 05:51:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715665886; cv=none; b=Ym+CT0lFRaeUtvUjHV6HsLYN44Q6cPjZUSMt/fXz+ryVnzwhbmrL7pnqf7Vt6KqW7eGlp65aY/BKzd71YHnhdpaCjDTANyGB1fpquAFoMsr+8ah9/qJUNy096wdWhS4umW8+gJZJ8yOdEhUX0sJ8B7cnBOlz0Ju6hbcnVI+F2nU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715665886; c=relaxed/simple;
	bh=OF8o9YDp1xbXXS9pK3U5R7wgQQr0jKjnEAPulQ1fMhg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=r2h3DWEWj26kFJhq+Sifw4IeBfH7+67gWlsGMMvpw37VKQGG7Cno1sDZNpvUkKmtW0wo+8MB8+jFjQHfEC19h6h5l6TYLz/R9iHokWbA/nXB+amwR0fjjR4MA5byPFzXrO61chOUQwbQy6hkvB33eb9T6Ut+mO7ruHQA/iVDZp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=JNdtdLAt; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="JNdtdLAt"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1715665883;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FiYLFnKZivRpeJ4PWERZJck4xmYEwFKMbyVtwgpr9ws=;
	b=JNdtdLAtKaHHA9AQZiE1aJz/Dd7t7urHw7fKFfEvaGGTYa26ZtplO+wPWcnX2fE60bIGx6
	Q0RHj6Rw+rYfzltS51guCYkZW78crNP2R81X3HCC3j63/8F+v5JxotOwhUPffMODzQBPRi
	POUmw0h6EcLRO8JmHpmTkLaZ8Ydw5Jo=
Received: from mail-pf1-f198.google.com (mail-pf1-f198.google.com
 [209.85.210.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-454-cAVJQq3gNFKGwN0d0Z7nJA-1; Tue, 14 May 2024 01:51:21 -0400
X-MC-Unique: cAVJQq3gNFKGwN0d0Z7nJA-1
Received: by mail-pf1-f198.google.com with SMTP id d2e1a72fcca58-6f454878580so5010771b3a.3
        for <linux-raid@vger.kernel.org>; Mon, 13 May 2024 22:51:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715665880; x=1716270680;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FiYLFnKZivRpeJ4PWERZJck4xmYEwFKMbyVtwgpr9ws=;
        b=TH86jiR4weyRkaA37pR6/8sfCknnbpYmgGEjuesEYP4+Hgef21z/j3WtfgSdOyEhyU
         W7FV+QdtNdrM6+7P6A6xO97EmZFmtD3y8W6r8ILVQmHxH7Kou3NtEfpWZkNGkN/vt8Ew
         NM9inASFwSEe/E+L/BGB4qhYiGzIq8Ew6U+647/ZnbDUhnIRYg4aX585NKudox/JLKuq
         51IRCswPHC35z4FvCCSBNW0wIoBVRUeiqObDfUhM5PcD79PR2jo0vagWdo2BBmy4yH7e
         83ZncbKzNkCuTST4fdClzYSyyrCGymqTLXY96H4ZgAuKO1YTPdP1mBAoKxY2SVlmEaxp
         HSZA==
X-Forwarded-Encrypted: i=1; AJvYcCUlH5KQDJAGruLM3lhWX68jyIeNR3VkvfnRgL+uOowq9Pi400g2VTcJ21qwVoYHGhkSAWw3uEKNV0muu98KXjC4+acF/Pmo40UVEg==
X-Gm-Message-State: AOJu0Yw5xCsdLMDqIP5IzLoWsNEQSv4N8Mo/wTGihiipZZgz30wP1IPd
	OqVFrYbrpwc0tpgDkN9CpBWF4JD6Ubqji2ORiXUEOeaifRPfJ7+MKTgYbaHq+S0oxwbTyp0ewth
	DIsZGetgzayH3j2xQS5tC4KmVRRXSGLqqPTzqOipw50qgCzjFhcC78vNHfM4qOMnSKBJZ6BPVA7
	IPmnZtXm5EuCYyZS/2LDxRY0P9QBGLvdvaQA==
X-Received: by 2002:a05:6a21:9207:b0:1af:fbab:cfba with SMTP id adf61e73a8af0-1affbabd1e5mr3839101637.27.1715665880390;
        Mon, 13 May 2024 22:51:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEY7xbn2J2Vy9Rqv5L4uLboL7HEssdNiD/t6t5qivKpv4cPvOh/U0ZqSPmB54v090ZDOMRtOFqS27x88F0RbUE=
X-Received: by 2002:a05:6a21:9207:b0:1af:fbab:cfba with SMTP id
 adf61e73a8af0-1affbabd1e5mr3839080637.27.1715665880007; Mon, 13 May 2024
 22:51:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240509011900.2694291-1-yukuai1@huaweicloud.com> <20240509011900.2694291-2-yukuai1@huaweicloud.com>
In-Reply-To: <20240509011900.2694291-2-yukuai1@huaweicloud.com>
From: Xiao Ni <xni@redhat.com>
Date: Tue, 14 May 2024 13:51:08 +0800
Message-ID: <CALTww2_2UG49wxNZv1Ay7u9X-2SoV31ca-=2K8uWHH9nRT2Apw@mail.gmail.com>
Subject: Re: [PATCH md-6.10 1/9] md: rearrange recovery_flage
To: Yu Kuai <yukuai1@huaweicloud.com>
Cc: agk@redhat.com, snitzer@kernel.org, mpatocka@redhat.com, song@kernel.org, 
	dm-devel@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-raid@vger.kernel.org, yukuai3@huawei.com, yi.zhang@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, May 13, 2024 at 9:57=E2=80=AFAM Yu Kuai <yukuai1@huaweicloud.com> w=
rote:
>
> From: Yu Kuai <yukuai3@huawei.com>
>
> Currently there are lots of flags and the names are confusing, since
> there are two main types of flags, sync thread runnng status and sync
> thread action, rearrange and update comment to improve code readability,
> there are no functional changes.
>
> Signed-off-by: Yu Kuai <yukuai3@huawei.com>
> ---
>  drivers/md/md.h | 52 ++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 38 insertions(+), 14 deletions(-)
>
> diff --git a/drivers/md/md.h b/drivers/md/md.h
> index 029dd0491a36..2a1cb7b889e5 100644
> --- a/drivers/md/md.h
> +++ b/drivers/md/md.h
> @@ -551,22 +551,46 @@ struct mddev {
>  };
>
>  enum recovery_flags {
> +       /* flags for sync thread running status */
> +
> +       /*
> +        * set when one of sync action is set and new sync thread need to=
 be
> +        * registered, or just add/remove spares from conf.
> +        */
> +       MD_RECOVERY_NEEDED,
> +       /* sync thread is running, or about to be started */
> +       MD_RECOVERY_RUNNING,
> +       /* sync thread needs to be aborted for some reason */
> +       MD_RECOVERY_INTR,
> +       /* sync thread is done and is waiting to be unregistered */
> +       MD_RECOVERY_DONE,
> +       /* running sync thread must abort immediately, and not restart */
> +       MD_RECOVERY_FROZEN,
> +       /* waiting for pers->start() to finish */
> +       MD_RECOVERY_WAIT,
> +       /* interrupted because io-error */
> +       MD_RECOVERY_ERROR,
> +
> +       /* flags determines sync action */
> +
> +       /* if just this flag is set, action is resync. */
> +       MD_RECOVERY_SYNC,
> +       /*
> +        * paired with MD_RECOVERY_SYNC, if MD_RECOVERY_CHECK is not set,
> +        * action is repair, means user requested resync.
> +        */
> +       MD_RECOVERY_REQUESTED,
>         /*
> -        * If neither SYNC or RESHAPE are set, then it is a recovery.
> +        * paired with MD_RECOVERY_SYNC and MD_RECOVERY_REQUESTED, action=
 is
> +        * check.

Hi Kuai

I did a test as follows:

echo check > /sys/block/md0/md/sync_action
I added some logs in md_do_sync to check these bits. It only prints
MD_RECOVERY_SYNC and MD_RECOVERY_CHECK without MD_RECOVERY_SYNC. So
the comment is not right?

Best Regards
Xiao

>          */
> -       MD_RECOVERY_RUNNING,    /* a thread is running, or about to be st=
arted */
> -       MD_RECOVERY_SYNC,       /* actually doing a resync, not a recover=
y */
> -       MD_RECOVERY_RECOVER,    /* doing recovery, or need to try it. */
> -       MD_RECOVERY_INTR,       /* resync needs to be aborted for some re=
ason */
> -       MD_RECOVERY_DONE,       /* thread is done and is waiting to be re=
aped */
> -       MD_RECOVERY_NEEDED,     /* we might need to start a resync/recove=
r */
> -       MD_RECOVERY_REQUESTED,  /* user-space has requested a sync (used =
with SYNC) */
> -       MD_RECOVERY_CHECK,      /* user-space request for check-only, no =
repair */
> -       MD_RECOVERY_RESHAPE,    /* A reshape is happening */
> -       MD_RECOVERY_FROZEN,     /* User request to abort, and not restart=
, any action */
> -       MD_RECOVERY_ERROR,      /* sync-action interrupted because io-err=
or */
> -       MD_RECOVERY_WAIT,       /* waiting for pers->start() to finish */
> -       MD_RESYNCING_REMOTE,    /* remote node is running resync thread *=
/
> +       MD_RECOVERY_CHECK,
> +       /* recovery, or need to try it */
> +       MD_RECOVERY_RECOVER,
> +       /* reshape */
> +       MD_RECOVERY_RESHAPE,
> +       /* remote node is running resync thread */
> +       MD_RESYNCING_REMOTE,
>  };
>
>  enum md_ro_state {
> --
> 2.39.2
>

