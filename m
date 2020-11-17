Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=BAYES_05,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30514C63777
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 02:43:54 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C7D14246A4
	for <linux-raid@archiver.kernel.org>; Tue, 17 Nov 2020 02:43:53 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="pKSmvuQ5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725994AbgKQCnu (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 16 Nov 2020 21:43:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725554AbgKQCnu (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 16 Nov 2020 21:43:50 -0500
Received: from mail-lf1-x12d.google.com (mail-lf1-x12d.google.com [IPv6:2a00:1450:4864:20::12d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06BA4C0613CF
        for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2020 18:43:49 -0800 (PST)
Received: by mail-lf1-x12d.google.com with SMTP id e139so8603058lfd.1
        for <linux-raid@vger.kernel.org>; Mon, 16 Nov 2020 18:43:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=WeV+JVOkEmNTDp4jy1ZY4oZElCBz4q7DQiSfSHKoqUY=;
        b=pKSmvuQ5NyGfGT6QRdy+5nCDTnt+jx9zwrhlgYISMOIPn4CZ+5BsFpNv3WZsGktD69
         vhK12zqmaWOY3T+xEORutprRu+PdhQa9jHfO2yDXwe78L0/LVaBRMMAAB1OMIfJt/wzU
         jXaZ48Xjcy1IeLGRaqeAaVGWOgcLl+Qq2/7BP1ABcjuLSv6SgGsLuQu6AC1KUmvvBMiC
         PX/WgkfibTsOmN2FM6Q7iJ5qfsoyqRiRiX0WP9XN1uQFZeAtB2Xjz9snmKituTLx90pz
         4jMJxoimfvXJ1FsFhQnVdKbHGYhgznlUcXe3eUhATHQ5mdnqf96D0eQ6FJ/Txl/IH8Wm
         uWIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=WeV+JVOkEmNTDp4jy1ZY4oZElCBz4q7DQiSfSHKoqUY=;
        b=kDekMG9FFXj931P0y5pYb8tKq0wn5t8RK+UpT/YdBlhkSbt11ce7cq2QrvLB+QnBZk
         wb9nVHvMxVv2fRQNrYCMVqtWDi9S7WblBcMJyWfHdtDJj5ZRRoMEQBRuWExsRhJkzu8N
         Q2u3RvO+Js4OnJBQjGI+Og4nCJiDLLxkeMYc0vr2vQShMOUiWUq/UdXSGgwsToFBNK/z
         N7tIvp2KZxGSlsD8PNSpnsnebp1kpmqu2PTU71EJTdjRTQA2EXJznkiqjPW1C2/AocIb
         yGgH8IkVgP75V4pUNUl0gZKglAmD877TrXagJARrD4wxqMyOzLBWcV531Xsd9P+quCy2
         qkLA==
X-Gm-Message-State: AOAM533r1f9BYCzU0w10fh8pRrNKlqNOKvs9DBfmWNyWSeXMRh+2Q0lT
        C4HTB5D6hW4yyxFabAfxaCntjqtypQyzkRGi5c1pTsDXJ2bTLg==
X-Google-Smtp-Source: ABdhPJxw7OzQbL7YZmh7kNRN2Q479TD6uaYs1dOsRFZbvYTyINWMCDWzzkChI/khpESgqXK+SIfLjefXcdHpbjFbKwo=
X-Received: by 2002:a19:e04c:: with SMTP id g12mr872502lfj.261.1605581028158;
 Mon, 16 Nov 2020 18:43:48 -0800 (PST)
MIME-Version: 1.0
From:   o1bigtenor <o1bigtenor@gmail.com>
Date:   Mon, 16 Nov 2020 20:43:12 -0600
Message-ID: <CAPpdf5-ji4YSMyCkwr8BRZLE4Jm8835TMOUfWGd2Xg6c=7TYBg@mail.gmail.com>
Subject: Information request
To:     Linux-RAID <linux-raid@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Greetings


I managed to delete a file that would require a lot of hours to replace.
(I would be entering all the information again.)

The file is located on a Raid 10 array set up using mdadm - v4.1 - 2018-10-01.
Am running Debian Bullseye (testing).

Looking for suggestions on how to recover the file.

Not sure what other data might be required for anyone assisting so if
more information is required - - please indicate.

TIA
