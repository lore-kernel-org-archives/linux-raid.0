Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 51026C678D5
	for <linux-raid@archiver.kernel.org>; Wed,  8 Mar 2023 01:37:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbjCHBhO (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 7 Mar 2023 20:37:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjCHBhN (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Tue, 7 Mar 2023 20:37:13 -0500
X-Greylist: delayed 381 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 07 Mar 2023 17:37:10 PST
Received: from out-50.mta0.migadu.com (out-50.mta0.migadu.com [IPv6:2001:41d0:1004:224b::32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08B4259E73
        for <linux-raid@vger.kernel.org>; Tue,  7 Mar 2023 17:37:09 -0800 (PST)
Message-ID: <777de4f2-1b5d-aded-620d-4c14102a551f@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1678239013;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3XrhP9BkNWIV/d0B6E1/teteVpRVYuR+HkxqrXYg+Nw=;
        b=Gv/IwiiWgpR9b9oS0xV7rY04lTIgNUa4zKx7R8diSjhXWaUkW9JPDJKve2phCdVNoHa4YO
        qP4jNCG5u4e9yZD0cQ8g+d4tCawsirNncHu1/9ZDh/FY5TSWKWR+yKNvFCeqK702NleCKI
        at+b2MZICagh631798WkxuguUqrkRnI=
Date:   Wed, 8 Mar 2023 09:30:08 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 00/34] address various checkpatch.pl requirements
Content-Language: en-US
To:     Heinz Mauelshagen <heinzm@redhat.com>
Cc:     linux-raid@vger.kernel.org, ncroxon@redhat.com, xni@redhat.com,
        dkeefe@redhat.com
References: <cover.1678136717.git.heinzm@redhat.com>
 <5be00f6c-22ee-1af3-c5ed-d92863d7f442@linux.dev>
 <CAM23Vxqf-XMdoobeEyyk1MC=PzkWM=5w88jM8R-joxrrT82ukw@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Guoqing Jiang <guoqing.jiang@linux.dev>
In-Reply-To: <CAM23Vxqf-XMdoobeEyyk1MC=PzkWM=5w88jM8R-joxrrT82ukw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org



On 3/8/23 01:22, Heinz Mauelshagen wrote:
> As the MD RAID  subsystem is in active maintenance receiving
> functional enhancements still, it is
> hardly old in general,

I might use the inappropriate word, let's say the 'existing' code.
And I am not against use checkpatch (all the new patches
should be checked by it I believe).

> profits from coding (style) enhancements and
> adoption of current APIs.

This kind of patchset can also bring troubles, eg, people works
for downstream kernel need more effort to backport fix patches
due to conflict, I assume stable kernel could be affected as well.

A more sensible way might be fix coding style issue while the
adjacent code need to be changed because of new feature or bug
etc. Anyway, just my 0.02$.

BTW, pls don't top reply if possible.

Thanks,
Guoqing
