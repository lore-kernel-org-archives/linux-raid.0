Received: from va-2-46.ptr.blmpb.com (va-2-46.ptr.blmpb.com [209.127.231.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02E313F1056
	for <linux-raid@vger.kernel.org>; Fri, 18 Sep 2026 09:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789723219; cv=none; b=plUySAnDGzwBotzmG0S9K2Z6+njbtPVoPKabf7oJT7rVmiXm3NRziOxTx7TIeEhfD4QZHy5ztIUQ+RS2bIUIbakJ/4sGhhUoJpIMdeb/NT2orUKdWsqLDbkLpqgFtEuURtLXrnLXdMGlarTnocOXpGTNjijRDc++w/JAVoWtu+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789723219; c=relaxed/simple;
	bh=lVI4wS9/F6uS9qnJB4qvn+MECJkuubYFiWZq6Sw6lrU=;
	h=Cc:From:Date:Content-Type:To:In-Reply-To:Subject:Message-Id:
	 Mime-Version:References; b=Zdn1wox9PSM8yn2uL0FxGt6AFePhepSunJhLuAne+dUncHtbVRq0SeoJVlSnmVpcqd04S4QCTQg1BYZd/dareITLnp9T1RtSjy96rQewQQHB/ryjLfviDmCpMgX0cIp/gI+iy2cBXWRTPMfDGKSOREKDk6YlWAjPmsEY21x3peI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=bwBSdZ1I; arc=none smtp.client-ip=209.127.231.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="bwBSdZ1I"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1789723203;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=c/HoGHos08YYVCDf+erQy3ROLdbEA8DrOr1npGBRCuw=;
 b=bwBSdZ1IC2vZJtJQ/GMrgZtFKRuuaPwCdBnsVuBZK6OAE/8KLo1qyhHqMMucszqIQ+NkQ2
 HU22scbIi4juP7uDQoN2yJO1G9pAH/o3M11JKl8GQa+S1r5Y8BMJwBwEJhOfbqphjVZxdn
 4yJH4AnELbXL5Ej/uTa6zIxHk/LQAYt4GP5OAuLG1IzbfNdiAQ/oxgQ4h14NALYiEW2F81
 ZWkWZwb9JqbvgqODZjDQttxI64Lhn4YXAABcOdUvpIV5upKvcA6VJysv/TxG7WPbSXtXFa
 VdB7sBO5K3nkoNbXDSVcHsd3NaAQP4MUtRi2ofcw3DZ/hzlSesbtohAXVw9SsA==
Cc: "Jens Axboe" <axboe@kernel.dk>, "Josef Bacik" <josef@toxicpanda.com>, 
	"Tejun Heo" <tj@kernel.org>, "Johannes Weiner" <hannes@cmpxchg.org>, 
	=?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	"Jonathan Corbet" <corbet@lwn.net>, 
	"Shuah Khan" <skhan@linuxfoundation.org>, 
	"Randy Dunlap" <rdunlap@infradead.org>, "Coly Li" <colyli@fygo.io>, 
	"Kent Overstreet" <kent.overstreet@linux.dev>, 
	"Alasdair Kergon" <agk@redhat.com>, "Mike Snitzer" <snitzer@kernel.org>, 
	"Mikulas Patocka" <mpatocka@redhat.com>, 
	"Benjamin Marzinski" <bmarzins@redhat.com>, "Song Liu" <song@kernel.org>, 
	"Li Nan" <magiclinan@didiglobal.com>, "Xiao Ni" <xiao@kernel.org>, 
	"Andreas Gruenbacher" <agruenba@redhat.com>, 
	"Matthew Wilcox" <willy@infradead.org>, "Jan Kara" <jack@suse.cz>, 
	"Andrew Morton" <akpm@linux-foundation.org>, 
	"Chris Li" <chrisl@kernel.org>, "Kairui Song" <kasong@tencent.com>, 
	"Kemeng Shi" <shikemeng@huaweicloud.com>, 
	"Nhat Pham" <nphamcs@gmail.com>, "Baoquan He" <baoquan.he@linux.dev>, 
	"Barry Song" <baohua@kernel.org>, 
	"Youngjun Park" <youngjun.park@lge.com>, 
	"Nathan Chancellor" <nathan@kernel.org>, 
	"Nick Desaulniers" <ndesaulniers@google.com>, 
	"Bill Wendling" <morbo@google.com>, 
	"Justin Stitt" <justinstitt@google.com>, 
	"Nilay Shroff" <nilay@linux.ibm.com>, "Tao Cui" <cuitao@kylinos.cn>, 
	<linux-block@vger.kernel.org>, <cgroups@vger.kernel.org>, 
	<linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>, 
	<linux-bcache@vger.kernel.org>, <dm-devel@lists.linux.dev>, 
	<linux-raid@vger.kernel.org>, <gfs2@lists.linux.dev>, 
	<linux-fsdevel@vger.kernel.org>, <linux-mm@kvack.org>, 
	<llvm@lists.linux.dev>
From: "yu kuai" <yukuai@fygo.io>
Date: Fri, 18 Sep 2026 17:19:53 +0800
X-Original-From: yu kuai <yukuai@fygo.io>
X-Lms-Return-Path: <lba+26aad0242+12f7a7+vger.kernel.org+yukuai@fygo.io>
User-Agent: Mozilla Thunderbird
Reply-To: yukuai@fygo.io
Received: from [192.168.1.104] ([39.182.0.142]) by smtp.larksuite.com with ESMTPS; Fri, 18 Sep 2026 09:20:01 +0000
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
To: "Christoph Hellwig" <hch@lst.de>, "yu kuai" <yukuai@fygo.io>
In-Reply-To: <20260918071634.GA10884@lst.de>
Subject: Re: dm review needed, was: Re: [PATCH v3 2/3] blk-cgroup: store blkcg in bio instead of blkg
Message-Id: <daf4ba77-4c25-4993-900d-ee1fe713d9b6@fygo.io>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
References: <20260918041744.1526924-1-yukuai@kernel.org> <20260918041744.1526924-3-yukuai@kernel.org> <20260918071634.GA10884@lst.de>

Hi,

=E5=9C=A8 2026/9/18 15:16, Christoph Hellwig =E5=86=99=E9=81=93:
> On Fri, Sep 18, 2026 at 12:17:43PM +0800, Yu Kuai wrote:
>>   static inline void dm_bio_record(struct dm_bio_details *bd, struct bio=
 *bio)
>>   {
>>   	bd->bi_bdev =3D bio->bi_bdev;
>> -	bd->bi_flags =3D bio->bi_flags;
>> +	/*
>> +	 * Restoring BIO_BLKG_REF would not recreate its associated reference.
>> +	 */
>> +	bd->bi_flags =3D bio->bi_flags & ~(1U << BIO_BLKG_REF);
> But do we need to restore the reference?  I have to admit that
> this surrounding code is very confusing and I would really like
> to have the dm maintainers look over it.

dm_bio_record() will store the bi_flags for current bio, later the flag is =
restored
by dm_bio_restore(). For example like dm-raid1 read error path:

issue path, if blk-throttle is enabled, flag can be set before bio issuing =
to dm-raid1

mirror_map
  dm_bio_record
   bd->bi_flags =3D bio->bi_flags
   // contain the new flag

bio_endio
  bio_clear_blkcg
  // new flag is cleared
  clone_endio
   mirror_end_io
   // if this IO failed and there is another mirror to read
    dm_bio_restore
     bio->bi_flags =3D bd->bi_flags
     // new flag is set without get a blkg reference

So I think we don't need to restore the reference, BTW, there is another ap=
proach to
avoid such problem in blk-throttle I don't take for now:

For bio entering blk-throttle, we can clear the new flag and blkg reference=
 directly
after the bio is throttled and before this bio is issuing to disk, because =
bio will
not enter blk-throttle in the completion path. And since blk-throttle is th=
e only rq_qos
policy that can be enabled for bio-based disk, then dm_bio_record() will ne=
ver see a
bio with the new flag set.

--=20
Thanks,
Kuai
