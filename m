Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56EB0C64EC4
	for <linux-raid@archiver.kernel.org>; Fri,  3 Mar 2023 17:16:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231434AbjCCRQo (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Fri, 3 Mar 2023 12:16:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231489AbjCCRQZ (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Fri, 3 Mar 2023 12:16:25 -0500
Received: from mail-ed1-x531.google.com (mail-ed1-x531.google.com [IPv6:2a00:1450:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D82E821A0F
        for <linux-raid@vger.kernel.org>; Fri,  3 Mar 2023 09:16:22 -0800 (PST)
Received: by mail-ed1-x531.google.com with SMTP id s11so13052973edy.8
        for <linux-raid@vger.kernel.org>; Fri, 03 Mar 2023 09:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1677863781;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=0tI0lSbtCCvzReakyPxs9HaqgVhTnx5h3WqXQ7Jx8u0=;
        b=InEDKuVkBhx1glwkh/+LhwI8Q5ERfF8qq0AR1BsTUzNW6KUuE0509UI0xQVqScTqqK
         z3JzgNe0sPWabBoZMYNmCZ7O5k73VTaDLS8YKS//Pc2F+5iZ36cvTYRUkA+kBHXR0VDa
         aAwhJJ4QrUIH3C8dba3j2tbfSMMe289NuRWGFERcnX7d3zPPLDnBQgpni2UetezBQc6d
         lmfsmWWKXOYYcaIK5rP2DhKs+I1uA770de6ZyhwlEP9cC55IrVzxU7wUPQHE7HKouMgn
         PuXPmbgmBxN9Kf2zUb0IV1I2z4Cj+dayH09r1zOd7dvAOIuoXZa8KYfCyifqxktQ7fDz
         bI2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677863781;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0tI0lSbtCCvzReakyPxs9HaqgVhTnx5h3WqXQ7Jx8u0=;
        b=S16sF8QqB7kxJGd0oBUaG9LrGy5zJuGq76YGVtY9N1hw+2oNmh9ddE7wtNofc04yLf
         3oNn2Wip0E9SabOVbR0I2XRa/Cl6G7WurFR2hFbFruBxxYSkIF/8ELO/+ieDcEzz8TB0
         DN24eoYltpvGxdYFahwnM1GiG6ULV8Mg76psYbBPSaLRZTvqIfzPffJU7rx5ieGMdDDw
         1MvNwjOpIrB9LW64LL4Dq/bfySJa0pKh7/P2UyTXdi7Xsg6OGDPioJGjpbZCod8G7rj4
         Vw8F3AwhYedRPIVvBEEGnbSy4LR5OqbkcH351/qcrPE0MCPnxQs7MFXDLqe8Zev27Scl
         R3YA==
X-Gm-Message-State: AO0yUKXG5AmrHSXi5iqKAYIKYKcY/lFg/B5T2J5UucZwlQs+UVpSxpvU
        /VIjAer4C6Bzc6UoNNWEk/GxGvxSvLY=
X-Google-Smtp-Source: AK7set9Si0NGXxqcYwtj6ZYX8W5tu7Nbeh8pSwJiFX6uAnb3B95YX+9w8WueaZiJNkLdYutuYO33kw==
X-Received: by 2002:a17:906:a3c3:b0:8f2:5c64:d53b with SMTP id ca3-20020a170906a3c300b008f25c64d53bmr6511051ejb.24.1677863781280;
        Fri, 03 Mar 2023 09:16:21 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id v9-20020a17090651c900b008b2e4f88ed7sm1147998ejk.111.2023.03.03.09.16.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Mar 2023 09:16:20 -0800 (PST)
Date:   Fri, 3 Mar 2023 20:15:52 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     Roger Heflin <rogerheflin@gmail.com>
Cc:     neilb@suse.de, linux-raid@vger.kernel.org,
        cip-dev <cip-dev@lists.cip-project.org>
Subject: Re: [bug report] md: range check slot number when manually adding a
 spare.
Message-ID: <ZAIrSD6q1Zy2oF0b@kadam>
References: <e664f254-90a0-42df-8fc8-ad808f6dedeb@kili.mountain>
 <CAAMCDedsGtWcwe4KY9SgdciXoHYeM+YO4U7v-QCRnL5PqQTs9A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAAMCDedsGtWcwe4KY9SgdciXoHYeM+YO4U7v-QCRnL5PqQTs9A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Fri, Mar 03, 2023 at 10:09:50AM -0600, Roger Heflin wrote:
> On Fri, Mar 3, 2023 at 8:31 AM Dan Carpenter <error27@gmail.com> wrote:
> >
> > [ Ancient code, but you're still at the same email address...  -dan ]
> >
> > Hello NeilBrown,
> >
> > The patch ba1b41b6b4e3: "md: range check slot number when manually
> > adding a spare." from Jan 14, 2011, leads to the following Smatch
> > static checker warning:
> >
> > drivers/md/md.c:3170 slot_store() warn: no lower bound on 'slot'
> > drivers/md/md.c:3172 slot_store() warn: no lower bound on 'slot'
> > drivers/md/md.c:3190 slot_store() warn: no lower bound on 'slot'
> >
> > drivers/md/md.c
> >     3117 static ssize_t
> >     3118 slot_store(struct md_rdev *rdev, const char *buf, size_t len)
> >     3119 {
> >     3120         int slot;
> >     3121         int err;
> >     3122
> >     3123         if (test_bit(Journal, &rdev->flags))
> >     3124                 return -EBUSY;
> >     3125         if (strncmp(buf, "none", 4)==0)
> >     3126                 slot = -1;
> >     3127         else {
> >     3128                 err = kstrtouint(buf, 10, (unsigned int *)&slot);
> >
> > slot comes from the user.
> >
> >     3129                 if (err < 0)
> >     3130                         return err;
> >     3131         }
> 
> kstrtouint is string to unsigned int, it has this code:
> 
> if (tmp != (unsigned int)tmp)
> return -ERANGE;
> 
> And so will not return a negative number without an error, so 0 is the
> lower limit as enforced by the function.

Some of what you have written is correct, but your main conclusion is
wrong.  The kstrtouint() gives you unsigned ints.  If you take a very
large unsigned int and cast it to an int then you get a negative value
so the underflow issue is real.

Btw, in more modern code we would write:

	err = kstrtoint(buf, 10, &slot);
	if (err)
		return err;

It still has the underflow issue...  I have been wanting to say that and
resisted saying it because it was obvious to everyone.  However I am
only human and can only resist the temptation to point out the obvious
for so long.

regards,
dan carpenter

