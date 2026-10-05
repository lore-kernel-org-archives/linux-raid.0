Received: from mail-ej2-f40.google.com (mail-ej2-f40.google.com [74.125.228.168])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2B14274658
	for <linux-raid@vger.kernel.org>; Mon,  5 Oct 2026 04:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.228.168
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791176291; cv=pass; b=Ew9f+EUeTHfdB//zIj5x2qCpGv7BEL897cQ3cqb4P6Yfnc9bk8cgtDBfB7kWKft1RxAIq7Xl5RNDqPq8/7o6D7PJ+kLWiipRX92Wze/0L0TA/IiHgW98uwM9SyUrY8LABbI4lmL5dsNkzy5nowvnR7PoUuxM+Arz6frOLocpaQM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791176291; c=relaxed/simple;
	bh=k8QhU0CgxteoVSnG2ChBJ+4Z+ni9b7jo7/wYqwD+m1A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tu4bWHXq2YhHoGNyeUu1WCK2zZKYmyilz6JtscY8Lp5N2uAYZuXww39BPd4JRWAtZPb/QjTG4Ibxv9dU01JiMTrADZL2A10JH7XwfXmrdafP82KdrzF+E09yQmb3xUoYolslZRRi8qNmu7vjK7rTT1xlQDMMgjp4eYSgaai3jrA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com; spf=pass smtp.mailfrom=ionos.com; dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b=HfmeeVb+; arc=pass smtp.client-ip=74.125.228.168
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cloud.ionos.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=ionos.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="HfmeeVb+"
Received: by mail-ej2-f40.google.com with SMTP id a640c23a62f3a-c2e412bc301so8259666b.3
        for <linux-raid@vger.kernel.org>; Sun, 04 Oct 2026 21:58:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791176288; cv=none;
        d=google.com; s=arc-20260327;
        b=sACl2mgjummUQBYgflUPa8EfVFWvSBIFqDXAfwNUJNV69kpSoI5ionm43gcsmmdExr
         R5OoD00MVDbZ7it3NyXXrqTwFyjWZwgbBtunbKcwWyAKWtbMi+FE5Bbf5vkNNz0X8uP6
         UAvtVxjgHS2haJoiQzp+Qd/3zX08KeEdsbxHSWfSOcAxrE+nzQ1i03lH7qwFHn8/o3dz
         gv/VrZZcmNgPL1lyobUqPq+EdDrkoHHeHFI6SH7Vto578kcCSYOBEZtc8hFfdVWKZ1Wz
         ssf4NA4dMULx6Y5sm+vKnOaorMtReSNewwLsMWaSVlPM42bPTRvcaanIadhii55KfOQj
         e7CA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Yb8J5ooNOneYN3yeLjRDUS+cu9SC1W2gX1QlAxi98Ro=;
        fh=hrnHRiAmW1TCGuTRJTiJXDBQa5WhqX3OjIW0R+n+eCM=;
        b=Cn70/RmOBM1Zs4oRjuas1WBSYw+FIxPHegBPYPeEsgBQvy60eGeMkECtqxWAhxg/sx
         sGep5/TvG2mwEwKTn4J/2C7OfwW/OS3C+YjogQwwXxMHQLUJpfajRb+Qhv6iMNlN1whT
         QAP5bYMdZO7Soic4u5qGCsmQgiGECPbqjyOt83kTWGnnc2BgE5vnCEDjNdLbV9fYvk+w
         IfSG1PXBzJkMWZuryyr3oERpIsd0Hp55FdyvZVRayAmb/tTQTVqf2grnhyW9NXb/eOjM
         Ou3kLCXWtw99TVoMYWaM7uyRKAzQ15B/cCviMctRtRXw3N0crSIfsnj/inycbT+eVmeX
         7Elg==;
        darn=vger.kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google; t=1791176288; x=1791781088; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Yb8J5ooNOneYN3yeLjRDUS+cu9SC1W2gX1QlAxi98Ro=;
        b=HfmeeVb+gRHEJT/vobjNzTnfPqgXprm0Qg0J9QuoBDR3Pi0XGT/ff1ZcQT4pe8Zj5B
         sl54pjARAZMooXepwOU1gNjFAKfyWrjZJEas2k7GVxK7jU2j7/4pNrQZ+xaGPrFLqtyP
         baMKr+RNwdZh460yQGNKRO07zOXWptDnUrnexNLl/bwbCpRV0hxuSqWm8JxfWf03rc1s
         XlZLIcRzK0sOuSoW/af7v2R1umZymuw3VD47gA66weSVmsU0Du+huHY9yRX5YMVSoMHc
         a1BxfGWzvgZ0BwNs4W5kZ9ia4giqqMx+lSO255WRvAA6K495WJiRjTQtzVce8LedRL2f
         M9yw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791176288; x=1791781088;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Yb8J5ooNOneYN3yeLjRDUS+cu9SC1W2gX1QlAxi98Ro=;
        b=DanH0xiCBsQmT4m33Nf3/3pplsDBe33lbphjVUDYWy3miqV6iE0PcWIYC1FoIIYob3
         HQBKjduULFDTacRED2BD+yPwOnQfHdy+TPRHt5xMhqgIC5GiY7BCjfa5tzLBRxzFTuhh
         GV8MsbnNBXoMBRKPiq73NCBfSAoPBYgjMs+F2gtv80vLzMN0S2rvXPMIc6WIHLH91eAZ
         T26TRrQak98Or8LaOMF7RFP2nHufpc+WmYn95RB9TWBFdROU+ncnk4Kf0jqZSDd3H/Wr
         3zHfBBUv+jnzu//toKYAhrjKubbzm5B1bQk5q81j9C4Yvq8UFBFoSHJ1ZRE8fnd5o+28
         S0Lg==
