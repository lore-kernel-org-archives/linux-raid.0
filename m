Received: from va-2-56.ptr.blmpb.com (va-2-56.ptr.blmpb.com [209.127.231.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC10327F19F
	for <linux-raid@vger.kernel.org>; Tue,  2 Jun 2026 03:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780371681; cv=none; b=J8n/1zOD5TYo2LD7L3sZz+9LASBd2M0ZhPQ3uUEz/VzIeFnXjlNDxEbWOn8bFPbAlUyrnh0RGiQTDKffuhg+Mcaf6AFdgcyyV5zhdPC8Pk/3RAhJDiBwieeaK3LZ2RMmR5MqG7nvFB/LG5xGzBJpR3WNdxaq4W3r17omp69lKW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780371681; c=relaxed/simple;
	bh=TYbTK+1pZKxSIOHaFVEQ0H0lKRBtMbTz3gFI+nBSXig=;
	h=To:Mime-Version:From:Subject:Date:Cc:Message-Id:Content-Type:
	 In-Reply-To:References; b=JsHV0gJCKjIhSmW+W3LRh8VwSSlgyPWuIr2QM6PMAXMdz90x9Y74MH3e1PUJ2uWbJ4jHJvoqUGHImhPUoXczLctEhTMxxJMRsVLixFT31wkHci17KINVV7ndPZ8MuHa7iIeCtl6ZzSbG/uWzHR6PsFZgtY3j8egycAOEWlomTQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io; spf=pass smtp.mailfrom=fygo.io; dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b=CuXbA23L; arc=none smtp.client-ip=209.127.231.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=fygo.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fygo.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fygo-io.20200929.dkim.larksuite.com header.i=@fygo-io.20200929.dkim.larksuite.com header.b="CuXbA23L"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fygo-io.20200929.dkim.larksuite.com; t=1780371667;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=TYbTK+1pZKxSIOHaFVEQ0H0lKRBtMbTz3gFI+nBSXig=;
 b=CuXbA23Lo711oK9Irg1+ckVhiECd+m9hb+/7l5ELnsCa2kJ5EK/OgE4pvIerp9HuGSkYHk
 Xf1VfyIP16se8NT2QjaRuI8W8FpKVJ9A5Jv+n5syScs68ML4mOgruF3ie5lW/Et3rjg+XB
 Zutuh/wnQzNEPNAzxG0aJXLbfXJRYqueXRFBqwTHVr9t3mFmZwjfv5rdg+kMpf5YwwNx2d
 KVuHf5hd/j7C1WzV2cczIO4Kah/QDl0tv72tfkPx0Fb3j8ukq9ltWSmQSiLtgRcPAGvJ+7
 Pr1yR+1Xwvm0e61YIeN+VMkgn25+bK5aDeG/YCoRZ8HvslZj0WkRudOFpPhOfQ==
To: "Jens Axboe" <axboe@kernel.dk>
Received: from smtpclient.apple ([120.245.64.106]) by smtp.larksuite.com with ESMTPS; Tue, 02 Jun 2026 03:41:06 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
From: "Coly Li" <colyli@fygo.io>
Subject: Re: [GIT PULL] md-7.2-20260531
Date: Tue, 2 Jun 2026 11:40:53 +0800
X-Mailer: Apple Mail (2.3864.600.51.1.1)
Cc: "Yu Kuai" <yukuai@fygo.io>, <linux-raid@vger.kernel.org>, 
	<linux-block@vger.kernel.org>, 
	"linux-bcache" <linux-bcache@vger.kernel.org>
Message-Id: <74048F79-FAD4-4C63-A885-31467EA60530@fygo.io>
Content-Type: text/plain; charset=UTF-8
X-Original-From: Coly Li <colyli@fygo.io>
X-Lms-Return-Path: <lba+26a1e50d2+0d729a+vger.kernel.org+colyli@fygo.io>
In-Reply-To: <753dfdb4-7d68-4183-af3f-d51e92d4dd31@kernel.dk>
References: <20260531112618.160409-1-yukuai@fygo.io> <753dfdb4-7d68-4183-af3f-d51e92d4dd31@kernel.dk>

Hi Jens,

> 2026=E5=B9=B46=E6=9C=882=E6=97=A5 02:55=EF=BC=8CJens Axboe <axboe@kernel.=
dk> =E5=86=99=E9=81=93=EF=BC=9A
>=20
> On 5/31/26 5:26 AM, Yu Kuai wrote:
>> Hi Jens,
>>=20
>> Please consider pulling the following changes into your for-7.2/block
>> branch.
>>=20
>> This pull request contains:
>>=20
>> Bug Fixes:
>> - Only requeue dm-raid bios when dm is suspending. (Benjamin Marzinski)
>> - Reset raid10 read_slot when reusing r10bio for discard. (Chen Cheng)
>> - Fix raid1/raid10 deadlock in read error recovery path. (Abd-Alrhman Ma=
salkhi)
>> - Fix raid1/raid10 error-path detection with md_cloned_bio(). (Abd-Alrhm=
an Masalkhi)
>> - Fix raid1/raid10 bio accounting for split md cloned bios. (Abd-Alrhman=
 Masalkhi)
>> - Fix raid1 nr_pending leak in REQ_ATOMIC bad-block path. (Abd-Alrhman M=
asalkhi)
>>=20
>> Improvements:
>> - Skip redundant raid_disks updates when the value is unchanged. (Abd-Al=
rhman Masalkhi)
>>=20
>> Cleanups:
>> - Update MAINTAINERS email addresses. (Yu Kuai, Li Nan)
>> - Clean up raid1 read error handling. (Christoph Hellwig)
>> - Move the exceed_read_errors condition out of fix_read_error(). (Christ=
oph Hellwig)
>> - Use str_plural() in raid0 dump_zones(). (Thorsten Blum)
>=20
> Pulled, thanks.
>=20
> Side note - emails from you with the new email address all end up in
> spam. I just noticed some of them this morning. But I think you want to
> ensure that the DKIM etc part of your email is all kosher, gmail flags
> all of it.

Could you please check my patch to change my email address go fygo.io in yo=
ur spam emails?
I guess similar situation may also happen on my patch sent from fygo.io.
And yes, we are looking into this DKIM issue now.

Thanks.

Coly Li
