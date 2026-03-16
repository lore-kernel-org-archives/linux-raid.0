Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87AA63932E6
	for <linux-raid@vger.kernel.org>; Mon, 16 Mar 2026 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=170.10.129.124
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773675941; cv=pass; b=ah3xueyxAGGQSveRrh5MrxLjLo+xENyS1rcSQbOOWDHbh/njKDS0QlBrXgISVU0n2Mm1G5q/q/0rtzT1CcLOdQ6cM0JwbmfMmqIfvox3rspWIaMfikeP9vPWL3iAax6lEzuljyPx2Y1KEDKXryUg0wPEFw9tYW56LjaySFJS3VE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773675941; c=relaxed/simple;
	bh=hjQ4FVy9JCH1w+FkKGRcPmGlKqhYdcMwmxgAQQjsIZ0=;
	h=MIME-Version:From:Date:Message-ID:Subject:To:Cc:Content-Type; b=mydupAM9MX52Cj4AKC5jTKmMZfwEN5ieFmCBMswO1D5zDB9Iv6yGrUGCa0ZmwVSrB9/Li1nN+qfPjR3cWGfr87vVUPx4Z3QFZYgPvQMhAxxTwrM07NS4cQR/6HMbebQcWXtOA7dJzKVtJnureiGiUlb56f5l4BB2Nqjz/Qx48ss=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Ek5UQNlA; dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b=AFmDLHXz; arc=pass smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ek5UQNlA";
	dkim=pass (2048-bit key) header.d=redhat.com header.i=@redhat.com header.b="AFmDLHXz"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1773675939;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hjQ4FVy9JCH1w+FkKGRcPmGlKqhYdcMwmxgAQQjsIZ0=;
	b=Ek5UQNlANhmcXDl3DTJCRMwtMnIgrppW0Ajq/L255k84dVkZaxmIiz3wyYnBSy4yVl8IvP
	A3pLU6n6VDwgbE8ALQoI1W64fQYOS9o3bKOO/Sm5/aI4wuDNLfSEuFj5FAqy4CdInc0dQV
	Qe0lLPHJqtmpJ0ztbhA/1Vzik+HGLnU=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-159-WL_sqZuvOBKqQXjUIKxlsw-1; Mon, 16 Mar 2026 11:45:38 -0400
X-MC-Unique: WL_sqZuvOBKqQXjUIKxlsw-1
X-Mimecast-MFC-AGG-ID: WL_sqZuvOBKqQXjUIKxlsw_1773675937
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-38a469b8bcbso28517571fa.1
        for <linux-raid@vger.kernel.org>; Mon, 16 Mar 2026 08:45:37 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773675936; cv=none;
        d=google.com; s=arc-20240605;
        b=FBIsUdxD99YYjBz38zyc2a/wWYWr3n/IFJlbz47mhLu+3iT5eUUUXzBtRUJ3+yho3p
         IgWelrPmJ08RulphBao+A0VcUiJSWWTMxTIogCKCkizVj4ob0lhku5q7MucKjsp6ywBL
         uvIbMtgIHr5/z/BQZdFEJEj8h1xlgh7MAXVyfmB7JLcpPYlynlDdNejYnmX9REHWAXkG
         ahQBbpHeuIFtvBSpaw5m2nL4kHtPVlAZtQClWXD1Avn4NWbsgLpjYUc0c9Mde258rKvW
         ebsI7PRVNj+a7h9GsgAe2BhtcUuWZ1uvRubk3Gr7RzJEXI8MA1huK2ZPvvuCuuxJ5HHo
         KzIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:dkim-signature;
        bh=hjQ4FVy9JCH1w+FkKGRcPmGlKqhYdcMwmxgAQQjsIZ0=;
        fh=7xnjXTOG6hVceEfT2/c7IMB55OA2fjD2V/FAwLLQgLs=;
        b=MaOloklJp28I3RWVNYelOzxb5BehCR1bJKRp0g6uk4WprKc+AELOOo+Sr58+I9ppnV
         4hj+Py/O0mXrC2Sb+sYdSkX0YAfvNqpU1TDLEX2w/E/xB/x86W5qYphzCN0W0bLCcnf3
         LXKeC+iONyx8u/QMja6lD6K3EEdbrmCabfp5Sf+XfNEsm46IyqnXBp5dn7ufJWRxXNN1
         6Vszuu7hfxpf5Fv3Hg0ETNsyMBC9OKLIoXKBBC2jvZSYE3aQm/HOjUnxOajbMkFUld0A
         Mh32U4O71u3fNPoUTJtK6yI6FXDM3yhlPn9C15KHcOy/z/QTlyiNq4JthX4b0457YUK2
         6n5w==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=redhat.com; s=google; t=1773675936; x=1774280736; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=hjQ4FVy9JCH1w+FkKGRcPmGlKqhYdcMwmxgAQQjsIZ0=;
        b=AFmDLHXzrbiE0S0p9SC305tegyK+0eeg4W+ZxKgR+s4Kr3m6y6fqWNxsCh7upfcKn8
         4KC2jkERddvzzLE5FwcImtAId5wS24IouAhlc9jZMaUnWl6XBN9Y5ZT3Klw8OJjGsxt6
         tYyGXFFbQmsjwsMyJKmixt8EwKcnrFaKL3Z0F7Jk6LIJl1mS1OWWXBogENhNC7vDnO9w
         rnzrHneAvhd7S1jFegeFr1qegNYAxj1Lyq1nq4YEflo6wFEcv4twzDZKAPE06Ovlka+r
         xsbhbVQz1j7Boo+I5LIc46SJVMMsBJWaZrzd+LcVg+qKQm+C4GiK50WTix1NI0BKP8GH
         KFJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773675936; x=1774280736;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjQ4FVy9JCH1w+FkKGRcPmGlKqhYdcMwmxgAQQjsIZ0=;
        b=n8SoxX/zSJ0qXEkyuqv8KygxFRgjc3Evoa4ningPd3fb1eIkzQomIRQVKJYbxq7z0j
         wx2Xa/auqoAjAnlbfHbEa0pZHeHXp77FhgQD+R4EdG6TlZdc7gCFNhRJF8m+RnANFiiA
         TGq84shdeFg/BLgQ8XYMjNnjC7XK4CDdVY2YK8RQX0OSegA662kqY20G7lIkyVOYMIXw
         v8GP6a+ctesPYL03I9t3mgciyDBD8A82emOjbPFDjsdd0CpIUBCQvqVQPlmQb2Y+Zj4X
         oZARCcqDB1bmnewiXmhtvQWxxeUsU/vJ+9t5SfZSF6Iv7hF960znkDcX8OeC0SZAKWio
         At2Q==
