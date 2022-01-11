Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46A4DC433F5
	for <linux-raid@archiver.kernel.org>; Tue, 11 Jan 2022 12:06:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239566AbiAKMGn (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Tue, 11 Jan 2022 07:06:43 -0500
Received: from mga02.intel.com ([134.134.136.20]:2331 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239449AbiAKMGn (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Tue, 11 Jan 2022 07:06:43 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1641902803; x=1673438803;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=5cQeaesQ3nOVgyL7ZmFR5NGdoYLiVucHh60gJaTDLZ0=;
  b=dMXebB+Wrs+qyOZzSOsmoI7MD0YmmRHsOJxgFaPbzxmdTAC2Nt0yTlxc
   yUWPVUuHdTG9/Liy5JgcmXlCIR5KPAW768P2mDFlHoUNkkT8MnrYAL/uA
   WlIAIP5z4/UtfBtQZPM36BqsznZ1IcaFEn8e9AHhNCgvy+HIrUiUKkqla
   nfLn2pwxwl+M/6E14wIM50RjkGPM6Y0WG6gEKtJKNndp6yBDztzlm89xR
   cxMosjCX5PB+gWZbUkLM/7t2brWoeVxOyt3p1aLwFGIgv9v8VXkQfGvep
   v6Ysw7ebpLKlyeqMwX8pYhlHdGE3LFwSDVybx0WwjFMZ1HjmXwPF4NC6v
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10223"; a="230811863"
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="230811863"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 04:06:42 -0800
X-IronPort-AV: E=Sophos;i="5.88,279,1635231600"; 
   d="scan'208";a="472438906"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.30.96])
  by orsmga003-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Jan 2022 04:06:40 -0800
Date:   Tue, 11 Jan 2022 13:06:35 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Bruce Dubbs <bruce.dubbs@gmail.com>
Cc:     Wols Lists <antlists@youngman.org.uk>,
        Randy Dunlap <rdunlap@infradead.org>,
        linux-raid@vger.kernel.org,
        "Douglas R. Reno" <renodr2002@gmail.com>,
        Pierre Labastie <pierre.labastie@neuf.fr>
Subject: Re: mdadm regression tests fail
Message-ID: <20220111130635.00001478@linux.intel.com>
In-Reply-To: <c85495ef-d5ef-e3b7-338d-4cc5173e0c55@gmail.com>
References: <c4c17b11-16f4-ef70-5897-02f923907963@gmail.com>
        <45492ddd-42f1-674f-af27-5e0a0aace8c9@infradead.org>
        <96d9e6d4-16e5-6bfe-fc5a-7d0dfbaeadf0@youngman.org.uk>
        <c85495ef-d5ef-e3b7-338d-4cc5173e0c55@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Wed, 5 Jan 2022 14:42:31 -0600
Bruce Dubbs <bruce.dubbs@gmail.com> wrote:

> My point is that many of the tests fail.  It's not that someone
> should use the superblock v0.9.  That's only an example. The test
> should be removed or marked "Expected FAIL" or similar.  Our users
> run the tests as a confidence check that the build is successful.
> They are generally not trying to debug the package.
> 
> I can certainly say that the tests are broken and leave it at that.
> If it were only a couple of tests that fail, we generally say
> something like testA and testG are known to fail, but in this case
> fully half of the tests fail.
> 
> I would like to know what the maintainers think of the regression
> tests.  Are they maintained?  Should they all pass?  For our users
> there are far too many tests to run them individually.
> 
>    -- Bruce
> 

Hi Bruce,
I can say that at least IMSM test are maintained and used regularly.
You can use this subgroup. I can also see some test
improvements submitted last time in mdadm repository, so I can assume
that there are some usages outside IMSM (at least for 1.x metadata).

Without continuous integration testing in upstream it is externally hard
to have all tests in good shape. The verification is done by users, as
you can see it is not used frequently. I'm closer to say that this part
in not maintained. You can take a challenge and fix them :)

Thanks,
Mariusz
