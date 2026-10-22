Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.127.231.20
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792640058;
	b=24F+oPWhfXNmmceoKBTAHbkc2yZ7WED4GXTyKRtL3NML8o/W1N9wRzd+E4i9+YsxoIgV
	 5BuMdVZ45PkK+5jzQykjGaybD3j+rwVPjucFHZbCGCXbr6QsnDxOv5gmD4+VklldYbkKg
	 74q7dovUnUaLlRmRYYAr248QZX4Blde1DmTGjNYmVJC7yF17XaqE2whvqcrcmdg6vMQmK
	 dLoHXFSwExSfaEtsVjWWKkf2uOmVKJsJv2rRwlkhRZjEkwx4k3R8VZVpRQjKg7Cq6GDEu
	 I2OqzK1v8MN12Z6Yt1VJTMr/XSH1jT/UtKu++vLXG0ZVAXK+C8eeIcK89j3vkX6FUTw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792640058;
	h=DMARC-Filter:DKIM-Signature:In-Reply-To:X-Original-From:To:From:
	 Message-Id:X-Lms-Return-Path:Date:Content-Transfer-Encoding:Received:
	 Cc:Mime-Version:Content-Type:References:Reply-To:Subject:User-Agent;
	bh=yD0b3S9s+1o6zBqSgF7q03eIOb1HjjlnNNtuiDAFCiA=;
	b=Ib6AabW+W2bl1W/cH+drvkZGrdanbMkeDgKRUXW9odbcTiUtblBy3aWOGv2FLhOxdioq
	 Ds2ljYTdTzVkbkG6smcz4NxMPyR0Jku1K2i3VkuJE/UmjjyeMitk1d1ceBA+HBqJLz7ca
	 btiKBvi0S4SpMcFMg8FBrjJQfBe0O7KUYGQXyvYDYlcDC+tdtMFmCYz1a0q49MFhQvxZu
	 E1ariWV7Z+oN4hyHXNFIZj98+ue6r0PwRtd1Re2H3rTW6m2FBL/LZaBEueS4TgvDUmXN2
	 Y6oMSR2uxHuJ8ffZ3jWp4Mg0EUDFu8UFH1PLg4xBw/LRj6Wz9w9IbUJoN3C1S2rxYzA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=fygo.io;
	spf=pass smtp.mailfrom=fygo.io;
	dkim=pass header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=mtHWUDrS;
	arc=none smtp.remote-ip=209.127.231.20
Received: from va-2-20.ptr.blmpb.com (va-2-20.ptr.blmpb.com [209.127.231.20])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 560C2606A320
	for <linux-raid@vger.kernel.org>; Thu, 22 Oct 2026 03:34:17 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 560C2606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.a=rsa-sha256 header.s=s1 header.b=mtHWUDrS
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1792640045;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=yD0b3S9s+1o6zBqSgF7q03eIOb1HjjlnNNtuiDAFCiA=;
 b=mtHWUDrSISvFXXMXgoDTPwfRdQXiRx0vDp+kyWuPyQFG3WPGBE/OTEk5fQEJBY2cKd3lKd
 tHaU4pJipK/rLHMRJGQZbTLMJBRba99qFdzYOfOUFIq0dEJ8MwEojIYfq2VV+exyl2HPCV
 RBDfnJx47iISYkcXoGoAMOdwZmqHrpP/TYpFOwkXky0siZ3lXWTNTkQMHYK9jXI6kFLyxY
 f9l5YuTxopftCILNH8pJKMcpTRybQ5jJTD11eTWjQa80ZWlwZm41opcj3QCRY9cLIvAm8o
 6DOQSLg55JKqlDBiMY+X5RjI6jb6QQjxCGeuLjFhAjQY35aqnU/U3mfThiZ/sQ==
In-Reply-To: <20260923124634.5497-1-aadityakansal390@gmail.com>
X-Original-From: yu kuai <yukuai@fygo.io>
To: "Aaditya Kansal" <aadityakansal390@gmail.com>, 
	"Song Liu" <song@kernel.org>, "yu kuai" <yukuai@fygo.io>
From: "yu kuai" <yukuai@fygo.io>
Message-Id: <e743762c-2ed0-465b-bfa1-57e75aabf034@fygo.io>
X-Lms-Return-Path: <lba+26ad98423+dce483+vger.kernel.org+yukuai@fygo.io>
Date: Thu, 22 Oct 2026 11:33:51 +0800
Content-Transfer-Encoding: quoted-printable
Received: from [192.168.1.104] ([39.182.0.21]) by smtp.larksuite.com with ESMTPS; Thu, 22 Oct 2026 03:33:54 +0000
Cc: "Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	<linux-raid@vger.kernel.org>, 
	<syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com>
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Post: <mailto:linux-raid@vger.kernel.org>
List-Help: <mailto:linux-raid+help@vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-raid+owner@vger.kernel.org>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20260923124634.5497-1-aadityakansal390@gmail.com>
Reply-To: yukuai@fygo.io
Subject: Re: [PATCH v2] md: fix out-of-bound by adding checks at store
User-Agent: Mozilla Thunderbird

