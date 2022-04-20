Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FE7BC433EF
	for <linux-raid@archiver.kernel.org>; Wed, 20 Apr 2022 12:24:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378505AbiDTM1G (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 20 Apr 2022 08:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378467AbiDTM1F (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 20 Apr 2022 08:27:05 -0400
Received: from sonic307-9.consmr.mail.gq1.yahoo.com (sonic307-9.consmr.mail.gq1.yahoo.com [98.137.64.33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38FBD403F2
        for <linux-raid@vger.kernel.org>; Wed, 20 Apr 2022 05:24:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=att.net; s=s1024; t=1650457458; bh=iiHKbgMiAHL56Y8MHrktA0CoW/mIksRWqBEgLAqt0EE=; h=Date:Subject:To:References:From:In-Reply-To:From:Subject:Reply-To; b=czpLvW4YRCUxiEQnQ7d6XKggZadg8qi8yW4L0rnU7Dscy4HS7mtdFGDi/gPNsM3bf30JVip1hCt+OqXPDYWKEmx2IkB+C34t0y95wCRWZ+7CBztjmAU5XkloCBDDJ7UUjPahcRhYUE513cIWHJtlz71jQX7T6Xnc9jEZ6PjY4uk=
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1650457458; bh=aEx45yBh0EChhe3u+9hqd5Xt4j95LmU6/E5d71ofVdB=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=MNC4C0bI0YL243PKu+bq3V32+PmGjHWa9Cq+x0KSaUJeLHeRWHxrGdj36RSNpXe7OmFLmJOF9rGf7bMZvrWErveDdJU8m8FvpIOJ6MtawJY8Dtls7gUz/s9t7pc4KlLnQoOtWAxjkdfKa1tQGgUjyGTXFn3DB6yxu5MTgEtXK8i/hITJ7pJcDuLCw8kYeKgaMLHZ5GUtod20wpHdyZuIxO9D3ENcEQV+rsrCiquFHBnbdbh0FP+2bV7RHkunMZ7euJiPrdNvk9zXP9iJanEi+WLx7bDlUX1pqoaDRZNDHhzCqtQTmHHAeRWutOYIEal/klXHq986Fgj4YMD6CVPVXg==
X-YMail-OSG: sxHy5CEVM1mEeVhKjtPjkW0MlF4r35zKamYiNYvl_VDkG4YNLXsMLWXB.edAXny
 JEBJcfB28jQS2AKiiqQZu4FMvRrLLfE_PXsxcoR_N4GCPj_b87vxgI0avEauxwwZOlAXSoY2FK1P
 4M9kh.MzOrNnjhlFpL0jNxCG6IMLsH0AWDXwYevGwwyJyYTq1H9m_bA8ffUlldKuZ4Eef.l8W9VO
 Zh0LNQ7gcypzyVq55YWXNfD4S.E534YHjpZZO2dUr9vteCn62vZ_H7MZYbBq6np7qlSLDm1BrKFt
 uHjJIO4hZtZAHpC7.99ITdSUybksF5oI4xX3hRAnqWaOMaAS1kfw3ausf0lxewBC62qMo8ePmJhW
 29DJ58wQKPxQmlCsoMXRNTa4FzilnKYfEuFPGJzzCSRbgXXhQv_DEvEnnLZ2h.oVqGv3y2N3K17d
 LTPcNTYIJ4nlAxgugaat66mURl3OzEpnA9QfHEn8ni5w8.e.xS18K0TyRTWwjosqdU2SI2X3bTuv
 3AiwDcr7FDfeNQwMkFP7gbWdPzKLXuxvmmVIsL5c.unrX0TXFACdF18tIIvMSlGmpCbQCKoRgoxE
 uAIaG9QBSXA9WLhalIgy6pbDa03F2Pv0NSABCEMgHexTjYhO8qgxFwRbLvM4YVmsV9KtNV1pueRf
 A6EJhIzYdM5iPHWpSEPkhuFoIyzVhI.wn6P8Fc7ydqHywJ98rf2R2rYl.bnfRWicqk0Ffv3Hj4C.
 WabS6h14og.FQUdsIwGcBKw1PGSm3ZM6YY1OFZIPK2rfV0yhL1XNgtgPi_.xzgTi4rwIFzX8Z1E.
 YGd95VULFNeEZMShA2cC7GT3LkpOQskuhg82nKdtXNqH851fbIiBTSVgcYwddGTzlJgQb8LRzYQi
 joDMA92kXTlJDvq7RAuQM9bAPVDoRrVEePTCvmj1oTJFtw.nPios6AjnczYcDA99TCYWo.dW4PLp
 mptCSuM_F7woW9hGsPX8ziUlMCdDOISeQVdJ25g.S_srFNEVnPQV6Sjfy.zORS4sAZZ3td5cN7.7
 uxJ67hYX7QkNP5hrpeBVfrUpgPmLFgz_KsTEXoxkYdoftf8gdQvX5TFOok7m8_vJrAy_95ETKMfp
 DLzPgrTXmgribJOo3SGT79_en0eb75chaEwHdwhV8hvT.QWA6RC3D4UUObmeDvCd2vW..B61xnZR
 FZbwXR25OhYadYVKhmgmKmG7_yY5LQsiJGAe3yGdP4WAayFTJ8xszVk9KbaI7NcXwQF6WVtM6IG5
 utIsPChHgpyfE_SqayXn91t2uxyC5zz1DJ8CzZ_eYSAfJVbpbvFnDS4XlHkVNFuO50PFZrC0h49t
 a6d7lzPVwY2IFqAxm5z7znK_ny0zfUaPQkA20_NpzAaWKQP.JN0kLbfDqkrvlah7eEjyXrUUmsYm
 M7RdGWfu2ElaLKJ9E4WHE0SSx6xedBZUV_VMjnNiCA8av5S4GNMuZ8D8b5poWHMrrfoSPtMxCbJs
 MA0hoDUIOm_4ozzcUbJ4jOJ7mSUecmjNmDE3WEXrXPJ55eFj0Wahp6A.98P4GrGLqsuFLA2JLwET
 4UYH4Ku873FsawtJq0M.VrsC.lBYNJuMddqjv_zemhFkl2t._LYusvKXPFmwJYyE0Ghn4pWxuzLS
 1I80p7zHdj3kKfTnOfeIaztGrziYFtt8yudH0hSDYnZyPlLwLA6MCyOn_EQcLb3IYB5xsgw6LkVr
 sFWIXjrp89d71gjUtM7oH0oRy0XGe2fAEBZXLaj_7vVQiiaakBmNTE9vlhjq7Rvx7eIICdbfmwmB
 bvjimrrD0TaKvyvHLd6a0Yttxh6e4ngeY9uCy_1WQUYmi6n7CoL_Uh03vJfrfsyEG4._fEf2wuCQ
 ae2D9v8289gizNtaVjQKNDMlcYVYRVKIivJRus0b2DxZS4ngQ3TJQbhHsrmXabMkWtI.twYdOz9O
 GGQr7FZViqeJlD6ldcnzniQPg9qrWjJLKTBmcSjmyueQrJZe2QGDitC4R2u9DT_cF8wB8jj4e0Xd
 OuGn3DxYMY.D1s1GI6MrW5xnQwJSpznAyK82AMYkzQLb0nuQskzPBg9uYxqrPVW03YYm7hmD34W9
 9ycxnQkwaG410LjKOgjQe84S7FT9bQydaQiDzLn1gdtlw86qfdugzqPwLjBAEo8i3uAsD1EqZ38t
 AmKCjZaoiRlR.kAB0wfcasAzYRwn0ryNvPR0Lyh3PIkAygkD_wiTxVdLJESfuR95fA9H0DbAqBY.
 NHSK7nhvuUr9qid2qi4BTbDO0ckGN4x8jizBPDG4gauwcxF07RMKyyxKn2NNIvY_V.BAz
X-Sonic-MF: <lesrhorer@att.net>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.gq1.yahoo.com with HTTP; Wed, 20 Apr 2022 12:24:18 +0000
Received: by hermes--canary-production-ne1-6855c48695-xzkwj (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 26dfd38715966ac9f6b57e06749edcb0;
          Wed, 20 Apr 2022 12:24:13 +0000 (UTC)
Message-ID: <6c3ff307-23b4-8ad5-9061-b6076ebd2195@att.net>
Date:   Wed, 20 Apr 2022 07:24:08 -0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: Need to move RAID1 with mounted partition
Content-Language: en-US
To:     Pascal Hambourg <pascal@plouf.fr.eu.org>,
        Linux RAID <linux-raid@vger.kernel.org>
References: <CAKRnqN+_=U58dT5bvgWJ1DgyEuhjsbmCuDL+xOLxmcuG1ML4qg@mail.gmail.com>
 <e3573002-05f3-3110-62a6-e704385f877f@youngman.org.uk>
 <CAKRnqNLjsX9nVLrLedo4tfxtg0ZBz=6XJu=-z_Ebw6Auh+oz-Q@mail.gmail.com>
 <8c2148d0-fa97-d0ef-10cc-11f79d7da5e5@youngman.org.uk>
 <CAKRnqN+21BZT1eufn962xiEDvnrBtk68dTBSLT1mx7+Ac2kJ+w@mail.gmail.com>
 <CAKRnqN+6wAFPf5AGNEf948NunA97MJ9Gy5eFzLCfX+WfHY72Pg@mail.gmail.com>
 <b5c0e119-0159-8566-1c6e-6d13b65b2f89@att.net>
 <20220420110810.x2ydoqhyeuocnrwy@bitfolk.com>
 <11e5dc60-1c00-4cfa-8b4e-ab0839a5fd9f@plouf.fr.eu.org>
From:   Leslie Rhorer <lesrhorer@att.net>
In-Reply-To: <11e5dc60-1c00-4cfa-8b4e-ab0839a5fd9f@plouf.fr.eu.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Mailer: WebService/1.1.20048 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 4/20/2022 7:07 AM, Pascal Hambourg wrote:
> Le 20/04/2022 à 13:08, Andy Smith wrote:
>>
>> On Wed, Apr 20, 2022 at 03:40:12AM -0500, Leslie Rhorer wrote:
>>> The third partition on each drive is assigned as swap, and of
>>> course it was easy to resize those partitions, leaving an
>>> additional 512MB between the second and third partitions on each
>>> drive.  All I need to do is move the second partition on each
>>> drive up by 512MB.
>>
>> I'd be tempted to just make these two new 512M spaces into new
>> partitions for a RAID-1 and move your /boot to that, abandoning the
>> RAID-1 you have for the /boot that is using the partitions at the
>> start of the disk.
> 
> I agree, unless the BIOS cannot read sectors at that offset.
> 
> Or you could create a RAID10 array with the 4 partitions if they have 
> similar sizes.

	They don't. 'Not even close.
> 
> Or you could move /boot back into the / filesystem.

	I would rather not.
> 
> In either case, the BIOS restriction applies and you may need to 
> reinstall the boot loader on both drives.

	I did so just for safety.  Whether it was actually needed or not, who 
knows?

> Or you could try to reduce the required space in /boot :
> - remove old kernels

I did that.  It wasn't enough.  Eventually I just moved the kernel files 
and created symlinks before completing the upgrade on one system.  The 
other got the resize treatment.

> - reduce initramfs size with MODULES=dep instead of MODULES=most in 
> /etc/initramfs-tools/initramfs.conf

	I didn't try that.  It probably would have worked.

> - remove plymouth if installed

	Nope.
