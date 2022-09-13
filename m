Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B750DC54EE9
	for <linux-raid@archiver.kernel.org>; Tue, 13 Sep 2022 03:59:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiIMD7P (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 12 Sep 2022 23:59:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiIMD7N (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 12 Sep 2022 23:59:13 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556784D83F
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 20:59:12 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id d82so10531463pfd.10
        for <linux-raid@vger.kernel.org>; Mon, 12 Sep 2022 20:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=IxpXVW07TA1ADoTFPTKPrDHxv8R5QRqLzyHSctE47Bg=;
        b=DYwLm3Fw9+ht5hx5IrPRF069LetiJ8AeAFinWdHSW1aHtk1t7qDECajm88VHM+cMRP
         GnTMklKFWy4T8OH9f4wkCE2yA9E4OLhsIum2MZM0hjkVk6fRjMR7d4yG+MYplLtzMgam
         Aa6XGwwc5+wJQ+T1cMfQrxbQmJKJctu/wzC/zrezabYiGtix7zEj8Vrhl4TrOPgG2vee
         iHU89TnD9kxf93JPVHPcBAGDq7zk47nasS3El+hMDoaWeiqSXF3Ii6aRtL2fih2w+X7w
         8L5ifKppJlfA+6PoPqmmzexppQfdzTE5aVS+6IdpdGS8CryKpvkfVG5Rn7WPkiW4DEj8
         I+BQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=IxpXVW07TA1ADoTFPTKPrDHxv8R5QRqLzyHSctE47Bg=;
        b=ugt1/NEOKY3Y39RXVjQVHDJ0w03QFrvs/jd3ddaw8XIQCiQM5p2LhpKsS9COsrnkjZ
         gxyoCJ01Ma9Q8VYRgT1vVk6D1IIBFKYlSwegzHjJyn7s3GFlXUBry0YSIIlYGxy2sMIS
         0jbMpas1cklr2KxtJ8ZEb7g3iQSLvg6dx4iwDKsyhkO7qvrcbnZnKz/kNsoOPWhgjQll
         h3w84mvE+u5eb1JDEtssFgHfCzDL4awI4Y20uvyAAyk0Lyf2BlgQY8vW4TxjOXV34pDc
         fM3BHpR2bt0vUXM8CIBapOsVWxBtSSWlyHEUbJg45lsi5S5MpbybIy4aelbb2aZsPdZR
         aheg==
X-Gm-Message-State: ACgBeo1cDbqF6hjwBO3EKjUa45I2tKxqL2AXBgFwiDxfh5at/yZVe3Sz
        7rMQMhUsCQSBXHszELtRrJCw9fqKGGnIFscCxPxKzqh4
X-Google-Smtp-Source: AA6agR6xuI+EgtSondxc7d/Dm03qX29bmQNsgjbPW7D9KKoQ1dP4kBJc78nlSf+ek7l/O8ZTgR3gyi6dTsVYcYZ9IRs=
X-Received: by 2002:a05:6a00:24d2:b0:542:f6e3:e18d with SMTP id
 d18-20020a056a0024d200b00542f6e3e18dmr10089151pfv.36.1663041551793; Mon, 12
 Sep 2022 20:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <CAJJqR20U=OcMq_8wBMQ5xmWmcBcYoKN5+Fe9sPHYPkZ_yHurQQ@mail.gmail.com>
 <e8b44f4a-b6ae-6912-1b26-f900a24204af@turmel.org> <CAJJqR209OzydScj2jScKvKBR=B6d5JErfaFg=4qcSuC7aEvHEg@mail.gmail.com>
 <CAJJqR22EWec7gMwtVZCxxWc4-w9fEp8jaHWmtENwsLYSi7G5PQ@mail.gmail.com>
 <df503250-7c8e-d6f7-21fd-2fe4f1cae961@turmel.org> <CAJJqR231QRUexo=eqi=ijF+ErT=LZHr7DxWPAqC+RqF51ehmxw@mail.gmail.com>
 <CAJJqR22XEbkzF1wfO_RrnVV01E25q_OBHGdDOyBzOcGfUSwadg@mail.gmail.com>
 <CAJJqR23vGGpL-QRGKi-ft6X4RWWF0SPWJEEa=TPuo1zRnHPS3A@mail.gmail.com>
 <593e868a-d0a4-3ad5-d983-e585607ec212@turmel.org> <CAJJqR23RE3Hfrm-bkiyMm3OjUTCFhXsRvBXr4H8563t1VyY=0g@mail.gmail.com>
 <CAJJqR23+V1_DTzYQv7=6M9U6qbd7yEHE3WR2XuXbaBH2oVqLQw@mail.gmail.com> <87fsgw8l15.fsf@vps.thesusis.net>
In-Reply-To: <87fsgw8l15.fsf@vps.thesusis.net>
From:   Luigi Fabio <luigi.fabio@gmail.com>
Date:   Mon, 12 Sep 2022 23:58:40 -0400
Message-ID: <CAJJqR21jhoE5Ot1Vc9qRB10sOCB70dMBsLQkZ71Buy1=kBtvyQ@mail.gmail.com>
Subject: Re: RAID5 failure and consequent ext4 problems
To:     Phillip Susi <phill@thesusis.net>
Cc:     Phil Turmel <philip@turmel.org>, linux-raid@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, Sep 12, 2022 at 3:12 PM Phillip Susi <phill@thesusis.net> wrote:
> That's funny.  IIRC, the backups virtually never get updated.  The only
> thing e2fsck needs to get from them is the location of the inode tables
> and block groups, and that does not change during the life of the
> filesystem.
>
> I might have something tickling the back of my memory that when e2fsck
> is run, it updates the first backup superblock, but the others never got
> updated.
The way I have found it explained in multiple places is that the
backups only get updated as a consequence of an actual userspace
interaction. So you have to run fsck or at least change settings in
tune2fs, for instance, or resize2fs ... then all the backups get
updated.
The jury is still out on whether automated fscks - for those lunatics
who haven't disabled them - update or not. There is conflicting
information.

LF