Hi,

=E5=9C=A8 2026/9/23 20:46, Aaditya Kansal =E5=86=99=E9=81=93:
> syzbot reported array-index-out-of-bounds in super_90_sync()
>      UBSAN: array-index-out-of-bounds in drivers/md/md.c:1697:17
>      index 124 is out of range for type 'mdp_disk_t [27]'
>      CPU: 1 UID: 0 PID: 10197 Comm: syz.3.1362 Tainted: G    L
>      syzkaller #0 PREEMPT(full)
>      Tainted: [L]=3DSOFTLOCKUP
>      Hardware name: Google Google Compute Engine/Google Compute Engine,
>      BIOS Google 08/05/2026
>      Call Trace:
>       <TASK>
>       __dump_stack lib/dump_stack.c:94 [inline]
>       dump_stack_lvl+0x100/0x190 lib/dump_stack.c:120
>       ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>       __ubsan_handle_out_of_bounds+0xcc/0xf0 lib/ubsan.c:455
>       super_90_sync+0x1eed/0x1ff0 drivers/md/md.c:1697
>   ...
>
> super_90_sync() exists for older version 0.90, which supports up to 27
> maximum disks (MD_SB_DISKS). This function doesn't contain any bound chec=
ks
> for raid disks. The repro wrote higher value (124) in raid_disks sysfs
> attribute to trigger this bug.
>
> The repro is one configuration that triggers this bug, which is caused by
> the lack of proper checks at sysfs stores. Store is one path to reach
> OOB.
>
> Add helper function md_check_disks_fit_metadata() and call it at
> raid_disks_store() and metadata_store() to reject the write for
> mismatched configuration (raid_disks > MD_SB_DISKS for major =3D=3D 0). T=
his
> prevents invalid configuration via stores from reaching the super_90_sync
> function.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Reported-by: syzbot+9e3014263a35700ab49b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D9e3014263a35700ab49b
> Signed-off-by: Aaditya Kansal <aadityakansal390@gmail.com>
> ---
> v2:
> - moved the fix from super_90_sync() to a level above at store functions
> - add checks at stores themselves to prevent wrong configuration from
>    reaching the target function
> - add helper function to be called at all the sites where check is
>    required
>
>   drivers/md/md.c | 23 ++++++++++++++++++++++-
>   1 file changed, 22 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 680b34a63cb3..f0f693f6bf7c 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -1354,6 +1354,13 @@ int md_check_no_bitmap(struct mddev *mddev)
>   }
>   EXPORT_SYMBOL(md_check_no_bitmap);
>
> +static int md_check_disks_fit_metadata(int major, int raid_disks)
> +{
> +	if (major =3D=3D 0 && raid_disks > MD_SB_DISKS)

Just checking major =3D=3D 0 is not enough, external metadata should be exc=
luded,
and all possible cases should be listed and checked, as I'm not sure if the=
re are
other cases for now.

> +		return -EINVAL;
> +	return 0;
> +}
> +
>   /*
>    * load_super for 0.90.0
>    */
> @@ -4448,8 +4455,15 @@ raid_disks_store(struct mddev *mddev, const char *=
buf, size_t len)
>   		mddev->delta_disks =3D n - olddisks;
>   		mddev->raid_disks =3D n;
>   		mddev->reshape_backwards =3D (mddev->delta_disks < 0);
> -	} else
> +	} else {
> +		err =3D md_check_disks_fit_metadata(mddev->major_version, n);
> +		if (err) {
> +			pr_warn("md: raid disks (%d) exceeds max disks (%d) for metadata vers=
ion 0.90",
> +					n, MD_SB_DISKS);
> +			goto out_unlock;
> +		}
>   		mddev->raid_disks =3D n;
> +	}
>   out_unlock:
>   	memalloc_noio_restore(noio_flags);
>   	mddev_unlock_and_resume(mddev);
> @@ -5041,6 +5055,13 @@ metadata_store(struct mddev *mddev, const char *bu=
f, size_t len)
>   	err =3D -ENOENT;
>   	if (major >=3D ARRAY_SIZE(super_types) || super_types[major].name =3D=
=3D NULL)
>   		goto out_unlock;
> +
> +	err =3D md_check_disks_fit_metadata(major, mddev->raid_disks);
> +	if (err) {
> +		pr_warn("md: metadata version 0.90 doesn't support raid disks count hi=
gher than %d",
> +				MD_SB_DISKS);
> +		goto out_unlock;
> +	}
>   	mddev->major_version =3D major;
>   	mddev->minor_version =3D minor;
>   	mddev->persistent =3D 1;
> --
> 2.55.0

--=20
Thanks,
Kuai
