Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 812CD3DCD9B
	for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 17:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.214.180
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782321949; cv=pass; b=b6+v1UrLqYtZfD7eme61WV8usQYB0K/RyQvronYx66N48WuyP5X0k+UXfwdZKC4Mmqwme+3Abf123zDs+ywb66MxgH6lznazhhkM5PJUgkdtUX3Zciyoc5rw6z/yU2Xl4h77aS/3N14RBKGYTOJG9vKGzIXb+OVrXRcBif4uXb0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782321949; c=relaxed/simple;
	bh=2ulYMFA2kFw/iz4ZhIGgEMFkfQEvvSC3Q2LgFZA+dH8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Eb/9bpEkG3l+jwxtTOyg4bLhw9AlqsmZpX4jFGGgexXeCBK+RwCWJK+/ocs4H7YR420O+9bsF+E6mcs/+laJxK3Dwqh+PrtNNejEeLuugqbQC2+BTVhAsFgpfosplZWsrm24hT8X19WnsVidSS6UtN9nELB16/K47BjSxGxQoCA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZuajVOHR; arc=pass smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZuajVOHR"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c74383c93cso10504955ad.1
        for <linux-raid@vger.kernel.org>; Wed, 24 Jun 2026 10:25:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782321948; cv=none;
        d=google.com; s=arc-20240605;
        b=j83ziEzLVV7rcnu7d5BpLxo0BXq1PshSwtzOSRgEtUhc26DtoX8Sicf5obNo0I5cO+
         jSbWUDWDhRCSn3fbFlnuICQnQltTjrW/bAPuInjH41RxwUGAAcRiudilCi3zf6YYJI1B
         t/qai3gVIEFk755QJdLywHJa9hOXvPJVIzpwYLnJN/oWJwfWp8qWy4tAZuWQVzkWig1M
         nDw7K431NzQbAYaG+4Nz/ad6K5Jfa+sNcOPwgCskkTPkaYp97Nfx+IlkmAFd4q47xdlB
         CYzgAW8o9zr8aPRIg2OJGBLUP8T2kZpV1DUDJ5vLuCxkIkh+9F6F/hOUZNVG/syh6HJu
         T3Ug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=h54lF4cp4pKVbkWYZ0Pc8whGOHAxadfn5MZ75TgQZE8=;
        fh=mTP6TkWV1IhQRgyhsEpYqIpiXvhDlZKdHAfNRdOTDjk=;
        b=DzlYK+rLk5fSCWOiBVwzAh9bBh+vHOqUQPUOEI4n0Q6+L/1soweNBzSlZOS28s3/ta
         MHm9rW9yeypkJIKwBLpsCog4QDZDLplw7XsmLbLNdj+kLMf17wYnFA43R/EkaNYYcmiA
         OAz1AVW0tFEjULe3OpKgiAePrtOHloQU8S6DZEeF4EOZobpUykNEWir9HHXXzwWfjkYK
         Mr/Yw5J9mYXS7qZBkQEol4MewPZGA89QtxMGBtTD3B/9WwsKWwvalKUic+EeKAIYbJZr
         ovY0Mn2LdxfJBRGCd+l3+Jtu2ezTIBbE3QojfrBrbYmhM7onZaYV6TT8qdGju9olNpP1
         +MPw==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782321948; x=1782926748; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h54lF4cp4pKVbkWYZ0Pc8whGOHAxadfn5MZ75TgQZE8=;
        b=ZuajVOHRzYMwsesqnQ7vZN+kyxzANDwvojiklgv26ZKTglzSETUXrhRo9jzD9sN7A7
         mU0wr2pk/7lArfYAteoftKCzZT4iwCQoer1su6mXCi7akHsic+2J61A+eQar1aHxqlmw
         3I65D9gf/C/6+biFAPY2PukZgZNxUGBe+RUA04/WXzobDNmcF7eIJVoWGv1lWtqtstxw
         oYiZCLRgGOaUEXYBX6LDfjHfhoEebG0kMIiM3g4pvTC6huVhds2TDfp9OANXEBC9Xrcm
         UoVtrkvFjwoBQS8tFFayl+cif8TrmQtqI8tupmASnSArNseMCVFf0bCQpNUcZw7fwSCw
         MFmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782321948; x=1782926748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=h54lF4cp4pKVbkWYZ0Pc8whGOHAxadfn5MZ75TgQZE8=;
        b=RXXBd6C16hE30Q0SwKBWqh2EWMRTLZ2CGtEPehq9xlnwLWHv2HjXYSHSRDGQ2vgEMg
         ki/uGuKS5s63k03VrmcM+njQ95WWNjiC0Heu+BWzEpR0hURz4Xje68F/1iWW+ajc2MJb
         kk8erXAbP8jUvaQT/+CnjUkUxAXMkG8XegdNlCmVPHg/mjrxvZosW2onRUjUqVWzptOr
         4+EJlDvvcCkmhU1e3JKlLEA+2uGsnIFMlQP+ulT7OZ0rluIYVBDqHVHAhsCtLaDufhr+
         gwAtNgee7yEvjcPw+DVr8c1aBH0i90dugoKDZTXeMXZKM0whc3oPy9mwiK+ut40C/tPQ
         xjow==
