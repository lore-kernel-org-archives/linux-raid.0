Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47E1DC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  9 Feb 2022 21:16:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233066AbiBIVP7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 9 Feb 2022 16:15:59 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:41506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232999AbiBIVP6 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 9 Feb 2022 16:15:58 -0500
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7387CC014F32
        for <linux-raid@vger.kernel.org>; Wed,  9 Feb 2022 13:16:01 -0800 (PST)
Received: by mail-qt1-x82f.google.com with SMTP id g4so2368262qto.1
        for <linux-raid@vger.kernel.org>; Wed, 09 Feb 2022 13:16:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZG8/+6k4k1wQNeFFGAStRyzFmlXONQ6pjWoPjHvuI9o=;
        b=KcLX0qvkoE5/9bDgfyjTwtb5m2p2qtbg0RsJpl6VeO2MXrjL24AUSr3d4i189cw6hI
         BYdIts70M6XsCP4ZohJSQ9tVwcXC5zSWFtIcfb29d5K5EAwhkSxGWBCUisxu71MYZp25
         sx2yJ34giS3oMr7lFlTCjPbUkphd/ImDodZnHfv1B07DOCx0aFxsb6uWLWkPjiICXCfD
         koKVSigVve63jiHchowQ39VS8v14pZsOED5Ij0zNGm5bIa0/wD7qFsa3fej6a1JSYZ82
         r9lg0UBkuwBr8SmjsSo8214pYJRr+wIO96bb59gfgjns8i8sXTyLPUamLLY0noXTG6xr
         ip3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZG8/+6k4k1wQNeFFGAStRyzFmlXONQ6pjWoPjHvuI9o=;
        b=ww6EtkRk1YJtE2CDV0Ls9b20DTufQqw8GIPYMIQye1LtOVHNBqw/C0RVvhHNXHtS/m
         C2M+pSgabRFcuotNx4Hcv7F48Jx1lT4q55ZD+IUiKki/LUk8yrAwYz3TdoE/MaiHGH2f
         Mn6ib4hsjPPkmg4HpD1BiOQaqBTBU8v5Zg7XfMR+7B0QzByTACeSnCC4G7QCncx0M1WE
         O05KNVLQ8DBNPyqoip65O2LsbJUS+NaTWEPzMeGoUPAq/kXubB6EgwHZfkaGT1uTh5w2
         4ynjCv37/G+JCbBAnicNUIonvAdn6+0B5LBbcYWCobsa4yFQrWdsLmUEhAj6BLFVi+bO
         qTbg==
X-Gm-Message-State: AOAM5333r/h7R5cOkRkqjIU61yCDJaR5YloSZhcR+Iu0o3qFGseGqDxf
        xkTwLHxCTgOXZZQm1O+0tYyJ6vaQhLM=
X-Google-Smtp-Source: ABdhPJxFoWeg7ZayR0W7yVQJJDzp95greUKwo5SQCjImWll8XQjIiuIj4VFI6aRAgg7juDpW09fSAQ==
X-Received: by 2002:ac8:4d45:: with SMTP id x5mr2819824qtv.404.1644441360672;
        Wed, 09 Feb 2022 13:16:00 -0800 (PST)
Received: from falcon.sitarc.ca ([2607:fea8:c39f:f018::c39])
        by smtp.gmail.com with ESMTPSA id z19sm10000295qtj.77.2022.02.09.13.16.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 09 Feb 2022 13:16:00 -0800 (PST)
Date:   Wed, 9 Feb 2022 16:15:42 -0500
From:   Red Wil <redwil@gmail.com>
To:     Phil Turmel <philip@turmel.org>
Cc:     linux-raid <linux-raid@vger.kernel.org>
Subject: Re: Replacing all disks in a an array as a preventative measure
 before failing.
Message-ID: <20220209161542.544496ce@falcon.sitarc.ca>
In-Reply-To: <bb5b9cb3-8f74-3194-1193-2108a39d6cdb@turmel.org>
References: <20220207152648.42dd311a@falcon.sitarc.ca>
        <bb5b9cb3-8f74-3194-1193-2108a39d6cdb@turmel.org>
X-Mailer: Claws Mail 3.16.0 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 9 Feb 2022 09:57:25 -0500
Phil Turmel <philip@turmel.org> wrote:

> On 2/7/22 15:26, Red Wil wrote:
> > Hello,  
> 
> [trim/]
> 
> > Approaches/solutions and critique
> >   1- add one by one a 'spare' and 'replace' raid member
> >    critique:
> >    - seem to me long and tedious process
> >    - cannot/will not run in parallel
> >   2- add all the spares at once and perform 'replace' on members
> >    critique
> >    - just tedious - lots of cli commands which can be prone to
> > mistakes. next ones assume I have all the 'spares' in the rig
> >   3- create new arrays on spares, fresh fs and copy data.
> >   4- dd/ddrescue copy each drive to a new one. Advantage can be
> > done one by one or in parallel. less commands in the terminal.  
> 
> My last drive upgrades were done in a chassis that had two extra hot 
> swap bays.  So I could do two at a time.  I wanted to keep careful
> track of roles, so I started a replace after each spare added, to
> ensure that spare would get the designated role.  After it was
> running, I would --add and --replace the next.  After the first two
> were running (staggered), it was just waiting for one to finish to
> pop it out and start the next.
> 
> After completion, I used --grow to occupy the new space on each.
> 
> Took several days, but no downtime at all.
> 
> Phil

Hello Phil,

My current chassis is full (no space at all) but I found another
chassis I could use to temporary extend my chassis for the duration of
the swap by using two SAS HBAs and use all 22 drives at once. 

Thanks
Red
