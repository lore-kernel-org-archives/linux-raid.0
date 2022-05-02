Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C4DC433F5
	for <linux-raid@archiver.kernel.org>; Mon,  2 May 2022 22:45:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231133AbiEBWsa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 2 May 2022 18:48:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbiEBWs3 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 2 May 2022 18:48:29 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772B1E08F
        for <linux-raid@vger.kernel.org>; Mon,  2 May 2022 15:44:58 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m14-20020a17090a34ce00b001d5fe250e23so574687pjf.3
        for <linux-raid@vger.kernel.org>; Mon, 02 May 2022 15:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=9Pev6TadqoPCvCslhpANrkqa0tRzANTdzEtaxAf0Hbw=;
        b=IO+ItVxTbHRREuluGK2fhmQblF4cgW5vavOTKIpFPkRROJX9gmuVnnXRYdROnlh0zK
         5E/tkPZJOY5b9uCPVSTrQo5ZT1qEvx0sCk9u5l6zkQG9tJNfyrMIAV++5Lw/q2Ftl4OP
         5q5eBsfs5slcB3cSP6ZXkHWEyjFQtO83O56Dk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=9Pev6TadqoPCvCslhpANrkqa0tRzANTdzEtaxAf0Hbw=;
        b=69F9QpUUxiJibbZefnEHntol4QO/5aIBADS1aRa8JtZvWOkky0r1dvemOWTOvdxZm1
         inPjT3rA4j/1188fZy/m4V8TShDwg25VcXPeO3KPOWLWKmo7owbWdIDEpU799ZdD85sG
         1wtDR2CIm20KUmnmiO5ykmb1mj3/KRDH0/5tejF8hCszwUCpnTqwVuqYYXEzO47eMNwJ
         SjvJqPNqBVC2ku8BUAIRFCSPiOuyEBNiw04lNOmp/5l4StYV9KypreDNsGFkwMTPGnR7
         XL+x41zWx7HnvYl3pW7orBygdkFAG1UUi+EuYLGt2HSaLtx35faV94ibjRRrllFLIdx1
         eQ8Q==
X-Gm-Message-State: AOAM530dw3TGUTR7314eTMPxzb8alXkXGE4vULNBLDgIgct3fZdm9sJe
        mGstYBML87AoRda2SBtUWuN0Jw==
X-Google-Smtp-Source: ABdhPJxhVHtiibpNcHj8mIUaI5q3jvfhB3UxBy63zLm72g4zQPjmd26WW0fmoc9EkpEka6ka3qUucw==
X-Received: by 2002:a17:902:d4c2:b0:15e:abd0:926f with SMTP id o2-20020a170902d4c200b0015eabd0926fmr4925055plg.129.1651531497972;
        Mon, 02 May 2022 15:44:57 -0700 (PDT)
Received: from localhost ([2620:15c:202:201:1e1a:955c:a9ca:e550])
        by smtp.gmail.com with UTF8SMTPSA id f3-20020a17090a654300b001d26c7d5aacsm218470pjs.13.2022.05.02.15.44.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 May 2022 15:44:57 -0700 (PDT)
Date:   Mon, 2 May 2022 15:44:56 -0700
From:   Matthias Kaehlcke <mka@chromium.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     Alasdair Kergon <agk@redhat.com>,
        Mike Snitzer <snitzer@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>,
        linux-kernel@vger.kernel.org,
        linux-security-module@vger.kernel.org, dm-devel@redhat.com,
        linux-raid@vger.kernel.org,
        Douglas Anderson <dianders@chromium.org>,
        Song Liu <song@kernel.org>
Subject: Re: [PATCH v2 2/3] LoadPin: Enable loading from trusted dm-verity
 devices
Message-ID: <YnBe6K72iKSDSqk9@google.com>
References: <20220426213110.3572568-1-mka@chromium.org>
 <20220426143059.v2.2.I01c67af41d2f6525c6d023101671d7339a9bc8b5@changeid>
 <202204302316.AF04961@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202204302316.AF04961@keescook>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Sat, Apr 30, 2022 at 11:21:54PM -0700, Kees Cook wrote:
> On Tue, Apr 26, 2022 at 02:31:09PM -0700, Matthias Kaehlcke wrote:
> > I'm still doubting what would be the best way to configure
> > the list of trusted digests. The approach in v2 of writing
> > a path through sysctl is flexible, but it also feels a bit
> > odd. I did some experiments with passing a file descriptor
> > through sysctl, but it's also odd and has its own issues.
> > Passing the list through a kernel parameter seems hacky.
> > A Kconfig string would work, but can be have issues when
> > the same config is used for different platforms, where
> > some may have trusted digests and others not.
> 
> I prefer the idea of passing an fd, since that can just use LoadPin
> itself to verify the origin of the fd.
> 
> I also agree, though, that it's weird as a sysctl. Possible thoughts:
> 
> - make it a new ioctl on /dev/mapper/control (seems reasonable given
>   that it's specifically about dm devices).
> - have LoadPin grow a securityfs node, maybe something like
>   /sys/kernel/security/loadpin/dm-verify and do the ioctl there (seems
>   reasonable given that it's specifically about LoadPin, but is perhaps
>   more overhead to built the securityfs).

Thanks for your feedback!

Agreed that an ioctl is preferable over a sysctl interface. I wasn't aware
of securityfs and prefer it over a /dev/mapper/control ioctl. Ultimately
the list of digests is meaningful to LoadPin, not (directly) to the device
mapper / verity. I'm not sure how well this feature of integrating LoadPin
with verity will be by the verity maintainers in the first place, it's
probably best to limit the LoadPin specific stuff in verity to a minimum.
I experimented a bit with the securityfs option, building it doesn't seem
too much of an overhead. If loadpin.c ends up too cluttered with the
verity and securityfs stuff I could try to outsource some of it to (a)
dedicated file(s).
