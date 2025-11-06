Received: from e234-53.smtp-out.ap-northeast-1.amazonses.com (e234-53.smtp-out.ap-northeast-1.amazonses.com [23.251.234.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A574B34D90B;
	Thu,  6 Nov 2025 17:06:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=23.251.234.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762448775; cv=none; b=keni/370y+Si5t00rtn50cZ5Yp0AMXgSdmjcVEj+wthUsqqLbByYgMMxMJNdGrxZV6Kr5ZI/G0r+UoeX8e4pxWGAxexNORfkoG2Jowr6igFNuUOFpenQiV6ejCF8CcufA/zipZ2Y463vuJibK7IeGZiwQdnIL72hheUAodGSST4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762448775; c=relaxed/simple;
	bh=/09vbaMECOxDSeeUKvZYYb6GJmqeVeebylXAf7GzLvg=;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Date:MIME-Version:
	 Content-Type; b=jL0y8egwqL+iPYTJ8Ok0EuvXU7z73AK91mHBgxM15qjGNJCTStFeaZaSk4nJ8kZ4Ywj+WNoXP2xihAGwQfpmKkZS+4UOLQ/nrr/m88p+O5HCx7HCF7ooDGVHTB1Pf5ZB2krCs8W6u4V3tO4dTr4xd3QUBPDCfgH69rTTpXOxyvo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me; spf=pass smtp.mailfrom=send.mgml.me; dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b=n6F5NqHo; dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b=q/5R7eCe; arc=none smtp.client-ip=23.251.234.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=send.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=mgml.me header.i=@mgml.me header.b="n6F5NqHo";
	dkim=pass (1024-bit key) header.d=amazonses.com header.i=@amazonses.com header.b="q/5R7eCe"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple; s=resend;
	d=mgml.me; t=1762448771;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type;
	bh=/09vbaMECOxDSeeUKvZYYb6GJmqeVeebylXAf7GzLvg=;
	b=n6F5NqHoEeQ99KhBM5M/vGRkA9GZWdm0dE+yi+I1vQ5rBvipG0M5maMxnnpMsQAR
	VuevtTmp84OH6M4XkvQe9OGo2OuuGZAnTN5zu8muhDj+86/HcbXP9GCLRvNAFJ25v6f
	1TU/6umec/G/MilKWCBif2jLnjElN8BbumljnCzU=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/simple;
	s=suwteswkahkjx5z3rgaujjw4zqymtlt2; d=amazonses.com; t=1762448771;
	h=In-Reply-To:From:To:Cc:Subject:Message-ID:Content-Transfer-Encoding:Date:MIME-Version:Content-Type:Feedback-ID;
	bh=/09vbaMECOxDSeeUKvZYYb6GJmqeVeebylXAf7GzLvg=;
	b=q/5R7eCezJDLqs6ObDlqNT3wluwH438n43CrADom1n/lXySbBebHJQq1zl/S8bLy
	whdrV3Itl7h+X31HPY50fsB4ikdsbqagyFacKB/3mxmANdmo3iqGcKPMDPRbCS6y7fx
	Yq62pBhmkOVKz6tQB4+YZd+/qOQaN8l0ZXCeliRc=
User-Agent: Mozilla Thunderbird
Content-Language: en-US
In-Reply-To: <d8ba0843-cbeb-4a91-b658-34b21e8b36fe@fnnas.com>
From: Kenta Akagi <k@mgml.me>
To: yukuai@fnnas.com, song@kernel.org, shli@fb.com, mtkaczyk@kernel.org, 
	jgq516@gmail.com
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v5 02/16] md: serialize md_error()
Message-ID: <0106019a5a22074b-2fa38887-99a3-4b33-b83a-1fb32e6b023a-000000@ap-northeast-1.amazonses.com>
Content-Transfer-Encoding: quoted-printable
Date: Thu, 6 Nov 2025 17:06:10 +0000
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Feedback-ID: ::1.ap-northeast-1.TOS0vxEE3Ar6ai29fkp2i/jb+l2iigajCGeLfF7S3sk=:AmazonSES
X-SES-Outgoing: 2025.11.06-23.251.234.53

Hi, thank you for reviewing!

On 2025/10/30 11:11, Yu Kuai wrote:
> Hi,
>=20
> =E5=9C=A8 2025/10/27 23:04, Kenta Akagi =E5=86=99=E9=81=93:
>> Serialize the md_error() function in preparation for the introduction of
>> a conditional md_error() in a subsequent commit. The conditional
>> md_error() is intended to prevent unintentional setting of MD_BROKEN
>> during RAID1/10 failfast handling.
>>
>> To enhance the failfast bio =
error handler, it must verify that the
>> affected rdev is not the last =
working device before marking it as
>> faulty. Without serialization, a =
race condition can occur if multiple
>> failfast bios attempt to call the =
error handler concurrently:
>>
>>          failfast bio1			failfast bio2
>>          ---                             ---
>>          =
md_cond_error(md,rdev1,bio)	md_cond_error(md,rdev2,bio)
>>            if(!is_degraded(md))		  if(!is_degraded(md))
>>               raid1_error(md,rdev1)          raid1_error(md,rdev2)
>>                 spin_lock(md)
>>                 set_faulty(rdev1)
>> 	       spin_unlock(md)
>> 						spin_lock(md)
>> 						=
set_faulty(rdev2)
>> 						set_broken(md)
>> 						spin_unlock(md)
>>
>> This can unintentionally cause the array to stop in situations where the
>> 'Last' rdev should not be marked as Faulty.
>>
>> This commit serializes=
 the md_error() function for all RAID
>> personalities to avoid this race =
condition. Future commits will
>> introduce a conditional md_error() =
specifically for failfast bio
>> handling.
>>
>> Serialization is applied =
to both the standard and conditional md_error()
>> for the following =
reasons:
>>
>> - Both use the same error-handling mechanism, so it's =
clearer to
>>    serialize them consistently.
>> - The md_error() path is =
cold, meaning serialization has no performance
>>    impact.
>>
>> Signed-off-by: Kenta Akagi <k@mgml.me>
>> ---
>>   drivers/md/md-linear.=
c |  1 +
>>   drivers/md/md.c        | 10 +++++++++-
>>   drivers/md/md.h        |  1 +
>>   drivers/md/raid0.c     |  1 +
>>   drivers/md/raid1.c     |  6 +-----
>>   drivers/md/raid10.c    |  9 =
++-------
>>   drivers/md/raid5.c     |  4 +---
>>   7 files changed, 16 =
insertions(+), 16 deletions(-)
>>
>> diff --git a/drivers/md/md-linear.c =
b/drivers/md/md-linear.c
>> index 7033d982d377..0f6893e4b9f5 100644
>> --- a/drivers/md/md-linear.c
>> +++ b/drivers/md/md-linear.c
>> @@ -298,6 +298,7 @@ static void linear_status(struct seq_file *seq, =
struct mddev *mddev)
>>   }
>>  =20
>>   static void linear_error(struct =
mddev *mddev, struct md_rdev *rdev)
>> +	__must_hold(&mddev->device_lock)
>=20
> This is fine, however, I personally prefer lockdep_assert_held(). :)

