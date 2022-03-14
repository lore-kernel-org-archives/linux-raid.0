Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51BE0C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 14 Mar 2022 14:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241035AbiCNOz1 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 14 Mar 2022 10:55:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240855AbiCNOz0 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 14 Mar 2022 10:55:26 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02C3943386
        for <linux-raid@vger.kernel.org>; Mon, 14 Mar 2022 07:54:17 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id y8so15220381edl.9
        for <linux-raid@vger.kernel.org>; Mon, 14 Mar 2022 07:54:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=knigga.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VYdFA9Ic8kFGAerGks/81xcvlCs3aa+kHuR0U4G4T5g=;
        b=df/GKA+OeA5j0t93FRlnPH9hDf/Msg9uLfBy+7/7kwa8PXDc4Qbdj6LYcL/8gHQYBG
         HJemAkLedUlvlHUG6kGvactH2PKyaRoX5ITORMXxA/ZvYKPPbxESqCmKo+a0exhE3Df6
         v+ZQ4YYoN25lzany6wAkRxWhexEffqGIq7R/4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VYdFA9Ic8kFGAerGks/81xcvlCs3aa+kHuR0U4G4T5g=;
        b=UAfyZjmwVygcS4bM5Gevr845TVvc5FgIv08BA1tnqsObo4tFbuS7uQUg6U2JrJZ8vj
         HW8sptjjb9bgqzHEuiLReg/bChzbT+1GQweZJY516RzNZ3TuqQAnNpGrwVU/vIW7ZAiW
         kwKPAa9jwEODZBRwmnCzkCZ4tY59SzVqLdHy4MlKDsVda4uBRvUm5J8sdgtt5C2AmlKI
         TVBMIh0w2yJkZr6OxljGRUYRxCgv4ANGP7tGkKnfGsiMVROU9ypfK5gIs3uYpcXWbqOR
         QETBUybkCwO6Ey/AMf05WFyCrio1MKO/q4WKmoImKy+Zz0186GTJa95umb1OA4QE9wvU
         QrBA==
X-Gm-Message-State: AOAM530ePzrXm878az/TuvkOSsTtgiO+If2Vt+zl+WHJ3mHM6bYGs20y
        lTPO0NtC2Q2niYe0nhERFDDYxEIUec+ixxZX/jbjOgVOjGG2E4JwlNc=
X-Google-Smtp-Source: ABdhPJzau2TDt34CFjY6Y4byiLQnkAR+ne5D+FlPX7L5Ocx4LIYq/HcoXqN6g4TPRN53tmPOqECxm1g6W2mih0u1YWc=
X-Received: by 2002:aa7:db94:0:b0:410:f0e8:c39e with SMTP id
 u20-20020aa7db94000000b00410f0e8c39emr20671996edt.14.1647269655419; Mon, 14
 Mar 2022 07:54:15 -0700 (PDT)
MIME-Version: 1.0
References: <CAKhSdW1zghNFqn2qemMZ7FJpiBcbAd0BcYifHmcM8WWPnai-=g@mail.gmail.com>
 <20220314115809.00007ac1@linux.intel.com>
In-Reply-To: <20220314115809.00007ac1@linux.intel.com>
From:   Kristoffer Knigga <kris@knigga.com>
Date:   Mon, 14 Mar 2022 09:53:39 -0500
Message-ID: <CAKhSdW3v-e6N8GA2Sq=qurACA9S1f5Bsf9pSq6oL1YH4aSR+=g@mail.gmail.com>
Subject: Re: mdadm is unable to see Alder Lake IMSM array
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Mariusz,

Thanks for taking a look at this.

> This is RST family product but mdadm implements VROC solution. Both
> products have same origin but now they are not aligned and as you can
> see, they may not be compatible at all.

Is RST support planned for mdadm?

> Here we have Sata remapping under VMD controller. I
> think that our mdadm implementation is not able to handle it correctly,
> we are assuming that it must be nvme device.

Out of curiosity, would you expect an array of NVMe devices to work?

This kind of programming is far outside of my expertise, but if
there's anything I can do to help an effort to add this support to
mdadm, please let me know.  I can provide more information about the
hardware, and I can build and run tests if that's useful.

Thank you!

Kris
