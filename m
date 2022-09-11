Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EDFEECAAA1
	for <linux-raid@archiver.kernel.org>; Sun, 11 Sep 2022 11:41:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230345AbiIKLlk (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Sun, 11 Sep 2022 07:41:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34452 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230390AbiIKLlc (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Sun, 11 Sep 2022 07:41:32 -0400
X-Greylist: delayed 3603 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 11 Sep 2022 04:41:25 PDT
Received: from outbound5d.eu.mailhop.org (outbound5d.eu.mailhop.org [3.121.156.226])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68A0E399CC
        for <linux-raid@vger.kernel.org>; Sun, 11 Sep 2022 04:41:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1662889812; cv=none;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        b=VX32VfJlA4VS6rCY2ob9cAfoslIYSVWitiueRC94hecoBmg3BTncKw7nTpY6VO9jd93EVA7Ow1iro
         LQYfFYuV8Pq0bi1WKdjgKAjTB9qdPc4lbR4RXZD2KDtQ2G9T9RAlvdhw2lddWMJtJq7qU9Ks0F8xBp
         kzPYxttSyzk+dbkkTQ/w+3yZxLbVN+ZUiFOBzTvVfu8wDl7QxTwVAkZH+IaHGm3nRjwCLW3KOGtx93
         5EjjSnBeyaa8YTWfUcpRYwgrQqGHG4ZQwH+o4LvTIxJ0SZjSwxvgro/D4Mfj24Ja+fy3ccEqSaRC/8
         60rTLL5KFn+k5c/sgtI4GUD5jir5YLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=arc-outbound20181012;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
         mime-version:date:message-id:dkim-signature:from;
        bh=hSOEtcdm5Mcl84PQhyk/fdxEP0foMQZ0NUQIMpeUE8Y=;
        b=IQemHrFF71AXtbTfh/DUcyewXQRz+4+84eJxsHM7+XMJc1ygZhC2J7f+4fZNw+I7H9waQ71TVNlSE
         2v0NEVKmPg1hpFE+WQlQ+tzCMybua7PyOK9vMtn9QqlyXbXU65bNUhPfvX94SktJnx0qh0fm2vUM76
         A32denJO+JmLC3Achv/Qu6FM9UjVNxr27G3gJpkFLh3biMd9cuKFte/GpGN7TI7lj69IHWpZFLWD7t
         2EvM/XXUYI6D6Z70tylRLPj0LzDJCJV7Xq7cMc5xH35ZUtyYsF/w6Fn7GYbl1IQZTpsRPncxMsZxmn
         o6eQxxQuv5S/BNiNVNrRnaM10nuZRsA==
ARC-Authentication-Results: i=1; outbound3.eu.mailhop.org;
        spf=softfail smtp.mailfrom=demonlair.co.uk smtp.remote-ip=86.157.202.140;
        dmarc=none header.from=demonlair.co.uk;
        arc=none header.oldest-pass=0;
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=outbound.mailhop.org; s=dkim-high;
        h=content-transfer-encoding:content-type:in-reply-to:from:references:to:subject:
         mime-version:date:message-id:from;
        bh=hSOEtcdm5Mcl84PQhyk/fdxEP0foMQZ0NUQIMpeUE8Y=;
        b=ppUBnp5KdVUyBUDf406PCEYHD5YVLAdAoanOBaK8nzNyC/QOD/0nv/lWneFiQmVRdzxowv4r+8bN2
         HF2JEAghZBzFtamv6mKYrm8W6apqNntKLedV157gTPUgmZydHo4nsJBUwzKEtqf7yyHgPmLVE3OLKP
         bLNOYj5KYVSnccLSRcl3hMDMVpE9CdvaG5hGJIl0IFcF5NYybG/vixVjMnLlRkZJDO+j9AXmQg1Xjd
         DW0qfN4tX0UqomOqh1bEyEiAQqBBeU38liQCI+nopBHfDkfPCCGkHpcWB/3MK2Hzo089OhETjn6Y2N
         NOaMUGndLEkvGMdPpwbiTk/jYxg/FnQ==
X-Originating-IP: 86.157.202.140
X-MHO-RoutePath: ZGVtb25sYWly
X-MHO-User: 1febcab5-31b7-11ed-be1c-8777f00826c1
X-Report-Abuse-To: https://support.duocircle.com/support/solutions/articles/5000540958-duocircle-standard-smtp-abuse-information
X-Mail-Handler: DuoCircle Outbound SMTP
Received: from phoenix.demonlair.co.uk (host86-157-202-140.range86-157.btcentralplus.com [86.157.202.140])
        by outbound3.eu.mailhop.org (Halon) with ESMTPA
        id 1febcab5-31b7-11ed-be1c-8777f00826c1;
        Sun, 11 Sep 2022 09:50:10 +0000 (UTC)
Received: from [10.57.1.71] (mercury.demonlair.co.uk [10.57.1.71])
        by phoenix.demonlair.co.uk (Postfix) with ESMTP id 255A31EA0E1;
        Sun, 11 Sep 2022 10:50:10 +0100 (BST)
Message-ID: <d40ed93b-ed5d-61de-fba8-7c20251c911f@demonlair.co.uk>
Date:   Sun, 11 Sep 2022 10:50:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: 3 way mirror
Content-Language: en-GB
To:     Gandalf Corvotempesta <gandalf.corvotempesta@gmail.com>,
        Linux RAID Mailing List <linux-raid@vger.kernel.org>
References: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
From:   Geoff Back <geoff@demonlair.co.uk>
In-Reply-To: <CAJH6TXj0y_bfJ1q50S7xnTyz_4BSrgNboim9e+zK1nKZX9MR3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 11/09/2022 10:08, Gandalf Corvotempesta wrote:
> let's assume a 3 way mirror (raid1 with 3 disks)
> One disk got a bad sector detrcted by smartd
> what happens trying to read or write to that sector?
>
> is md smart enough to read from the other 2 disks and serve consistant data?
>
> in other words, can i delay the disk replacement for a couple of days
> (i've ordered the disk today, will came tuesday) ?

If this is a recorded grown defect or block reallocation, the drive will
continue to operate normally anyway; the disk will have remapped the
sector internally to one of a few thousand spares kept for the purpose.

However for failed sectors in general, and especially ones that have not
been remapped, yes if MD tries to read from the block and the disk
reports a read error it will automatically redirect to another drive.  I
believe it will also attempt to rewrite the bad sector with the data
from the other drive in order to repair the mirror.  Write operations
will be sent to all three drives and the drive with the bad sector will
normally automatically remap to a spare sector if the internal write
fails.  Once available spare sectors are exhausted the drive will fail
the write, at which point md will fail the drive out of the array.

Of course, this is dependent on your disks returning errors in a timely
fashion rather than locking up on extensive retries.  If you are using
NAS-level or enterprise drives, you should be good, but if you are using
desktop-grade drives they are likely by default to retry for so long
that the kernel times out and the drive drops off the bus instead of
reporting an error.  At that point, of course, md sees the drive as failed.

Cheers,

Geoff.

Geoff Back
What if we're all just characters in someone's nightmares?


