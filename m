Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118262F6931
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 09:46:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777369600; cv=none; b=Vag4W4+XZ8jH6Q/8f3smVx7Nr8chdZ54GBJXdtcj7JeUlyFYZRICHp++lksxf3PrmabAO+1/EEjZ8rlO43c0FoFYVucv+vjTio2mdbaPqz+sPcldctLEPXMVKVYD2SJFFJBpfaMJGYFHo50UFKuZYUWhL9uwbgCz8JNcFaTSgVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777369600; c=relaxed/simple;
	bh=Qd8r2XERAsF2ZqM1eGzApNqXlkZ2oxcM4Oik8MbtyMc=;
	h=From:To:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=FrPuWbwNPE1Rl07FAgUiJS18hDga+Ok9LLjSPg9rgYL3fvT+hEy8dMv1r57pVZckFnkYMyYic/3MtdN9f13AYdQPiWYB9MH76MztVJDm6K+bzowqKIEJBDyAAgjl9UXwVZJ8CO6vjlcbdNeUJkmhCzOrffRBh1indd2CG0lK+XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tLh+8eMT; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tLh+8eMT"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-4891e86fabeso124001595e9.1
        for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 02:46:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777369597; x=1777974397; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ux4Am1RgZmRAsesxXhf54ARTdACqBM6PK9xVapLkK0=;
        b=tLh+8eMTBa6T7yqsxQ83STrK/ETPCo8dKe59sDTm7X2o2msqppsz7FxJ3BcpSbUgyO
         8hKom36b/3ezlSNzvWeqPP/1s5emB1DMcij7dt5tD2hB58wBFqiLuOreGP9VNyLZnsJU
         y/zMFTI0gVyM+aj9hIkTocUIjfBNvP44X0QFkIAQp34+VAm1OGxiZGGU16RhE3tnSIGr
         4uLlO1oKMU0wiY3NKqWnyn3tpsIC5FavBlf5CkiFi1cPAPVNGyyvqSbTm03bNtOecM9H
         +QRtjcegdpu7e8kQa1Ms/DhnUmbzB1Ext/51ivE++rSYhRclA7XNq1E0objzHhHpR/BM
         lk8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777369597; x=1777974397;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:to:from:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5ux4Am1RgZmRAsesxXhf54ARTdACqBM6PK9xVapLkK0=;
        b=pg3B25uw2A6p4G9TxyDVH233JGD32Fte4/zHlBIOVzwJuySnK03DdTs2+qthM0Qlvz
         02pDP52u9/9AcXx5cjC3epa+tzx8G9KJHrlJxXsbsZKKPHlvTCybEMorsb3hefAboEee
         V0IgVYOf0AodSBF8fdbKXZ2rMrUTfkXG3m7VXrMkaZgFItnHwTHL16LJdIYFe5R9TlTZ
         /ufbXh1lylPOV8VlWvAoOViX7lUXiw9s7rOWeOVm26XCYdl6H9gZkwStjiZEuIxKUOeY
         f6QoBlmZF/KaKhxFCfjpW4ABpVEi/sYEhkTTCImTKc0hXyPk0baPoEJEe8kGYpdBKRqL
         DHvA==
X-Forwarded-Encrypted: i=1; AFNElJ80dZaCOYYSMSMQfC7VLmO7+spzpioQkjK2YrNVEqx5C2Naun19K4T9RMmeoMO1BaMu8b64tWjXKGJt@vger.kernel.org
X-Gm-Message-State: AOJu0YxtNkx3t4xRyzrP1XSE55RroF6FWW/gFpK6+jL/tQ7DACc1Yz7e
	1440NGpZg+ZMx5BWqKL4MsYJbDpASdaJ9+HI/itsz8y/IQLJc1isJovA