X-Forwarded-Encrypted: i=1; AKwUvBwCJGd1mVYrezeF+8ywCw2wnc4GZrwb4fiv0om2OlwfJJvtsh7ONsziRThAsIVZoIPJgpvjJsNB7La4@vger.kernel.org
X-Gm-Message-State: AFuF++lTAypM9PBn4rFXg/CX7VrxfqMyyCbwqN8Ki+1z2YM+37gw+6BC
	qVnsEiVfvVxfbC24DC0pcL25VuBmCnzDsD5oIlxe9GGn8IdbyF2sDT3pNSCp9p6/FpdcC6kgomU
	aUOVDuiZJG5fG2toM35JQ0P7siUd4hmO3uqbqxZjEHA==
X-Gm-Gg: AYBFou1XoQiXss36H8JqDYrRNocjwTpEQ79WxJdwNj/LQFfHBO0PYG0V861q/cNAPEI
	udd7fEfKZNgbjg6i/gawjgI6yeoWvjdRNyxK7gEFshtsLb4WV7xU9k1A/C+9ElaU6k7ioUubujA
	0oDNFAWHdvFTl8A8wSumdKKX8l8EJudYSWJRxK0fDCRBN0sAMUMD03LELECprBGkBRdT1QYyvBB
	YEZ1rXZQrN/YmVAWWyb3sYU3fJb7B2n2PUVInQ4MVOFN4sD6tKTtrgjdOtqTUF+wkqz6hjm8vkS
	TVfMgzCpX4r3J2I1s0ZK+mebC5mI6E80IqFV9uHp7rv8US1/Q4I6WNU=
X-Received: by 2002:a17:907:1ca4:b0:c25:3ec4:9e43 with SMTP id
 a640c23a62f3a-c2e4a7f48b0mr805405466b.0.1791176287731; Sun, 04 Oct 2026
 21:58:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20260920103705.23191-1-jinpu.wang@ionos.com>
In-Reply-To: <20260920103705.23191-1-jinpu.wang@ionos.com>
From: Jinpu Wang <jinpu.wang@cloud.ionos.com>
Date: Mon, 5 Oct 2026 06:57:55 +0200
X-Gm-Features: AclHuK9F6bDW0nS2vy3QRjl6tjhB0B-9YTim3Rc-1xgPDX9Z9hWewK_66u3Qn2w
Message-ID: <CAMGffE=Vz19wLqdECCc3G47oZVRkQ=RuYFzZt8A1m7jxHUeV7A@mail.gmail.com>
Subject: Re: [PATCH] md: fix mddev_unlock() called without holding lock in lbs_store()
To: Song Liu <song@kernel.org>, Yu Kuai <yukuai@fygo.io>
Cc: Li Nan <magiclinan@didiglobal.com>, Xiao Ni <xiao@kernel.org>, 
	linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Sep 20, 2026 at 12:37=E2=80=AFPM Jack Wang <jinpu.wang@ionos.com> w=
rote:
>
> From: Jack Wang <jinpu.wang@cloud.ionos.com>
>
> lbs_store() jumped to the unlock label on mddev_lock() failure,
> calling mddev_unlock() on a mutex that was never acquired. Return
> directly instead.
>
> Fixes: 62ed1b582246 ("md: allow configuring logical block size")
> Signed-off-by: Jack Wang <jinpu.wang@cloud.ionos.com>

ping?
> ---
>  drivers/md/md.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..41fbe5d9961a 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -6048,11 +6048,10 @@ lbs_store(struct mddev *mddev, const char *buf, s=
ize_t len)
>
>         err =3D mddev_lock(mddev);
>         if (err)
> -               goto unlock;
> +               return err;
>
>         err =3D mddev_set_logical_block_size(mddev, lbs);
>
> -unlock:
>         mddev_unlock(mddev);
>         return err ?: len;
>  }
> --
> 2.43.0
>
