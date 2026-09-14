Received: from mail-yw1-f175.google.com (mail-yw1-f175.google.com [209.85.128.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B994489881
	for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 13:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789391053; cv=pass; b=e8vcRonVki10sl2uaQ6K363uVDMLWcr6kJrN2R90XrcSfYuJs8lQWsvyyORkJmJdVTUDcUT777JalrMRyMs/czEmmLNUO9W+GBnKPCzebHvDDm+/jO4ZsqMo+CHP9YepGH9rq2XmF/pJL2Qy37UcDwYKhApgst4pk6XejhAXDdM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789391053; c=relaxed/simple;
	bh=ybb9QeOsqfZN3IEmsd/nesigDpigySXViDpUH0wC3nI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eEieQ7wiYJzM3/sNWdVHt0a0I3lbICrzMBiUPCsJug/WoJuGIFaLW+b10jTVd4S5uwqvaItcEBo3Squh3nN4XgJqZJGzmh9lG4LfTe1WGTGiCLeOjxwFClGRrR+qdx3QFrtYWG/Z1TynZsluKTDAQu010ATWH10rpuQu4rM1nCU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Rn0IZ8VL; arc=pass smtp.client-ip=209.85.128.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Rn0IZ8VL"
Received: by mail-yw1-f175.google.com with SMTP id 00721157ae682-836c4474028so26774557b3.0
        for <linux-raid@vger.kernel.org>; Mon, 14 Sep 2026 06:04:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789391050; cv=none;
        d=google.com; s=arc-20260327;
        b=UhmRRUIQEDSI9s19WJ09JVzoJ/lkiPk9ZrdICnHlCehNLCMTbai1xnhaPIduXiVlx2
         v5XTOvFQ0Rz8SYGyvk3u+S3KCu6e/73Rysu/zw9k4phTuVBiErAPxegeJSzISyz9VUTQ
         pF+N/GsAOd1RcIPeXxCQkVKY2Grwe0eJTAfU4DtKgOqA+PNs8Ycv8WJkanuXakJsS7Ue
         OIgT09xDH9p9AYbR1IsKk0nHQ5qfxLVK7lnw2U8npes0iNHQBEm/OwqBHO6ayIdNtqK+
         7VMp2msKtqdHDaoAWnbox2xjA/rIi0LIj9WYudq2tfpl/DOMHJiSI8grQKfBYihtGnKJ
         vqxQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=opyQzysdmm2CzDSQThdzdAuoqcZ3TYYFu94kwvLe8Lc=;
        fh=tTmPzOe+zvNZbgNNAg05LFARApgDp8mDL7pkYZe3JXQ=;
        b=PNnp0I0h8E0J3IjNX0Yp+GumkQW6ZPT9izdYFfjBbGpVqv9fT3ZAi+9hq1l9r44ae9
         fIdf/N8UximezADNfeSapiGmlfC2k7ZQ8R4o+7iUYZ6id5wIoQ+bUPVcjD2fyugXoNKW
         dos8jf6BoHPsV2v5g7wfr+MY+fCVkPxwh6hdRYDJK10Pby4EBu3p0hqd/HBLHdNGIRP7
         rYVmBrGtUNXhMmeINwW4vZMDJS3D/wlF5JsrW4wS36QPNLdFxzBkYU1bZgoT9eRl3A06
         m8MAyYctHU24EInRwVkWsnEuwnLSZRVctRsPokD8HrPK3gK2nRB16s/ud2+VY7CDVRkV
         +AaA==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789391050; x=1789995850; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=opyQzysdmm2CzDSQThdzdAuoqcZ3TYYFu94kwvLe8Lc=;
        b=Rn0IZ8VLM7m+5y4lt9TzjoBk99xNtpXKRh+LZ2Sd3KdCBnJXp6dtlfpFvrH1L3rPv5
         /ijBNa76MX7Auzfq3hpVh+ySleme5WofITnLpv/ga2G5WseF2DtqoKRhxn9bQdwh0I5m
         ttfXCjzUGwWOPqNFgCPTqjUGJZ5OVwU2NWPv1ZFvqQvcAtWU8PDCWVX36RoKJ0YNPrkz
         L6BRTmfQuLs8nRZu1ylj6sdvohNUHjentaT85Lf2YI4Et2lQSKNa5cWSOIa8UD0Fviya
         fNNm1r7rvi4tmBmjJfBewgvsUrOaNsMSIHcODsbr2DDsfIddcxhxhVAqh+Ry13UE+wt5
         H+AA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789391050; x=1789995850;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=opyQzysdmm2CzDSQThdzdAuoqcZ3TYYFu94kwvLe8Lc=;
        b=T/3ZaNHejPlFd/zCPvFG3ZS2iKil9UFdUb59wwoWIl6xfmS/TcuyhivEjKhbysVi2C
         E6igZSre1htGtx5drqWyQ1JvvDAaKWt7UMhFZ/YGp5BfLuK+/P9oExYZr2gfdVNWIqOI
         W06JVZRgJMBtXNq414IevcUA9ezfQLsYyB4X/xKKVduY5tAK7g/LxC2igu6MwW9gdJ9b
         NN6VGe2cQEVNMu28vI6HD4EKzJdEpFyI662x0X0GcENpqiK7Mb+KG1basQwgCGGjsabx
         WpIeHiUYl2O2YearPadK4plqF8QUD88y7BGWk7IvOu26cFtvCQN9AUs1J7yc20VYcsMB
         fNLA==
X-Forwarded-Encrypted: i=1; AKwUvBy9PGv1HYC5tBGlOZzTgeu65fsT0DgLesIhegRYJA3xOV8icupcgAMgBt1AoPYoI4tWmkWrzEzCJJds@vger.kernel.org
X-Gm-Message-State: AFuF++kizrt02x39ZcAEAnfjv3pQ+FR4hxtK/sX+ndshyDPIET35NZ1p
	iJY/SkEfPJcM1JahbBAOTjRmQsjSSJyuMgauigU6cdwJAG/kNvxk4Yh+EzVNTbrdGC6dLIthWPu
	ZAlH9k9rBVboVNYq+JnP3E7/x7kDOKPw=
X-Gm-Gg: AYBFou2YWrVFYH4bJXoOGxYYjrl0POgDvXcxjoHXU3d9iYbPZFaOIsxRHASmve9p7Es
	SyPgeSGgtjHu02nBtE6svDUuaqrKnY3LseC5Qe9ZHu1AGpkRqu6c0ZnFJpumSrvcydJJQWTnXAa
	fkmt+03Mg74CYWh6wsuxL8hlz9/Dtq6NA6avy9hh0EcKVJaypGLf36hrNxRC+U3tuNyZpWYL8sM
	5cMkEhhNKtHsxZHP0SZ5NimcJHW+Q0Lrxt71o0xcXkeFFRjoCSRZnRHSbK73ttgwd6hs1PW3/f+
	w5hwFVD6CsvHexqYLHBKboqhvJv9TKN0M1REzwBYwVJRVIA7aZQggtjgECWbj0QyLWI9
X-Received: by 2002:a05:690c:83:b0:873:5bb2:6c1a with SMTP id
 00721157ae682-88d2389df38mr5815567b3.68.1789391049683; Mon, 14 Sep 2026
 06:04:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260910131103.988-1-yogeshgaur.83@gmail.com> <15056940-2572-4395-a72b-8cba7d8d11b7@fygo.io>
In-Reply-To: <15056940-2572-4395-a72b-8cba7d8d11b7@fygo.io>
From: Yogesh Gaur <yogeshgaur.83@gmail.com>
Date: Mon, 14 Sep 2026 18:33:56 +0530
X-Gm-Features: AcwNN1WM7MPwMDCdIU3gN0obgQhJP0QA1G58-SaaBx-D5_6qkKONYxKbBE_NY0w
Message-ID: <CAG6enPyLT=e_O=nyji6JawnCbvfM6tFPxc2-vsGB886R7O1b6Q@mail.gmail.com>
Subject: Re: [PATCH] md/raid5: don't BUG() on an inconsistent reshape state
 from the superblock
To: yukuai@fygo.io
Cc: Song Liu <song@kernel.org>, Li Nan <magiclinan@didiglobal.com>, 
	Xiao Ni <xiao@kernel.org>, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, Sep 12, 2026 at 1:18=E2=80=AFPM yu kuai <yukuai@fygo.io> wrote:
>
> =E5=9C=A8 2026/9/10 21:11, Yogesh Gaur =E5=86=99=E9=81=93:
>
> > raid5_run() branches on mddev->reshape_position. When it is MaxSector -=
-
> >
> > no reshape in progress -- the else branch asserts that nothing else
> >
> > describes one:
> >
> >
> >
> >       BUG_ON(mddev->level !=3D mddev->new_level);
> >
> >       BUG_ON(mddev->layout !=3D mddev->new_layout);
> >
> >       BUG_ON(mddev->chunk_sectors !=3D mddev->new_chunk_sectors);
> >
> >       BUG_ON(mddev->delta_disks !=3D 0);
> >
> >
> >
> > Nothing enforces that invariant. Both superblock validators copy the
> >
> > reshape fields straight off disk without cross-checking them against
> >
> > each other: super_1_validate() takes reshape_position, delta_disks,
> >
> > new_level, new_layout and new_chunk from the superblock whenever
> >
> > MD_FEATURE_RESHAPE_ACTIVE is set, and super_90_validate() does the same
> >
> > for minor version 91. A superblock that sets the reshape feature while
> >
> > leaving reshape_position at the MaxSector sentinel therefore reaches th=
e
> >
> > else branch with a non-zero delta_disks, and assembling the array takes
> >
> > the machine down:
> >
> >
> >
> >    kernel BUG at drivers/md/raid5.c:8117!
> >
> >    Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> >
> >    RIP: 0010:raid5_run+0x11a7/0x1670 drivers/md/raid5.c:8117
> >
> >    Call Trace:
> >
> >     md_run+0xc2f/0x2510 drivers/md/md.c:6779
> >
> >     do_md_run+0x36/0x660 drivers/md/md.c:6880
> >
> >     array_state_store+0x9c5/0xcf0 drivers/md/md.c:4765
> >
> >     md_attr_store+0x1c5/0x330 drivers/md/md.c:6158
> >
> >     sysfs_kf_write+0xf2/0x150 fs/sysfs/file.c:145
> >
> >     kernfs_fop_write_iter+0x3e0/0x5f0 fs/kernfs/file.c:345
> >
> >
> >
> > This is reachable by anyone who can present an md superblock, so BUG()
> >
> > is the wrong response. Refuse to start the array instead, the way the
> >
> > reshape_position !=3D MaxSector branch a few lines above already refuse=
s a
> >
> > reshape it cannot resume. Nothing has been allocated at this point --
> >
> > the journal-and-bitmap check just above returns -EINVAL the same way --
> >
> > so there is nothing to unwind.
> >
> >
> >
> > Reported-by:syzbot+1f5a7de91d547763f4c8@syzkaller.appspotmail.com
> >
> > Closes:https://syzkaller.appspot.com/bug?extid=3D1f5a7de91d547763f4c8
> >
> > Fixes: 91adb56473fe ("md/raid5: refactor raid5 "run"")
> >
> > Assisted-by: LLM
> >
> > Signed-off-by: Yogesh Gaur<yogeshgaur.83@gmail.com>
> >
> > ---
> >
> >   drivers/md/raid5.c | 16 +++++++++++-----
> >
> >   1 file changed, 11 insertions(+), 5 deletions(-)
> Applied to md-7.3
>
Thanks.

> --
> Thanks,
> Kuai