X-Gm-Message-State: AOJu0Yy9YUGbB2jLDdl1vr9secrOH3muJa06Jw8HRud5c1nTtBM7ksfy
	3EVpR4lowOoTwvme1sy05A1DDbmlGCpSdtRcsMFPSfzSxVMJwa+PkQT5ToWSaBhTfmyhFvnb2iN
	H6SYM/31FA9qyp14wBwYjsAnjk46kljI=
X-Gm-Gg: AfdE7cnOJlT3zud9cqhO3x/CWyChjNTNHDFNqPa+p3OQhPIYIAdWFSUzXxIUDJftrVg
	WMgRlz3cN/ecTl+DEzQUpqSKQ3WvRm14aZlJIwTjWto5A3H8sEVjWy06s1EMVbv3H80k6/w0AmK
	v/fOwjZCxtusiXOxr6j91MBymc5x87Ee5OPbkO32mBW8P/+BRDuDJLJNe3wCQQ4xNFQpOJzK9A3
	rUjJwIZqhI9GH0HnH+doZnLbMLh03O7g9RS3SPJJfJHwGgfROeSyGdNmz+M+yTaIU5NhLXNj/+9
	Y3Jy0Qa2lAzdfsqglGpYjyOHpk6FayaXqKxgomWz9iX1t3udOeCpePQY1p9N/sAz3Sim71m4/ZU
	8r6nJ+ZDOfYNx
X-Received: by 2002:a17:902:e790:b0:2c1:f262:4962 with SMTP id
 d9443c01a7336-2c7e155dd89mr45922735ad.20.1782321947598; Wed, 24 Jun 2026
 10:25:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260624155452.211646-1-nishidafmly@gmail.com>
 <20260624155452.211646-9-nishidafmly@gmail.com> <20260624161245.292821F000E9@smtp.kernel.org>
In-Reply-To: <20260624161245.292821F000E9@smtp.kernel.org>
From: Hiroshi Nishida <nishidafmly@gmail.com>
Date: Wed, 24 Jun 2026 10:25:36 -0700
X-Gm-Features: AVVi8CfykguIgR_hnOKDWjOkdsb_WTfQQoNRVrBjvv9IkmE75YRljQjjyjs-x-c
Message-ID: <CAE1ksKSaLykqdP90aueX-kn0ydjd6bQ7FjuAxnVaFGCvAsi8zQ@mail.gmail.com>
Subject: Re: [PATCH 8/8] md/raid5: reserve stripe cache for user I/O during rebuild
To: sashiko-reviews@lists.linux.dev
Cc: linux-raid@vger.kernel.org, yukuai@fygo.io
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> [High] Breaking the read-ahead loop doesn't bound the rebuild to 50% -- t=
he
> outer md_do_sync() loop just calls raid5_sync_request() again and the
> unconditional first-stripe allocation keeps filling the cache to 100%.

