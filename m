Received: from www5210.sakura.ne.jp (www5210.sakura.ne.jp [133.167.8.150])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCFF754F81;
	Sat, 20 Sep 2025 06:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=133.167.8.150
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758349917; cv=none; b=Fv8YKCX+oYI+/8bztdUXFkrkLhEmhZOOD/i7rbPrnYl12/mzJHcML+quOyBmf2ofg8Maw8TH2gIOlqmE7k3oI2Rs5TmC1PDZVSTofK1Yd+3qXsCapVso08/LEBbdbX0BGxKQtbaR/5/W1KGhTmwKtgMbOqxT9NlOWTjgsaBiryg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758349917; c=relaxed/simple;
	bh=6vb/9afzetWbNWekhsEKKz+g5RX9WDAS4JQOn4JeWps=;
	h=Message-ID:Date:MIME-Version:Cc:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=aiLhmkQB11TTty6INLR55Paw44av+/VtEBkbstIQcky5nWh7sKZPqTK4Xspvry3L4AX8/o2gaeCrsew+8SRwiW2armYLUJYBqZLGtwT3Ml9wWjbYNTR4ufuh5//R/LgKCE9OkHK9yXv5uBXIjjT5UPsD7heihedInhBDg3leoWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fwd.mgml.me; spf=pass smtp.mailfrom=fwd.mgml.me; dkim=fail (0-bit key) header.d=fwd.mgml.me header.i=@fwd.mgml.me header.b=Bj02TLX+ reason="key not found in DNS"; arc=none smtp.client-ip=133.167.8.150
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=fwd.mgml.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fwd.mgml.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=fwd.mgml.me header.i=@fwd.mgml.me header.b="Bj02TLX+"
Received: from NEET (p3767220-ipxg00h01tokaisakaetozai.aichi.ocn.ne.jp [180.15.208.220])
	(authenticated bits=0)
	by www5210.sakura.ne.jp (8.16.1/8.16.1) with ESMTPSA id 58K6UTaF010965
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
	Sat, 20 Sep 2025 15:30:30 +0900 (JST)
	(envelope-from k@fwd.mgml.me)
DKIM-Signature: a=rsa-sha256; bh=konQqpCDA2zLa8r0aoNTN11Z1nBGuu9K9Qo3Tk9sMFs=;
        c=relaxed/relaxed; d=fwd.mgml.me;
        h=Message-ID:Date:Subject:To:From;
        s=rs20250919; t=1758349830; v=1;
        b=Bj02TLX+L1jrzQa4FHtPX30KoIslhsyN+NavawYa/3ZzpzHD16PRdquDr+8tKgR2
         HFVxQ6OTpxQKqOQp7YIHWG4LAyg+O7JyNNz4JLhhT8/2ANsj+fDqJyYrNlXb96Rs
         nS2TDyNwlBE/n4G9T6ZcHV8PDsqM1uoQe/0nyDZ+nznhI4YJqWL8laRvw3lJycmj
         XAobpgOTVKd04DUEckywO4D+SUU2SK7t9ou18EsumS9ZbRhVKqb3LRh5CAwyVZTG
         x8eVXdOj+uaai870udGmIvFEPZ1Q9/vXPUfc1D0su20k3yb1RydDKYw5GlQq28AO
         MRxfsboNSLH+7Hc10CuWmw==
Message-ID: <e88ac955-9733-4e57-830b-d326557d189a@fwd.mgml.me>
Date: Sat, 20 Sep 2025 15:30:29 +0900
Precedence: bulk
X-Mailing-List: linux-raid@vger.kernel.org
List-Id: <linux-raid.vger.kernel.org>
List-Subscribe: <mailto:linux-raid+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-raid+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Cc: linux-raid@vger.kernel.org, linux-kernel@vger.kernel.org,
        yukuai3@huawei.com, k@fwd.mgml.me
Subject: Re: [PATCH v4 4/9] md/raid1,raid10: Don't set MD_BROKEN on failfast
 bio failure
To: Yu Kuai <hailan@yukuai.org.cn>, yukuai1@huaweicloud.com, song@kernel.org,
        mtkaczyk@kernel.org, shli@fb.com, jgq516@gmail.com
