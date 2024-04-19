Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5C87130A56
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 15:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713542288; cv=none; b=BNEe2VHJYd/MQh2brtI8a40VBjPzkvFbZj+kAPxD2YeWf7JZhgaditggNrrGwhdNYyyytfLXeTkVXDzkGD1f2dNhhS7UFfvLj0V25V4aDQZJvL+qNqlMhWvyGbJgWu21WJXnlviOH2RDuKippCC48wLdZ386QIviBTH8VFTowE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713542288; c=relaxed/simple;
	bh=S3Dkrs9fbhor0TQh8NP4QfjaApPeKJxbByQy5xiV2Xs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UsYcQNQhjAOMiltibFBxvk4LdFKsRJJ2Q9c17tqQJ88VCmyhBliiUV0Ctz4YOzN8BtMA4+YHATbAt4v9yfE/uMayEbmmnmV4Xd/sEcozKpiXFPTK900BD9l24SNUnM5xah5xGjtwRomWTg+CPhPAQtCkvwvwPr036vE9zJkwwSM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=n9xvfUpQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="n9xvfUpQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0BC1C4AF07
	for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 15:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1713542288;
	bh=S3Dkrs9fbhor0TQh8NP4QfjaApPeKJxbByQy5xiV2Xs=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=n9xvfUpQa54t/uSqHG5gXdl6smEBW1ezkNfWg2KNwiV5Pe3JiST9VNB3q5Lw7YMpv
	 lOMAd2xgb1IH+Rjt1t1WlmLVYE2p9HgvS6L4XaHXzyzrcG7oGGSOJCalGwemGgt+40
	 oy1dXq3u/EkvwLD6DfNnMuEqY+S3/AOBDc2br1EvjUrHHYfQAkis10Fbxvjok2QbXX
	 8D8DkXiKNBbwifOYBQTBT7wPWtZNl4Lfok9w7+oaFTEALgq1pq9auVIkSk3NPNuvBA
	 6eof0lBkSwFrJDUNfyKBdMWL0ZORRYw/jAVKoOcEWYgXR3IjG213+c/TVFdxbjHNkv
	 WRe+Pl4dOgnhA==
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-516d487659bso2617784e87.2
        for <linux-raid@vger.kernel.org>; Fri, 19 Apr 2024 08:58:08 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXKVPOhyyYuQu3r0nI78J1w0alp51dZaGG7eP63txcK5gwh8iLU3uPw9Q/4glZHsWvm5Y32Y0bZptTM6rELW6fOrxO7/EHrT/nWVw==
X-Gm-Message-State: AOJu0YzkW70+aEh2KF1ZJJz6xCVdEURickBBptmu0MgjhJ7tfVaVR1X+
	9wo/W3cfdXqGaHIBE70hLlGDA7Hc2wbqD9DD7xwdZuFheffVAwGo4BgJDoMPvok7iGGthnhuPP5
	a66WG2sqHjAIz+SX0rQE+hZODCRc=
X-Google-Smtp-Source: AGHT+IHanHz4kGHCC0rqxrMi5Up+E0aT+ikqEKHNxRRKYn3zSj8gGAS9ZH8EMfZ1fwLjltfvFbepdhCEle1Zguxa0eE=
X-Received: by 2002:a05:6512:20c3:b0:51a:c3a6:9209 with SMTP id
 u3-20020a05651220c300b0051ac3a69209mr1296092lfr.68.1713542287023; Fri, 19 Apr
 2024 08:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240418102321.95384-1-xni@redhat.com> <20240418102321.95384-6-xni@redhat.com>
 <20240419120555.00002b95@linux.intel.com>
In-Reply-To: <20240419120555.00002b95@linux.intel.com>
From: Song Liu <song@kernel.org>
Date: Fri, 19 Apr 2024 08:57:55 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5SihA0czyJUdG6XNhx4c+=W_XksoQS7cJ30chkBLgW4Q@mail.gmail.com>
Message-ID: <CAPhsuW5SihA0czyJUdG6XNhx4c+=W_XksoQS7cJ30chkBLgW4Q@mail.gmail.com>
Subject: Re: [PATCH 5/5] tests/01raid6integ.broken can be removed
To: Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc: Xiao Ni <xni@redhat.com>, linux-raid@vger.kernel.org, jes@trained-monkey.org, 
	yukuai1@huaweicloud.com, ncroxon@redhat.com, colyli@suse.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Apr 19, 2024 at 3:06=E2=80=AFAM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> On Thu, 18 Apr 2024 18:23:21 +0800
> Xiao Ni <xni@redhat.com> wrote:
>
> > 01raid6integ can be run successfully with kernel 6.9.0-rc3.
> > So remove 01raid6integ.broken.
> >
> > Signed-off-by: Xiao Ni <xni@redhat.com>
> > ---
> I don't follow the *.broken file concept. We could also describe that in =
comment
> in the test, so LGTM for the changes.
>
> If you want to, you can remove all *.broken files and add some comments
> in test instead. If we have some tests failing marked as broken long time=
 ago,
> you can either remove those scenarios as we are obiously not interested i=
n
> fixing those scenarios.

test script has options to skip broken tests (--skip-broken,
--skip-always-broken).
If we remove all the .broken files, we need to update the script to handle
comments in the test file.

Thanks,
Song
