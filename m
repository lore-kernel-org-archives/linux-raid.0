Return-Path: <linux-raid-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98E80C25B71
	for <linux-raid@archiver.kernel.org>; Wed, 25 Oct 2023 07:44:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233479AbjJYHoa (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Wed, 25 Oct 2023 03:44:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343521AbjJYHoO (ORCPT
        <rfc822;linux-raid@vger.kernel.org>); Wed, 25 Oct 2023 03:44:14 -0400
Received: from mgamail.intel.com (mgamail.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624891FCC
        for <linux-raid@vger.kernel.org>; Wed, 25 Oct 2023 00:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1698219353; x=1729755353;
  h=date:from:to:cc:subject:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=HfekqqHHuWHMdXXBHu4Vi8cxsnP0r1GnBykbUrnLl7I=;
  b=nk1K50COQ6DGANAqW56ZrSKd1nlI6PypXbPG1yxnpi4BFe6XrQHcj8bc
   UYfbGQjNT4rMrVaYH6zN7/qNJ5LGjy03HCu6NuDMYrvPA2NLuql+ICe1s
   dyIeIS9p/Mhstkqc1bxzf4z+plf5JKxHGZu+OeW8KBW2uSYdDdMt575U1
   hofMTFFMnJumO2I1o98ce3q2zU8HoipsfgUJerDpz0k39xV14vsYmCpFA
   EZ5mms5d154Ea1SyamcRxEZoLYjR2a5aiFc2UfyoWusMJxHHHp/uJdo/H
   uKKUntkYop2dRfWmUGGoApyeOC53FnkLWIq2wKwhZ+01k8obgm7CI8lyW
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="391123047"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="391123047"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 00:35:52 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10873"; a="1005922716"
X-IronPort-AV: E=Sophos;i="6.03,250,1694761200"; 
   d="scan'208";a="1005922716"
Received: from mtkaczyk-mobl.ger.corp.intel.com (HELO localhost) ([10.249.145.107])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Oct 2023 00:35:51 -0700
Date:   Wed, 25 Oct 2023 09:35:46 +0200
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Laurence Perkins <lperkins@openeye.net>
Cc:     "linux-raid@vger.kernel.org" <linux-raid@vger.kernel.org>
Subject: Re: mdadm + Intel 12th gen.
Message-ID: <20231025093546.00000d91@linux.intel.com>
In-Reply-To: <MW2PR07MB40585189F6AC1CF7E8113790D2DFA@MW2PR07MB4058.namprd07.prod.outlook.com>
References: <MW2PR07MB40585189F6AC1CF7E8113790D2DFA@MW2PR07MB4058.namprd07.prod.outlook.com>
X-Mailer: Claws Mail 4.1.0 (GTK 3.24.33; x86_64-w64-mingw32)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On Tue, 24 Oct 2023 16:54:26 +0000
Laurence Perkins <lperkins@openeye.net> wrote:

> Greetings!
> 
> I have a Gigabyte motherboard:
> https://www.gigabyte.com/Motherboard/Q670M-D3H-DDR4-rev-10#kf
> 
> With a 12th gen Intel processor:
> https://ark.intel.com/content/www/us/en/ark/products/134591/intel-core-i712700-processor-25m-cache-up-to-4-90-ghz.html
> 
> Which I've set up to use dual NVMe drives as IMSM RAID via VMD.
> 
> And I seem to have run into:
> https://bugzilla.redhat.com/show_bug.cgi?id=2053593
> 
> As I understand it, mdadm is ignoring any IMSM RAID arrays that don't all
> come from the same SATA controller in order to avoid users accidentally
> creating such arrays with a selection of devices where they can't manage it
> via the BIOS menus.  Up to now that was sensible.
> 
> Unfortunately, VMD now lets non-SATA drives use features that used to be SATA
> only.  So systems with NVMe drives can use all the BIOS features for them,
> including the RAID configuration and monitoring.  But then mdadm sees that
> the drives aren't on a SATA controller and deliberately ignores them.
> 
> For now I have hacked the workaround from that Redhat bug report into my
> initramfs (IMSM_NO_PLATFORM=1), but I expect this kind of configuration to
> get more common in the future.  So perhaps it would be a good idea to make
> using them a little more intuitive.  So since I don't manage to find any sign
> of the upstream bug report mentioned by the Redhat user actually having been
> filed I'm going to mention it now and ask if there are any plans for what to
> do with this in future versions.
> 
> LMP

Hi Laurence,
Please provide what OS you are using. I think that all you need is in upstream:
https://git.kernel.org/pub/scm/utils/mdadm/mdadm.git/commit/?id=75350d87c86001c47076e1f62478079bdc072223
but your mdadm has no support yet. Please consider updating mdadm or OS.

Please kindly note that what you are trying to use is a desktop RST family
software raid. Implementation in Linux is for VROC (formerly RSTe, enterprise
raid solution). Metadata format used by both solution is same, that is why
Linux is able to understand it but since both product has been separated many
years ago, there could be differences. Officially, we are not supporting such
configurations.

Thanks,
Mariusz