References: <010601995d6b88a4-423a9b3c-3790-4d65-86a4-20a9ddea0686-000000@ap-northeast-1.amazonses.com>
 <6ce45082-2913-4ca2-b382-5beff6a799c6@yukuai.org.cn>
Content-Language: en-US
From: Kenta Akagi <k@fwd.mgml.me>
In-Reply-To: <6ce45082-2913-4ca2-b382-5beff6a799c6@yukuai.org.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

I have changed my email address because our primary MX server
suddenly started rejecting non-DKIM mail.

On 2025/09/19 10:36, Yu Kuai wrote:
> Hi,
> 
> 在 2025/9/18 23:22, Kenta Akagi 写道:
>>>> @@ -470,7 +470,7 @@ static void raid1_end_write_request(struct bio *bio)
>>>>                (bio->bi_opf & MD_FAILFAST) &&
>>>>                /* We never try FailFast to WriteMostly devices */
>>>>                !test_bit(WriteMostly, &rdev->flags)) {
>>>> -            md_error(r1_bio->mddev, rdev);
>>>> +            md_bio_failure_error(r1_bio->mddev, rdev, bio);
>>>>            }
>>> Can following check of faulty replaced with return value?
>> In the case where raid1_end_write_request is called for a non-failfast IO,
>> and the rdev has already been marked Faulty by another bio, it must not retry too.
>> I think it would be simpler not to use a return value here.
> 
> You can just add Faulty check inside md_bio_failure_error() as well, and both
> failfast and writemostly check.

Sorry, I'm not sure I understand this part. 
In raid1_end_write_request, this code path is also used for a regular bio,
not only for FailFast.

You mean to change md_bio_failure_error as follows:
* If the rdev is Faulty, immediately return true.
* If the given bio is Failfast and the rdev is not the lastdev, call md_error.
* If the given bio is not Failfast, do nothing and return false.

And then apply this?
This is complicated. Wouldn't it be better to keep the Faulty check as it is?

@@ -466,18 +466,12 @@ static void raid1_end_write_request(struct bio *bio)
                        set_bit(MD_RECOVERY_NEEDED, &
                                conf->mddev->recovery);

-               if (test_bit(FailFast, &rdev->flags) &&
-                   (bio->bi_opf & MD_FAILFAST) &&
-                   /* We never try FailFast to WriteMostly devices */
-                   !test_bit(WriteMostly, &rdev->flags)) {
-                       md_error(r1_bio->mddev, rdev);
-               }
-
                /*
                 * When the device is faulty, it is not necessary to
                 * handle write error.
                 */
-               if (!test_bit(Faulty, &rdev->flags))
+               if (!test_bit(Faulty, &rdev->flags) ||
+                   !md_bio_failure_error(r1_bio->mddev, rdev, bio))
                        set_bit(R1BIO_WriteError, &r1_bio->state);
                else {
                        /* Finished with this branch */


Or do you mean a fix like this?

@@ -466,23 +466,24 @@ static void raid1_end_write_request(struct bio *bio)
                        set_bit(MD_RECOVERY_NEEDED, &
                                conf->mddev->recovery);

-               if (test_bit(FailFast, &rdev->flags) &&
-                   (bio->bi_opf & MD_FAILFAST) &&
-                   /* We never try FailFast to WriteMostly devices */
-                   !test_bit(WriteMostly, &rdev->flags)) {
-                       md_error(r1_bio->mddev, rdev);
-               }
-
                /*
                 * When the device is faulty, it is not necessary to
                 * handle write error.
                 */
-               if (!test_bit(Faulty, &rdev->flags))
-                       set_bit(R1BIO_WriteError, &r1_bio->state);
-               else {
+               if (test_bit(Faulty, &rdev->flags) ||
+                   (
+                   test_bit(FailFast, &rdev->flags) &&
+                   (bio->bi_opf & MD_FAILFAST) &&
+                   /* We never try FailFast to WriteMostly devices */
+                   !test_bit(WriteMostly, &rdev->flags) &&
+                   md_bio_failure_error(r1_bio->mddev, rdev, bio)
+                   )
+               ) {
                        /* Finished with this branch */
                        r1_bio->bios[mirror] = NULL;
                        to_put = bio;
+               } else {
+                       set_bit(R1BIO_WriteError, &r1_bio->state);
                }
        } else {
                /*

Thanks,
Akagi

> Thanks,
> Kuai
> 
> 
> 

