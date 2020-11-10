Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6407C388F7
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 06:38:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 94D942080A
	for <linux-raid@archiver.kernel.org>; Tue, 10 Nov 2020 06:38:25 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=cloud.ionos.com header.i=@cloud.ionos.com header.b="J3uGAhMP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728701AbgKJGiZ (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 10 Nov 2020 01:38:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726010AbgKJGiY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 10 Nov 2020 01:38:24 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9D66C0613CF
        for <linux-raid@vger.kernel.org>; Mon,  9 Nov 2020 22:38:24 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id 62so9282476pgg.12
        for <linux-raid@vger.kernel.org>; Mon, 09 Nov 2020 22:38:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloud.ionos.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XIYgjZhqRelF4kN4pNvLwvER0TJnmB2EBZHD2/c/pkg=;
        b=J3uGAhMP3owjY90mnY8p8yaIz13g0M+Iij8QbY9Qcryogle41ELOhDZBWo183cArqv
         ru2Te4K9hkW8WuVuoXh0sXCzkxvPOjtEYjnjPiHoqXvlflTNLnD9VmCR+Fcv+17voiFt
         Vs+hDiu4Uj6omkrYuBaaWPlzl9BdED4Bwnpf4ExQryTSQ/4MnrhafsWS/SdWiM1Cv8Ti
         dLH1ypukoeH6aIINldd/+0ohfClXQibrVLaQXMZvtaTHjg8OI11pHmui7IZppRXQ80Qs
         6HXUG4DtwGMmh4jL9qHpNk6aZR3vRMWDxLi1iypXNQva9/MqG2EP2fvIDHMGEVn/fYJ1
         sobw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XIYgjZhqRelF4kN4pNvLwvER0TJnmB2EBZHD2/c/pkg=;
        b=tte3Nt1MbCMGetqy/GcaNZEcrRzSRpp0tXAYS0FIqwtueGINVrJR/NfMJHylR6oHVu
         I8OslAWtT8Iu6A/yOiwbbuaSpbb4e+6KXhvj8ZxqIgehCdJOtW/P1HAYR7DwdaRIt2mp
         Z3SRmBIcEpwDtKqSM4jgcjSMWzhXg9wCzHQqXcVT7GWngmEe+mbsqCoQ8oVqsIJB0nmt
         wec/+uY9Gfgt+v8ZkE2/xg+VgIGLMG6VbcBbieCavAIMRHNBngTZKuRXcNOWMTW2Wcm7
         3453WMsv5tXZrOzCx2N8a1FCx7EJWVJG0s0DEzHc9Cyml81Qr8eeOYkG2eIlmBC8Qudu
         u2XA==
X-Gm-Message-State: AOAM532JnrSINrCM2ndGeJrAAR/WoHDnb5EIavYZCblDoNg56dpMAYrJ
        KTyGwZi+PSPDTlODqNEfXQnq9A==
X-Google-Smtp-Source: ABdhPJywJRBWaAlKLubbRC9q6zhcga8nOGknVupfdhUFenbh5DYy9XcxAYEt3TGv/a0/E0flj+Xpdg==
X-Received: by 2002:a63:a74b:: with SMTP id w11mr15938210pgo.425.1604990303034;
        Mon, 09 Nov 2020 22:38:23 -0800 (PST)
Received: from ?IPv6:240e:82:3:dd3e:4104:46a1:91e1:ec2f? ([240e:82:3:dd3e:4104:46a1:91e1:ec2f])
        by smtp.gmail.com with ESMTPSA id mp16sm1642413pjb.13.2020.11.09.22.38.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Nov 2020 22:38:22 -0800 (PST)
Subject: Re: [PATCH 1/2] md/cluster: reshape should returns error when remote
 doing resyncing job
To:     Zhao Heming <heming.zhao@suse.com>, linux-raid@vger.kernel.org,
        song@kernel.org
Cc:     lidong.zhong@suse.com, xni@redhat.com, neilb@suse.de,
        colyli@suse.de
