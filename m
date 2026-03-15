Received: from va-2-37.ptr.blmpb.com (va-2-37.ptr.blmpb.com [209.127.231.37])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BF6B368941
	for <linux-raid@vger.kernel.org>; Sun, 15 Mar 2026 16:57:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.127.231.37
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773593839; cv=none; b=B7ygQc6aimHVLT6ESozJaKa3TdS/uEbhqe5xbM12qnAPgRkxt4/zWugYogIcguWOnU3RYW0QnZ1X6fzuqPnd4pXbI4nSy4AWcOOOdCgPDQcSqRU2jhp+YlqnRAgxHu7bmngp08cdHDLu/h8Fly0Cn1SOxUkZmt3pAQ7fJYP+8rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773593839; c=relaxed/simple;
	bh=O2KOwkqk4ikHy4VgSSIBWTjYnV22zD5e6y3hbVWzxgg=;
	h=From:Mime-Version:Content-Type:References:To:Cc:Date:In-Reply-To:
	 Subject:Message-Id; b=CFYuuwW30Lm5RHIu497UZihLXtX/TCsR3esNj2kJSXMCEfsEXWJwHQczxa62gnurmNvPvHsZNZye83FdnV4Cyy9ZpBcsUPOk3wfn6+3g9VkmZfiIigy36vvCmHQBcyz5Cr9YCIAOabtQJZW8OlSWMb1AX/wZ4U3jpPOuCa8Jxs4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=BGm91f0M; arc=none smtp.client-ip=209.127.231.37
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="BGm91f0M"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1773593832;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=w44ffbDj2a9C+QfBeb3jXrjjHLI8tZBXGmhfM/jz1Ho=;
 b=BGm91f0MJkZcmK/ctKsnPOr3hVi1+UIjBJkUWcyG1T9zUWnMN6J5cQJpIGBWcUGPNIEaiU
 D7fkntGbY5RRBU9BskwmjKvaaG9uDF8ZCNsoncvVM2maxBPWXl0cDHtJCAyRPlpaZsVC9R
 gV4XOcD7kZ9v6166XVGpLHYIgexrTgIN29v7wDBBMUgPvgNTkW80xO8hKoEwcJykm4VcOe
 JijsMlC7nuI3Q3DJhHkgiTRJu+RzhCZM4DkbqvDxgdCV36hez/SJgnJunPRotxXtk7fzZw
 HXFFggS/ZZb7NdMAnrt8nmj3wIYdyZ41wyYz+CtzLY+3yFumdsTeQoEFOY8Exw==
From: "Yu Kuai" <yukuai@fnnas.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <20260223024038.3084853-1-yukuai@fnnas.com> <20260223024038.3084853-3-yukuai@fnnas.com> <CALTww2-oZrNS8hj+ZnBYmfxOrE6gjwqpvkWex_XCupHPCpyLBw@mail.gmail.com>
X-Lms-Return-Path: <lba+269b6e4e6+fe2485+vger.kernel.org+yukuai@fnnas.com>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
To: "Xiao Ni" <xni@redhat.com>, <yukuai@fnnas.com>
Cc: <song@kernel.org>, <linan122@huawei.com>, <colyli@fnnas.com>, 
	<linux-raid@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Reply-To: yukuai@fnnas.com
Received: from [192.168.1.104] ([39.182.0.175]) by smtp.feishu.cn with ESMTPS; Mon, 16 Mar 2026 00:57:10 +0800
Date: Mon, 16 Mar 2026 00:57:08 +0800
In-Reply-To: <CALTww2-oZrNS8hj+ZnBYmfxOrE6gjwqpvkWex_XCupHPCpyLBw@mail.gmail.com>
User-Agent: Mozilla Thunderbird
Content-Transfer-Encoding: quoted-printable
Content-Language: en-US
Subject: Re: [PATCH v2 2/5] md/md-llbitmap: raise barrier before state machine transition
Message-Id: <554d2b1d-e2bc-4723-8862-36961eaa4376@fnnas.com>

Hi,

=E5=9C=A8 2026/3/9 21:05, Xiao Ni =E5=86=99=E9=81=93:
> On Mon, Feb 23, 2026 at 10:42=E2=80=AFAM Yu Kuai <yukuai@fnnas.com> wrote=
:
>> Move the barrier raise operation before calling llbitmap_state_machine()
>> in both llbitmap_start_write() and llbitmap_start_discard(). This
>> ensures the barrier is in place before any state transitions occur,
>> preventing potential race conditions where the state machine could
>> complete before the barrier is properly raised.
> Hi Kuai
>
> In the above commit message, race conditions are mentioned. I want to
> give an example here to check if I understand correctly.
>
> raid1 with 2 disks is used in this case.
> T0: Thread A calls llbitmap_state_machine() and state of bit is set to Bi=
tDirty
> T1: Thread daemon calls llbitmap_daemon_work() and the state of the
> bit is set to BitClean from BitDirty.
> (Now the state is already wrong)
> T2: Thread A calls llbitmap_raise_barrier to wait Thread daemon
> finishes and go on working
> T3: data is written to disk1 and disk2. A power failure occurs.
> (The data on disk1 and disk2 maybe different, so a data curruption happen=
s)
>
> Does this case belong the race conditions you mentioned in the commit
> message? Can you add one race condtion in your message?

This is not that complex, the reason state machine from fast path can concu=
rrent
with each other is that they both change state to the same state, and obliv=
iously
they can't concurrent from slow path, this is why the barrier is needed. An=
d I
made this mistake in the first version.

>
> Best Regards
> Xiao
>
>> Cc: stable@vger.kernel.org
>> Fixes: 5ab829f1971d ("md/md-llbitmap: introduce new lockless bitmap")
>> Signed-off-by: Yu Kuai <yukuai@fnnas.com>
>> ---
>>   drivers/md/md-llbitmap.c | 8 ++++----
>>   1 file changed, 4 insertions(+), 4 deletions(-)
>>
>> diff --git a/drivers/md/md-llbitmap.c b/drivers/md/md-llbitmap.c
>> index 30d7e36b22c4..5f9e7004e3e3 100644
>> --- a/drivers/md/md-llbitmap.c
>> +++ b/drivers/md/md-llbitmap.c
>> @@ -1070,12 +1070,12 @@ static void llbitmap_start_write(struct mddev *m=
ddev, sector_t offset,
>>          int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>>          int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>>
>> -       llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwr=
ite);
>> -
>>          while (page_start <=3D page_end) {
>>                  llbitmap_raise_barrier(llbitmap, page_start);
>>                  page_start++;
>>          }
>> +
>> +       llbitmap_state_machine(llbitmap, start, end, BitmapActionStartwr=
ite);
>>   }
>>
>>   static void llbitmap_end_write(struct mddev *mddev, sector_t offset,
>> @@ -1102,12 +1102,12 @@ static void llbitmap_start_discard(struct mddev =
*mddev, sector_t offset,
>>          int page_start =3D (start + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>>          int page_end =3D (end + BITMAP_DATA_OFFSET) >> PAGE_SHIFT;
>>
>> -       llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard=
);
>> -
>>          while (page_start <=3D page_end) {
>>                  llbitmap_raise_barrier(llbitmap, page_start);
>>                  page_start++;
>>          }
>> +
>> +       llbitmap_state_machine(llbitmap, start, end, BitmapActionDiscard=
);
>>   }
>>
>>   static void llbitmap_end_discard(struct mddev *mddev, sector_t offset,
>> --
>> 2.51.0
>>
>>
--=20
Thansk,
Kuai
