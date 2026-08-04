Received: from lf-2-44.ptr.blmpb.com (lf-2-44.ptr.blmpb.com [101.36.218.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA0043815F0
	for <linux-raid@vger.kernel.org>; Tue,  4 Aug 2026 11:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=101.36.218.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785844130; cv=none; b=sXqV+tHLzi4yylXLC5TcfBopE4UppWYBitZLMKhmLQRFYzZDgQmF0DtFxuNCVHnQW8VSJSDLSOWrnMvLsVukSIrLKi//3SODtpsFqOKwmFl9KdzTnAC6CPp1mi73UAQ6SqsvFDU1NhQnvLyKoLJ6kqYh4WticKFYOtNk09CgLMQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785844130; c=relaxed/simple;
	bh=PwfFZYqcQAs0rvCtyY5lFZ8GGd08uXwGJ/cN/kbe0t0=;
	h=From:Subject:Mime-Version:In-Reply-To:To:Cc:Date:Content-Type:
	 Message-Id:References; b=f2azNMKOj89IjcVCyF4jzBsRwqEZ6vu6mRK/mroMeHSivrxfNc7STEfrV35RCJRE6c/igDOzBB1c3HYQsXm6+ficEzVj+L/X1k9kD8+JNK1jeLSPfJhBTf41EGyoyCBKtMAy2my3VYYgOumHK5/ma3DnPQgZDhVPzvAABfpxtTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=eRML9zQe; arc=none smtp.client-ip=101.36.218.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="eRML9zQe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1785844075;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=AQHEzP1XnMJFOCBfUl5/XZvJgDdT8bVDb82e+/Lw9gY=;
 b=eRML9zQeVaLtVzDfd1DWuzB9lilF+TIYjWVEYgz0wxiH5N1lhqVxho337+Qf6+/imURZ0P
 NujozsfZqO2XgrgQMsV4pF5aOlFcBHnG1VdXHUypiuFecQspxH786ChK3hUsE/n4TGLo0W
 ACHv5WKL52GSRW7VC6ehbzdVXEtxP3MJt2ToSJnoH3w6nJjZWJB7sxzd3iRdNmQVkIBCdb
 oqridTJpCDE+X2ELcTMdHS1xhEwIpNjcflw53LZyAGiH0BMCTvNrypkj+tt5p+yVGPj5Lj
 38fiM9c70nivQCMYxS/Z9indieOERjvkLgjURxhqd6sBs+5CMOFZQOO0c6wGmg==
From: "yu kuai" <yukuai@fygo.io>
Subject: Re: [PATCH v2 3/3] md/raid10: skip clean regions in bulk during recovery
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
In-Reply-To: <20260804090110.111062-1-yunye.zhao@linux.alibaba.com>
X-Original-From: yu kuai <yukuai@fygo.io>
Reply-To: yukuai@fygo.io
To: "Yunye Zhao" <yunye.zhao@linux.alibaba.com>, "yu kuai" <yukuai@fygo.io>
Cc: <joseph.qi@linux.alibaba.com>, <linux-kernel@vger.kernel.org>, 
	<linux-raid@vger.kernel.org>, <magiclinan@didiglobal.com>, 
	<sashiko-bot@kernel.org>, <song@kernel.org>, <xiao@kernel.org>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
X-Lms-Return-Path: <lba+26a71d16b+50c9e8+vger.kernel.org+yukuai@fygo.io>
Date: Tue, 4 Aug 2026 19:47:50 +0800
Content-Type: text/plain; charset=UTF-8
Received: from [192.168.1.104] ([39.182.0.181]) by smtp.larksuite.com with ESMTPS; Tue, 04 Aug 2026 11:47:54 +0000
Message-Id: <e22f9816-fb97-49aa-a4d2-b098ccafb654@fygo.io>
References: <67ed4a7f-f250-42e4-8833-662d35a68e75@fygo.io> <20260804090110.111062-1-yunye.zhao@linux.alibaba.com>

Hi,

=E5=9C=A8 2026/8/4 17:01, Yunye Zhao =E5=86=99=E9=81=93:
> Hi Kuai,
>
>> By re-add a disk, this is really a resync, and bitmap can be used in
>> this case to skip clean bits. In this case, I still think the correct
>> solution, for old bitmap, is to let bitmap_start_sync() return much
>> bigger skipped blocks.
> Thanks for the correction.  Just to describe how md currently drives it:
> with no resync pending, md_choose_sync_action() takes the re-added member
> as a spare from remove_and_add_spares(), then clears MD_RECOVERY_SYNC and
> sets MD_RECOVERY_RECOVER (md.c:10151-10163).  md_sync_position() then
> starts the sweep at rdev->recovery_offset (md.c:9557) and
> md_sync_max_sectors() bounds it by mddev->dev_sectors (md.c:9489).  So a
> re-add runs raid10_sync_request()'s recovery branch, in device address
> space, rather than the resync branch.

Yes

>
> md_run() defaults the bitmap/resync space to the device space, and raid10
> is the only personality that overrides it:
>
> 	md_run()  resync_max_sectors =3D mddev->dev_sectors	md.c:6753
> 	raid5     resync_max_sectors =3D mddev->dev_sectors	raid5.c:8090
> 	raid10    resync_max_sectors =3D raid10_size(mddev, 0, 0)	raid10.c:4149
>
> So in the recovery branch sync_blocks is in array sectors while the retur=
n
> value advances a device cursor - for a near layout the two differ by
> raid_disks / near_copies (raid10_find_virt(), raid10.c:699).

I still don't understand why this will avoid you been using skip_sectors re=
turned
from bitmap_start_sync():

For example, a 4 1T disks raid10 with near=3D2, assume re-add a rdev with b=
itmap all
clean, you first pass in sect=3D0 to bitmap_start_sync(), then skip_sectors=
, ideally,
can be set to full array size 2T, then you can map the array 2T back to rde=
v, which
you'll get 1T. Do this in the loop and choose the minimal for all members, =
finally
you can skip 1T at a time.

Check the code, currently raid10 do not map the max_sync, which is RESYNC_P=
AGES, back
to rdev sector, and use it directly. I wonder is this safe for raid10 with =
chunksize less
than RESYNC_PAGES?

>
> If I read you right, you would prefer this fixed on the bitmap side rathe=
r
> than in raid10.c.  For the recovery branch to use the reported span
> directly, that span has to be in the device address space, so md-bitmap.c
> would need the raid10 geometry.  I will look into how that can be
> implemented.

I still don't get why

>
> Thanks,
> Yunye

--=20
Thanks,
Kuai
