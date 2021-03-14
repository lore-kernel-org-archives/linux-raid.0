Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22CDFC433E0
	for <linux-raid@archiver.kernel.org>; Sun, 14 Mar 2021 19:39:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D3B9864E7C
	for <linux-raid@archiver.kernel.org>; Sun, 14 Mar 2021 19:39:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233143AbhCNTig (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 14 Mar 2021 15:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229870AbhCNTiF (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 14 Mar 2021 15:38:05 -0400
X-Greylist: delayed 1851 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 14 Mar 2021 12:38:04 PDT
Received: from letbox-vps.us-core.com (letbox-vps.us-core.com [IPv6:2a0b:ae40:2:4a0b::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05CFBC061574
        for <linux-raid@vger.kernel.org>; Sun, 14 Mar 2021 12:38:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=2017.lechner.user; h=Content-Type:Cc:To:Subject:Message-ID:Date:From:
        In-Reply-To:References:MIME-Version:Sender:Reply-To:Content-Transfer-Encoding
        :Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BO7eCsfyFEY4SCWdH/daXphrt+XT8qT6CXHoDHjFxEQ=; b=KcmVrVlrKrGj2+y8ba67g6HAmU
        y9DiSM2/dVjpoA0yyUW2OlhtEsAA9xMuyyZE1FSMFZ+W4KmVD7zoUPQQ/hcoZlxSdHMV3ZnI/ftez
        gGSo4k98Vor2FmaU/YXAEja/MGvZm9cCaL3uJObBCjXrI/vbKUJGsAoQpbPT9GqGsFb8=;
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=debian.org; s=2020.lechner.user; h=Content-Type:Cc:To:Subject:Message-ID:
        Date:From:In-Reply-To:References:MIME-Version:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=BO7eCsfyFEY4SCWdH/daXphrt+XT8qT6CXHoDHjFxEQ=; b=4trFCuP+dUvweJNNZ073ZeuvZl
        MEo245vvORdgp+G3huqmassSW48M+Z+54n+m50dLcHIU3LPlj8L6MqeWqkDQ==;
Received: from mail-oi1-f173.google.com ([209.85.167.173])
        by letbox-vps.us-core.com with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <lechner@debian.org>)
        id 1lLW50-008n74-My
        for linux-raid@vger.kernel.org; Sun, 14 Mar 2021 12:07:10 -0700
Received: by mail-oi1-f173.google.com with SMTP id d20so32401366oiw.10
        for <linux-raid@vger.kernel.org>; Sun, 14 Mar 2021 12:07:10 -0700 (PDT)
X-Gm-Message-State: AOAM533QM34yX35HNlWMcuz5oP7/FLB0GmABch5L84zzRLW9alkcXYUy
        W3KY9ULcRETmgUjRK70UBsJy5cf4i+OXG+tCVHY=
X-Google-Smtp-Source: ABdhPJznVYc6aqgMBq3VfO6dTptXsJxmi92u6lOKogpv0m5ZIcPNKVnMlFQji9H5IoAXs9Cia8nXYaO5HelVO1XJb5E=
X-Received: by 2002:aca:31d7:: with SMTP id x206mr15535054oix.178.1615748830189;
 Sun, 14 Mar 2021 12:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <de867ab3-9942-77a0-c14d-dbfc67465888@linux.intel.com> <2cb77cb7-468d-88ed-a938-63b35e574177@trained-monkey.org>
In-Reply-To: <2cb77cb7-468d-88ed-a938-63b35e574177@trained-monkey.org>
From:   Felix Lechner <lechner@debian.org>
Date:   Sun, 14 Mar 2021 12:06:34 -0700
X-Gmail-Original-Message-ID: <CAFHYt55AVTz2U1kZOw0wb0xUp7Gr1W=XOjzrn2Kg+sU2h9YDKQ@mail.gmail.com>
Message-ID: <CAFHYt55AVTz2U1kZOw0wb0xUp7Gr1W=XOjzrn2Kg+sU2h9YDKQ@mail.gmail.com>
Subject: Re: release plan for mdadm
To:     Jes Sorensen <jes@trained-monkey.org>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Jes,

Congratulations to the birth of your daughter!

On Tue, Mar 2, 2021 at 7:38 PM Jes Sorensen <jes@trained-monkey.org> wrote:
>
> I am not aware of anything major pending

Please allow me to mention a fresh, critical Debian bug [1] with data
loss when /proc, /sys and /dev are not mounted.

I assumed maintenance recently, and the Debian package lags behind
your development status. Perhaps this issue was already addressed.
Thanks!

Kind regards
Felix Lechner

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=982459