References: <1604847181-22086-1-git-send-email-heming.zhao@suse.com>
 <1604847181-22086-2-git-send-email-heming.zhao@suse.com>
From:   Guoqing Jiang <guoqing.jiang@cloud.ionos.com>
Message-ID: <4a845cf6-3d18-1cc2-d8ca-620bc7bc8714@cloud.ionos.com>
Date:   Tue, 10 Nov 2020 07:38:09 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <1604847181-22086-2-git-send-email-heming.zhao@suse.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 11/8/20 15:53, Zhao Heming wrote:
> Test script (reproducible steps):
> ```
> ssh root@node2 "mdadm -S --scan"
> mdadm -S --scan
> mdadm --zero-superblock /dev/sd{g,h,i}
> for i in {g,h,i};do dd if=/dev/zero of=/dev/sd$i oflag=direct bs=1M \
> count=20; done
> 
> echo "mdadm create array"
> mdadm -C /dev/md0 -b clustered -e 1.2 -n 2 -l mirror /dev/sdg /dev/sdh
> echo "set up array on node2"
> ssh root@node2 "mdadm -A /dev/md0 /dev/sdg /dev/sdh"
> 
> sleep 5
> 
> mdadm --manage --add /dev/md0 /dev/sdi
> mdadm --wait /dev/md0
> mdadm --grow --raid-devices=3 /dev/md0
> 
> mdadm /dev/md0 --fail /dev/sdg
> mdadm /dev/md0 --remove /dev/sdg
>   #mdadm --wait /dev/md0
> mdadm --grow --raid-devices=2 /dev/md0
> ```
> 

What is the result after the above steps? Deadlock or something else.

> node A & B share 3 iSCSI luns: sdg/sdh/sdi. Each lun size is 1GB, and
> the disk size is more large the issue is more likely to trigger. (more
> resync time, more easily trigger issues)
> 
> There is a workaround:
> when adding the --wait before second --grow, the issue 1 will disappear.
> 
> Rootcause:
> 
> In cluster env, every node can start resync job even if the resync cmd
> doesn't execute on it.
> e.g.
> There are two node A & B. User executes "mdadm --grow" on A, sometime B
> will start resync job not A.
> 
> Current update_raid_disks() only check local recovery status, it's
> incomplete.
> 
> How to fix:
> 
> The simple & clear solution is block the reshape action in initiator
> side. When node is executing "--grow" and detecting there is ongoing
> resyncing, it should immediately return & report error to user space.
> 
> Signed-off-by: Zhao Heming <heming.zhao@suse.com>
> ---
>   drivers/md/md.c | 8 ++++++--
>   1 file changed, 6 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/md/md.c b/drivers/md/md.c
> index 98bac4f304ae..74280e353b8f 100644
> --- a/drivers/md/md.c
> +++ b/drivers/md/md.c
> @@ -7278,6 +7278,7 @@ static int update_raid_disks(struct mddev *mddev, int raid_disks)
>   		return -EINVAL;
>   	if (mddev->sync_thread ||
>   	    test_bit(MD_RECOVERY_RUNNING, &mddev->recovery) ||
> +		test_bit(MD_RESYNCING_REMOTE, &mddev->recovery) ||
>   	    mddev->reshape_position != MaxSector)
>   		return -EBUSY;
>   
> @@ -9662,8 +9663,11 @@ static void check_sb_changes(struct mddev *mddev, struct md_rdev *rdev)
>   		}
>   	}
>   
> -	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks))
> -		update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
> +	if (mddev->raid_disks != le32_to_cpu(sb->raid_disks)) {
> +		ret = update_raid_disks(mddev, le32_to_cpu(sb->raid_disks));
> +		if (ret)
> +			pr_warn("md: updating array disks failed. %d\n", ret);
> +	}
>   
>   	/*
>   	 * Since mddev->delta_disks has already updated in update_raid_disks,
> 

Generally, I think it is good.

Thanks,
Guoqing
