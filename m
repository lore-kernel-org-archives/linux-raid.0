Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBD4F2DC783
	for <linux-raid@vger.kernel.org>; Mon, 15 Sep 2025 00:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757897688; cv=none; b=kXps2PSoDWZ6nIeNuQ5vE9mAoYe9VuEiuGK7vK6eh5/7YrawPxHDq/ceuqaBFX3FMezNS1PjTinAsS0I2aYUu+oQPsFdG5L4CTtdCZJEdjApsxQBLOaXacw7kLHOssMSTuKnKsmUfXhBhIwIX39k/k4D7b+CbMzMKC1YrlLb9HM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757897688; c=relaxed/simple;
	bh=2H+jg+10yOReIONF0RMG5Zf0e6olHrDjMqOX7e84mkw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S7sVVL1kXPCd3pgdDi50zP6iTI9f9i+4JaMqAz+k+LQDZSgsk3yKPmPcinI95e8hHx20SM0siJfgR9eHYVYPjAKlfh1fNF3m6YqckXd35UISIvQkkFtONNqfAoVW4DQxnj4BK+b1UOl+fyKpPUgTX2sxu/Q88cmTg5Ge1UVzvYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=SZFNiRin; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="SZFNiRin"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1757897686;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2CXqzW/FBI73vI3HLsKDczhoYjriIGW4EosjELG0hxY=;
	b=SZFNiRinLCEZeSQNWVEF/21Cp6xzCw0maZ6zhgHxmaXnkQzJvt2ud1iK6eFRMj1cvbi20V
	ZFA0cdnQcOGIvOKUnqZuLauITUVlwEAYB2cyEcTvDGKTfV/UOzjmo00xq2qbCCCdC/3EBO
	PA+h6N6Bmy6suwNMOHhBB6d5mfPb/tY=
