Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D562CC433EF
	for <linux-raid@archiver.kernel.org>; Wed,  8 Sep 2021 15:39:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BDF7261108
	for <linux-raid@archiver.kernel.org>; Wed,  8 Sep 2021 15:39:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352096AbhIHPk7 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 8 Sep 2021 11:40:59 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:43095 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349764AbhIHPk7 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 8 Sep 2021 11:40:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1631115591;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=G48sRBUv0RW8Bmsn3wBbdcGbHLUcyA8MFWQ2Ei8wvdk=;
        b=NE/7lgtGGWGJbuyFBUR+XbHbX5bqkSkSkpOzHLPeRYOZ1yqQYvgkHeR7YWe4tZeikx9BMl
        V4pni2iD2XP5C2IrCEewKZIpcGN005Uva26m836L4cPyAXcvXhBTdBw7KnmwF0moloMPFu
        TFlqEUWZF5UjNcp09qpd9XYgMBco81o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-Yxml9_9IPZma1vMyFQgQOw-1; Wed, 08 Sep 2021 11:39:49 -0400
X-MC-Unique: Yxml9_9IPZma1vMyFQgQOw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 884791030C20;
        Wed,  8 Sep 2021 15:39:47 +0000 (UTC)
Received: from x2.localnet (unknown [10.22.8.236])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4456E77F29;
        Wed,  8 Sep 2021 15:39:31 +0000 (UTC)
From:   Steve Grubb <sgrubb@redhat.com>
To:     =?ISO-8859-1?Q?Wei=DF=2C?= Michael 
        <michael.weiss@aisec.fraunhofer.de>,
        Richard Guy Briggs <rgb@redhat.com>
Cc:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "casey@schaufler-ca.com" <casey@schaufler-ca.com>,
        "agk@redhat.com" <agk@redhat.com>,
        "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>,
        "song@kernel.org" <song@kernel.org>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>
Subject: Re: [PATCH v4 0/3] dm: audit event logging
Date:   Wed, 08 Sep 2021 11:39:02 -0400
Message-ID: <4344604.LvFx2qVVIh@x2>
Organization: Red Hat
In-Reply-To: <20210908131616.GK490529@madcap2.tricolour.ca>
References: <20210904095934.5033-1-michael.weiss@aisec.fraunhofer.de> <9ca855cb19097b6fa98f2b3419864fd8ddadf065.camel@aisec.fraunhofer.de> <20210908131616.GK490529@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wednesday, September 8, 2021 9:16:16 AM EDT Richard Guy Briggs wrote:
>  Another minor oddity is the double "=" for the subj
> 
> > > field, which doesn't appear to be a bug in your code, but still
> > > puzzling.
> > 
> > In the test setup, I had Apparmor enabled and set as default security
> > module. This behavior occurs in any audit_log message.
> > Seems that this is coming from the label handling there. Having a quick
> > look at the code there is that they use '=' in the label to provide a
> > root view as part of their policy virtualization. The corresponding
> > commit is sitting there since 2017:
> > "26b7899510ae243e392960704ebdba52d05fbb13"
> 
> Interesting...  Thanks for tracking down that cause.  I don't know how
> much pain that will cause the userspace parsing tools.  I've added Steve
> Grubb to the Cc: to get his input, but this should not derail this patch
> set.

It likely breaks any parser. I would even say that it's a malformed event 
that should be corrected. There's been a published a specification for audit 
events  for at least 5 years. Latest copy is here:

https://github.com/linux-audit/audit-documentation/wiki/SPEC-Writing-Good-Events

-Steve