X-Gm-Gg: AeBDietuMlayBcx6NJHLpg2ftHCXfwS4KDcFH3cpgVApQkjrdCCCdT5EhtVj6b1lOfD
	BKHnxcq/85e4TLsfBDtgbL23Y7mfvB9+SM4Bge0PTfijg3sIGQ/WRuPhLqFTyzkWJmT8oF8lszk
	en+fQe9ER0M7gKmHlDKIA/1thWZfK4JksZOw8c/SWsXthBLcUcw+mkaFuscdv7h0T84VMv3RnQm
	RccZZVVZUxAO10oW1Wc0ez46UyfYfQ3vG0J9chfdWoGAame2vRuDhfyDqzGc7zuBTmzp7B6jnAt
	GYHnM2yg9rPCqL2/AqmHxB1A1omxFlRq/ZOx1Gwx6xMDitb+vYKnn+daWVKUHZQt+MaDubKEqiq
	I3P1kGNE4zGdF3HOMJkecrccplQnZGH6nX7W3LAW9tb1eiBC7IC4sJzavHaaP8f3riD9qwy+wOG
	15fBLcwBZee02FP7fuYr/uDSX6HpvXL+F/3vPo+3ivAI/gKQkUiIxHeMiYU9JILGdHn7K6SDoLc
	xU=
X-Received: by 2002:a05:600c:1512:b0:487:4eb:d125 with SMTP id 5b1f17b1804b1-48a77af5f32mr22552665e9.9.1777369597257;
        Tue, 28 Apr 2026 02:46:37 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:60f:89ae:9995:66df:f74:57a3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a774a4031sm26406385e9.2.2026.04.28.02.46.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 02:46:36 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Yu Kuai <yukuai@fnnas.com>, song@kernel.org, shli@fb.com,
 neilb@suse.com, linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
 yukuai@fnnas.com
Subject: Re: [PATCH] md/raid1: fix bio splitting in raid1 thread to avoid
 recursion and deadlock
In-Reply-To: <2cf6f585-a0de-4c84-9cfc-05e1f6fde549@fnnas.com>
References: <20260427103446.300378-1-abd.masalkhi@gmail.com>
 <2cf6f585-a0de-4c84-9cfc-05e1f6fde549@fnnas.com>
Date: Tue, 28 Apr 2026 11:46:35 +0200
Message-ID: <m2lde74dtw.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Kuai,

Thank you for the feedback.

On Tue, Apr 28, 2026 at 16:54 +0800, Yu Kuai wrote:
> Hi,
>
> =E5=9C=A8 2026/4/27 18:34, Abd-Alrhman Masalkhi =E5=86=99=E9=81=93:
>> Splitting a bio while executing in the raid1 thread can lead to
>> recursion, as task->bio_list is NULL in this context.
>>
>> In addition, resubmitting an md_cloned_bio after splitting may lead to
>> a deadlock if the array is suspended before the md driver calls
>> percpu_ref_tryget_live(&mddev->active_io) on it's path to
>> pers->make_request().
>
> I don't understand, I agree this is problematic in the suspend case, but
> what's wrong with task->bio_list being NULL? This can only cause the reve=
rse
> order because the split bio will submit first. However this is not a big =
deal
> as this is the slow error patch.
>
> If suspend is the only problem here, the simple fix is to add checking
> in md_handle_request().
>

