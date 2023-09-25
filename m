Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70AB5CE7AA3
	for <linux-raid@archiver.kernel.org>; Mon, 25 Sep 2023 16:43:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229905AbjIYQn2 (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 25 Sep 2023 12:43:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjIYQn1 (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Mon, 25 Sep 2023 12:43:27 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 518799F
        for <linux-raid@vger.kernel.org>; Mon, 25 Sep 2023 09:43:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695660201; x=1727196201;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=NVs6G6jfZ4Ie3AAywOophirly7mPgBbToBKdol5PeUg=;
  b=GJrZ9OBJg410dZg2uOVBqzyNiQDAFiTtvBJaVWIZt/GohzOwPnaLb0Ym
   PckTTO5jjF73xpjDx/PhOAXZ6IBCp3vs6IlxKcDLjH2o1XymQraOu4z3B
   boyzf3atDDvJuCC8OYIwacn46g6+E3nzhfdfiAQedldRiJteYhf2Zj25S
   Oh5ngizXR3WLEb7fg8fAfiH9Vuh8hockvU5yQps5ChgQGkIgSL3ExgMsz
   zDD8jfetj44YQpUKV9gxZE3H8WEesfJCMRL9wptsz2l2n/LaOZI3ZctF9
   u5crM3pgdEo71ibVJLtwWjtfVgaJSNnzULeCZJloX1zmrzg46j9Nw+33n
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="371619338"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="371619338"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 09:43:20 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10843"; a="814035115"
X-IronPort-AV: E=Sophos;i="6.03,175,1694761200"; 
   d="scan'208";a="814035115"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.130.218])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Sep 2023 09:43:19 -0700
Date:   Mon, 25 Sep 2023 18:43:14 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Joel Parthemore <joel@parthemores.com>
Cc:     linux-raid@vger.kernel.org
Subject: Re: request for help on IMSM-metadata RAID-5 array
Message-ID: <20230925184314.00005d58@linux.intel.com>
In-Reply-To: <e8fbc585-9367-a865-8c18-bf9e4fc7562f@parthemores.com>
References: <507b6ab0-fd8f-d770-ba82-28def5f53d25@parthemores.com>
        <20230925114420.0000302f@linux.intel.com>
        <e8fbc585-9367-a865-8c18-bf9e4fc7562f@parthemores.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Mon, 25 Sep 2023 17:52:41 +0200
Joel Parthemore <joel@parthemores.com> wrote:

> Den 2023-09-25 kl. 11:44, skrev Mariusz Tkaczyk:
> 
> > Hi Joel,
> > sorry for late response, I see that you were able to recover the data!  
> 
> 
> Yes. I just wanted to proceed as slowly and carefully as possible so 
> that I would not make an awkward situation worse. ;-) The advice I got 
> from the list gave me the assurance to go ahead.
> 
> 
> > I think that metadata manager is down or broken from some reasons.
> > #systemctl status mdmon@md127.service  
> 
> 
> I forgot to say with my earlier post that I'm not running systemd but 
> rather openrc. Gentoo supports both, and I have my reasons for 
> preferring not to make the switch to systemd. Therefore...
> 
> 
> > I you will get the problem again, please try (but do not abuse- use it as
> > last resort!!):
> > #systemctl restart mdmon@md127.service  
> 
> 
> ...That solution won't work. ;-)
> 
> If I do have the problem again, maybe I can come to understand better 
> how/why it's happening.
> 
Ohh, ok. Please note that VROC solution is not validated with openrc and we
have userspace metadata manager, it requires to be careful even with systemd.
In this case native metadata is safer option because the metadata management is
done by kernel. But... you used this for years with no issues so I seems to be
not so bad. Anyway you can always try # mdmon -at to gentle ask metadata daemon
to fork and restart for every IMSM array in your system.

Mariusz
