Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C6DECDB47E
	for <linux-raid@archiver.kernel.org>; Thu, 12 Oct 2023 17:38:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347459AbjJLRih (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Thu, 12 Oct 2023 13:38:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347453AbjJLRiY (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Thu, 12 Oct 2023 13:38:24 -0400
Received: from mail-il1-x136.google.com (mail-il1-x136.google.com [IPv6:2607:f8b0:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56A3F1B2
        for <linux-raid@vger.kernel.org>; Thu, 12 Oct 2023 10:37:15 -0700 (PDT)
Received: by mail-il1-x136.google.com with SMTP id e9e14a558f8ab-3574c225c14so1604225ab.0
        for <linux-raid@vger.kernel.org>; Thu, 12 Oct 2023 10:37:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20230601.gappssmtp.com; s=20230601; t=1697132234; x=1697737034; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3fP3PSonxE3b8oN/BrMP7MMUuVcreoUisJQQ+xM9c3I=;
        b=yihVtJExzlvPa/22vOLkX6Zvi/GIkVj1OEBRAp0KS1iJYbPzGLGaRr0x9YXl1HXFHo
         pkzbmKy/91wGBjs/hCSIAOyN7Te2SengX8z84hulcwHEOwfa3aQWUWdappypkH9MIN79
         Z8+1Kwz0rJbevaYxGYwNRJ2ZcvTH2kQoTvGNR+DUkZ1mvtADOOG8D01HKDz6qSCpOs7R
         rU4GKkEPXX110jL4vNZ1JtfE64qO9f42Hfe305REQdnX/wYhdsQCq2XIeOniWgcDadOc
         dc/jGLVGDx6PyOsM+9KbwdyhN1L06AkD56TnLItSPK5VgHeU3gmV7JqH10r2fnvqTVg2
         HDlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697132234; x=1697737034;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3fP3PSonxE3b8oN/BrMP7MMUuVcreoUisJQQ+xM9c3I=;
        b=qs2Ay1YWFAokHVBdlj+O+0w16Ikm+upgjdRxGesWaA1Cg+UNsurcovBdYkTj6C2Dxh
         JofQ/7gNSvMoAgdvs97GXvOSdTI+8I+zZllLw+Vw/upGGQbW2jja3uKyuVBavitG1Y40
         1sHz7nCtVD4BQE+Ifxx0lui2CiNOjqi9QRTKwysXL3ES7t/C34ZoyJm5oJrTR0qw/QAc
         twv6oRcyOfdBDip3Cyd+p3h2PwXuy5fC344Eu5cVKiKnsZeHbLCxlsO9DTcNHX49tT+W
         zm4z3YXqUDx4O3oo4YWGs8DospBRYeb22lQ1HZSSJUs8NQYc7otPYkOAjqsa8F8SbgE4
         S5eg==
X-Gm-Message-State: AOJu0YyVivsB4VivBlkNLNfUQC/BSXDBiqdKyfHU4oIZxGJQWZuEKD0l
        VQVixFItSYAYWoCQKScTkMiZwA==
X-Google-Smtp-Source: AGHT+IHb0inN/olr/9Ui1zD+9z4EOPwxufTCX8yKF1EdfGSxJRk9IlFKIYZDcMuWO0z1LtzNf6kLfA==
X-Received: by 2002:a05:6602:2e03:b0:792:6068:dcc8 with SMTP id o3-20020a0566022e0300b007926068dcc8mr32138507iow.2.1697132234578;
        Thu, 12 Oct 2023 10:37:14 -0700 (PDT)
Received: from [192.168.1.94] ([96.43.243.2])
        by smtp.gmail.com with ESMTPSA id fx17-20020a0566381e1100b004317dfe68e7sm3994713jab.153.2023.10.12.10.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Oct 2023 10:37:13 -0700 (PDT)
Message-ID: <29275e05-21f5-4003-acda-59948bf9c4f0@kernel.dk>
Date:   Thu, 12 Oct 2023 11:37:11 -0600
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [GIT PULL] md-next 20231012
Content-Language: en-US
To:     Song Liu <songliubraving@meta.com>,
        linux-raid <linux-raid@vger.kernel.org>
Cc:     Yu Kuai <yukuai3@huawei.com>, Yu Kuai <yukuai1@huaweicloud.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
References: <93D0A7F8-B4DF-43B1-983A-27DF9BF33663@fb.com>
From:   Jens Axboe <axboe@kernel.dk>
In-Reply-To: <93D0A7F8-B4DF-43B1-983A-27DF9BF33663@fb.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 10/12/23 12:33 AM, Song Liu wrote:
> Hi Jens, 
> 
> Please consider pulling the following changes for md-next on top of your
> for-6.7/block branch. The major changes are:
> 
> 1. Rewrite mddev_suspend(), by Yu Kuai;
> 2. Simplify md_seq_ops, by Yu Kuai;
> 3. Reduce unnecessary locking array_state_store(), by Mariusz Tkaczyk. 

Pulled, thanks.

-- 
Jens Axboe


