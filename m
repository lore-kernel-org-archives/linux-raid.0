Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64AFBC77B73
	for <linux-raid@archiver.kernel.org>; Fri, 26 May 2023 22:38:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230372AbjEZWi0 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 26 May 2023 18:38:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229716AbjEZWiY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 26 May 2023 18:38:24 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 754CF9C
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 15:38:23 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id 98e67ed59e1d1-2562b1b1af0so226336a91.0
        for <linux-raid@vger.kernel.org>; Fri, 26 May 2023 15:38:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20221208.gappssmtp.com; s=20221208; t=1685140703; x=1687732703;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=NCBcIK81qyzpETvxM2zYvDftpceqYk8XdxslMadazjU=;
        b=O2hAgTgXanTqcj9joUhSjNSTmtfhGblZnIj+r+e6bydEHH2LhECMjlOEJKgST7x6b3
         aM3BVK/3gg0HSzVRDENXrxGNGrJtXffrubScD6h/EcNCkE0B8PTUSK5utnmT6ffVgy82
         2eAiIhJqpNmQTZTpUmZgPBfMOhXpjoMGQS5h7nXwEksgCOPzCS1IURUfhye6URZxy0Wb
         1c1xhyMMUW9bnDuEfhVoi5UzKVkOtWjvs8dqiGhtioCwHJwIQP7HlPdUt62hNQingTUM
         6Dhcwajw+XaXRs/s0TcytY/OlsM1H5mbIxk0Q1OmxzO61UX7cUGJYTOWUjtmb7fv3985
         3b2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685140703; x=1687732703;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NCBcIK81qyzpETvxM2zYvDftpceqYk8XdxslMadazjU=;
        b=hvKXPUBp6cP0tpScJlV/EHGFt1Z2zDxoiqPpjlMH9X56nBXVO1m/Iwh/BjKP513ilY
         Gz1UlBSDvry+jWF4wXGjiRPHGd/OjWNxgTz+71UkBrRQUylU5oZtIuaYUZrtlQCN+dJE
         PHI6w/qA61dKEovcbcFhsuGlKN8snhUqnacdOxB+23ZJYjxxGWj9Gw+oPy0ZPL5obVBi
         YOHcVGqoXI8LDrMy6rPG1+MoEOwy9ttQhJq9G7nl72Kxx/pft5fkEVIxWsS9IE1tCuPj
         bgO6b3AMI2qzZuR0ksfCdDt2EJDa0ZaTWJQZPjfBB7w/nceHEHZPKvDQeY0/AGocOPak
         k6+g==
X-Gm-Message-State: AC+VfDzuTvkWaBoASAIBnfVW1x520WSEY07FEyzHU53+x/LBMi+ZxWcL
        x3v5nR8MIhQSeEwNVti6O0SSjpvV0BYRnxaRdro=
X-Google-Smtp-Source: ACHHUZ7+5dBv2EB9CkD1X9FZ5vmTg8xls3SI0SZytQSt3WZmWTgSWR//G9UehrwPnezKytvIPXoAqg==
X-Received: by 2002:a17:90b:3e8e:b0:252:b342:a84a with SMTP id rj14-20020a17090b3e8e00b00252b342a84amr4740457pjb.0.1685140702880;
        Fri, 26 May 2023 15:38:22 -0700 (PDT)
Received: from [192.168.1.136] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 27-20020a17090a031b00b00250c753b889sm5393567pje.23.2023.05.26.15.38.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 May 2023 15:38:22 -0700 (PDT)
Message-ID: <e67cfba9-82ca-f1ad-98eb-43baaa66be9d@kernel.dk>
Date:   Fri, 26 May 2023 16:38:21 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux aarch64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [GIT PULL] md-fixes 20230524
To:     Song Liu <song@kernel.org>, Song Liu <songliubraving@meta.com>
Cc:     linux-raid <linux-raid@vger.kernel.org>,
        Yu Kuai <yukuai3@huawei.com>
References: <3D58B70B-92D3-4355-A89D-0F6490448546@fb.com>
 <CAPhsuW6V0dQkGov7rxhUhuj5sf38YNUmPoin0sxP3=MnYDdZKw@mail.gmail.com>
Content-Language: en-US
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <CAPhsuW6V0dQkGov7rxhUhuj5sf38YNUmPoin0sxP3=MnYDdZKw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 5/26/23 3:15 PM, Song Liu wrote:
> On Wed, May 24, 2023 at 12:03 PM Song Liu <songliubraving@meta.com> wrote:
>>
>> Hi Jens,
>>
>> Please consider pulling the following change for md-fixes on top of your
>> block-6.4 branch. This change fixes a raid5 regression since 5.12 kernels.
>>
>> Thanks,
>> Song
>>
>>
>>
>> The following changes since commit 3eb96946f0be6bf447cbdf219aba22bc42672f92:
>>
>>   block: make bio_check_eod work for zero sized devices (2023-05-24 08:19:26 -0600)
>>
>> are available in the Git repository at:
>>
>>   ssh://git@gitolite.kernel.org/pub/scm/linux/kernel/git/song/md.git tags/md-fixes-2023-05-24
> 
> Just realized that I forgot to update the repository address. Ut should be:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/song/md.git
> tags/md-fixes-2023-05-24

Pulled, thanks.

-- 
Jens Axboe


