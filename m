Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0BEF0C64E7B
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 08:43:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 142DD206E3
	for <linux-raid@archiver.kernel.org>; Tue,  1 Dec 2020 08:43:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.jp header.i=@posteo.jp header.b="F8VYwh7N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727247AbgLAIn2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 1 Dec 2020 03:43:28 -0500
Received: from mout01.posteo.de ([185.67.36.65]:38463 "EHLO mout01.posteo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727058AbgLAIn2 (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 1 Dec 2020 03:43:28 -0500
Received: from submission (posteo.de [89.146.220.130]) 
        by mout01.posteo.de (Postfix) with ESMTPS id 7D727160060
        for <linux-raid@vger.kernel.org>; Tue,  1 Dec 2020 09:42:31 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.jp; s=2017;
        t=1606812151; bh=TrsJOpVR7Ju7Oqw/22Li4RbPb1G0O33b+KBW4RfgBnU=;
        h=Date:From:To:Cc:Subject:From;
        b=F8VYwh7NM0yRczxONFVg8eD381LlpjNbaBs8k2ciM4BTk6HuXbiD7WCqR+O3m4eej
         rrnPBM4IgY7fhGc028q1vbk67RP+QUwHSNLLQrxcnjPX1MeM42Z0QUScRT5MESQBs3
         THUmB8T2ERVK4HJis/UY4ENTfUnKymgbypCmsEEJUd2nqs1YG19DER4NVpZr4aiL4C
         YG7fxwfAwgJhu98VWw+aDEQJl5TcCKO1dctaugpfmVnk0P76McP3HaGUPDRYIw2kOD
         5b+v9TcvNalaw03GoH4QAGpWHcxGTkX1VzrOMioCjpLTBTsbfljCmMfThhA0KCsloj
         n+pIKJHu+ITew==
Received: from customer (localhost [127.0.0.1])
        by submission (posteo.de) with ESMTPSA id 4ClbFg1vQ5z9rxN;
        Tue,  1 Dec 2020 09:42:31 +0100 (CET)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 01 Dec 2020 09:42:31 +0100
From:   c.buhtz@posteo.jp
To:     David T-G <davidtg-robot@justpickone.org>
Cc:     linux-raid@vger.kernel.org
Subject: re: partitions & filesystems (was "Re: =?UTF-8?Q?=3F=3F=3Froot=20?=
 =?UTF-8?Q?account=20locked=3F=3F=3F=20after=20removing=20one=20RAID=31=20?=
 =?UTF-8?Q?hard=20disc=22=29?=
In-Reply-To: <20201130200503.GV1415@justpickone.org>
References: <e6b7a61d16a25c433438c670fa4c0b4f@posteo.de>
 <20201130200503.GV1415@justpickone.org>
Message-ID: <79f45fa57fab1faa3b01c0706d828ec7@posteo.de>
X-Sender: c.buhtz@posteo.jp
User-Agent: Posteo Webmail
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Dear David and others,

thanks a lot for so much discussion and details. I learn a lot.
Following your discussions I see there still is some basic knowledge 
missing on my side.

Am 30.11.2020 21:05 schrieb David T-G:
> You don't see any "filesystem" or, more correctly, partition in your
> 
>   fdisk -l

I do not see the partition in the output of "fdisk -l".

But I can (when both discs are present) mount /dev/md127 (manualy via 
mount and via fstab) to /Daten and create files on it.

> So the display isn't interesting, although the logic behind that 
> approach
> certainly is to me.

I plugged in the nacked hard discs and they appear as /dev/sdb and 
/dev/sdc. After that
   mdadm --create /dev/md/md0 --level=1 --raid-devices=2 /dev/sdb 
/dev/sdc
Then I did
  ls -l /dev/md/md0 and found out this is just a link to /dev/md127.
I formated the raid with
  mkdfs.ext4 /dev/md127
Then I mounted (first manually via mount and after sucess via fstab) 
/dev/md127 to /Daten

Is this unusual?
