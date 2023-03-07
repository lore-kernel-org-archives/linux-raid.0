Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39DF9C61DA4
	for <linux-raid@archiver.kernel.org>; Tue,  7 Mar 2023 03:05:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229894AbjCGDFK (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 6 Mar 2023 22:05:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230176AbjCGDFJ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 6 Mar 2023 22:05:09 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD37743936
        for <linux-raid@vger.kernel.org>; Mon,  6 Mar 2023 19:04:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678158260;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=qQwG7mlsTIMwFYTr6+mvh+Zolyv8vO7M45n2Q/6JnuE=;
        b=cw4yUXLzTld44/g9WiCBNlpUoNlD+MeOormGmPNHMVoqMGwvQHQ5ndAIhTwwT8e/gmCN6h
        PIpk/hiZNRDEctvgEPtc/AZz3LGPII0nKt2SuD9XkRRf5arJKLqc4rSF0HByrpusxRvst+
        EQwt/nXqOKLvLsTqtPCbYOrzz+TyOQA=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-596-UkZjAo01Pz2yz6yR9idSXA-1; Mon, 06 Mar 2023 22:04:19 -0500
X-MC-Unique: UkZjAo01Pz2yz6yR9idSXA-1
Received: by mail-pl1-f199.google.com with SMTP id ju20-20020a170903429400b0019ea5ea044aso5237128plb.21
        for <linux-raid@vger.kernel.org>; Mon, 06 Mar 2023 19:04:19 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678158258;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qQwG7mlsTIMwFYTr6+mvh+Zolyv8vO7M45n2Q/6JnuE=;
        b=sFGefxxhmXcmcX41fHp+j7RUQqGzWC+yjWqTSsAy/HF2v8NpXBtUvydS1xuMqfgwdH
         pzsCzIxRWdNRlcDR9L1WWKf0DKEzIcZ0tI7rAvbAksz/eX4sP/BmvEkWqWFgX6T99yxU
         8ard2sI0BGBCIdAk/Ys1LH/BOJ90dl1QPhcf6KphURPbc2UKGFGWPbO80WCheev/LOjW
         BQq+NBCGiW+vTDEs9vx0Pj+6NCRjcx0umrG83WbWrvCyd4/CpDAFeRSALB65wQAALogA
         sX4okTcrqLi/H4YX3bTKkugaonTsBAVgKA2fWvfFE30nJY2V42c5AuftISIo8P69/EMy
         eVCQ==
X-Gm-Message-State: AO0yUKUND26JkhwLNfMVzDNwGdsoglo59ENmX6vBqDRBSfCn9MQzgp4A
        9Dd4fiZanz5T7vkDs7zDtELBN2d7LwDns0IGtpNCpAZdoFwIwjbIDWo7yJB+n3zZN61LMafsHxc
        pDK/TE7j0e82DbuCxGs120JKxdAFxck3ilsUTY66RgGUO6dFFkdw=
X-Received: by 2002:a63:ac53:0:b0:503:7be2:19a7 with SMTP id z19-20020a63ac53000000b005037be219a7mr4732542pgn.1.1678158258088;
        Mon, 06 Mar 2023 19:04:18 -0800 (PST)
X-Google-Smtp-Source: AK7set8ldKcrwWoNOfZMcNpHBIax4h88/A4WFrVKkAQded4pmhOo8O6plHFa5o8qyO787il6cbCr84GZ1kT5HNtbszo=
X-Received: by 2002:a63:ac53:0:b0:503:7be2:19a7 with SMTP id
 z19-20020a63ac53000000b005037be219a7mr4732539pgn.1.1678158257811; Mon, 06 Mar
 2023 19:04:17 -0800 (PST)
MIME-Version: 1.0
From:   Xiao Ni <xni@redhat.com>
Date:   Tue, 7 Mar 2023 11:04:06 +0800
Message-ID: <CALTww2-1B08z+BgPKqoBMnGQ-PhB9Yr=bA7YR7HyzGX0K127MQ@mail.gmail.com>
Subject: What's the usage of md-autodetect.c
To:     linux-raid <linux-raid@vger.kernel.org>
Cc:     Nigel Croxon <ncroxon@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

From the code of md-autodetect.c, it looks like it's used to create
the raid device
during boot. Now we use udev rules to assemble the raid. Do we still need it?
What's the usage of md-autodetect?

And in Kconfig, it depends on md-raid as Y when building a kernel. If we change
the default to M, md-autodetect will not work anymore, right?

Best Regards
Xiao

