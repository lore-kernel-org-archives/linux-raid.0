Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7C8AC47089
	for <linux-raid@archiver.kernel.org>; Wed,  7 Dec 2022 16:43:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229778AbiLGQnu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 7 Dec 2022 11:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229868AbiLGQnt (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 7 Dec 2022 11:43:49 -0500
Received: from mail-il1-x135.google.com (mail-il1-x135.google.com [IPv6:2607:f8b0:4864:20::135])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B43025D6AE
        for <linux-raid@vger.kernel.org>; Wed,  7 Dec 2022 08:43:47 -0800 (PST)
Received: by mail-il1-x135.google.com with SMTP id h17so8076978ila.6
        for <linux-raid@vger.kernel.org>; Wed, 07 Dec 2022 08:43:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kJ8Ay+PB284aY3NVmhw3n5NaBjbrOxQtEAJy+RGXMRM=;
        b=Ny7BzO6Z3MS2ZJ0cRncx8Fzd5LXVeD1NHgtDeyn6MJ6xVu5o3y5OWYJZCvUtEgjKRk
         UNUPyxK+q6Ys/IktM1+7HYWPvLZRwL1iJmxg5fEtG7dBfn8iQ0DETRblKzR4UnQC+HtJ
         k1VqyES/CL5JZBKrXcVioYud0xilCvP+oC8W5LQkl0ZmVqdFxLYxqIzDNxweoqMHg6FN
         ljqwW+AfkWgOjuNLzw4HiWU6wW5KlGdJjq4azTIVo0fK02r4j5WyJaFN/7wYQhkwyBjs
         lLuD782mA4hJl4Gw17g9BhZiCbWyGJKUIkg0swDfu8lfl7B88IJiGrKlSmUDGnmKJ+sH
         5kug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:date:message-id:subject
         :references:in-reply-to:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kJ8Ay+PB284aY3NVmhw3n5NaBjbrOxQtEAJy+RGXMRM=;
        b=qpPmiXwlUa777j6ZJXTimKVqfOz2+fKqMMzhnZwSxa3DhIfiWriyiiAS5OvCUFgP91
         11e4trNRBWjNbtHKhQE4lIu4KlnB1YkIWOEMBCA+VNQGtwjSHVaXwMytELL3EU7O1R3u
         6Xt/HfEqx9DRh5a2h2Bcdpwk/BbUSk/kFUmV3HSgKv1XGTWhbX5JwqvuLQy+dpsWsG7v
         I92izvRUkJV94AgdNJNv7K/qO3F5rhE2O00Uz2yjT893OFdlbh9O37+GnteZOsACqegf
         wMAiVxiOYmAtjMQcb9RK82n+THjh4BMPmVmLE1EO1OJxUdicA3PG1nhv05FYQ7H+q603
         +B3A==
X-Gm-Message-State: ANoB5pl/+3GOVnkIunF9c1jKaUSHhJNcHc/Wk7FfyZqH2Uvr8Vn0tg2X
        hd/U4HUHlYCWhRDWQRa09dfEsA==
X-Google-Smtp-Source: AA0mqf7tWpWZtUh0xPnGJO9AZcQHA021bUAhGGmdDCkM2tthnOVB7XOHehMq1xO+VcDumIv8Vf9cvw==
X-Received: by 2002:a92:cc84:0:b0:302:489c:669 with SMTP id x4-20020a92cc84000000b00302489c0669mr34208447ilo.135.1670431427024;
        Wed, 07 Dec 2022 08:43:47 -0800 (PST)
Received: from [127.0.0.1] ([207.135.234.126])
        by smtp.gmail.com with ESMTPSA id e12-20020a0566380ccc00b003728cd8bc7csm7802731jak.38.2022.12.07.08.43.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Dec 2022 08:43:46 -0800 (PST)
From:   Jens Axboe <axboe@kernel.dk>
To:     snitzer@kernel.org, Christoph Hellwig <hch@lst.de>
Cc:     colyli@suse.de, song@kernel.org, linux-block@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-bcache@vger.kernel.org,
        dm-devel@redhat.com
In-Reply-To: <20221206144057.720846-1-hch@lst.de>
References: <20221206144057.720846-1-hch@lst.de>
Subject: Re: [PATCH] block: remove bio_set_op_attrs
Message-Id: <167043142630.172966.3660102879335248846.b4-ty@kernel.dk>
Date:   Wed, 07 Dec 2022 09:43:46 -0700
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.11.0-dev-50ba3
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org


On Tue, 06 Dec 2022 15:40:57 +0100, Christoph Hellwig wrote:
> This macro is obsolete, so replace the last few uses with open coded
> bi_opf assignments.
> 
> 

Applied, thanks!

[1/1] block: remove bio_set_op_attrs
      commit: c34b7ac65087554627f4840f4ecd6f2107a68fd1

Best regards,
-- 
Jens Axboe