Certainly seems like lockdep is better. I'll fix it.

By the way, I realized this PATCH can cause a deadlock in the following =
cases:
1. md_error acquires device_lock. It's interruptible because it's =
spin_lock.
2. a something  - I can't find the specific function or scenario=
 - does call=20
  spin_lock_irqsave(&mddev->device_lock);. Since =
spin_lock_irqsave calls=20
preempt_disable first and then spin_acquire, =
device_lock will never be released=20
in a non-SMP environment because =
md_error thread are never scheduled.

It seems like one of the following =
changes is necessary, what do you think?
- Add a dedicated spinlock_t =
member for md_error serialize
- Use spin_lock_irqsave instead of spin_lock =
in md_error
It's not cool, but I think it would be better to add new =
members.

Thakns,
Akagi

>=20
> Otherwise LGTM.
>=20
> Thanks,
> Kuai
>=20
>>   {
>>   	if (!test_and_set_bit(MD_BROKEN, &mddev->flags)) {
>>   		char *md_name =3D mdname(mddev);
>> diff --git a/drivers/md/md.c =
b/drivers/md/md.c
>> index d667580e3125..4ad9cb0ac98c 100644
>> --- a/drivers/md/md.c
>> +++ b/drivers/md/md.c
>> @@ -8444,7 +8444,8 @@ =
void md_unregister_thread(struct mddev *mddev, struct md_thread __rcu =
**threadp)
>>   }
>>   EXPORT_SYMBOL(md_unregister_thread);
>>  =20
>> -void md_error(struct mddev *mddev, struct md_rdev *rdev)
>> +void _md_error(struct mddev *mddev, struct md_rdev *rdev)
>> +	__must_hold(&mddev->device_lock)
>>   {
>>   	if (!rdev || =
test_bit(Faulty, &rdev->flags))
>>   		return;
>> @@ -8469,6 +8470,13 @@ =
void md_error(struct mddev *mddev, struct md_rdev *rdev)
>>   		queue_work(md_misc_wq, &mddev->event_work);
>>   	md_new_event();
>>   }
>> +
>> +void md_error(struct mddev *mddev, struct md_rdev *rdev)
>> +{
>> +	spin_lock(&mddev->device_lock);
>> +	_md_error(mddev, rdev);
>> +	spin_unlock(&mddev->device_lock);
>> +}
>>   EXPORT_SYMBOL(md_error);
>>  =20
>>   /* seq_file implementation /proc/mdstat */
>> diff --git a/drivers/md/md.h b/drivers/md/md.h
>> index 64ac22edf372..=
c982598cbf97 100644
>> --- a/drivers/md/md.h
>> +++ b/drivers/md/md.h
>> @@ -913,6 +913,7 @@ extern void md_write_start(struct mddev *mddev, =
struct bio *bi);
>>   extern void md_write_inc(struct mddev *mddev, struct =
bio *bi);
>>   extern void md_write_end(struct mddev *mddev);
>>   extern void md_done_sync(struct mddev *mddev, int blocks, int ok);
>> +void _md_error(struct mddev *mddev, struct md_rdev *rdev);
>>   extern void md_error(struct mddev *mddev, struct md_rdev *rdev);
>>   extern void md_finish_reshape(struct mddev *mddev);
>>   void md_submit_discard_bio(struct mddev *mddev, struct md_rdev *rdev,
>> diff --git a/drivers/md/raid0.c b/drivers/md/raid0.c
>> index e443e478645a..8cf3caf9defd 100644
>> --- a/drivers/md/raid0.c
>> +++ b/drivers/md/raid0.c
>> @@ -625,6 +625,7 @@ static void =
raid0_status(struct seq_file *seq, struct mddev *mddev)
>>   }
>>  =20
>>   static void raid0_error(struct mddev *mddev, struct md_rdev *rdev)
>> +	__must_hold(&mddev->device_lock)
>>   {
>>   	if (!=
test_and_set_bit(MD_BROKEN, &mddev->flags)) {
>>   		char *md_name =3D =
mdname(mddev);
>> diff --git a/drivers/md/raid1.c b/drivers/md/raid1.c
>> index 7924d5ee189d..202e510f73a4 100644
>> --- a/drivers/md/raid1.c
>> +++ b/drivers/md/raid1.c
>> @@ -1749,11 +1749,9 @@ static void =
raid1_status(struct seq_file *seq, struct mddev *mddev)
>>    * &mddev->fail_last_dev is off.
>>    */
>>   static void =
raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>> +	__must_hold(&mddev->device_lock)
>>   {
>>   	struct r1conf *conf =3D =
mddev->private;
>> -	unsigned long flags;
>> -
>> -	=
spin_lock_irqsave(&conf->mddev->device_lock, flags);
>>  =20
>>   	if (test_bit(In_sync, &rdev->flags) &&
>>   	    (conf->raid_disks - =
mddev->degraded) =3D=3D 1) {
>> @@ -1761,7 +1759,6 @@ static void =
raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>  =20
>>   		if (!mddev->fail_last_dev) {
>>   			conf->recovery_disabled =3D =
mddev->recovery_disabled;
>> -			spin_unlock_irqrestore(&conf->mddev->devic=
e_lock, flags);
>>   			return;
>>   		}
>>   	}
>> @@ -1769,7 +1766,6 @@ =
static void raid1_error(struct mddev *mddev, struct md_rdev *rdev)
>>   	if (test_and_clear_bit(In_sync, &rdev->flags))
>>   		mddev->degraded++;
>>   	set_bit(Faulty, &rdev->flags);
>> -	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
>>   	/*
>>   	 * if recovery is running, make sure it aborts.
>>   	 */
>> diff --git a/drivers/md/raid10.c b/drivers/md/raid10.c
>> index 57c887070df3..25c0ab09807b 100644
>> --- a/drivers/md/raid10.c
>> +++ b/drivers/md/raid10.c
>> @@ -1993,19 +1993,15 @@ static int =
enough(struct r10conf *conf, int ignore)
>>    * &mddev->fail_last_dev is =
off.
>>    */
>>   static void raid10_error(struct mddev *mddev, struct =
md_rdev *rdev)
>> +	__must_hold(&mddev->device_lock)
>>   {
>>   	struct r10conf *conf =3D mddev->private;
>> -	unsigned long flags;
>> -
>> -	spin_lock_irqsave(&conf->mddev->device_lock, flags);
>>  =20
>>   	if (test_bit(In_sync, &rdev->flags) && !enough(conf, =
rdev->raid_disk)) {
>>   		set_bit(MD_BROKEN, &mddev->flags);
>>  =20
>> -		if (!mddev->fail_last_dev) {
>> -			spin_unlock_irqrestore(&conf->mdd=
ev->device_lock, flags);
>> +		if (!mddev->fail_last_dev)
>>   			return;
>> -		}
>>   	}
>>   	if (test_and_clear_bit(In_sync, &rdev->flags))
>>   		mddev->degraded++;
>> @@ -2015,7 +2011,6 @@ static void =
raid10_error(struct mddev *mddev, struct md_rdev *rdev)
>>   	set_bit(Faulty, &rdev->flags);
>>   	set_mask_bits(&mddev->sb_flags, =
0,
>>   		      BIT(MD_SB_CHANGE_DEVS) | BIT(MD_SB_CHANGE_PENDING));
>> -	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
>>   	pr_crit("md/raid10:%s: Disk failure on %pg, disabling device.\n"
>>   		"md/raid10:%s: Operation continuing on %d devices.\n",
>>   		mdname(mddev), rdev->bdev,
>> diff --git a/drivers/md/raid5.c =
b/drivers/md/raid5.c
>> index 3350dcf9cab6..d1372b1bc405 100644
>> --- a/drivers/md/raid5.c
>> +++ b/drivers/md/raid5.c
>> @@ -2905,15 +2905,14 @@ static void raid5_end_write_request(struct bio =
*bi)
>>   }
>>  =20
>>   static void raid5_error(struct mddev *mddev, =
struct md_rdev *rdev)
>> +	__must_hold(&mddev->device_lock)
>>   {
>>   	struct r5conf *conf =3D mddev->private;
>> -	unsigned long flags;
>>   	pr_debug("raid456: error called\n");
>>  =20
>>   	=
pr_crit("md/raid:%s: Disk failure on %pg, disabling device.\n",
>>   		mdname(mddev), rdev->bdev);
>>  =20
>> -	spin_lock_irqsave(&conf->md=
dev->device_lock, flags);
>>   	set_bit(Faulty, &rdev->flags);
>>   	clear_bit(In_sync, &rdev->flags);
>>   	mddev->degraded =3D =
raid5_calc_degraded(conf);
>> @@ -2929,7 +2928,6 @@ static void =
raid5_error(struct mddev *mddev, struct md_rdev *rdev)
>>   			mdname(mddev), conf->raid_disks - mddev->degraded);
>>   	}
>>  =20
>> -	spin_unlock_irqrestore(&conf->mddev->device_lock, flags);
>>   	set_bit(MD_RECOVERY_INTR, &mddev->recovery);
>>  =20
>>   	set_bit(Blocked, &rdev->flags);
>=20