Received: from mail-lf1-f70.google.com (mail-lf1-f70.google.com
 [209.85.167.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-548-OyN3E7pnPZWAkjM1tzTx9g-1; Sun, 14 Sep 2025 20:54:44 -0400
X-MC-Unique: OyN3E7pnPZWAkjM1tzTx9g-1
X-Mimecast-MFC-AGG-ID: OyN3E7pnPZWAkjM1tzTx9g_1757897683
Received: by mail-lf1-f70.google.com with SMTP id 2adb3069b0e04-571c4a20da8so1998958e87.1
        for <linux-raid@vger.kernel.org>; Sun, 14 Sep 2025 17:54:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757897683; x=1758502483;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2CXqzW/FBI73vI3HLsKDczhoYjriIGW4EosjELG0hxY=;
        b=Xf3OmQVevWTJb57WGqzBuSTvbu6/B4gV5YwsstaVvIvRdiVnqdtNSvYEiPvyv6CR/u
         mPUsViD4DV5qDPrVr1yZg4x2ELqa4c6ASS46gGPZIBuTr5zjpjwf6oOw2K1zYl6i/vwS
         jP1ienO48G0lMN7yE3MXgQa5jizwF9XvNMnw9kTJGDVLnxHwvh78NbEEaRNsRl1MyJXo
         5fVajCziulDd14+1VzkM+InFNRJvjLEqXAXv0+Gko5447C3efdAnTUFaaM46zndt1WWS
         1SQGVhpRnftJQ38o6fyBkPy8NsqBaOyn05fjrPBa5PR9TFeddBWwIDnYH/e2+5hSRQDV
         XvaQ==
X-Forwarded-Encrypted: i=1; AJvYcCV/XLh9jloLaD8awT6v+6FFIFtVD6mXqLUckfEXqirr3MPdyguESw1/3MphMjEbzPTfFEFy3nvzeK5J@vger.kernel.org
X-Gm-Message-State: AOJu0YyhRTKGMJ8uNaC5wy0cpbDPpUDswsjZKyNfyEEheqenCeepb2li
	Thgfre59SDRMyyVzG3ZmMKpeiVw68qVSdeWOo/ueb6X/3N4h8TZ8rvZACA0i8FWtSBjuRlyXDYi
	/9nORNyNrPAc7o/qTifrQoofRRvhulpSPKSg6oioaD8rKEUKKMlRB9M/7QfBAlV5w04yddnwyXG
	DwL5DI57dOgfOeeIoMwCudzvFM1n7nXlv1pV01GQ==
X-Gm-Gg: ASbGncsxHHIe1PHvWuCtm6Jfp2Sl+BKcwfm7D5egY622tjNLNU2opxogvFokFK1DyRG
	VOzf+3hJk/OG0CRflfEmuZ3Djj2GxbaIYSZCAunhUAIY4x/swrB9GCQmtkLXXx7P+VYsjw+avuf
	2QkWfc2Mcsdut98eSqN3ZGbQ==
X-Received: by 2002:a05:6512:20d8:b0:55b:842d:5828 with SMTP id 2adb3069b0e04-5704fb86ba0mr2606648e87.36.1757897682754;
        Sun, 14 Sep 2025 17:54:42 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHmz6qX/jdgjuZjb9iigYOR3iF1HIoJJDW/HijhqS6l6O8YRkkUSWIwVUfmx9+d4T8r4V2QgzQWCc5ohXHRnKM=
X-Received: by 2002:a05:6512:20d8:b0:55b:842d:5828 with SMTP id
 2adb3069b0e04-5704fb86ba0mr2606642e87.36.1757897682325; Sun, 14 Sep 2025
 17:54:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250912153352.66999-1-mwilck@suse.com>
In-Reply-To: <20250912153352.66999-1-mwilck@suse.com>
From: Xiao Ni <xni@redhat.com>
Date: Mon, 15 Sep 2025 08:54:29 +0800
X-Gm-Features: Ac12FXxczwZ_ST1Gna3IIF6jxIWOsp_s7e7TEWtvNYPKsLMVJlTN-V1dv-SRG60
Message-ID: <CALTww2_yJADqiLsS2dMdfA8pcJyYK3-rCfkrmHRSFhx3vzwnTg@mail.gmail.com>
Subject: Re: [PATCH 0/4] mdadm: rework mdcheck systemd service logic
To: Martin Wilck <martin.wilck@suse.com>
Cc: Mariusz Tkaczyk <mtkaczyk@kernel.org>, linux-raid@vger.kernel.org, 
	Yu Kuai <yukuai@kernel.org>, Nigel Croxon <ncroxon@redhat.com>, Li Nan <linan122@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Sep 12, 2025 at 11:34=E2=80=AFPM Martin Wilck <martin.wilck@suse.co=
m> wrote:
>
> This Patch set changes the logic of the "mdcheck" tool and the related sy=
stemd
> services mdcheck_start.service and mdcheck_continue.service.
> The set and related discussion are also posted as GitHub PR [1].
>
> The set is meant to be applied on top of PR#189 [2], which has already be=
en
> merged in the current main branch on GitHub.
>
> [1] https://github.com/md-raid-utilities/mdadm/pull/190
> [2] https://github.com/md-raid-utilities/mdadm/pull/189
>
> The current behavior is like this:
>
> * mdcheck without arguments starts a RAID check on all arrays on the syst=
em,
>   starting at position 0. This is started from mdcheck_start.service,
>   started by a systemd timer once a month.
> * mdcheck --continue looks for files /var/lib/mdcheck/MD_UUID_$UUID, read=
s the
>   start position from them, and starts a check from that position on the =
array
>   with the respective UUID. This is started from a systemd timer every ni=
ght.
>
> In either case, mdcheck won't do anything if the kernel is already runnin=
g a
> sync_action on a given array. The check runs for a given period of time
> (default 6h) and saves the last position in the MD_UUID file, to be taken=
 up
> when mdcheck --continue is called next time. When the entire array has be=
en
> checked, the MD_UUID_ file is deleted. When all checks are finished,
> mdcheck_continue.timer is stopped, to be restarted when mdcheck_start.tim=
er
> expires next time.
>
> Before the recent commit 8aa4ea9 ("systemd: start mdcheck_continue.timer
> before mdcheck_start.timer"), this could lead to a race condition when th=
e
> check for a given array didn't complete throughout the month.
> mdcheck_start.service would start and reset the check position to 0
> before mdcheck_continue.service could pick up at the last saved
> position. Commit 8aa4ea9 works around this by starting
> mdcheck_continue.service a few minutes before mdcheck_start.timer.

Hi Martin

The race condition is caused by the faulty modification by admin.
commit 8aa4ea9 ("systemd: start mdcheck_continue.timer before
mdcheck_start.timer") already fixes the problem that an array should
continue to do the check if it doesn't finish checking in one month.
The admin changes the timer sequence back again, it's a faulty action.
We can add a warning comment in the timer service file to avoid such a
race.

>
> Yet the general problem still exists: both services trigger checks on the
> kernel's part which they can only passively monitor. So if a user plays w=
ith
> the timer settings (which he is in his rights to do), another similar rac=
e
> might happen.

diff --git a/misc/mdcheck b/misc/mdcheck
index 398a1ea607ca..7d1d79f795f0 100644
--- a/misc/mdcheck
+++ b/misc/mdcheck
@@ -116,7 +116,7 @@ do
        mdadm --detail --export "$dev" | grep '^MD_UUID=3D' > $tmp || conti=
nue
        source $tmp
        fl=3D"/var/lib/mdcheck/MD_UUID_$MD_UUID"
-       if [ -z "$cont" ]
+       if [ -z "$cont" -a ! -f "$fl" ]
        then
                start=3D0
                logger -p daemon.info mdcheck start checking $dev

How about this? The start action checks the UUID file. So the check
will continue if it doesn't finish in one month.

Best Regards
Xiao
>
> This patch set changes the behavior as follows:
>
> Only mdcheck_continue.service actually starts and stops kernel-based sync
> actions. This service will continue at the saved start position if an MD_=
UUID*
> file exists, or start a new check at position 0 otherwise. Starting at 0 =
can
> be inhibited by creating a file /var/lib/mdcheck/Checked_$UUID. These fil=
es
> will be created by mdcheck when it finishes checking a given array. Thus
> future invocations of mdcheck_continue.service will not restart the check=
 on
> this array.
>
> mdcheck_start.service runs mdcheck --restart, which simply removes all
> Checked_* markers from /var/lib/mdcheck, so that the next invocation of
> mdcheck_continue.service will start new checks on all arrays which don't =
have
> already running checks.
>
> The general behavior of the systemd timers and services is like before, b=
ut
> the mentioned race condition is avoided, even if the user modifies the ti=
mer
> settings arbitrarily.
>
> This set slightly changes the behavior of the mdcheck script. Without
> --continue, it will still start checks on all array, but unlike before it=
 will
> skip arrays for with a Checked_ marker exists. To avoid that, run mdcheck
> --restart before mdcheck.
>
> More details in the commit description of the patch "mdcheck: simplify st=
art /
> continue logic and add "--restart" logic".
>
> Martin Wilck (4):
>   mdcheck: loop over sync_action files in sysfs
>   mdcheck: replace deprecated "$[cnt+1]" syntax
>   mdcheck: simplify start / continue logic and add "--restart" logic
>   mdcheck: log to stderr from systemd units
>
>  misc/mdcheck                     | 105 ++++++++++++++++++++-----------
>  systemd/mdcheck_continue.service |   6 +-
>  systemd/mdcheck_start.service    |   3 +-
>  systemd/mdcheck_start.timer      |   2 +-
>  4 files changed, 75 insertions(+), 41 deletions(-)
>
> --
> 2.51.0
>

