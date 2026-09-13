Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 595DB3845D8
	for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 23:46:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789343198; cv=none; b=EtnrmP4xx/zpWpn4UF7o++Zz6GwYn7gGdWRQCbAUduLmpHi2O0b0DgK8xpa8gF+hF/RtIRMkf/BuK/UcKkMHhLE1H4/nrTD22kkrW3IG2ITFlFfxyRWMdK0p8gmGeMHxUiu6jMY+M5hO6fvIcguj4IdYc6LGs7rh5LL+RDMqVpI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789343198; c=relaxed/simple;
	bh=Qn9lIkgmGdmg09kU+H9Bzm5YtdGfa5a/RA3U99GBCpk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=TDPtb0D0tQHSUyDVDjDwtGoHY+dDy2j2OGaRmUQ0HSneLBVvPcAjlHrL54pcZyd/ldqfYPmsLfZgoOqA2L42/dz/Z5ysFhXyXSIcF2N1sKnLQwj0lTl88RSqv+Mdd3J8ZUmkQU9+6qLi0F153OUHKrxrwYqRU5KxrNQhVdx8144=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6c1a8f2c565so2645338eaf.2
        for <linux-raid@vger.kernel.org>; Sun, 13 Sep 2026 16:46:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789343196; x=1789947996;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=cjOiu+m9w1SzNUGZg72zZnORRd0gFlaMH0tXwn0wV5g=;
        b=RkWGjmoZR5FpKWOWiuYKK6rfustWmOQlEFbBt7E75GnLUwKEfr26nI39jrXpwborZc
         VLoT8oxzpBGkGrdfswFip/jPL5sRstQdXyz/GGHFlIDifuEoXl+48uMObDid9L4h3yhX
         TCKqK/ebbwYsQ/SaHGfVed/CiIAwejsOYSRwY3bIqch1EqsLaZ527FHx1syWdFAQKQJi
         tk3sOeFaJs44udOb+IMk6T8nrgbwLa9V8xVBBwbyPFm48nautzz8iDHUbt+ymdtxddw3
         QRFmfwFJShgEtoaQRRgT75Xkwzug+Qfso/ZJFACB16DGMDt5h5q3RGiN78cC2V8sJzgS
         uBKg==
X-Forwarded-Encrypted: i=1; AKwUvBzEuc/O0C8uEgzwaPQ58dbsp0AS6D6q1GGnCw4ovWujXDG1vsUdwsad2/iCi2ApMo50eB8aiUa2HZrd@vger.kernel.org
X-Gm-Message-State: AFuF++kpSxnaa4mRkMCjw9QDRs0ffbJNq+ZPIcsYj3xKtxqcyjZubjYe
	WuEq2Cc2LPU7lIZPYE/+Zwq1tKBit0kXnCIOFOgmpgv2G26MtdqZ4byVrQyEF7pJDzs/jr7iw3n
	0JSq50B/SCmVBfUgU31Rn0TQAIKM3EXxCQ6cEmPaIbj/v0meh02GFRXU9jAk=
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a4a:e842:0:b0:6bd:e592:2c66 with SMTP id
 006d021491bc7-6c544cac0demr5509eaf.46.1789343196358; Sun, 13 Sep 2026
 16:46:36 -0700 (PDT)
Date: Sun, 13 Sep 2026 16:46:36 -0700
In-Reply-To: <20260913234627.465492-1-aadityakansal390@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa735dc.3aa11909.1a03b8.0004.GAE@google.com>
Subject: Re: [PATCH] md: add max_disks bound check in older version
From: syzbot <syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com>
To: aadityakansal390@gmail.com
Cc: aadityakansal390@gmail.com, linux-raid@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

> #syz test

"" does not look like a valid git branch or commit.

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
