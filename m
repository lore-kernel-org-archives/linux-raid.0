Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A75BF3C09E0
	for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 23:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789342648; cv=none; b=aqE8fsZudQzwulqOPBMB30tIoL+xq25s4YGJJ2j5ZaZGiO9BZX64ffvIVnBAAZmv54p8DEb2kRxc8RXfvJ2ImcXd9ah++COdkZsTE2p5e2NjNtu6ZdTe45rdrVXSZIILo56G3rdemM+EqyX3wTVpSaqPNdACIo6aGFM5BJe6RAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789342648; c=relaxed/simple;
	bh=YpUP09OyVbTkYiDq4W7DT4ucZTXStfn0jkAGCtMQPyc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=hL7YBh98gTw6kKd6BHSdpBhOQDezu0/TzFDbrE9l9+BzTkn51bhxtP0pEpE7KfTYVoGAJdlQJuf5P7FAKpuEMsXKxRSTH2FL0tjzJ+prfABQdNwKnTCaLbb/LbbteQygAEkuS9cxAJpcpT9l3K8rB0IQGeXRXDRVRp1OlmbXXXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6c1bb6ec882so2181970eaf.2
        for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 16:37:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789342645; x=1789947445;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=np8KSvSuHAU9TGAQM2uGFye4XuOKuIWYRdmGyDZ0FT0=;
        b=JZljiE0WA8W4P4vpXtmkw2DLZRoTY0A6VBfWhgJclzqGkvGmCfc8TfOBl9wcb1eTxN
         Pjk+rx8usxbEvQgi9eUdEIux9oFdlUbu88IxtwLUkTy3i5nsnJyiQ7gIFbVXN/oXRifE
         LPiBdCldGiEj68MyOAqQ3pHVYQniM6/DcUpFAqqv0yFPr9E1VRWhzozRzh0RWTzCPYsC
         CC3B17IIogFfIcP6FYdClHCiUM/MMuhC5ilSktvd3Kbq2rv5oUm/DtVv3LH8Her9vScq
         /FOoupTnRS/+Bq2a/Z5JEACwdm6Dz8jNkXwYYCTNZ7dyRkGiHeCOoz4pGS/I+JHo+WY/
         fBGA==
X-Forwarded-Encrypted: i=1; AKwUvBzmRB6vurEhuqv6mgSPfFRmfD7YfSdhVc9S+v1d0HtfBekmmkNqFelKt0kd5jJRP3iV4wVOrv7/fITq@vger.kernel.org
X-Gm-Message-State: AFuF++mf2W5AckgGN8HKT94tEyJpDsisnqhNOdbixK1F9PkWoUx8HzeV
	e7r9tgppVaK/wTH/Bd+sFKw2R5un6fL8YxXsk0rZTyp3Hlb6VLs2poKt4YxzG3DNH2fEeXa77y1
	dHwziQu/Qb+z7zvNyMYniURiwdlfjTVEPw1wA/6myK7V0NqoL+7yWsXyQjHQ=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca1:b0:6b1:535a:eb8 with SMTP id
 006d021491bc7-6c53fd884f9mr14268eaf.2.1789342645581; Sun, 13 Sep 2026
 16:37:25 -0700 (PDT)
Date: Sun, 13 Sep 2026 16:37:25 -0700
In-Reply-To: <20260913233717.464321-1-aadityakansal390@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa733b5.f81106d8.2ab401.0039.GAE@google.com>
Subject: Re: [PATCH] md: add max_disks bound check in older version
From: syzbot <syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com>
To: aadityakansal390@gmail.com
Cc: aadityakansal390@gmail.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz test

"" does not look like a valid git branch or commit.

>
> syzbot reported array-index-out-of-bounds in super_90_sync()
>     UBSAN: array-index-out-of-bounds in drivers/md/md.c:1697:17
>     index 124 is out of range for type 'mdp_disk_t [27]'
>     CPU: 1 UID: 0 PID: 10197 Comm: syz.3.1362 Tainted: G    L
>     syzkaller #0 PREEMPT(full)
>     Tainted: [L]=SOFTLOCKUP
>     Hardware name: Google Google Compute Engine/Google Compute Engine,
>     BIOS Google 08/05/2026
>     Call Trace:
>      <TASK>
>      __dump_stack lib/dump_stack.c:94 [inline]
>      dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>      ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>      __ubsan_handle_out_of_bounds+0xcc/0xf0 lib/ubsan.c:455
>      super_90_sync+0x1eed/0x1ff0 drivers/md/md.c:1697
>  ...
>
> super_90_sync() exists for older version 0.90, which supports up to 27
> maximum disks (MD_SB_DISKS). This function doesn't contain any bound checks for
> raid disks. The repro wrote higher value (124) in raid_disks sysfs attribute
> to trigger this bug.
>
> Add bound checks in super_90_sync() to prevent index-out-of-bounds error. This
> bound check hardens super_90_sync() function, such that it can catch max disk
> index-out-of-bounds coming from any path, including raid_disks
> attribute.
>
> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> ---
>  drivers/md/md.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..f5fce41637f1 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1693,6 +1693,12 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
>  			desc_nr = rdev2->raid_disk;
>  		else
>  			desc_nr = next_spare++;
> +
> +		if (desc_nr >= MD_SB_DISKS) {
> +			pr_warn("md: raid_disks = %d exceeds max_disks = %d for version 0.90\n",
> +					desc_nr, MD_SB_DISKS);
> +			continue;
> +		}
>  		rdev2->desc_nr = desc_nr;
>  		d = &sb->disks[rdev2->desc_nr];
>  		nr_disks++;
> @@ -1722,7 +1728,7 @@ static void super_90_sync(struct mddev *mddev, struct md_rdev *rdev)
>  			d->state |= (1<<MD_DISK_FAILFAST);
>  	}
>  	/* now set the "removed" and "faulty" bits on any missing devices */
> -	for (i=0 ; i < mddev->raid_disks ; i++) {
> +	for (i = 0; i < mddev->raid_disks && i < MD_SB_DISKS; i++) {
>  		mdp_disk_t *d = &sb->disks[i];
>  		if (d->state == 0 && d->number == 0) {
>  			d->number = i;
> --
> 2.55.0
>
