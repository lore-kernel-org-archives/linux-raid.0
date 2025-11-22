Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A45B827054C
	for <linux-raid@vger.kernel.org>; Sat, 22 Nov 2025 20:33:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763843640; cv=none; b=SzJm7iYdB320vkZ1knS0u+TtgvPXyZTmat/Weu0QzCd2XitE2+DK0pGY0dfYDZ7dlVY/MNN/lmqxfE9rY/tX+CEIwI3DoSeGV5pi4ozlbHS6lmAziEuIC2dj1+h2DbulVd5KqGhCHtpMmXiFQNQ3Kq9NvSry1aOmdFUEIrvO4FA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763843640; c=relaxed/simple;
	bh=NHaFMiF6dxiCU0vMg8q5qTDPlG31ZZujzGUesGhT5hQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=hF0ZdIG7HFNodhNP8nKhcsrFiUqE2Mo5/b62x+ipjBc5xXvyaxVE2WdyVqmn8KRbj/CAO9VwXoCdSivIfuOIql1LookWwi4sUclVTgz4SUONohFB44Z653s8t36ebYOp9Lw2kGMuTqntKMzry9obTNuD3YoX5VA1UZRD6eE0FCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WFKUqDUt; arc=none smtp.client-ip=209.85.208.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WFKUqDUt"
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-37a3a4d3d53so24218181fa.3
        for <linux-raid@vger.kernel.org>; Sat, 22 Nov 2025 12:33:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763843636; x=1764448436; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dFn2EwqFqpnjkFoKzC+88UIKZbJzPZxsjNZNiF3KFj4=;
        b=WFKUqDUtK3N3S7kIr3lO0eVi0KSOTQ4CydlfEdvVVcgXR93bkGwTgp1Eb7U5KxZPcS
         CD+7IjinJCUKmvDPuMH1fYHjY5ywfX3qpRyuYmRbVawon+BnkzIwUB+m3+XVisxkjFi0
         IPRbCVqbx5Bj+nEE53y0vsBITf5zXsktmqFFqy6VC+x5OistRVdLc8HXaI3peXm/eQWj
         s9BWR3rS3vX+AcP81cogkDA+RU9tXthlONdwZ7+IVUu4f2n8g48xSoVWlKfFhU5vcoGj
         LQYRUw6l1SUBaboWt6sMFdoUEKtVZPRgwVMiRhbv8PPgMRTZwn49bvlbr2+6bdrDZVFJ
         DAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763843636; x=1764448436;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dFn2EwqFqpnjkFoKzC+88UIKZbJzPZxsjNZNiF3KFj4=;
        b=r90XBfhF01AAkqK0NdUgfI/yyrNhAesr483HNIg5elgiHFn8+X6sByyveW1JEBJL/3
         TvnSki2s/+B93h04Z7DF5FtycNg+/l1FMNfYgWa9syqMhug5anshr1SSG3KT0ptMejaL
         kOFP10z4pzNXbcK98uwstl/NoMUeYddTgSCqG9obxKniWVmZbBWFuo3kYJs7Xt6s6yhP
         7nmbnZ4RnxinWz19DPYQQDuKElk8Pxr2nfNeCEAZgdp7uwRP5KlxbLm4kKTjmlWy/TF3
         UieZ1/zJs5gni4QIlneLOBUALgM096GnyPQumT4QoqLrwztPeRzq8VDq5Efz5B5ijJwh
         aVJw==
X-Forwarded-Encrypted: i=1; AJvYcCUO836aOfUIUuii+f4Fj7R1LfXY1n5mzCcoMYE9I9sF/iXpN6RmYLLRv0jcCARJQC4SMh1xHkdrwxWR@vger.kernel.org
X-Gm-Message-State: AOJu0YyBVL3FtBohBJk4miBfCbikSLL3UDTsuBRlFv/2iBpOUx2fuqx/
	VqmYSdJCM1bFva/bbN01juAsVzkfK6OCTEYPQkoqTeShtkgZ03wi+3vt
X-Gm-Gg: ASbGnctl7Yn4s17ZxBmUWzliWNCmJNHVZYDJHm6ZxmnB3waLs2IODJ5XES02LSRMoVA
	jufVmNpCjNBs1NFtQZJrp8fOvqRRLo8vwzb0CziksdUGYEd5G5fGuxX3ECVt1PBEjSoqv6+EZ+2
	zlNWWBuvWFvqZ6doHV601tv2V8pYCrd/ex+Wfd9CLY+zPJasgctNSCUpxADK982wGtAVnw5a4KC
	FAbJfSWrvO2Fm9WGMvKgUQvRqLnf5gh57zWe4dUYTxgXyIG3GtA2djmxHzfIuzDqgQAjDnxOn78
	4zWe8qNGBX1SQ7kg4t0znqeSk/6UtzuLkALFewV/4GsR1cFzPk1acBvGGcWT3T/VbHsznvNvz0C
	MSrBjxliHwfjS42Puttmff5vh0r3z0HNlRPjV26CnOBl0FLgT2HV4EZijIiBXw1pZDrH61BTy72
	AEBhXK+ecs