You're right, and it defeats the patch's purpose.
The 50% check only gates the window batch; the first stripe of each
raid5_sync_request() call is allocated
unconditionally before the loop, so md_do_sync() keeps driving one
stripe per call past 50%
until the cache is full and the existing blocking get throttles at ~100% an=
yway.
The "reserve half the cache for user I/O" claim doesn't hold.

Making it actually bound the rebuild would mean gating the
first-stripe allocation and
having raid5_sync_request() yield without making progress --
effectively reworking the sync throttle, which is more than this
change should take on,
and the user-latency benefit was never something I could measure
cleanly.
So I'll drop this patch from v2.  (It's coupled to the read-ahead
window patch, which I'll keep and fix per the other thread.)

Thanks,

2026=E5=B9=B46=E6=9C=8824=E6=97=A5(=E6=B0=B4) 9:12 <sashiko-bot@kernel.org>=
:

>
> Thank you for your contribution! Sashiko AI review found 1 potential issu=
e(s) to consider:
> - [High] The patch fails to bound the rebuild's share of the stripe cache=
 to 50%. Breaking the read-ahead batch loop just causes the outer md_do_syn=
c() loop to allocate stripes one-by-one, relentlessly filling the cache to =
100% anyway.
> --
>
> commit 29ed9bbd7953c5d6ceeb0158cc53c81fd4d3aaf9
> Author: Hiroshi Nishida <nishidafmly@gmail.com>
>
> md/raid5: reserve stripe cache for user I/O during rebuild
>
> This commit attempts to prevent rebuild operations from monopolizing the
> stripe cache and starving concurrent user I/O. It adds yield points in th=
e
> resync read-ahead loop to stop submitting stripes if there are active
> waiters or if the cache is more than half full.
>
> > diff --git a/drivers/md/raid5.c b/drivers/md/raid5.c
> > --- a/drivers/md/raid5.c
> > +++ b/drivers/md/raid5.c
> > @@ -6656,6 +6656,27 @@ static inline sector_t raid5_sync_request(struct=
 mddev *mddev, sector_t sector_n
> >            submitted < RAID5_SYNC_WINDOW && win_sector < max_sector &&
> >            win_sector < mddev->resync_max;
> >            submitted++, win_sector +=3D RAID5_STRIPE_SECTORS(conf)) {
>
> [ ... ]
>
> > +             /*
> > +              * Reserve cache for user I/O only when it is actually co=
mpeting.
> > +              * preread_active_stripes counts stripes queued for write=
 I/O
> > +              * (including the read phase of RMW); sync stripes never =
set
> > +              * STRIPE_PREREAD_ACTIVE, so during a pure rebuild it sta=
ys zero
> > +              * and the window fills freely.  Competing user reads do =
not bump
> > +              * the counter but are caught by the waitqueue_active() c=
heck
> > +              * above.
> > +              */
> > +             if (atomic_read(&conf->preread_active_stripes) > 0 &&
> > +                 atomic_read(&conf->active_stripes) >=3D
> > +                 conf->max_nr_stripes / RAID5_SYNC_HWMARK)
> > +                     break;
>
> [Severity: High]
> Does breaking out of the read-ahead loop here actually limit the cache
> usage to 50%?
>
> When this breaks, raid5_sync_request() returns control to md_do_sync(),
> which operates in a loop and will immediately call raid5_sync_request()
> again for the next sector.
>
> Because raid5_sync_request() unconditionally allocates its first stripe
> earlier in the function before entering this batch loop, won't the outer
> loop just continue allocating stripes one-by-one until the cache reaches
> 100% capacity and triggers the fallback blocking path anyway?
>
> --
> Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260624155452.21=
1646-1-nishidafmly@gmail.com?part=3D8



--
Hiroshi Nishida
nishidafmly@gmail.com
