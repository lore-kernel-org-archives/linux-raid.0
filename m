Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63683621
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 05:49:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725515381; cv=none; b=RDBzFKdQtkjv8qd8f5v/AQX6p0pLsIb2DTDcNBgu0nmyjPLerXXYwyzuFiXggdLNWQ2HQREOLLCzKKqvk5VgE1gZ4QiQwmXO/w5P8TxZ6wzssJjfCXHFf0NFhZ4re74nLGIRxWyLLQ/8peY2TAQXtB9B1QMUaE6zRPo3LUW6hI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725515381; c=relaxed/simple;
	bh=WZQvFkjqNmYBOwb2EoLnK/dTBwSQWF4Vi/FVyKOUFg8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RoYcgiH6vFGg0aUDI4/Cm+++c8WvQFWUuoMlk30aFTAElfUtwb4ogLyqvzrkhFKGf4BOqZ48V1Sh/sptxZ+DNvg0CH3AcE+esqiKJcWL61Ati8OktH7IktirYXuhj86/OzY1imH5wip0s1ZNKPuFgt06yJNpq/Q9xQyPK8dKRWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=K8XPf1rl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="K8XPf1rl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9BCDC4CEC4
	for <linux-raid@vger.kernel.org>; Thu,  5 Sep 2024 05:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1725515380;
	bh=WZQvFkjqNmYBOwb2EoLnK/dTBwSQWF4Vi/FVyKOUFg8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=K8XPf1rlWxV7uHYRkJYlo/mhU/cYlA909FlH3steGUjNYekbJRbMZYwhK/G6gE3Iq
	 pEK2x6a2LwTmTW1OhtId2rHhmQSID/cWs36b75Bl+fjn2cS83WRvU2wlo9Q9H+7eNU
	 rWYRP1KSS6vqV0/mAS9V+ybetNiHPgd9ppHohl7MQKiajWMrUgStZI8j3o9Ahoydcx
	 B1F1SqyqHLQFFlBHlbd0WP6CZxcV9rGDgZJfdBaFtx+ksxZaefAwSLqwhroUcQcheM
	 z1vDM4EMHHyWToF1YYeGvpED3852yjapWeX/uNGGud4S75otiSs8fojkHbjsSVRj1t
	 MKOwIdONQ9BaQ==
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-3a043869e42so3704625ab.0
        for <linux-raid@vger.kernel.org>; Wed, 04 Sep 2024 22:49:40 -0700 (PDT)
X-Gm-Message-State: AOJu0YyNS0qJU423psmb5nESToytQENJHOqHyRXx6xg8QiYbLYaS/1Ro
	BZscbIEu4dScud4KSQfzgdr0Ch3mWQ7BY1CI538CQRnAu5Hbu9pQr5G6oyHVdePYJ66iFn1Z8OI
	/FPtodGI9J73ZlDYIkVaJB87e3Hs=
X-Google-Smtp-Source: AGHT+IF46vEAi44htpa60gyeq7eI6SAcoJU30X4SQpITtSrDutSJcEfSNz3emh8l7xg5kwifhn1Wi8+0Z6R8oyCE4kE=
X-Received: by 2002:a05:6e02:13a4:b0:39d:47c6:38b1 with SMTP id
 e9e14a558f8ab-39f797b23damr45924985ab.9.1725515380159; Wed, 04 Sep 2024
 22:49:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240903142949.53628-1-mateusz.kusiak@intel.com>
In-Reply-To: <20240903142949.53628-1-mateusz.kusiak@intel.com>
From: Song Liu <song@kernel.org>
Date: Wed, 4 Sep 2024 22:49:29 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5HUbvnZoW6Q=EWOcoBaLTcWQzXQd2j4aYcX5qDb+5BSw@mail.gmail.com>
Message-ID: <CAPhsuW5HUbvnZoW6Q=EWOcoBaLTcWQzXQd2j4aYcX5qDb+5BSw@mail.gmail.com>
Subject: Re: [PATCH] md: report failed arrays as broken in mdstat
To: Mateusz Kusiak <mateusz.kusiak@intel.com>
Cc: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Sep 3, 2024 at 7:29=E2=80=AFAM Mateusz Kusiak <mateusz.kusiak@intel=
.com> wrote:
>
> Depening if array has personality, it is either reported as active or
> inactive. This patch adds third status "broken" for arrays with
> personality that became inoperative. The reason is end users tend to
> assume that "active" indicates array is operational.
>
> Add "broken" state for inoperative arrays with personality and refactor
> the code.
>
> Signed-off-by: Mateusz Kusiak <mateusz.kusiak@intel.com>

Applied to md-6.12.

Thanks,
Song
