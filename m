Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 419F83CF041
	for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 08:16:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777364176; cv=none; b=uukO90Bvl4JE4Jqlu5HO5APzfc+E74sv6rd60T5qAd8/1iRIvzIdNcm1tkWiRAG7266LGxsU18rkZ1XTYtFA0uReFHx0SrfqeuNsqcmPEDhNAmmkXjtQtimdVUqhlXNqFSEXIj8tcRSVPSzCQ3MYzNMOMwxIhRsKBFFaZhVwpDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777364176; c=relaxed/simple;
	bh=Ty0ij7CJr3MZq+D9Q7tPWddxEvpeZYJgAMbz8t1NFO4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=mcL5MaPxPs9Uesw4f57dcVSF/PvubPZLQZria9CxaohAW2yPxO50PPFuAwCLGcnD7Xh8A9ZoLfgHoKInZnR1HbHl01fbgne2z5yde47fknGBVs6vrAaKbM/1Es9kGsU3zaOEheAay6Jb1GPERngVZBj+hjOqqpECNFKkvr0nu5Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=P8uxcJRP; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="P8uxcJRP"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-488af96f6b2so146384865e9.0
        for <linux-raid@vger.kernel.org>; Tue, 28 Apr 2026 01:16:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777364174; x=1777968974; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iKROIxfjCeob4adBq1XKBR+o+ZkdWO2RiPzgfiK5lUk=;
        b=P8uxcJRPqVPgwBTvBWMOgDH2OHlCb9+HCNitrhNoGt1lfnkIoV8dQ3lr1ami2Bk868
         UVCe5LCffY+H7a8h4dDHw9c71nSBuOQMgHlztz0uUiYh0NMNKuBcuuZmrPL94FFAFIS5
         BVwiDxR88R6VTMRmpi+dasf1/O/x39QM2TlElZ3fc063i9KW7rjRidfWHUslSURIFOVq
         3X3kBzncY7niAmm3q1dCP4gknTXo/pMJZmurrRVWztoDS8s3fntpB3eEaGnfKK7bbLB/
         gfqUu8MvJjxhAO+Bt3y/Q2cIkn4Wst2vD7CG6EesgQs0bPH1OATfUTN+3VSIM/URbAi+
         GThg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777364174; x=1777968974;
        h=content-transfer-encoding:mime-version:message-id:date:references
         :in-reply-to:subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=iKROIxfjCeob4adBq1XKBR+o+ZkdWO2RiPzgfiK5lUk=;
        b=Vm0OYmSmjdkZleFvWAGk3YxhvGDnh+3I2sISowcq8PCWFFN14gG72VyUgByKzSh9S8
         qaTd6Avu/hYxjLRY4INoyYntDl/u62EZ5hx6jxtb0L6f6dgERlcShj0rbPFZnVk+sa9J
         WMTL2ez6wLlhCxc4vEe7vBRDE2ZB2CDvd/mEteB6fVStImG24a44HL5W85Cm5oRVu5Ui
         y3f8/UILGeIRKssV3GuzykQ++uy6B5DqF3Ql8pqN/4opVYcEwtz44VcalggcgqkxqoMN
         R7xteGGISO1Xi5IvVNPS6Z0OtMuiSNz/KTI6JGw/V6hOi7zP12mx6r1cx4L5mqGLigtd
         8c1w==
X-Forwarded-Encrypted: i=1; AFNElJ92ye4SiBR9OOEw5PjiWzeHobHCR/uRSPuOZD4oxXSZbqcqXYWr56NssdCDBV5WBNKsP4ueu3haQuXw@vger.kernel.org
X-Gm-Message-State: AOJu0YyIIlqnCBTrk94B+z5fhN96BxWBg720ga3x42RNg5XPI/uXxmds
	dNls17uEn3DTyntXF5AfA3pyVr4tvlPRsEhE0uyUJl6Dalntd+dKFE6d