I meant that when current->bio_list is NULL, raid1_read_request()
can recurse into itself, as shown in the following trace-cmd output:

	  raid1_read_request() {                  <---
		bio_submit_split_bioset() {
		  bio_split() {..}
		  bio_chain();
		  submit_bio_noacct_nocheck() {
			__submit_bio() {
			  md_submit_bio() {
				md_handle_request() {
				  raid1_make_request() {
					raid1_read_request() {    <---
					  md_account_bio() {=20

If this behavior is not an issue, I will follow your suggestion and
only add the check in md_handle_request().

>>
>> Avoid splitting the bio in this context and require that it is either
>> read in full or not at all.
>>
>> This prevents recursion and avoids potential deadlocks during array
>> suspension.
>>
>> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>> I sent an email about this issue two days ago, but at the time I was not
>> sure whether it was a real problem or a misunderstanding on my part.
>>
>> After further analysis, it appears that this issue can occur.
>>
>> Apologies for the earlier confusion, and thank you for your time.
>>
>> Abd-Alrhman
>> ---
>>   drivers/md/raid1.c | 33 ++++++++++++++++++++++++---------
>>   1 file changed, 24 insertions(+), 9 deletions(-)
>>
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index cc9914bd15c1..14f6d6625811 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -607,7 +607,7 @@ static int choose_first_rdev(struct r1conf *conf, st=
ruct r1bio *r1_bio,
>>=20=20=20
>>   		/* choose the first disk even if it has some bad blocks. */
>>   		read_len =3D raid1_check_read_range(rdev, this_sector, &len);
>> -		if (read_len > 0) {
>> +		if (read_len > 0 && (!*max_sectors || read_len =3D=3D r1_bio->sectors=
)) {
>>   			update_read_sectors(conf, disk, this_sector, read_len);
>>   			*max_sectors =3D read_len;
>>   			return disk;
>> @@ -704,8 +704,13 @@ static int choose_slow_rdev(struct r1conf *conf, st=
ruct r1bio *r1_bio,
>>   	}
>>=20=20=20
>>   	if (bb_disk !=3D -1) {
>> -		*max_sectors =3D bb_read_len;
>> -		update_read_sectors(conf, bb_disk, this_sector, bb_read_len);
>> +		if (!*max_sectors || bb_read_len =3D=3D r1_bio->sectors) {
>> +			*max_sectors =3D bb_read_len;
>> +			update_read_sectors(conf, bb_disk, this_sector,
>> +					    bb_read_len);
>> +		} else {
>> +			bb_disk =3D -1;
>> +		}
>>   	}
>>=20=20=20
>>   	return bb_disk;
>> @@ -852,8 +857,9 @@ static int choose_best_rdev(struct r1conf *conf, str=
uct r1bio *r1_bio)
>>    * disks and disks with bad blocks for now. Only pay attention to key =
disk
>>    * choice.
>>    *
>> - * 3) If we've made it this far, now look for disks with bad blocks and=
 choose
>> - * the one with most number of sectors.
>> + * 3) If we've made it this far and *max_sectors is 0 (i.e., we are tol=
erant
>> + * of bad blocks), look for disks with bad blocks and choose the one wi=
th
>> + * the most sectors.
>>    *
>>    * 4) If we are all the way at the end, we have no choice but to use a=
 disk even
>>    * if it is write mostly.
>> @@ -882,11 +888,13 @@ static int read_balance(struct r1conf *conf, struc=
t r1bio *r1_bio,
>>   	/*
>>   	 * If we are here it means we didn't find a perfectly good disk so
>>   	 * now spend a bit more time trying to find one with the most good
>> -	 * sectors.
>> +	 * sectors. but only if we are tolerant of bad blocks.
>>   	 */
>> -	disk =3D choose_bb_rdev(conf, r1_bio, max_sectors);
>> -	if (disk >=3D 0)
>> -		return disk;
>> +	if (!*max_sectors) {
>> +		disk =3D choose_bb_rdev(conf, r1_bio, max_sectors);
>> +		if (disk >=3D 0)
>> +			return disk;
>> +	}
>>=20=20=20
>>   	return choose_slow_rdev(conf, r1_bio, max_sectors);
>>   }
>> @@ -1346,7 +1354,14 @@ static void raid1_read_request(struct mddev *mdde=
v, struct bio *bio,
>>   	/*
>>   	 * make_request() can abort the operation when read-ahead is being
>>   	 * used and no empty request is available.
>> +	 *
>> +	 * If we allow splitting the bio while executing in the raid1 thread,
>> +	 * we may end up recursing (current->bio_list is NULL), and we might
>> +	 * also deadlock if we try to suspend the array, since we are
>> +	 * resubmitting an md_cloned_bio. Therefore, we must be read either
>> +	 * all the sectors or none.
>>   	 */
>> +	max_sectors =3D r1bio_existed;
>>   	rdisk =3D read_balance(conf, r1_bio, &max_sectors);
>>   	if (rdisk < 0) {
>>   		/* couldn't find anywhere to read from */
>
> --=20
> Thansk,
> Kuai

--=20
Best Regards,
Abd-Alrhman
