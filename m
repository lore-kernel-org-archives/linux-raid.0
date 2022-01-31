Return-Path: <linux-raid-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3EA7CC433FE
	for <linux-raid@archiver.kernel.org>; Mon, 31 Jan 2022 12:23:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237774AbiAaMXF (ORCPT <rfc822;linux-raid@archiver.kernel.org>);
        Mon, 31 Jan 2022 07:23:05 -0500
Received: from smtp.hosts.co.uk ([85.233.160.19]:20912 "EHLO smtp.hosts.co.uk"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236654AbiAaMXF (ORCPT <rfc822;linux-raid@vger.kernel.org>);
        Mon, 31 Jan 2022 07:23:05 -0500
Received: from host81-132-12-162.range81-132.btcentralplus.com ([81.132.12.162] helo=[192.168.1.218])
        by smtp.hosts.co.uk with esmtpa (Exim)
        (envelope-from <antlists@youngman.org.uk>)
        id 1nEVi3-0000Kq-6t; Mon, 31 Jan 2022 12:23:03 +0000
Message-ID: <ddc5adff-a9b3-7d2e-f443-722f66a27a8e@youngman.org.uk>
Date:   Mon, 31 Jan 2022 12:23:02 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 2/3] md: Set MD_BROKEN for RAID1 and RAID10
Content-Language: en-GB
To:     Xiao Ni <xni@redhat.com>,
        Mariusz Tkaczyk <mariusz.tkaczyk@linux.intel.com>
Cc:     Song Liu <song@kernel.org>, linux-raid <linux-raid@vger.kernel.org>
References: <20220127153912.26856-1-mariusz.tkaczyk@linux.intel.com>
 <20220127153912.26856-3-mariusz.tkaczyk@linux.intel.com>
 <CALTww2_pHsq+=bY4CtimwxvarxQBM0ey7Y3xAfa0dwoJytU9kQ@mail.gmail.com>
From:   Wols Lists <antlists@youngman.org.uk>
In-Reply-To: <CALTww2_pHsq+=bY4CtimwxvarxQBM0ey7Y3xAfa0dwoJytU9kQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-raid.vger.kernel.org>
X-Mailing-List: linux-raid@vger.kernel.org

On 31/01/2022 08:29, Xiao Ni wrote:
>> + * Error on @rdev is raised and it is needed to be removed from @mddev.
>> + * If there is (excluding @rdev) enough members to operate, @rdev is always
> s/is/are/g
> 

If there *are* (excluding @rdev) enough members to operate, @rdev *is* 
always

Cheers,
Wol
