Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197D6C636CD
	for <linux-raid@archiver.kernel.org>; Sun,  5 Feb 2023 06:23:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229479AbjBEGXU (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 5 Feb 2023 01:23:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbjBEGXS (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 5 Feb 2023 01:23:18 -0500
Received: from mail-vs1-xe2e.google.com (mail-vs1-xe2e.google.com [IPv6:2607:f8b0:4864:20::e2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 495CE1C305
        for <linux-raid@vger.kernel.org>; Sat,  4 Feb 2023 22:23:17 -0800 (PST)
Received: by mail-vs1-xe2e.google.com with SMTP id 187so9574151vsv.10
        for <linux-raid@vger.kernel.org>; Sat, 04 Feb 2023 22:23:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=J965TV4QdB+aEIXqWJkUBs+LHQXtQO7JlrKUqHntLU0=;
        b=f6PiveBBw+xe1whLOXijn7aOY8gQtY5KKhYejFen+5V60D7vUD6ApKsnPRIL5YSugM
         3nT+Ux5LBkIuNLAIFIgChqqFrFMR87tNh0GmIhe5J+UuZila5372LnYyp118vvf/gSAm
         h0LB04qOQ3q5anALgERzfrIbz8z61VBWqkZ00F5/E/J7y4jBkIXVtycchYE19FeboP8R
         PP6QBKnViawE4q4bpS5Zq7DhNUrmF3zlpnsHyxvzLwReST0U3Im+9SFdOw5cLwoaSvLH
         jmdH3Y/z8gF2Ux+c28GDYQohVDMN5d9ARtZ8CE3j7439yEfFmNPEYoLSQomrK8uKacNk
         T51A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=J965TV4QdB+aEIXqWJkUBs+LHQXtQO7JlrKUqHntLU0=;
        b=uvaxkVz6ZCJM6PSKkEXzkfI8QYjDGQn/d+XjrkEKovtu5+Ogt+9pEcpbYxM83Eaa+j
         EztZqdRYZ2vZWI85DiDteV+EOvDTJ4vc7XdcmbxFcrwHB9rk+VSl20DH8yYUDc/w2zGx
         jpIC/yB019enLtOdGFRqP7SMb0+EW+bIh3/pg68aDgylLfOA/nrS9t1QXXAae09MEJVs
         uywpnlvbXfxZ5QlyBMOAYrTfm+wvHEeBhnJNSJZpuwP2S1kY/ON/4Ab+OR9REQR7coJy
         qGEEjIiUlTKNOLCeUf7KigdCLenc9mwG2m+SS6it7TsOBGepEnONOyoxCcOF7nn3ZUrC
         p7Hw==
X-Gm-Message-State: AO0yUKUav0DMQ8hI9HqftDURGqrcKS58+VGFrKsEBbYtvSizxuNuM/60
        DFOW/4zyhhMGcGRbhSCL3u2hCliLBPxii8QnxNoKZe7bTqZRDw==
X-Google-Smtp-Source: AK7set+uao4QWMbxhasqJngpO2X1/OLVZwBDWmOag161UJ6Se/+GaY4meiZzFFGCS30q+gl+cWVLC7BBJfGVOHQhMgM=
X-Received: by 2002:a67:fad7:0:b0:3f2:e3cf:522e with SMTP id
 g23-20020a67fad7000000b003f2e3cf522emr2472393vsq.67.1675578196120; Sat, 04
 Feb 2023 22:23:16 -0800 (PST)
MIME-Version: 1.0
References: <20230126021659.3801-1-kev.friedberg@gmail.com> <20230201095421.000033f0@linux.intel.com>
In-Reply-To: <20230201095421.000033f0@linux.intel.com>
From:   Kevin Friedberg <kev.friedberg@gmail.com>
Date:   Sun, 5 Feb 2023 01:23:04 -0500
Message-ID: <CAEJbB42309TzwmbpJKrgjX-7Q8JRUN+1W4i3NDUsxfrn6L=_Jg@mail.gmail.com>
Subject: Re: [PATCH] treat AHCI controllers under VMD as part of VMD
To:     Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Thank you!  Three weeks in it's stable for me (and I do have a backup
just in case). But that's just on my system and having this properly
tested, validated and hopefully merged would be much better.  This is
actually my first time working in C at this level, so any feedback is
appreciated.

Cheers,
Kevin

On Wed, Feb 1, 2023 at 3:54 AM Mariusz Tkaczyk
<mariusz.tkaczyk@linux.intel.com> wrote:
>
> Hi Kevin,
> Thank you for the patch. Please be aware that the RST is not officially
> supported on Linux. You are going to enable RST suppport using VROC Linux
> stack. You are using it at your own risk.
> Intel will review your patch and will run regression, it could take around
> month (sorry, we are getting back our labs now).
>
> Thanks,
> Mariusz
>
> On Wed, 25 Jan 2023 21:16:59 -0500
> Kevin Friedberg <kev.friedberg@gmail.com> wrote:
>
> > Detect when a SATA controller has been mapped under Intel Alderlake RST
> > VMD and list it as part of the domain, instead of independently, so that
> > it can use the VMD controller's RAID capabilities.
> >
> > Signed-off-by: Kevin Friedberg <kev.friedberg@gmail.com>
