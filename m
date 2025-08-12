Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BD174A21
	for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 12:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755001426; cv=none; b=pVDpPFTVG6WC51fhv0rLhCbWJDJxcizOtvXZfs5XlskZ53wex4ovisjQWjx78kOp5zxZ84Imuu7sZVLb8FvjX7gJBB8NmqWCnSJGBErscTU/3YRM09dz3qx53tzELJOuC00S5zysZGEMyizGTk2jra2/+SsX57pMYK4wzMNGPLM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755001426; c=relaxed/simple;
	bh=y8chvbwSa1/4F9iR28ytiEvykmZAHC9RhRNQnRWNvtk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=akXN9DOuNdhARWOosnu5hr6NlIW3DY0xPPSe3D2HDPbuIjQz4zANsFoZ3dK5sm1aPdEAs79Tyg0ep7hOmO5t82mxDrJC3HPM082rjO+K6RWliyCITmHyoFZGK7i3oo0lujbIC/Y+DA0TUVb3Fux2BTrBlL9IFoIeU6laiagwiQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=LfJjvVRG; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LfJjvVRG"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-71cb6973d61so5150547b3.0
        for <linux-raid@vger.kernel.org>; Tue, 12 Aug 2025 05:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755001424; x=1755606224; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y8chvbwSa1/4F9iR28ytiEvykmZAHC9RhRNQnRWNvtk=;
        b=LfJjvVRG/uJoUdRdpH0jwQQwV2z3XPBHTlkkgNu+UO55iW9TAiOSgdukueOKfujQet
         OY/7uWE72SFZb0KotXeMwv/HdodISab7vZMm35POl4eXUC2h0H2avxbU2wOp35mA/dVg
         Van/r0sf6wnyMTYAFg5RrrITK3JJL8zlbpe4wwf1OnmrDEXX4/2opzglzre+iF0JU9iR
         o7YkHBSbeP2EhqxRzbedjFiDRaZn7kZEvDdph83GSauDVXrUPtbhUEpluISKK1zDRd1L
         3bMmWnX8fiSs6TZPCxN7BiH6KvF5sKvw0QYgZSeFzMk2ECqMwocB3fbk7N+yM8DJAuYX
         ZSWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755001424; x=1755606224;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y8chvbwSa1/4F9iR28ytiEvykmZAHC9RhRNQnRWNvtk=;
        b=Rsj01q/+s6Zdm2T5iVBw1ZyzOuZXXE7Iuuk/HmzCXpFkHMOG8jenpKTIJIx/2xVNmA
         SsKRTjZhVBlxtWdtOkLEk28G3wcrdwzlQSKCu5pQDdlVp7nt/srDUFwgGe5jWTyGIZCm
         hOvFukeHpbYq/07iR4+TfdG1sVIPHO20YbMvktv3EypHcayC/HNOU7w28eUcjd2Te5KY
         zlN7rzSKSw8/++zFeSaT5ooVw9xvsMPTeFR3ge9QxqBiSSMHZPjDW2yFaDq1Kwhn6TVZ
         /ZfBrq+WVo8qFyzPBqW330Lcpvap3So5luAmqvOv1rYs3R2j6/vS7lNqcBOydcJ2XEsY
         L9Mg==
X-Forwarded-Encrypted: i=1; AJvYcCU6GCJTa/BjXAFWXeycFFBHqn6FGOjLmmD96LdqOuxn1IPa0orW48ivJwg1rxNEkocbuski8VcJb+/Z@vger.kernel.org
X-Gm-Message-State: AOJu0Yy2jSnlUIMIPxSjTd2uanSruEl/Y7qKLxK9rkZ0KF8dvN3XPVj4
	rlx0aoDFet4Bjlw2aREWATv7iikrW4Q9pbJOyu2ot36HLsIHnKAGICRqSbY4E/CYa2dsv8qEDoO
	JCTaF5g4AphkAGJ8LNjCgFqhptRn6F6FNkt1U
X-Gm-Gg: ASbGncvPUX3EjCDewkSbA9dAeapBAYUR+42gvnAy/wS8iCABRncRmuk7prd2QxZfGOy
	EaQkMBlMh2pqvOyKeQY1pBAbLth66NOqhGPO/8F30s7TLDxLhSI6C5Uc2hEdHFJuLn87XLpfc5U
	qiAd9M/NMehfQpKXqNJW00dUGpGsNMR4anSK0wgB/KvlCoCxgmbRYOZl/z3NcilQ08+0EF9HiNB
	HJKYBcvHMWw3DxBEoy9FyDadZr2CKCDFRMWvUuflw==
X-Google-Smtp-Source: AGHT+IE3E3jx0mBX4O6FVdWl/WqupCDCtXBw8CfsjhvvmTWfQP+5VggaUhtZNsCRUgrHC0Cqxc/zdaItv+054gl+2/4=
X-Received: by 2002:a05:690c:88f:b0:713:ffaa:5767 with SMTP id
 00721157ae682-71c42eacc6dmr43940317b3.7.1755001424182; Tue, 12 Aug 2025
 05:23:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250812074947.61740-1-xni@redhat.com> <75175b99-57ce-4384-9b75-c91d4fe4ddad@molgen.mpg.de>
 <CAMw=ZnSdKwvKwsfe_ajyxjobLvZZgUtApj5Lo9jXV5Bq_k76JA@mail.gmail.com> <CALTww2-ji2wjF2_SHc=Pqt1S=ZsuFKSsnkic03DAuCc5AGQspg@mail.gmail.com>
In-Reply-To: <CALTww2-ji2wjF2_SHc=Pqt1S=ZsuFKSsnkic03DAuCc5AGQspg@mail.gmail.com>
From: Luca Boccassi <luca.boccassi@gmail.com>
Date: Tue, 12 Aug 2025 13:23:33 +0100
X-Gm-Features: Ac12FXyinX5GRQMkbCbgAhtVmFLFYiptGTNQqXgVH76jNM0yKyTDrVqCgzO2hSA
Message-ID: <CAMw=ZnSkNG1vJRuTR3F_bdAPDwHG09bOhLG2iX9woePXVw7ngA@mail.gmail.com>
Subject: Re: [PATCH V2 1/1] md: add legacy_async_del_gendisk mode
To: Xiao Ni <xni@redhat.com>
Cc: Paul Menzel <pmenzel@molgen.mpg.de>, yukuai1@huaweicloud.com, 
	linux-raid@vger.kernel.org, yukuai3@huawei.com, mpatocka@redhat.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 12 Aug 2025 at 13:21, Xiao Ni <xni@redhat.com> wrote:
>
> Hi Luca
>
> On Tue, Aug 12, 2025 at 6:08=E2=80=AFPM Luca Boccassi <luca.boccassi@gmai=
l.com> wrote:
> >
> > On Tue, 12 Aug 2025 at 10:57, Paul Menzel <pmenzel@molgen.mpg.de> wrote=
:
> > > Maybe add a timeframe?
> > >
> > > md: async del_gendisk mode will be removed in Linux 6.18. Please upgr=
ade
> > > to mdadm 4.5+
> >
> > It would be great to avoid breaking compatibility for a couple of
> > years at least, please, to allow for multiple cycles of distro
> > releases, and to diminish disruptions. Thanks.
> >
>
> Ok, maybe we can use Linux 7.0, is it good for you?

Not sure when the jump to 7.x will happen though - maybe "the first
version after 2026's LTS release" or so? That should be enough time to
avoid disruptions. Thanks.