X-Gm-Message-State: AOJu0YwVEo+g8zoOmTNZvjUyfVEWlpuuyxB84bUIw6HCoYq+yufCS1uv
	wi80xOyjU5hHQb/KKs0chXaFvWEs6PokKwqW4CHKIFCHloI1w86MzikmMOxNdydZpGiLF2cw3Fx
	ah6lRUtHU33lLhFASlXkdkCoOVN26bLAY645SRZmrj4G4jTL5ZsYRUQ1dN9p+jTrRuQZxuxI//M
	a0Xr5iKO9WSQI5ilyMxLKYBH0lxHaoT9TA43sHR7lMjvpyO2CH
X-Gm-Gg: ATEYQzyCwNm3rMd8TIUL5lgxIZJyrehfkY7YfsoLajsEVg9clRRBSOC6choc8j/tw4k
	HsNkGM1YCOifgdGTYyxWGPxqo17Kk5XFcsZ7sznocW9V3Ff1iRN3jBJMmYr4bFk1Hu7rTWE1KbE
	E0Jo9ZOA0mgIkJcUWcOmsvIWaBvfM9+I4MrzTdgMoC1t9n4sHFonY3GPXUIR3zINK6KTxT49Ycp
	AN2u7Z97h0QVF3YRTQ6CIaoD8qjRS2acSOpi2bGOvQwqzTv43NB+xTpedCaydYL/xmr53hUkqui
	C4Pb/Q==
X-Received: by 2002:a2e:b165:0:b0:38a:523a:7fdc with SMTP id 38308e7fff4ca-38a89815630mr37014341fa.34.1773675936007;
        Mon, 16 Mar 2026 08:45:36 -0700 (PDT)
X-Received: by 2002:a2e:b165:0:b0:38a:523a:7fdc with SMTP id
 38308e7fff4ca-38a89815630mr37014181fa.34.1773675935508; Mon, 16 Mar 2026
 08:45:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
From: Xiao Ni <xni@redhat.com>
Date: Mon, 16 Mar 2026 23:45:23 +0800
X-Gm-Features: AaiRm53c4_xoMPz8mxuh1DawVaoUJY555TmrPLcKB7ipg4ebjKR2-lP71BXxqwU
Message-ID: <CALTww2_2pjjOSsVj-WT++m35555CjnPWokU7fut+HwUJVV-=ZQ@mail.gmail.com>
Subject: Release mdadm-4.6
To: linux-raid <linux-raid@vger.kernel.org>
Cc: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>, Nigel Croxon <ncroxon@redhat.com>, 
	Mariusz Tkaczyk <mtkaczyk@kernel.org>, Martin Wilck <martin.wilck@suse.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Hi all

I'm glad to announce mdadm-4.5. It is published to both remotes
(github and kernel.org). Here are some highlights from CHANGELOG.md.

# Release [mdadm-4.6](https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/=
log/?h=3Dmdadm-4.6)

Features:
- Add support for new lockless bitmap from Yu Kuai
- Add "PROBING ddf_extended" option in mdadm.conf from Martin Wilck
- Add --detail to usage in ReadMe from Brian Matheson

Fixes:
- Fix uuid endianness mismatch issue in sysfs_rules_apply() from Abirami090=
4
- Fix mdcheck: don't stop mdcheck_continue.timer from Martin Wilck
- Deal with hot-unplugged devices in platform-intel from Jean Delvare
- Detect corosync and libdlm via pkg-config in Makefile from Maxin John
- Fix UEFI backward compatibility for RAID10D4 in imsm from Blazej Kucman
- Optimize DDF header search using mmap for better performance from lilinzh=
e
- Set sysfs name after assembling imsm array in incremental from Xiao Ni
- Use creation_time for ctime in imsm container info from Xiao Ni
- Fix sigterm variable to be volatile sig_atomic_t from Cristian Rodr=C3=AD=
guez
- Use 64-bit off_t across both musl and glibc from Ankur Tyagi
- Fix format overflow error in super-intel.c from Martin Wilck
- Fix compilation errors for unused variables with GCC 16 from Martin Wilck
- Load md_mod first to avoid module loading issues from Xiao Ni

There are some important issues which led to boot failure. These issues
have been fixed recently. It's better to make a new release. So users
can choose a version without these problems.
https://github.com/md-raid-utilities/mdadm/issues/249 has the details.

Best Regards
Xiao