X-Gm-Gg: AeBDiesti9m3E5ggGA60JZ6DFPMp0bU1HLYCCnAOHzipX3X6qgpG0kHXBi+G8B5p3dG
	TQ+/J0w9NcOVtHhSdNov94Gt8sqGBd7xkI1MKI4SDejo/trRIhhrSLF/X/UD3esFIWGlZ29jowB
	eObkpwXqCbBSIw/5fCICUuV9LEnQBchmo08QKqnI4ggU92KT1vEVFH5Yh/M5Uk2he+G+3yoijG3
	S2LShAAOqi0BHmOX2ej+pbFe6Y+H89/mP77CPIOpdekkfjjIuU2cDdpeG0QrWsQkUM28h9RKi3F
	wxWaCYwXc/eaUIxfc/gQBZrjlOas5FIAQ7FuJNuoUFH83Anb/u8ECsVb0BNPqQm80ACL2HhMavK
	XK7TNHZvSZ9eJ2BCI6qAGdnQehuj88ymNSNLMgAd7s91DrzGVH/4wSzAwtQMsPpJuh/gkW+EESh
	f+wq14zqjtRW4xXicJv1k02/e8nR0QpXldoQeptzOgRVb/aTkcST9qVIck6BlAUmkpewsd/6cly
	zA2
X-Received: by 2002:a05:600c:b8d:b0:489:1f98:71e3 with SMTP id 5b1f17b1804b1-48a77b21791mr30098975e9.28.1777364173317;
        Tue, 28 Apr 2026 01:16:13 -0700 (PDT)
Received: from Abds-MacBook-Air.local ([2a02:3037:60f:89ae:d18f:1b9f:4762:f3cc])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48a773e70c2sm42722215e9.10.2026.04.28.01.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 01:16:12 -0700 (PDT)
From: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
To: Paul Menzel <pmenzel@molgen.mpg.de>
Cc: song@kernel.org, yukuai@fnnas.com, shli@fb.com, neilb@suse.com,
 linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] md/raid1: fix bio splitting in raid1 thread to avoid
 recursion and deadlock
In-Reply-To: <c859ab17-cfc6-4e54-9a79-8b0d2b145adc@molgen.mpg.de>
References: <20260427103446.300378-1-abd.masalkhi@gmail.com>
 <c859ab17-cfc6-4e54-9a79-8b0d2b145adc@molgen.mpg.de>
Date: Tue, 28 Apr 2026 10:16:08 +0200
Message-ID: <m2o6j34i0n.fsf@gmail.com>
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable


Hi Paul,

On Mon, Apr 27, 2026 at 16:49 +0200, Paul Menzel wrote:
> Dear Abd-Alrhman,
>
>
> Thank you for your patch.
>

RAID 10 seems to have a similar issue, i will fix it too.

> Am 27.04.26 um 12:34 schrieb Abd-Alrhman Masalkhi:
>> Splitting a bio while executing in the raid1 thread can lead to
>> recursion, as task->bio_list is NULL in this context.
>>=20
>> In addition, resubmitting an md_cloned_bio after splitting may lead to
>> a deadlock if the array is suspended before the md driver calls
>> percpu_ref_tryget_live(&mddev->active_io) on it's path to
>> pers->make_request().
>>=20
>> Avoid splitting the bio in this context and require that it is either
>> read in full or not at all.
>>=20
>> This prevents recursion and avoids potential deadlocks during array
>> suspension.
>
> Do you have a reproducer?
>
>> Fixes: 689389a06ce7 ("md/raid1: simplify handle_read_error().")
>> Signed-off-by: Abd-Alrhman Masalkhi <abd.masalkhi@gmail.com>
>> ---
>> I sent an email about this issue two days ago, but at the time I was not
>> sure whether it was a real problem or a misunderstanding on my part.
>>=20
>> After further analysis, it appears that this issue can occur.
>>=20
>> Apologies for the earlier confusion, and thank you for your time.
>>=20
>> Abd-Alrhman
>
> I suggest to always share the URL (lore.kernel.org), when referencing=20
> another thread. If relevant, maybe even reference your message with a=20
> Link: tag in the commit message.
>
>> ---
>>   drivers/md/raid1.c | 33 ++++++++++++++++++++++++---------
>>   1 file changed, 24 insertions(+), 9 deletions(-)
>>=20
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
>
> s/but/But/
>
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
>
> =E2=80=A6 we must read =E2=80=A6
>
>> +	 * all the sectors or none.
>>   	 */
>> +	max_sectors =3D r1bio_existed;
>
> Excuse my ignorance, but I do not get why a bool is assigned to an int=20
> representing the maximum sector value.
>
>>   	rdisk =3D read_balance(conf, r1_bio, &max_sectors);
>>   	if (rdisk < 0) {
>>   		/* couldn't find anywhere to read from */
>
>
> Kind regards,
>
> Paul

--=20
Best Regards,
Abd-Alrhman