X-Google-Smtp-Source: AGHT+IFhSsUjwtf7XXEFFhGewe4/WzYwa1EvQXhZvrF755UE0d1dYIej0yvrkJ/oBfshVizcRSlPOQ==
X-Received: by 2002:a05:651c:4416:10b0:37b:aac1:282e with SMTP id 38308e7fff4ca-37cd9287c95mr16773881fa.28.1763843635543;
        Sat, 22 Nov 2025 12:33:55 -0800 (PST)
Received: from localhost ([109.167.240.218])
        by smtp.gmail.com with UTF8SMTPSA id 38308e7fff4ca-37cc6b597b2sm19299711fa.12.2025.11.22.12.33.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 22 Nov 2025 12:33:55 -0800 (PST)
From: Askar Safin <safinaskar@gmail.com>
To: mpatocka@redhat.com
Cc: Dell.Client.Kernel@dell.com,
	agk@redhat.com,
	brauner@kernel.org,
	dm-devel@lists.linux.dev,
	ebiggers@kernel.org,
	kix@kix.es,
	linux-block@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	linux-lvm@lists.linux.dev,
	linux-mm@kvack.org,
	linux-pm@vger.kernel.org,
	linux-raid@vger.kernel.org,
	lvm-devel@lists.linux.dev,
	milan@mazyland.cz,
	msnitzer@redhat.com,
	mzxreary@0pointer.de,
	nphamcs@gmail.com,
	pavel@ucw.cz,
	rafael@kernel.org,
	ryncsn@gmail.com,
	safinaskar@gmail.com,
	torvalds@linux-foundation.org
Subject: Re: [PATCH 1/2] pm-hibernate: flush disk cache when suspending
Date: Sat, 22 Nov 2025 23:33:42 +0300
Message-ID: <20251122203347.3484839-1-safinaskar@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
References: <c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Mikulas Patocka <mpatocka@redhat.com>:
> [PATCH 1/2] pm-hibernate: flush disk cache when suspending
> 
> There was reported failure that suspend doesn't work with dm-integrity.
> The reason for the failure is that the suspend code doesn't issue the
> FLUSH bio - the data still sits in the dm-integrity cache and they are
> lost when poweroff happens.

Your patchset is impossible to apply using "b4 shazam".

Here is what I get when I try to apply it using "b4 shazam":


d-user@comp:/tmp$ git clone --depth=1 git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
Cloning into 'linux'...
remote: Enumerating objects: 96577, done.
remote: Counting objects: 100% (96577/96577), done.
remote: Compressing objects: 100% (93936/93936), done.
remote: Total 96577 (delta 7530), reused 20945 (delta 1607), pack-reused 0 (from 0)
Receiving objects: 100% (96577/96577), 267.21 MiB | 1.85 MiB/s, done.
Resolving deltas: 100% (7530/7530), done.
Updating files: 100% (91166/91166), done.
d-user@comp:/tmp$ cd linux
d-user@comp:/tmp/linux$ b4 shazam 'c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com'
Grabbing thread from lore.kernel.org/all/c44942f2-cf4d-04c2-908f-d16e2e60aae2@redhat.com/t.mbox.gz
Checking for newer revisions
Grabbing search results from lore.kernel.org
Analyzing 15 messages in the thread
WARNING: duplicate messages found at index 1
   Subject 1: pm-hibernate: flush block device cache when hibernating
   Subject 2: pm-hibernate: flush disk cache when suspending
  2 is not a reply... assume additional patch
WARNING: duplicate messages found at index 2
   Subject 1: swsusp: make it possible to hibernate to device mapper devices
   Subject 2: pm-hibernate: flush disk cache when suspending
  2 is not a reply... assume additional patch
Checking attestation on all messages, may take a moment...
---
  ✓ [PATCH] pm-hibernate: flush block device cache when hibernating
    ✓ Signed: DKIM/redhat.com
  ✓ [PATCH RFC 2/2] swsusp: make it possible to hibernate to device mapper devices
    ✓ Signed: DKIM/redhat.com
  ✓ [PATCH 1/2] pm-hibernate: flush disk cache when suspending
    ✓ Signed: DKIM/redhat.com
  ERROR: missing [4/3]!
---
Total patches: 3
---
WARNING: Thread incomplete!
Applying: pm-hibernate: flush block device cache when hibernating
Applying: swsusp: make it possible to hibernate to device mapper devices
Patch failed at 0002 swsusp: make it possible to hibernate to device mapper devices
error: patch failed: kernel/power/swap.c:1591
error: kernel/power/swap.c: patch does not apply
hint: Use 'git am --show-current-patch=diff' to see the failed patch
hint: When you have resolved this problem, run "git am --continue".
hint: If you prefer to skip this patch, run "git am --skip" instead.
hint: To restore the original branch and stop patching, run "git am --abort".
hint: Disable this message with "git config advice.mergeConflict false"


It seems you should send patches not as a reply.

But I will apply your patches anyway, no need to resubmit.

-- 
Askar Safin
