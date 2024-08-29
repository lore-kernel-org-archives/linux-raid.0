Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D9CB198E75
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 18:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724956063; cv=none; b=CKp46kEvqPnnGqBMIjGrW1nG9q5ij1qM2k/oCSSZs9nF9qJinnmyXMyzjUFxYhapcqAXxRqDcB0iSQels2d16+Nph0Q2JvhxTCNfdoxiayHSj6OPOZyUBkfncQem6YrxqWcaaP3oRhBzMa910Z792LMOUNzchi1eTpjA5nC0n+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724956063; c=relaxed/simple;
	bh=FCBtuZ84FZQU7E5aHgC+KwHJ3rue8TCgqI/eHXyCM+M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=epI4QzDyc1s2QxqMRXPsr/cmZm/21uZgJpgl9uoVBV/saTikb7JIU4pEMWfqFhSXJGT3sOVxKkuPz91aTbduNknqcWLOlYwwnHhgDBXB+iltaVV0NR6Bv4QPvj+NC05Cw7lRQjUVcf0loxoNeoEf3eaty3KmNGrG8asJJd3xdbs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=X52+D21I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="X52+D21I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21BE6C4CEC5
	for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 18:27:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1724956063;
	bh=FCBtuZ84FZQU7E5aHgC+KwHJ3rue8TCgqI/eHXyCM+M=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=X52+D21IFFS5LJUz6qrl6abHclY/bCSESDpnNdeZRfT8Gsd2gZwM9u4zkOxBKQI5V
	 8UfUT5jeMPHqJ050X4x8EdT4QSN2IfVgT7zsVDBi1l4rLjk5yK+NYwO3Uh+5QxIfz3
	 SKCdERBOjW8EZOamPRXTWDWq0mnyWqpMOpZHo4P8gFmXQ1F+UGk2ndzaBoxLuKVtId
	 PohpgdGEra9z58BFx+yMW9ZwmjmPXX/IoEkYaJPEvo6sNdQbW4/ZaEc0+FJDR/rltT
	 hY1kD3ECxy3OKfMCi/IDo0QUtJr7hmblMt0TRKcVhimaUbcGQ11SuM9bUc4ZOKAGvk
	 AYC9SL7X6gpEA==
Received: by mail-io1-f47.google.com with SMTP id ca18e2360f4ac-82a151ac96eso37483439f.2
        for <linux-raid@vger.kernel.org>; Thu, 29 Aug 2024 11:27:43 -0700 (PDT)
X-Gm-Message-State: AOJu0YywCbAhZr2UlNeEvGC3fLaQBVVHqJi52NVZVx4tJVs6YGq+NhKJ
	YZAYxgRlko7FZ1TsM+6o0kSlytwJTCWceoVUng3BMspwisfO+kis7LCOYc8D5cFhyv74eYyj8A2
	mrwOzJfS/tTRG1e1veCOeVqazWkE=
X-Google-Smtp-Source: AGHT+IEUnqYhyoi6u/ZJucRgQWYYYosKNkmQFXQPOTte5FhA40xJl2W9QKXEHWTKFhx2KYjVEmnUM+/NgmxyrZA7C3c=
X-Received: by 2002:a05:6e02:1d9b:b0:39d:4995:b2a3 with SMTP id
 e9e14a558f8ab-39f37994f41mr41771305ab.24.1724956062525; Thu, 29 Aug 2024
 11:27:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240828120212.31865-1-kinga.stefaniuk@intel.com>
In-Reply-To: <20240828120212.31865-1-kinga.stefaniuk@intel.com>
From: Song Liu <song@kernel.org>
Date: Thu, 29 Aug 2024 11:27:31 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5qVnWnQtZmd0iFgH_6cBbKR+pDDWSzh5Ym8902fycJbw@mail.gmail.com>
Message-ID: <CAPhsuW5qVnWnQtZmd0iFgH_6cBbKR+pDDWSzh5Ym8902fycJbw@mail.gmail.com>
Subject: Re: [PATCH v13 0/1] md: generate CHANGE uevents for md device
To: Kinga Stefaniuk <kinga.stefaniuk@intel.com>
Cc: linux-raid@vger.kernel.org, yukuai3@huawei.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Aug 28, 2024 at 5:02=E2=80=AFAM Kinga Stefaniuk
<kinga.stefaniuk@intel.com> wrote:
>
> Patch is caused by changes in mdadm - now mdmonitor is relying on udev
> events instead of pooling changes on /proc/mdstat file. This change
> gave possibility to send events to the userspace.
> Now, more events will be read by mdmonitor, but mechanism of getting
> details of the event will remain the same - all devices have to be
> scanned on new event and their parameters read. It can be changed by
> adding environmental data, which will fully describe this uevent,
> as Kuai suggested. This change needs to be analyzed and planned,
> because it requires a lot of work in md and design changes in
> mdmonitor - to stop scanning all of the devices on new event and read
> uevent details directly from udev. Mariusz will take care of this topic,
> and follow up on this later.
> Paul, the test suite which was used is internal and checks if mdmonitor
> has noticed expected events. For now there is no plan for adding test,
> which checking events to mdadm.
>
> Kinga Stefaniuk (1):
>   md: generate CHANGE uevents for md device

It appears this patch doesn't apply on the md-6.12 branch. Please
rebase and resend the patch.

Thanks,
Song

>
>  drivers/md/md.c     | 148 +++++++++++++++++++++++++++-----------------
>  drivers/md/md.h     |   3 +-
>  drivers/md/raid10.c |   2 +-
>  drivers/md/raid5.c  |   2 +-
>  4 files changed, 94 insertions(+), 61 deletions(-)
>
> --
> 2.43.0
>
