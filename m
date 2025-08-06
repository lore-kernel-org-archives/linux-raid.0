Received: from mail-pj1-f51.google.com (mail-pj1-f51.google.com [209.85.216.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA2802750FE
	for <linux-raid@vger.kernel.org>; Wed,  6 Aug 2025 13:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754487298; cv=none; b=qkdPfvRE0JTXp42YmWC1QIi4XPpjJz+MjDnfgqjWrCj+XDDE3S0QN3V9OejhPV0qqrBnY6JRuEb4scWWtVrRQM/Kj6LvcQOfCLopnLuAz3j0iStoHvi0vo9GzlswCrTmB1lwQ+RZ9jo6DdxfZexkgpIYfcAXLNsvVlEF8+0iXTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754487298; c=relaxed/simple;
	bh=ygUAA1zArk6JjK+GPX3YGV01Vtr3N3HNdak18eu6kHo=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Content-Type; b=DUP1FzGSUL65RNmXEyRhh3kS5HvEcoXQ3C5+hkIrNy2IwkFCCqhO0r/yj/Q8KKpuriyo/fLBHaFNKLuNQ2eFBspHIDG/2o+AHti5ZZTjBbDJfnYujJu7JjX2DxJdB0zbqEuef43idaPb7MO491syfdZTuqJpZsf0GkDmtnxVH/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HKvHXuwi; arc=none smtp.client-ip=209.85.216.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HKvHXuwi"
Received: by mail-pj1-f51.google.com with SMTP id 98e67ed59e1d1-31f28d0495fso7275666a91.1
        for <linux-raid@vger.kernel.org>; Wed, 06 Aug 2025 06:34:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754487296; x=1755092096; darn=vger.kernel.org;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+Wqx8C7ylJ5CKzNRyjh+eA7Pzpo4iMmES//rw9f1h7A=;
        b=HKvHXuwi+MI8EeyWKFqJ4G8Yi2T7QeN+HMyQ+VF6FCSm7gn2LFyNm6SLwG6YICpk+3
         OAtbqMUjWR2l11VRr3PmOLIKr0Cfo3RLJsDc8vgVoOLpA/jIw6eIIM15qB8RopAA6sah
         X+94xjvGOYFfS+vpESMudhZmQUth8wrSMC7su/PQH1j20tCfPnJVKxDM9y6SDD7HqyPL
         t7mJmU8Ief6Txhdkd8JZFMcra5mFmBzXHnb7o65b50uTjL80C0O3G57i7CFk40YWVqDO
         YxAAicB8D2zcEPTIorpOpM3Zh6g6Entv5yB4cRoo1qhdf2PITJK56MQof2WnBIQykP51
         fzkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754487296; x=1755092096;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+Wqx8C7ylJ5CKzNRyjh+eA7Pzpo4iMmES//rw9f1h7A=;
        b=GU+lGrthceCGqy78hZqrhoLbm77pgjrFRoFW1ApAg/dXHrUOzsjSPFSzBj/KoEWlWg
         1FSBiNVcrTF2D54rN90E1d2b8hbngousoubtjqmnJ7/PNnG/MTcM5fLFoJM+J5cpqXLA
         1FXfmd+mEPZ3HH9YsiIsCnrpVVnmLQr67rgNFAayTlMi8FS2p76617e6L/TujjUPQEDq
         Ncky9yyihkZQWZ4FC1FZGml4NyKQVvLt9Pp/y/RQDCi01VETgxLurvtnypixMLYZ/WC7
         FNH2J95W+jO3bBpvQLW3gmeGXqRUPazl4y9lGwTG071fNLO6uBov92+fLVho/ad6AQZF
         vwRw==
X-Gm-Message-State: AOJu0YzbPHACsz6SZgiKb8ZNwqZi+09YEilGuNZm0vM/bgqCoOVSGz1U
	y/WKIrqnSxIsg4A+T+5mUP3KnRbsgFeaUPnlLdpz/rhhoXeUppE3k/HpCKZMuoHbgux6zlLYGJE
	1OwhETWYOfsw83qdqePI2qFoly3ui1oCftksA
X-Gm-Gg: ASbGncuMf/mUGfufviKBUBqZtvToJXtt1Da8HXuaFJksvMRVNarvwYxSyuGqHzibBzJ
	sv7s8tsz0HDBniAKNQ7tnViFlUXAb/1pSlGUHyNGvjIUmv56r61PBA0zARhm70jABXTYHHxnwvu
	WPAOBApxnkkJNYvvmL8seJdA5VFrq2K9n7uH4YlVv/LbJQ0q+G1Kx2K4lUzx0jzRP2+b4k/ZY/I
	0NrcIhUNw==
X-Google-Smtp-Source: AGHT+IGRcgNKdPmOGFe0XCqgXxteIh6y+YHWex0Wu4GFhCztlBUYYPN85eSCtK2WMRRE161y9JBp9xZe8NQiUxFSLYQ=
X-Received: by 2002:a17:90b:2683:b0:31c:ad57:b97a with SMTP id
 98e67ed59e1d1-32166c2bd22mr3557157a91.13.1754487295834; Wed, 06 Aug 2025
 06:34:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: chen cheng <chenchneg33@gmail.com>
Date: Wed, 6 Aug 2025 21:34:43 +0800
X-Gm-Features: Ac12FXw9N1vRjhoew4zOXcvhQLzznnoS2kCQunnnnvdzTgV1rwInvwHNguHWwxs
Message-ID: <CAD8sxFLS7A3HLL3diYRU5fHxCUb_y-QJS666k5cPOgQ8wGFDjw@mail.gmail.com>
Subject: md: Does the thread entering the wait queue violate the semantics of
 REQ_NOWAIT in raid5_make_request() ?
To: linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

static bool raid5_make_request(struct mddev *mddev, struct bio * bi)
{
        ...

        if ((bi->bi_opf & REQ_NOWAIT) &&
            (conf->reshape_progress != MaxSector) &&
            get_reshape_loc(mddev, conf, logical_sector) ==
LOC_INSIDE_RESHAPE) {
                bio_wouldblock_error(bi);
                if (rw == WRITE)
                        md_write_end(mddev);
                return true;
        }

        if (likely(conf->reshape_progress == MaxSector)) {
                ...
        } else {
                add_wait_queue(&conf->wait_for_reshape, &wait);
                on_wq = true;
        }

        ...
}


In raid5_make_request(), if a reshape is progressing and the current
IO request is not within the reshape range and has the REQ_NOWAIT
flag, does the thread entering the wait queue violate the semantics of
REQ_NOWAIT?
