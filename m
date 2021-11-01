Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EC79C433EF
	for <linux-raid@archiver.kernel.org>; Mon,  1 Nov 2021 13:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0963561051
	for <linux-raid@archiver.kernel.org>; Mon,  1 Nov 2021 13:39:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232050AbhKANmR (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 1 Nov 2021 09:42:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45324 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231741AbhKANmR (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 1 Nov 2021 09:42:17 -0400
Received: from mail-ua1-x92a.google.com (mail-ua1-x92a.google.com [IPv6:2607:f8b0:4864:20::92a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 018CFC061714
        for <linux-raid@vger.kernel.org>; Mon,  1 Nov 2021 06:39:44 -0700 (PDT)
Received: by mail-ua1-x92a.google.com with SMTP id q13so31945651uaq.2
        for <linux-raid@vger.kernel.org>; Mon, 01 Nov 2021 06:39:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=TuJDg/bfViSm0qDx9yfbZqWLFZ6GGaPVKPd4ZqVbMbs=;
        b=i9YqG/J/6UhvjK8KmJ9hNjD6PE/4qOafgrsoWREXSqocz4HCLrD1ZAA4h5hBTde1Ni
         w9E88LS4HaSzYcHAOY2E/F4E+OYTf0zrUoA9p21PuNYSxwl4Ju6d0rGOUPIaLxDqw9Hq
         uAcOHaQMGiSWei7w1ay1htt3eQUgn4rt8/XkkI6XMrPa6GNeDZ/MIk/8GiJChuNp3Ixd
         oJE+6aWMpZC7gUYYfSjlHh3fTqf+pFBEWE5Cr19pqjIUaG7Hjga0aPvdCxdScWxO3tRg
         bIB2maY9biVpRCsqrwpKgMAZaU/IEFjWRZhZwsv/MbQXCTzQq7rspT2mjb6zln6eKp5s
         xbxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=TuJDg/bfViSm0qDx9yfbZqWLFZ6GGaPVKPd4ZqVbMbs=;
        b=bpj3MpncosjWBH70q2zvykDfRkGzXoZvTz7oV+Jnw90OR/3F2JimN0Qh4IBKD4rHxU
         /Pm+0W01vigoBR5pR9Pdzwxpmi6Zzyjpkx3L2ijkjAQbr5BORO5fsKJ/+pbdEdOmu419
         9ptOXK20xOR6CgOriqayc7EG8K+IGXnPc8yKm2FGPiKJ7AflKmR0RqlxTWdBF3UZzeW+
         H7Dba6JrfMNmAxTyHOrjHn/7YS8qeh5YER20RpqLdwfHJfa74NlK/ijv4qV30aTDWGxs
         zfPodyqyWYYLha0QhZ5w/akCansc2cX6twE8YugUf1tQy4ILe1nnqBc+SnwF2eu5QDcK
         yarA==
X-Gm-Message-State: AOAM530DvTznUnSkD2qvHKY4KYlfl8O7PGaU2IQImXwJpjadcoqyZYIG
        kHxdM8StF4waR5t14mehT/r31zHE/UKSsK0fAbZDFz6e
X-Google-Smtp-Source: ABdhPJwSrYh/+9VkE4f1NddOHnQl/gyTfXCXQQr7HgPQBKPCs6MgRmCpnwV2DuVsbUSYyCU/yBeqnCDwpEjc1FQfqmo=
X-Received: by 2002:a67:ae47:: with SMTP id u7mr29818781vsh.7.1635773982968;
 Mon, 01 Nov 2021 06:39:42 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?David_Bala=C5=BEic?= <xerces9@gmail.com>
Date:   Mon, 1 Nov 2021 14:39:29 +0100
Message-ID: <CAPJ9Yc-GCDULcgBtM3OcghouLnHQtKD=Z4bK4+tJFj_SYu3YVA@mail.gmail.com>
Subject: Behavior for read errors during rebuild?
To:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi!

What is the (default and possible non-default) behavior in the recent
version of MD code when a read error is encountered during a rebuild
(a failed drive was replaced with a new one and a rebuild is started).
Is it added to the badblocks list? Something else?

Primarily asking for raid5 , but information about other array types
is welcome too.

Regards,
David (not subscribed, but will look into the archives now and then)
