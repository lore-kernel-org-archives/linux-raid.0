Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 877E0C433EF
	for <linux-raid@archiver.kernel.org>; Mon, 20 Dec 2021 08:45:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234545AbhLTIps (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 20 Dec 2021 03:45:48 -0500
Received: from mga17.intel.com ([192.55.52.151]:49092 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231216AbhLTIps (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 20 Dec 2021 03:45:48 -0500
X-IronPort-AV: E=McAfee;i="6200,9189,10203"; a="220802553"
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="220802553"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 00:45:26 -0800
X-IronPort-AV: E=Sophos;i="5.88,220,1635231600"; 
   d="scan'208";a="507608899"
Received: from mtkaczyk-mobl1.ger.corp.intel.com (HELO localhost) ([10.213.9.163])
  by orsmga007-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Dec 2021 00:45:24 -0800
Date:   Mon, 20 Dec 2021 09:45:19 +0100
From:   Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
To:     Xiao Ni <xni@redhat.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
Subject: Re: [PATCH 1/3] raid0, linear, md: add error_handlers for raid0 and
 linear
Message-ID: <20211220094519.000013d0@linux.intel.com>
In-Reply-To: <CALTww2818H-T5W4oOSG_o_SU1MRAp+_=u9J824V0w1JcX8zZ8Q@mail.gmail.com>
References: <20211216145222.15370-1-mariusz.tkaczyk@linux.intel.com>
        <20211216145222.15370-2-mariusz.tkaczyk@linux.intel.com>
        <CALTww2818H-T5W4oOSG_o_SU1MRAp+_=u9J824V0w1JcX8zZ8Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

Hi Xiao,

On Sun, 19 Dec 2021 11:20:59 +0800
Xiao Ni <xni@redhat.com> wrote:

> > Usage of error_handler causes that disk failure can be requested
> > from userspace. User can fail the array via #mdadm --set-faulty
> > command. This is not safe and will be fixed in mdadm. It is
> > correctable because failed state is not recorded in the metadata.
> > After next assembly array will be read-write again. For safety
> > reason is better to keep MD_BROKEN in runtime only.  
> 
> Hi Mariusz
> 
> Let me call them chapter[1-4]
> 
> Could you explain more about 'mdadm --set-faulty' part? I've read this
> patch. But I don't
> know the relationship between the patch and chapter4.
> 
> In patch2, you write "As in previous commit, it causes that #mdadm
> --set-faulty is able to
> mark array as failed." I tried to run command `mdadm /dev/md0 -f
> /dev/sda`. md0 is a raid0.
> It can't remove sda from md0.

Did you test kernel with my patchset applied?

I've added chapter 4 because I'm aware of behavior change.
Now for r0, nothing happens when we are trying to write failure to
md/<disk>/state.
 
After the change, drive is not remove too, but MD_BROKEN is set and
any new write will be rejected. The drive will be still visible
in array (I didn't change that). Should I add it to description?

Thanks,
Mariusz

