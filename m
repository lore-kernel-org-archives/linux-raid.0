Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63CD717545;
	Mon, 10 Jun 2024 20:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718052828; cv=none; b=cOVg/dszP2+nB4OO4o5XsIjjZFDBLZYMMKiG9ydsyfnws/L+w8y4UAhzGf7NpEiM0QdiakwTZwFOgN75NOZ1mgztLIih0gxY2ljho6V38LDmQPc2Qjtz6Kyqn+h8mjzZhIlj/DChHVrqm3OhiHZ3DfbY4alRcqJv1EZWIPnw0vI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718052828; c=relaxed/simple;
	bh=K8KGJ3qdaNDs2fnn3De4uIqWVGSMjgQOHseds840ChE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R596c6tHpVEtNSOKn9LSka95GtKBRlcx/MCTPyhJTFQTnVMMOe8qimJm3UP9Po715TBLzR4g8qLJn1ChLTjMvEnLuN1VnIP23sqei8lJ20zUx5F0tQg143+EMBeSlW5dy2GWMUl2qEi5XDup+vd/Gjdk4XyDSR43AKDBr9IzrGA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=rbYPqZ+G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="rbYPqZ+G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47BFC4AF1C;
	Mon, 10 Jun 2024 20:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1718052827;
	bh=K8KGJ3qdaNDs2fnn3De4uIqWVGSMjgQOHseds840ChE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=rbYPqZ+GPmT0pYgY/RMKW/RyxTDHR2Me8Eh8qJLo3NXZ5G0ORniTcJQeS88xBahsA
	 uDNmACWTle4eh/dEkMpZv4h6hq8T1yPW7nhkmGTFiS6q/PV8mRCA3jdkqWBkiC5P1h
	 ibjAlxrfTlPvp9IK/e7n3sjUw4PTX4GUo0aIW8AakLityf4VzGxMx7p2OXuyUDoj35
	 kiDgTr8eSmpfotR3uZmFT1LvffrKg60Pcb1XhNKnIGlCaWq24Sim5RJNTTlt5qHvzf
	 81YLqMcvd0L+hJbZa5y+5xObP/hOiD1ySIWzKkvGL3WoahlW9/oxLnx1VTAO0V3rKo
	 Hh2oJg23IuQcQ==
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-2eadaac1d28so43435221fa.3;
        Mon, 10 Jun 2024 13:53:47 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVMOTRXtzHneLaJmFy7qdwkaT1Kpa5K0IJxvbqe0y57vRI0tjElp3zPDj/h466rJ4wq0eLyQdDgjaKqxoiGyjzL+Jy+dc/yPuvmhhTd
X-Gm-Message-State: AOJu0YwBRES+UoWsz0V7CYVExHjzKc77g1qtP/9ZK2EDFyuqe8MBienS
	0Jtpb+lqa7V8gfRNioaFegIjl12YrB9GIvhkBX1/PG3jP1G78waYSqWB2gZ15dVqR1HSC5P54sU
	q1FLih6GnjRId/zkotnP1PmuIlFE=
X-Google-Smtp-Source: AGHT+IE/8QiJUA6k89dwRrtwwT6/nPbc/qc52gPny1mrpiQoMoNr5v8YAibBYY5SUwWjtp33/DL2XkvvN/++nuQjTL8=
X-Received: by 2002:a2e:8746:0:b0:2eb:d8d2:f909 with SMTP id
 38308e7fff4ca-2ebd8d342c5mr35955871fa.16.1718052826217; Mon, 10 Jun 2024
 13:53:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240528203149.2383260-1-linan666@huaweicloud.com>
In-Reply-To: <20240528203149.2383260-1-linan666@huaweicloud.com>
From: Song Liu <song@kernel.org>
Date: Mon, 10 Jun 2024 13:53:34 -0700
X-Gmail-Original-Message-ID: <CAPhsuW6Ob23G4hOrwTMEKz26A3VCXPMdrgxxWXBKrXJJQAWW2w@mail.gmail.com>
Message-ID: <CAPhsuW6Ob23G4hOrwTMEKz26A3VCXPMdrgxxWXBKrXJJQAWW2w@mail.gmail.com>
Subject: Re: [PATCH v2] md: make md_flush_request() more readable
To: linan666@huaweicloud.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	yukuai3@huawei.com, yi.zhang@huawei.com, houtao1@huawei.com, 
	yangerkun@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, May 28, 2024 at 5:39=E2=80=AFAM <linan666@huaweicloud.com> wrote:
>
> From: Li Nan <linan122@huawei.com>
>
> Setting bio to NULL and checking 'if(!bio)' is redundant and looks strang=
e,
> just consolidate them into one condition. There are no functional changes=
.
>
> Suggested-by: Christoph Hellwig <hch@infradead.org>
> Signed-off-by: Li Nan <linan122@huawei.com>

Applied v2 to md-6.11. Thanks!

Song
